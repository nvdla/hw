#!/usr/bin/env python

import os
import sys
import argparse
import re
import json
from   pprint      import pprint
from   Levenshtein import ratio
from   shutil      import copy2


__DESCRIPTION__='''
=========================================
           # RunDiagnose #
=========================================
This class is used to main syndrome database, including:
    1. register new syndrome
    2. update syndrome info, including pattern list, 
       bug list, and description
    3. show/delete existed syndrome
'''

class  RunDiagnose(object):
    def __init__(self,synd_dir,regr_dir,publish_dir,publish=False,action='',syndrome='',pattern=[],bugid=[],desc=''):
        self._synd_dir    = synd_dir
        self._regr_dir    = regr_dir
        self._publish_dir = publish_dir
        self._publish     = publish
        self._act         = action
        self._syndrome    = syndrome
        self._pattern     = pattern
        self._bugid       = bugid
        self._desc        = desc
        self._db          = {}

    def run(self):
        #origin_dir =  os.getcwd()
        #os.chdir(self._synd_dir)
        self.load_syndrome_db()
        self.act2func(self._act)
        self.update_syndrome_db()
        #os.chdir(origin_dir)

    def load_syndrome_db(self):
        with open(os.path.join(self._synd_dir,'syndrome.json'), 'r') as fh:
            self._db = json.load(fh)

    def update_syndrome_db(self):
        with open(os.path.join(self._synd_dir,'syndrome.json'), 'w') as fh:
            json.dump(self._db, fh, sort_keys=True, indent=4)

    def act2func(self, act):
        pattern = ''
        if self._pattern:
            pattern = self._pattern[0]
        switcher = {
            'match'    : self.match_syndrome,
            'diagnose' : self.diagnose_regr,
            'add'      : self.add_syndrome,
            'update'   : self.update_syndrome,
            'show'     : self.show_syndrome,
            'del'      : self.del_syndrome
        }
        func = switcher.get(act)
        if act == 'match':
            return func(pattern)
        else:
            return func()

    def add_syndrome(self):
        if self._syndrome in self._db:
            raise Exception('Syndrome:%s already existes' % self._syndrome)
        self._db[self._syndrome]            = {}
        self._db[self._syndrome]['pattern'] = self._pattern
        self._db[self._syndrome]['bugid']   = self._bugid
        self._db[self._syndrome]['desc']    = self._desc
        print('AddSyndrome: %0s' % self._syndrome)

    def update_syndrome(self):
        if self._syndrome not in self._db:
            raise Exception('Syndrome:%s not existes' % self._syndrome)
        self._db[self._syndrome]['pattern'] += self._pattern
        self._db[self._syndrome]['bugid']   += self._bugid
        self._db[self._syndrome]['desc']    =  self._desc
        print('UpdateSyndrome: %0s' % self._syndrome)

    def show_syndrome(self):
        if self._syndrome not in self._db:
            raise Exception('Syndrome:%s not existes' % self._syndrome)
        print('*'*100)
        print('%-13s:  %0s' % ('Syndrome',    self._syndrome))
        print('%-13s:  %0s' % ('Pattern',     self._db[self._syndrome]['pattern']))
        print('%-13s:  %0s' % ('BugID',       self._db[self._syndrome]['bugid']))
        print('%-13s:  %0s' % ('Description', self._db[self._syndrome]['desc']))
        print('*'*100)

    def del_syndrome(self):
        if self._syndrome not in self._db:
            raise Exception('Syndrome:%s not existes' % self._syndrome)
        del(self._db[self._syndrome])
        print('DelSyndrome: %0s' % self._syndrome)

    def match_syndrome(self, errinfo):
        self.load_syndrome_db()
        match_syndrome = ''
        match_pattern  = ''
        for syn,syn_info in self._db.items():
            pattern = ''
            for item in syn_info['pattern']: 
                if ratio(errinfo, item) > ratio(errinfo, pattern):
                    pattern = item
            if ratio(errinfo, pattern) > ratio(errinfo, match_pattern):
                match_pattern  = pattern
                match_syndrome = syn
        if ratio(errinfo, match_pattern) < 0.85:
            match_syndrome = ''
        print('MatchSynsrom: %0s' % match_syndrome)
        return match_syndrome

    def diagnose_regr(self):
        file_list = os.listdir(self._regr_dir)
        test_file = '/'.join((self._regr_dir,''.join([x for x in file_list if x[:11]=='test_status'])))
        with open(test_file, 'r') as test_fh:
            test_data = json.load(test_fh)
        for tid,info in test_data.items():
            if test_data[tid]['status'] == 'FAIL':
                test_data[tid]['syndrome'] = self.match_syndrome(test_data[tid]['errinfo'])
        with open(test_file, 'w') as new_fh:
            json.dump(test_data, new_fh, sort_keys=True, indent=4)
        if self._publish:
            os.makedirs(os.path.join(self._publish_dir, 'json_db'), exist_ok=True)
            copy2(test_file, os.path.join(self._publish_dir, 'json_db'))




def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=__DESCRIPTION__)
    parser.add_argument('--syndrome_dir', '-synd_dir', dest='syndrome_dir', required=False, default='',
                        help='specify syndrome database direcotry')
    parser.add_argument('--regress_dir', '-regr_dir', dest = 'regress_dir', required = False,
                        help = 'Specify regression data directory')
    parser.add_argument('--publish_dir', '-publish_dir', dest = 'publish_dir', required = False, default='',
                        help = 'Specify directory for storing published regression results data report')
    parser.add_argument('--publish', '-publish', dest='publish', required=False, default=False, action='store_true',
                        help = 'Publish regression results data')
    parser.add_argument('--action', '-a', dest='action', choices=['add','update','show','del','match','diagnose'], required=True, 
                        action='store', help = 'action to be executed on related syndrome')
    parser.add_argument('--syndrome', '-synd', dest='syndrome', required=False,
                        help='Specify specify syndrome to be modify')
    parser.add_argument('--pattern','-pattern', dest='pattern', required=False, default=[],type=str, nargs='+',
                        help='provide pattern which will be mapped to related given syndrome')
    parser.add_argument('--bugid','-bugid', dest='bugid', required=False, default=[], type=int, nargs='+',
                        help='provide bugid which will be added to bug list of given syndrome')
    parser.add_argument('--description','-desc', dest='description', required=False, default='',
                        help='add description to related syndrome')
    config = vars(parser.parse_args())
    run_diagnose = RunDiagnose(synd_dir    = config['syndrome_dir'],
                               regr_dir    = config['regress_dir'],
                               publish_dir = config['publish_dir'],
                               publish     = config['publish'],
                               action      = config['action'],
                               syndrome    = config['syndrome'],
                               pattern     = config['pattern'],
                               bugid       = config['bugid'],
                               desc        = config['description'],
                              )
    run_diagnose.run()

if __name__ == '__main__':
    main()
