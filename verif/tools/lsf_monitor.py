#!/usr/bin/env python

import os
import re
import argparse
import subprocess
import time
import colorama
from   pprint import pprint


__DESCRIPTION__='''
=========================================================================================
                                    # LSFMonitor #
=========================================================================================
This tool is used to monitor LSF jobs status of one specific group, most time for jobs 
groups in one regression. To achieve this target, below functions implemented in this 
tool:
 - get all job ID of specific job name, wildcard character(*) is supported in job name.
 - Get EXEC_HOST information: RUNLIMIT/CPULIMIT/MEMLIMIT of each job ID.
 - Get status of each jobID, status includes: PEND/RUN/DONE/EXIT.
 - Get cpu_time/memory usage staus of each job ID
 - Get exit syndrome of exited jobs
'''

class LSFMonitor(object):


    def __init__(self, job_name='*', interval=30):
        self._job_name = job_name
        self._interval = interval
        self._job_id   = []
        self._job_query_max_rounds = 5

    def run(self):
        self._job_id = self.get_job_by_name(self._job_name)
        jobs_sts = self.get_job_init_status(self._job_id)
        while True:
            self.print_job_report(jobs_sts)
            if self.no_running_jobs(jobs_sts):
                break
            self.update_job_exec_status(jobs_sts)
            self.time_sleep(self._interval)

    def get_job_by_name(self, job_name=''):
        try:
            job_info = subprocess.check_output("bjobs -a -J '%0s'" % job_name, shell=True) 
            if not job_info:
                raise(None_Job)
        except:
            print(' wait 15s and retry')
            time.sleep(15)
            try:
                job_info = subprocess.check_output("bjobs -a -J '%0s'" % job_name, shell=True) 
                if not job_info:
                    raise(None_Job)
            except:
                raise Exception('job %0s not found' % job_name)
        pattern = re.compile(r'\\n(\d+) ')
        job_id = pattern.findall(str(job_info))
        job_id = [int(k) for k in job_id]
        return job_id

    def get_job_init_status(self, job_id=[]):
        exec_host_info = {}
        job_id_not_initiated = list(job_id)
        for round_idx in range(self._job_query_max_rounds):
            done_list = []
            for item in job_id_not_initiated:
                exec_host_info[item] = {}
                try:
                    info = subprocess.check_output('bjobs -al '+str(item), shell = True)
                except subprocess.CalledProcessError as e:
                    print('[WARNING] Failed to execute bjobs %s' % e.output)
                    continue
                except Exception as e:
                    print('[WARNING] Failed to execute bjobs by unexpected error %s' % e.output)
                    continue
                info = re.sub(r'\\n\s*','', str(info))
                cputime_p  = re.compile(r'CPU\s*time\s*used\s*is\s*([\d\.]+)')
                cputime    = cputime_p.search(str(info))
                maxmem_p   = re.compile(r'MAX\s*MEM:\s*(\d+.*)Mbytes;')
                maxmem     = maxmem_p.search(str(info))
                match = re.search(r'.*Status\s*<(\w+)>,.*VIRTUAL_QUEUE=([\w\.]+)\s*QSUB_JOB_TAG_PROJECT_MODE.*CWD\s*<(.*)>,.*CPULIMIT\s*([\d\.]+\s*min)\s*of\s*([a-zA-Z0-9-]+)\s*.*RUNLIMIT\s*([\d\.]+\s*min)\s*.*MEMLIMIT\s*(\d+\s*)K\s*', str(info))
                if match is None:
                    with open('log_of_job_'+str(item), 'w') as fh:
                        fh.write(str(info))
                    #print(str(info))
                    #raise Exception('Job status extraction failed')
                exec_host_info[item]['status']     = match.group(1)
                exec_host_info[item]['queue_type'] = match.group(2)
                exec_host_info[item]['testdir']    = os.path.basename(match.group(3))
                exec_host_info[item]['cpulimit']   = match.group(4)
                exec_host_info[item]['exechost']   = match.group(5)
                exec_host_info[item]['runlimit']   = match.group(6)
                exec_host_info[item]['memlimit']   = str(int(match.group(7))//1024)+' MB'
                if cputime:
                    exec_host_info[item]['cputime_used']   = '{:.1f}'.format(float(cputime.group(1))/60)+' min'
                else:
                    exec_host_info[item]['cputime_used']   = '-'
                if maxmem:
                    exec_host_info[item]['maxmem']   = maxmem.group(1)+' MB'
                else:
                    exec_host_info[item]['maxmem']   = '-'
                if match.group(1) == 'EXIT':
                    syndrome = re.search(r'Completed\s*<exit>;\s*(\w.*)\..*MEMORY\s*USAGE', str(info))
                    if syndrome:
                        exec_host_info[item]['syndrome'] = str(syndrome.group(1))
                    else:
                        exec_host_info[item]['syndrome'] = 'LSF job exited with unknown reason'
                else:
                    exec_host_info[item]['syndrome'] = ''
                done_list.append(item)
            job_id_not_initiated = list(set(job_id_not_initiated)-set(done_list))
            if not job_id_not_initiated:
                break
            print('Round %d: wait 5s and retry' % round_idx)
            time.sleep(5)
        # last round
        for item in job_id_not_initiated:
            exec_host_info[item] = {}
            exec_host_info[item]['status']       = 'EXPIRE'
            exec_host_info[item]['testdir']      = '-'
            exec_host_info[item]['cpulimit']     = '-'
            exec_host_info[item]['exechost']     = '-'
            exec_host_info[item]['runlimit']     = '-'
            exec_host_info[item]['memlimit']     = '-'
            exec_host_info[item]['queue_type']   = '-'
            exec_host_info[item]['cputime_used'] = '-'
            exec_host_info[item]['maxmem']       = '-'
            exec_host_info[item]['syndrome']     = '-'
        return exec_host_info

    def update_job_exec_status(self, job_status={}):
        for key,value in job_status.items():
            if value['status'] in ('RUN','PEND'):
                try:
                    info = subprocess.check_output('bjobs -al '+str(key), shell = True)
                except subprocess.CalledProcessError as e:
                    print('[WARNING] Failed to execute bjobs %s' % e.output)
                    continue
                except Exception as e:
                    print('[WARNING] Failed to execute bjobs by unexpected error: %s' % e.output)
                    continue
                info = re.sub(r'\\n\s*','', str(info))
                status_p   = re.compile(r'Status\s*<(\w+)>,')
                status     = status_p.search(str(info))
                cputime_p  = re.compile(r'CPU\s*time\s*used\s*is\s*([\d\.]+)')
                cputime    = cputime_p.search(str(info))
                maxmem_p   = re.compile(r'MAX\s*MEM:\s*(\d+.*)Mbytes;')
                maxmem     = maxmem_p.search(str(info))

                job_status[key].update({'status':status.group(1)})
                if cputime:
                    job_status[key].update({'cputime_used':'{:.1f}'.format(float(cputime.group(1))/60)+' min'})
                else:
                    job_status[key].update({'cputime_used':'-'})
                if maxmem:
                    job_status[key].update({'maxmem':maxmem.group(1)+' MB'})
                else:
                    job_status[key].update({'maxmem':'-'})
                if status.group(1) == 'EXIT':
                    syndrome = re.search(r'Completed\s*<exit>;\s*(\w.*)\..*MEMORY\s*USAGE', str(info))
                    if syndrome:
                        job_status[key].update({'syndrome':str(syndrome.group(1))})
                    else:
                        job_status[key].update({'syndrome':'LSF job exited with unknown reason'})

    def print_job_report(self, job_status):
        print('[LSF] Jobs status with name ' + self._job_name)
        print(150 * '-')
        print('%-10s %-40s %-7s %-10s %-10s %-15s %-10s %-10s %-30s' % 
              ('JOBID','TEST','STATUS','CPU_TIME','MAX_MEM','EXEC_HOST','CPU_LIMIET','MEM_LIMIT','SYNDROME'))
        print(150 * '-')

        run_jobs  = {k:v for k,v in job_status.items() if v['status'] == 'RUN'}
        done_jobs = {k:v for k,v in job_status.items() if v['status'] == 'DONE'}
        exit_jobs = {k:v for k,v in job_status.items() if v['status'] == 'EXIT'}
        pend_jobs = {k:v for k,v in job_status.items() if v['status'] == 'PEND'}
        self.print_job_status('GREEN',  done_jobs)
        self.print_job_status('RED',    exit_jobs)
        self.print_job_status('BLUE',   run_jobs)
        self.print_job_status('YELLOW', pend_jobs)

    def print_job_status(self, color='', job_status={}):
        for job,sts in job_status.items():
            msg = '%-10s %-40s %-7s %-10s %-10s %-15s %-10s %-10s %-30s' % \
                  (job,sts['testdir'],sts['status'],sts['cputime_used'],sts['maxmem'],sts['exechost'],sts['cpulimit'],sts['memlimit'],sts['syndrome'])
            print(getattr(colorama.Fore, color) + msg)

    def time_sleep(self, interval):
        for val in range(interval,-1,-1):
            print(f'{colorama.Style.RESET_ALL}[LSF] Will update jobs status after {colorama.Fore.RED}%0d{colorama.Style.RESET_ALL} seconds later ...' % val, end='\r')
            time.sleep(1)

    def no_running_jobs(self, job_status={}):
        run_jobs  = {k:v for k,v in job_status.items() if v['status'] == 'RUN'}
        if len(run_jobs) == 0:
            return True
        else:
            return False

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=__DESCRIPTION__)
    parser.add_argument('--job_name','-job_name', dest='job_name', required=False, default='*', type=str, 
                        help='''provide job name for filtering user-defined jobs to monitor, suporting wild charactor *, by
                        default choose all your own LSF jobs''')
    parser.add_argument('--monitor_interval', '-monitor_interval', dest='monitor_interval', type=int, required=False,
                        default=30, help = 'Specify monitor interval value in seconds')
    config = vars(parser.parse_args())
    lsf_monitor = LSFMonitor(job_name = config['job_name'],
                             interval = config['monitor_interval']
                            )
    lsf_monitor.run()

if __name__ == '__main__':
    main()
