#!/usr/bin/env python

import os
import sys
import argparse
import re
import json
import plotly.offline    as     off
from   plotly.graph_objs import Scatter, Layout, Table
from   pprint            import pprint
from   datetime          import datetime


__DESCRIPTION__= '''
=========================================
           # RunMetrics #
=========================================
This class is used to run official regression metrics report:
    1. load all regression_status_<datetime>.json
    2. generate HTML regression status webpage
'''

class  RunMetrics(object):

    def __init__(self, config):
        self._cfg = dict(config)
        self._regr_db = []
        self._x_axis = []
        self._y_axis = []

    def natural_sort(self, text):
        return int(re.sub('\D+','',text))

    def load_regr_db(self):
        db_list = os.listdir(self._cfg['db_dir'])
        db_list = [x for x in db_list if x[:4]=='regr']
        db_list.sort(key=self.natural_sort)
        for idx in range(len(db_list)):
            if db_list[idx][-5:] != '.json':
                raise Exception('Wrong data format, expect .json, actal filename:%s' % db_list[idx])
            sts_file = '/'.join((self._cfg['db_dir'],db_list[idx]))
            with open(sts_file, 'r') as fh:
                db = json.load(fh)
            self._regr_db.append(db)

    def load_x_axis(self):
        for idx in range(len(self._regr_db)):
            db = self._regr_db[idx]
            time_str = db['start_time'].split('-')
            date = list(map(int, time_str)) 
            self._x_axis.append(datetime(date[0],date[1],date[2],date[3],date[4],date[5]))

    def load_y_axis(self):
        passing_rate_dict = {'total':[]}
        #l0_passing_rate = []
        #l1_passing_rate = []
        planned_test_num = []
        running_test_num = []
        code_cov = []
        func_cov = []
        for idx in range(len(self._regr_db)):
            db = self._regr_db[idx]
            passing_rate_dict['total'].append(db['metrics_result']['passing_rate'])
            if 'passing_rate' in db:
                for sub,tags in db['passing_rate'].items():
                    if sub not in passing_rate_dict:
                        passing_rate_dict[sub]=[]
                    passing_rate_dict[sub].append(db['metrics_result'][sub])
            #l0_passing_rate.append(db['metrics_result']['L0_passing_rate'])
            #l1_passing_rate.append(db['metrics_result']['L1_passing_rate'])
            planned_test_num.append(db['metrics_result']['planned_test_number'])
            running_test_num.append(db['metrics_result']['running_test_number'])
            code_cov.append(db['metrics_result']['code_coverage'])
            func_cov.append(db['metrics_result']['functional_coverage'])
        self._y_axis = [passing_rate_dict, planned_test_num, running_test_num, code_cov, func_cov]

    def load(self):
        self.load_regr_db()
        self.load_x_axis()
        self.load_y_axis()

    def passing_rate_plot(self):
        passing_rate_dict = self._y_axis[0]
        #passing_rate      = Scatter(x=self._x_axis, y=self._y_axis[0], name='Total Passing Rate')
        #l0_passing_rate   = Scatter(x=self._x_axis, y=self._y_axis[1], name='L0 Passing Rate')
        #l1_passing_rate   = Scatter(x=self._x_axis, y=self._y_axis[2], name='L1 Passing Rate')
        #passing_rate_data = [passing_rate, l0_passing_rate, l1_passing_rate]
        num = len(passing_rate_dict)
        keys = list(passing_rate_dict.keys())
        passing_rate_data = []
        for idx in range(num):
            trace = Scatter(x=self._x_axis, y=passing_rate_dict[keys[idx]], name=keys[idx])
            passing_rate_data.append(trace)
        buttons       = []
        for idx in range(num):
            buttons.append(
                dict(
                    label  = keys[idx].upper(),
                    method = 'update',
                    args   = [
                        {'visible':[False]*(idx)+[True]+[False]*(num-idx-1)},
                        {'title'  :keys[idx]}
                    ]
                )
            )
        buttons.append(
            dict(
                label  = 'RESET',
                method = 'update',
                args   = [
                    {'visible':[True]*num},
                    {'title'  :'Passing Rate'}
                ]
            )
        )
        updatemenus = list([
            dict(   
                type    = 'buttons',
                active  = -1,
                buttons = buttons
            )
        ])
        layout = dict(
            title = 'Passing Rate', 
            yaxis=dict(tickformat='.2%',linewidth=2,showline=True,range=[0,1]), 
            xaxis=dict(type='date',linewidth=2,showline=True,tickwidth=1,dtick=86400000.0), 
            showlegend=False, 
            paper_bgcolor='rgba(240,240,240,0.85)',
            plot_bgcolor='rgba(240,255,255,0.85)',
            updatemenus=updatemenus
        )
        fig = dict(data=passing_rate_data, layout=layout)
        off.plot(fig, filename=self._cfg['regression_name']+"_passing_rate.html", auto_open=False)

    def test_num_plot(self):
        planned_test_num  = Scatter(x=self._x_axis, y=self._y_axis[1], name='Planned Tests Number')
        running_test_num  = Scatter(x=self._x_axis, y=self._y_axis[2], name='Running Tests Number')
        test_num_data     = [planned_test_num, running_test_num]
        updatemenus = list([
            dict(   
                type    = 'buttons',
                active  = -1,
                buttons = list([
                    dict(   
                        label  = 'PLANNED',
                        method = 'update',
                        args   = [
                            {'visible':[True, False]},
                            {'title'  :'Planned Test Number'}
                        ]
                    ),
                    dict(   
                        label  = 'RUNNING',
                        method = 'update',
                        args   = [
                            {'visible':[False, True]},
                            {'title'  :'Running Test Number'}
                        ]
                    ),
                    dict(   
                        label  = 'RESET',
                        method = 'update',
                        args   = [
                            {'visible':[True, True]},
                            {'title'  :'Test Number'}
                        ]
                    )
                ]),
            )
        ])
        layout = dict(
            title = 'Test Number', 
            yaxis=dict(range=[0,],linewidth=2,dtick=1,showline=True), 
            xaxis=dict(type='date',linewidth=2,showline=True,tickwidth=1,dtick=86400000.0), 
            showlegend=False, 
            paper_bgcolor='rgba(240,240,240,0.85)',
            plot_bgcolor='rgba(240,255,255,0.85)',
            updatemenus=updatemenus
        )
        fig = dict(data=test_num_data, layout=layout)
        off.plot(fig, filename=self._cfg['regression_name']+"_test_num.html", auto_open=False)

    def coverage_plot(self):
        code_coverage     = Scatter(x=self._x_axis, y=self._y_axis[3], name='Code Coverage')
        func_coverage     = Scatter(x=self._x_axis, y=self._y_axis[4], name='Functional Coverage')
        coverage_data     = [code_coverage, func_coverage]
        updatemenus = list([
            dict(   
                type    = 'buttons',
                active  = -1,
                buttons = list([
                    dict(   
                        label  = 'CODE',
                        method = 'update',
                        args   = [
                            {'visible':[True, False]},
                            {'title'  :'Code Coverage'}
                        ]
                    ),
                    dict(   
                        label  = 'FUNC',
                        method = 'update',
                        args   = [
                            {'visible':[False, True]},
                            {'title'  :'Functional Coverage'}
                        ]
                    ),
                    dict(   
                        label  = 'RESET',
                        method = 'update',
                        args   = [
                            {'visible':[True, True]},
                            {'title'  :'Coverage'}
                        ]
                    )
                ]),
            )
        ])
        layout = dict(
            title = 'Coverage', 
            yaxis=dict(tickformat='.2%',range=[0,1],linewidth=2,showline=True), 
            xaxis=dict(type='date',linewidth=2,showline=True,tickwidth=1,dtick=86400000.0), 
            showlegend=False, 
            paper_bgcolor='rgba(240,240,240,0.85)',
            plot_bgcolor='rgba(240,255,255,0.85)',
            updatemenus=updatemenus
        )
        fig = dict(data=coverage_data, layout=layout)
        off.plot(fig, filename=self._cfg['regression_name']+"_coverage.html", auto_open=False)

    def regr_table_plot(self):
        header = dict(
            values = ['<b>Name<b>','<b>Date<b>','<b>Seed<b>','<b>CommitID<b>','<b>Status<b>'],
            line   = dict(color='#7D7F80'),
            fill   = dict(color='#A1C3D1'),
            font   = dict(size=13),
            align  = [['middle']*5]
        )
        name_list = []
        date_list = []
        seed_list = []
        id_list   = []
        sts_list  = []
        regr_db   = self._regr_db
        regr_db.reverse()
        for idx in range(len(regr_db)):
            db = regr_db[idx]
            name_list.append("<a href='test_status_"+db['start_time']+".html'>"+self._cfg['regression_name']+'</a>')
            date_list.append(db['start_time'])
            seed_list.append(db['plan_seed'])
            id_list.append(  db['unique_id'])
            sts_list.append( db['status'])
        cell_val = dict(
            values = [name_list,date_list,seed_list,id_list,sts_list],
            line   = dict(color='#7D7F80'),
            fill   = dict(color='#EDFAFF'),
            font   = dict(size=13),
            align  = [['middle']*5]
        )
        trace = Table(header=header, cells=cell_val)
        data = [trace]
        layout = dict(
            paper_bgcolor='rgba(240,240,240,0.85)',
            plot_bgcolor='rgba(240,255,255,0.85)'
        )
        fig = dict(data=data, layout=layout)
        off.plot(fig, filename=self._cfg['regression_name']+"_table.html", auto_open=False)
    
    def test_table_plot(self):
        test_db = {}
        db_list = os.listdir(self._cfg['db_dir'])
        db_list = [x for x in db_list if x[:4]=='test']
        db_list.sort(key=self.natural_sort)
        for idx in range(len(db_list)):
            sts_file = '/'.join((self._cfg['db_dir'],db_list[idx]))
            with open(sts_file, 'r') as fh:
                db = json.load(fh)
                header = dict(
                    values = ['<b>ID<b>','<b>TestName<b>','<b>Status<b>','<b>Tag<b>','<b>Syndrome<b>','<b>ErrorInfo<b>','<b>BugID<b>'],
                    line   = dict(color='#7D7F80'),
                    fill   = dict(color='#A1C3D1'),
                    font   = dict(size=13),
                    align  = [['middle']*7]
                )
                id_list       = []
                name_list     = []
                status_list   = []
                tag_list      = []
                syndrome_list = []
                err_list      = []
                bug_list      = []
                for cnt in range(len(db)):
                    tid = str(cnt)
                    tinfo = db[tid]
                    id_list.append(tid)
                    name_list.append(tinfo['name'])
                    status_list.append(tinfo['status'])
                    tag_list.append('<br>'.join(tinfo['tags']))
                    syndrome_list.append(tinfo['syndrome'])
                    err_list.append(tinfo['errinfo'])
                    bug_list.append('TBD')
                cell_val = dict(
                    values = [id_list,name_list,status_list,tag_list,syndrome_list,err_list,bug_list],
                    line   = dict(color='#7D7F80'),
                    fill   = dict(color='#EDFAFF'),
                    font   = dict(size=13),
                    align  = [['middle']*7]
                )
                trace = Table(header=header, cells=cell_val)
                data = [trace]
                layout = dict(
                    paper_bgcolor='rgba(240,240,240,0.85)',
                    plot_bgcolor='rgba(240,255,255,0.85)'
                )
                fig = dict(data=data, layout=layout)
                fn = db_list[idx][:-5] + '.html'
                off.plot(fig, filename=fn, auto_open=False)

    def web_gen(self):
        origin_dir =  os.getcwd()
        os.makedirs(self._cfg['web_dir'], exist_ok=True)
        os.chdir(self._cfg['web_dir'])
        self.passing_rate_plot()
        self.test_num_plot()
        self.coverage_plot()
        self.regr_table_plot()
        self.test_table_plot()
        with open(self._cfg['regression_name']+'.html','w') as web_fh:
            web_fh.write('<html><head><style>\n')
            web_fh.write('#header {background-color:black;color:white;text-align:center;font-size:large;}\n')
            web_fh.write('#nav {background-color:snow;color:black;text-align:left;font-size:15px;float:left;width:6%;padding=5px;}\n')
            web_fh.write('#rate {float:right;width:94%;}\n')
            web_fh.write('#num  {float:right;width:94%;}\n')
            web_fh.write('#cov  {float:right;width:94%;}\n')
            web_fh.write('#table{float:right;width:94%;}\n')
            web_fh.write('</style></head>\n')
            web_fh.write('<body style="background-color:snow;"><div id="header"><p><img src="../../../nvidia.jpeg" width="100" height="100" align="middle" align="left" /><b>OSDLA REGRESSION REPORT</b></p></div>')
            web_fh.write("<div id='nav'><a href='#rate'><b>PASSINGRATE</b></a><br><br><a href='#num'><b>TESTNUM</b></a><br><br><a href='#cov'><b>COVERAGE</b></a><br><br><a href='#table'><b>REGRTABLE</b></a><br><br></div\n>")
            web_fh.write("<div id='rate'> <object data=\""+self._cfg['regression_name']+'_passing_rate.html'+"\" width=\"100%\" height=\"800\"></object>"+"</div>\n")
            web_fh.write("<div id='num'>  <object data=\""+self._cfg['regression_name']+'_test_num.html'    +"\" width=\"100%\" height=\"800\"></object>"+"</div>\n")
            web_fh.write("<div id='cov'>  <object data=\""+self._cfg['regression_name']+'_coverage.html'    +"\" width=\"100%\" height=\"800\"></object>"+"</div>\n")
            web_fh.write("<div id='table'><object data=\""+self._cfg['regression_name']+'_table.html'       +"\" width=\"100%\" height=\"800\"></object>"+"</div>\n")
            web_fh.write("</body></html>")
        os.chdir(origin_dir)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=__DESCRIPTION__)
    parser.add_argument('--db_dir', '-db_dir', dest='db_dir', required=False,
                        default='',
                        help='Specify regression status database direcotry for loading json file')
    parser.add_argument('--web_dir', '-web_dir', dest='web_dir', required=False,
                        default='',
                        help='Specify direcotry for generating regression report web page')
    parser.add_argument('--regression_name', '--regr_name', '-regression_name', '-regr_name', dest='regression_name', required=True, default='random',
                        help='Specify regression name which is used as the name of generated web page')
    config = vars(parser.parse_args())
    pprint(config)
    run_metrics = RunMetrics(config)
    run_metrics.load()
    run_metrics.web_gen()

