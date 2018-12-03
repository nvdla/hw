#!/usr/bin/env python

import os
import re
import sys
import argparse
import time
import json
import colorama
from   shutil      import copy2
from   lsf_monitor import LSFMonitor
from   pprint      import pprint

__DESCRIPTION__ = '''
  This tool is used to generate regression report.
'''

class RunReport(object):
    regress_dir = ''
    origin_dir = ''
    monitor = False
    monitor_interval = 0 # in seconds
    monitor_timeout = 0  # in minutes
    monitor_quiet = 0 # Only wait regression done but not print report
    submetrics = []
    verbose = False

    start_time = 0
    end_time = 0
    test_orgz_data = {}
    regr_sts_data = {}
    job_status = {}

    def __init__(self, regress_dir, publish_dir, publish=False,
                 monitor=False, monitor_interval=30, monitor_timeout=60,
                 monitor_quiet=False, submetrics=[], verbose=False):
        self.regress_dir = os.path.abspath(regress_dir)
        self.publish_dir = os.path.abspath(publish_dir)
        self.publish = publish
        self.monitor = monitor
        self.monitor_interval = monitor_interval
        self.monitor_timeout = monitor_timeout
        self.monitor_quiet = monitor_quiet
        self.submetrics = submetrics
        self.verbose = verbose

    def run(self):
        self.start_time = time.time()
        colorama.init(autoreset=True)
        origin_dir = os.getcwd()
        os.chdir(self.regress_dir)

        self.__load_json_file()
        while True:
            self.__parse_regress_status()
            if not self.monitor_quiet:
                if self.monitor:
                    self.__print_regress_report()
            if self.__is_regress_done():
                print(colorama.Fore.GREEN + 'Regression finished ...')
                break
            elif self.__is_monitor_timeout():
                print(colorama.Fore.YELLOW + '[INFO] Warning: Regression monitor timeout after {:.0f} minutes later !'.format((self.end_time - self.start_time)/60))
                break
            if self.monitor:
                self.__time_sleep(self.monitor_interval)
            elif not self.monitor:
                time.sleep(3600)
        if self.__is_regress_done() or self.__is_monitor_timeout():
            self.__print_regress_report()
            self.report_gen()
        os.chdir(origin_dir)

    def __load_json_file(self):
        with open('test_organization.json', 'r') as test_orgz_fh:
            self.test_orgz_data = json.load(test_orgz_fh)
            self.test_orgz_data = dict(sorted(self.test_orgz_data.items(), key=lambda x:x[1]['name'])) # sort by testname
        with open('regression_status.json', 'r') as regr_sts_fh:
            self.regr_sts_data = json.load(regr_sts_fh)
        if self.regr_sts_data['farm_type'] == 'LSF':
            lsfm = LSFMonitor()
            job_id_list = list(item['job_id'] for item in self.test_orgz_data.values())
            info_dict = lsfm.get_job_init_status(job_id_list)
            for item in info_dict:
                self.job_status.update({item:info_dict[item]})


    def submetrics_parse(self):
        submetrics_list = []
        if self.submetrics is not None:
            for item in self.submetrics:
                (key,val) = item.split(':')
                tags = val.split(';')
                submetrics_list.append({key:tags})
        return submetrics_list

    def passing_rate_calc(self, tags=[]):
        total_cnt    = 0
        pass_cnt     = 0
        passing_rate = 0
        for tid,info in self.test_orgz_data.items():
            if set(tags) <= set(info['tags']):
                if info['status'] == 'PASS':
                    pass_cnt += 1
                total_cnt += 1
        if total_cnt != 0:
            passing_rate = float('%.4f' % (pass_cnt/total_cnt))
        return passing_rate

    #def errinfo_analysis(self,errinfo):
    #    syndrome = ''
    #    if re.search(r'nvdla_tb_top.*timeout', errinfo, re.I):
    #        syndrome = 'TIMEOUT for INF keeping IDLE over 5000 cycles'
    #    elif re.search(r'txn compare failed', errinfo, re.I):
    #        re_obj = re.search(r'(\[.*\]).*txn compare failed', errinfo, re.I)
    #        syndrome = re_obj.group(1)
    #    elif re.search(r'attent to write working group', errinfo, re.I):
    #        syndrome = 'CMOD: attent to write working group'
    #    elif re.search(r'.*\.cpp', errinfo, re.I):
    #        syndrome = 'CMOD: assertion'
    #    else: 
    #        syndrome =  errinfo[0:100]
    #    return syndrome

    def test_sts_report_gen(self):
        test_sts_file = self.regress_dir+'/test_status_'+self.regr_sts_data['start_time']+'.json'
        self.test_orgz_data = dict(sorted(self.test_orgz_data.items(), key=lambda x:x[0])) # resort by test_id
        failed_test_db = {}
        for idx,info in self.test_orgz_data.items():
            if info['status'] != 'PASS':
                failed_test_db[idx] = info
        with open(self.regress_dir+'/failed_test_list.json', 'w') as fail_fh:
            json.dump(failed_test_db, fail_fh, sort_keys=True, indent=4)
        with open(test_sts_file, 'w') as new_fh:
            json.dump(self.test_orgz_data, new_fh, sort_keys=True, indent=4)
        if self.publish:
            os.makedirs(os.path.join(self.publish_dir,'json_db'), exist_ok=True)
            copy2(test_sts_file, os.path.join(self.publish_dir,'json_db'))

    def report_gen(self):
        self.test_sts_report_gen()
        self.regr_sts_data['metrics_result']['passing_rate'] = self.passing_rate_calc()
        if self.__is_regress_done():
            self.regr_sts_data['status'] = 'finish'
        elif self.__is_monitor_timeout():
            self.regr_sts_data['status'] = 'timeout'
        submetrics = self.submetrics_parse()
        for item_dict in submetrics:
            for key,tags in item_dict.items():
                submetrics_name = '_'.join(tags)+'_'+key
                if key not in self.regr_sts_data:
                    self.regr_sts_data[key] = {}
                self.regr_sts_data[key][submetrics_name]=tags;
                if key == "passing_rate":
                    self.regr_sts_data['metrics_result'][submetrics_name] = self.passing_rate_calc(tags)
                else:
                    # calculate function dependents on specific metrics
                    self.regr_sts_data['metrics_result'][submetrics_name] = 0
        report_file = self.regress_dir+'/regression_status_'+self.regr_sts_data['start_time']+'.json'
        with open(report_file, 'w') as new_fh:
            json.dump(self.regr_sts_data, new_fh, sort_keys=True, indent=4)
        if self.publish:
            os.makedirs(os.path.join(self.publish_dir,'json_db'), exist_ok=True)
            copy2(report_file, os.path.join(self.publish_dir, 'json_db'))

    def is_regress_pass(self):
        passed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'PASS']
        return len(passed_testlist) == self.regr_sts_data['metrics_result']['running_test_number']

    ## ------------------------------------------------------------------------
    ## Private functions
    ## ------------------------------------------------------------------------

    def __replace_path_sub_string(self, string, replacement = '...'):
        pattern = re.compile('(/[A-Za-z0-9._]+)+')
        return pattern.sub(replacement, string)

    def __parse_regress_status(self):
        if self.regr_sts_data['farm_type'] == 'LSF':
            lsfm = LSFMonitor()
            lsfm.update_job_exec_status(self.job_status)
        for tid, info in self.test_orgz_data.items():
            # ~dump_trace_only~ means we only run trace_generator regression.
            if self.regr_sts_data['dump_trace_only'] == 'True':
                result_dir = os.path.join(info['dir'], info['name'])
            else:
                result_dir = info['dir']
            while not os.path.isdir(result_dir):
                if self.verbose:
                    print('[INFO] %s does not exists.' % result_dir)
                time.sleep(1)
            os.chdir(result_dir)

            status_file = 'STATUS'
            errinfo = ''
            if not os.path.isfile(status_file):
                if self.verbose:
                    print('[INFO] %s does not exists.' % os.path.join(os.getcwd(), status_file))
                status = 'PENDING'
            else:
                with open(status_file, 'r') as status_fh:
                    status = status_fh.readline().rstrip('\n')
            if status == 'FAIL':
                if os.path.exists('testout'):
                    errinfo = self.__get_lastline('testout').rstrip('\n')
                else:
                    errinfo = 'trace_gen failed'
            elif status == 'RUNNING' and self.regr_sts_data['farm_type'] == 'LSF':
                if self.job_status[info['job_id']]['status'] in ('EXIT', 'EXPIRE'):
                    status = 'KILLED'
                    errinfo = self.job_status[info['job_id']]['syndrome']
            self.test_orgz_data[tid]['status']   = status
            self.test_orgz_data[tid]['errinfo']  = errinfo
            self.test_orgz_data[tid]['syndrome'] = ''
            if self.regr_sts_data['farm_type'] == "LSF":
                self.test_orgz_data[tid]['cputime']    = self.job_status[info['job_id']]['cputime_used']
                self.test_orgz_data[tid]['memsize']    = self.job_status[info['job_id']]['maxmem']
                self.test_orgz_data[tid]['cpulimit']   = self.job_status[info['job_id']]['runlimit']
                self.test_orgz_data[tid]['memlimit']   = self.job_status[info['job_id']]['memlimit']
                self.test_orgz_data[tid]['queue_type'] = self.job_status[info['job_id']]['queue_type']
                

    def __print_regress_report(self):
        passed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'PASS']
        failed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'FAIL']
        killed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'KILLED']
        running_testlist = [v for v in self.test_orgz_data.values() if v['status'] == 'RUNNING']
        pending_testlist = [v for v in self.test_orgz_data.values() if v['status'] == 'PENDING']

        farm_type = self.regr_sts_data['farm_type']
        print('[INFO] Dir = ' + self.regress_dir)
        print(150 * '-')
        if farm_type == 'LSF':
            print('%-10s %-40s %-20s %-10s %-10s %-10s %-10s %-10s %-10s %-10s %-s' % ('JobID', 'Test', 'TB', 'Status', 'CpuTime', 'MemSize', 'CpuPred', 'MemPred', 'CpuLimit', 'MemLimit', 'Errinfo'))
        else:
            print('%-10s %-40s %-20s %-10s %-s' % ('JobID', 'Test', 'TB', 'Status', 'Errinfo'))
        print(150 * '-')

        self.__print_testlist_status('GREEN',  passed_testlist,  farm_type)
        self.__print_testlist_status('RED',    failed_testlist,  farm_type)
        self.__print_testlist_status('CYAN',   killed_testlist,  farm_type)
        self.__print_testlist_status('BLUE',   running_testlist, farm_type)
        self.__print_testlist_status('YELLOW', pending_testlist, farm_type)

        print(150 * '-')
        print('TOTAL    PASS      FAILED    KILLED    RUNNING   PENDING   Passing Rate')
        print('%-4d     ' % self.regr_sts_data['metrics_result']['running_test_number'], end='')
        print(colorama.Fore.GREEN  + '%-10d'% len(passed_testlist), end='')
        print(colorama.Fore.RED    + '%-10d'% len(failed_testlist), end='')
        print(colorama.Fore.CYAN   + '%-10d'% len(killed_testlist), end='')
        print(colorama.Fore.BLUE   + '%-10d'% len(running_testlist), end='')
        print(colorama.Fore.YELLOW + '%-10d'% len(pending_testlist), end='')
        print(colorama.Style.BRIGHT+colorama.Fore.MAGENTA + '%.2f%%' % float(100*self.passing_rate_calc()))

    def __print_testlist_status(self, color='', testlist={}, farm_type=''):
        if farm_type == 'LSF':
            for test in testlist:
                if 'cpupred' not in test:
                    test['cpupred'] = '-'
                if 'mempred' not in test:
                    test['mempred'] = '-'
                msg = "%(jobid)-10s %(test)-40s %(tb)-20s %(status)-10s %(cputime)-10s %(memsize)-10s %(cpupred)-10s %(mempred)-10s %(cpulimit)-10s %(memlimit)-10s %(errinfo)-s" % {
                    'jobid'    : test['job_id'],
                    'test'     : os.path.basename(test['dir']),
                    'tb'       : test['test_bench'],
                    'status'   : test['status'],
                    'cputime'  : self.job_status[test['job_id']]['cputime_used'],
                    'memsize'  : self.job_status[test['job_id']]['maxmem'],
                    'cpupred'  : test['cpupred'],
                    'mempred'  : test['mempred'],
                    'cpulimit' : self.job_status[test['job_id']]['cpulimit'],
                    'memlimit' : self.job_status[test['job_id']]['memlimit'],
                    'errinfo'  : self.__replace_path_sub_string(test['errinfo'])
                }
                print(getattr(colorama.Fore, color) + msg)
        else:
            for test in testlist:
                msg = "%(test)-40s %(tb)-20s %(status)-10s %(errinfo)-s" % {
                    'test'   : os.path.basename(test['dir']),
                    'tb'     : test['test_bench'],
                    'status' : test['status'],
                    'errinfo': self.__replace_path_sub_string(test['errinfo'])
                }
                print(getattr(colorama.Fore, color) + msg)

    def __is_regress_done(self):
        passed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'PASS']
        failed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'FAIL']
        killed_testlist  = [v for v in self.test_orgz_data.values() if v['status'] == 'KILLED']
        return (len(passed_testlist)+len(failed_testlist)+len(killed_testlist)) == self.regr_sts_data['metrics_result']['running_test_number']

    def __get_lastline(self, filename):
        r = os.popen('tail -n 1 ' + filename)
        return r.readline()
    
    def __get_subdirs(self, d):
        return list(filter(lambda x: not x.startswith('.') and os.path.isdir(os.path.join(d, x)), os.listdir(d)))

    def __time_sleep(self, interval):
        for val in range(interval,-1,-1):
            print(f'[INFO] Will update regression status after {colorama.Fore.RED}%0d{colorama.Style.RESET_ALL} seconds later ...' % val, end='\r')
            time.sleep(1)

    def __is_monitor_timeout(self):
        self.end_time = time.time()
        return ((self.end_time - self.start_time) >= 60*self.monitor_timeout)

def main():
    parser = argparse.ArgumentParser(description = __DESCRIPTION__)
    parser.add_argument('--run_dir', '-run_dir',
                        dest = 'run_dir',
                        required = False,
                        help = 'Specify regression data directory')
    parser.add_argument('--publish_dir', '-publish_dir',
                        dest = 'publish_dir',
                        required = False,
                        default='',
                        help = 'Specify directory for storing published regression results data report')
    parser.add_argument('--publish', '-publish',
                        dest='publish',
                        required=False,
                        default=False,
                        action='store_true',
                        help = 'Publish regression results data')
    parser.add_argument('--monitor', '-monitor',
                        dest='monitor',
                        required=False,
                        default=False,
                        action='store_true',
                        help = 'Monitor regression status')
    parser.add_argument('--monitor_interval', '-monitor_interval',
                        dest='monitor_interval',
                        type=int,
                        required=False,
                        default=30,
                        help = 'Specify monitor interval value in seconds')
    parser.add_argument('--monitor_timeout', '-monitor_timeout',
                        dest='monitor_timeout',
                        type=int,
                        required=False,
                        default=60, 
                        help='Specify monitor timeout value in minutes')
    parser.add_argument('--monitor_quiet', '-monitor_quiet',
                        dest='monitor_quiet',
                        required=False,
                        default=False,
                        action='store_true',
                        help='Do not print regression report while monitor (used to wait regression finish)')
    parser.add_argument('--sub_metrics', '-sub_metrics',
                        dest = 'sub_metrics',
                        type=str,
                        nargs='+',
                        required = False,
                        help = '''Specify sub_metrics for generating regression report using string format: 'merics:tag(;tag)'. 
                        For example: passing_rate:L0;sdp, means generating submetrics with tag [L0,sdp] for 'passing_rate' metrics''')
    parser.add_argument('--verbose', '-verbose',
                        dest='verbose',
                        required=False,
                        default=False,
                        action='store_true',
                        help = 'Print verbose info')
    args = vars(parser.parse_args())
    run_report = RunReport(regress_dir=args['run_dir'],
                           publish_dir=args['publish_dir'],
                           publish=args['publish'],
                           monitor=args['monitor'],
                           monitor_interval=args['monitor_interval'],
                           monitor_timeout=args['monitor_timeout'],
                           monitor_quiet=args['monitor_quiet'],
                           submetrics=args['sub_metrics'],
                           verbose=args['verbose'],
                           )
    run_report.run()
    if run_report.is_regress_pass():
        return 0
    else:
        return 1

if __name__ == '__main__':
    ret = main()
    sys.exit(ret)

