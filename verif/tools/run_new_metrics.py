#!/usr/bin/env python

import os
import sys
import argparse
import re
import glob
import flask
import json
import dash
import dash_core_components   as     dcc
import dash_html_components   as     html
import dash_table_experiments as     table
import plotly.offline         as     off
from   plotly.graph_objs      import Scatter, Layout
from   pprint                 import pprint
from   datetime               import datetime

__DESCRIPTION__= '''
=========================================
           # RunMetrics #
=========================================
This class is used to run official regression metrics report:
    1. load all regression_status_<datetime>.json
    2. generate HTML regression status webpage
'''

class  RunMetrics(object):

    '''
    Generate metrics divs using dash and kick-off the app 
    
    Attributes:
        FUNC:
        run: create/run metrics app
    '''

    def __init__(self, config):
        self._cfg = dict(config)

    def run(self):
        div_plot = DivPlot(self._cfg)
        div_plot.dash_gen()
        div_plot.run()

class DataLoad(object):

    '''
    Load data for graph plotting usage:
        1) load regression status database
        2) load test status database
        3) load syndrome database
    of all projects / regressions

    Attributes:
        FUNC: 
        load: load regression data base to x_axis/y_axis
              load syndrome data base for triage usage
        VAR:
        x_axis:         x axis database, only including date time
        y_axis:         y axis database, including passing rate/test num/coverage
        regr_sts_db:    regression status data base
        test_db_files:  test status data base files
        synd_db:        error syndrome data base
        projs:          all avaliable project list
        db_dir:         metrics database root directory path
        synd_dir:       syndrome database directory path
        proj_regr_dict: dict with 'KEY': projects, 'value':regresions
    '''

    def __init__(self, config):
        self.db_dir          = config['db_dir']
        self.synd_dir        = config['syndrome_dir']
        self.projs           = []
        self.proj_regr_dict  = {}
        self.regr_sts_db     = {}
        self.synd_db         = {}
        self.x_axis          = {}
        self.y_axis          = {}
        self.test_db_files   = {}

    def _natural_sort(self, text):
        return int(re.sub('\D+','',text))

    def _load_db(self):
        self.projs = [x for x in os.listdir(self.db_dir) if x not in ['syndrome_db','NVlogo.png']]
        for proj in self.projs:
            if not os.path.exists(os.path.join(self.db_dir, proj)):
                raise Exception('Select project: %0s not existed in database' % proj)
            else:
                regr_list                 = os.listdir(os.path.join(self.db_dir,proj))
                self.proj_regr_dict[proj] = []
                self.test_db_files[proj]  = {}
                self.regr_sts_db[proj]    = {}
                for regr in regr_list:
                    self.proj_regr_dict[proj].append(regr)
                    # fetch all test status data files
                    sts_db_path = os.path.join(self.db_dir,proj,regr,'json_db')
                    self.test_db_files[proj][regr] = glob.glob('{}/test*.json'.format(sts_db_path))
                    self.test_db_files[proj][regr].sort(key=self._natural_sort)
                    # load regression status data
                    regr_db_files = glob.glob('{}/regr*.json'.format(sts_db_path))
                    regr_db_files.sort(key=self._natural_sort)
                    self.regr_sts_db[proj][regr] = []
                    for idx in range(len(regr_db_files)):
                        sts_file = regr_db_files[idx]
                        with open(sts_file, 'r') as fh:
                            db = json.load(fh)
                        self.regr_sts_db[proj][regr].append(db)
        with open(os.path.join(self.synd_dir,'syndrome.json'), 'r') as syn_fh:
            self.synd_db = json.load(syn_fh)

    def _load_x_axis(self):
        for proj in self.regr_sts_db:
            self.x_axis[proj] = {}
            for regr in self.regr_sts_db[proj]:
                self.x_axis[proj][regr] = []
                db                      = self.regr_sts_db[proj][regr]
                for idx in range(len(db)):
                    time_str = db[idx]['start_time'].split('-')
                    date     = list(map(int, time_str))
                    date_str = datetime(date[0],date[1],date[2],date[3],date[4],date[5])
                    self.x_axis[proj][regr].append(date_str)

    def _load_y_axis(self):
        for proj in self.regr_sts_db:
            self.y_axis[proj] = {}
            for regr in self.regr_sts_db[proj]:
                db                       = self.regr_sts_db[proj][regr]
                self.y_axis[proj][regr]  = []
                passing_rate_dict        = {'total':[]}
                planned_test_num         = []
                running_test_num         = []
                code_cov                 = []
                func_cov                 = []
                for idx in range(len(db)):
                    passing_rate_dict['total'].append(db[idx]['metrics_result']['passing_rate'])
                    if 'passing_rate' in db[idx]:
                        for sub,tags in db[idx]['passing_rate'].items():
                            if sub not in passing_rate_dict:
                                passing_rate_dict[sub]=[]
                            passing_rate_dict[sub].append(db[idx]['metrics_result'][sub])
                    planned_test_num.append(db[idx]['metrics_result']['planned_test_number'])
                    running_test_num.append(db[idx]['metrics_result']['running_test_number'])
                    code_cov.append(db[idx]['metrics_result']['code_coverage'])
                    func_cov.append(db[idx]['metrics_result']['functional_coverage'])
                self.y_axis[proj][regr]  = [passing_rate_dict, planned_test_num, running_test_num]
                self.y_axis[proj][regr] += [code_cov, func_cov]
                
    def load(self):
        self._load_db()
        self._load_x_axis()
        self._load_y_axis()

class DivPlot():
    
    '''
    Generate html DIVs for metrics system, create dash app and attach those html DIVs to the metrics
    app. DIVs includs: regression status graphs, test status tables, syndrome tables and maintaining
    cell. 
    '''

    def __init__(self, cfg):
        self._proj                                    = ''
        self._regr                                    = ''
        self._loader                                  = DataLoad(cfg)
        self._app                                     = dash.Dash()
        self._app.scripts.config.serve_locally        = True,
        self._app.css.config.serve_locally            = True,
        self._app.config.suppress_callback_exceptions = True

    def passing_rate_div(self):
        divs   = {}
        layout = Layout(
            title         = 'Passing Rate',
            titlefont     = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f'),
            xaxis         = dict(
                type      = 'date',
                linewidth = 2,
                showline  = True,
                tickwidth = 1,
                dtick     = 86400000.0,
                title     = 'Date',
                titlefont = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f')
            ),
            yaxis         = dict(
                tickformat='.2%', 
                linewidth=2, 
                showline=True, 
                range=[0,1], 
                title='Rate',
                titlefont = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f')
            ),
            height        = '700',
            legend        = dict(x=0, y=1),
            paper_bgcolor = 'rgba(240,240,240,0.85)',
            plot_bgcolor  = 'rgba(240,255,255,0.85)',
            hovermode     = 'closet'
        )
        for proj in self._loader.proj_regr_dict:
            divs[proj] = {}
            for regr in self._loader.proj_regr_dict[proj]:
                y_axis_v = self._loader.y_axis[proj][regr][0]
                div      = html.Div(
                    id       = 'passing_rate_div', 
                    children = [
                        html.H3('PASSING RATE'),
                        html.Hr(),
                        dcc.Graph(
                            id     = '_'.join((proj,regr,'passing_rate')),
                            figure = {
                                'data'  : [
                                    Scatter(
                                        x       = self._loader.x_axis[proj][regr],
                                        y       = y_axis_v[i],
                                        text    = i,
                                        name    = re.sub('_passing_rate','',i)
                                    ) for i in y_axis_v.keys()
                                ],
                                'layout': layout
                            }
                        )
                    ],
                    style = {
                        'textAlign' : 'center',
                        'float'     : 'right',
                        'width'     : '90%',
                        'display'   : 'inline-block',
                        'marginTop' : '10',
                    }
                )
                divs[proj][regr] = div
        return divs

    def test_num_div(self):
        divs   = {}
        layout = Layout(
            title         = 'Test Num',
            titlefont     = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f'),
            xaxis         = dict(
                type      = 'date',
                linewidth = 2,
                showline  = True,
                tickwidth = 1,
                dtick     = 86400000.0,
                title     = 'Date',
                titlefont = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f')
            ),
            yaxis         = dict(
                linewidth = 2,
                showline  = True,
                range     = [0,],
                title     = 'Num',
                titlefont = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f')
            ), 
            height        = '700',
            legend        = dict(x=0, y=1),
            paper_bgcolor = 'rgba(240,240,240,0.85)',
            plot_bgcolor  = 'rgba(240,255,255,0.85)',
            hovermode     = 'closet'
        )
        for proj in self._loader.proj_regr_dict:
            divs[proj] = {}
            for regr in self._loader.proj_regr_dict[proj]:
                y_axis_v = dict(PLANNED=self._loader.y_axis[proj][regr][1],
                                RUNNING=self._loader.y_axis[proj][regr][2])
                div = html.Div(
                    id       = 'test_num_div', 
                    children = [
                        html.H3('TEST NUM'),
                        html.Hr(),
                        dcc.Graph(
                            id     = '_'.join((proj,regr,'test_num')),
                            figure = {
                                'data'  : [
                                    Scatter(
                                        x       = self._loader.x_axis[proj][regr],
                                        y       = y_axis_v[i],
                                        text    = i,
                                        name    = i 
                                    ) for i in y_axis_v.keys()
                                ],
                                'layout': layout
                            }
                        )
                    ],
                    style = {
                        'textAlign' : 'center',
                        'float'     : 'right',
                        'width'     : '90%',
                        'display'   : 'inline-block',
                        'marginTop' : '10',
                    }
                )
                divs[proj][regr] = div
        return divs
    
    def coverage_div(self):
        divs   = {}
        layout = Layout(
            title         = 'Coverage',
            titlefont     = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f'),
            xaxis         = dict(
                type      = 'date',
                linewidth = 2,
                showline  = True,
                tickwidth = 1,
                dtick     = 86400000.0,
                title     = 'Date',
                titlefont = dict(family = 'Courier New, monospace',size = 18,color = '#7f7f7f'),
            ),
            yaxis         = dict(tickformat='.2%', linewidth=2, showline=True, range=[0,1], 
                                 title='Value'),
            height        = '700',
            legend        = dict(x=0, y=1),
            paper_bgcolor = 'rgba(240,240,240,0.85)',
            plot_bgcolor  = 'rgba(240,255,255,0.85)',
            hovermode     = 'closet'
        )
        for proj in self._loader.proj_regr_dict:
            divs[proj] = {}
            for regr in self._loader.proj_regr_dict[proj]:
                y_axis_v = dict(CODE=self._loader.y_axis[proj][regr][3],
                                FUNC=self._loader.y_axis[proj][regr][4])
                div = html.Div(
                    id       = 'coverage_div', 
                    children = [
                        html.H3('COVERAGE'),
                        html.Hr(),
                        dcc.Graph(
                            id     = '_'.join((proj,regr,'coverage')),
                            figure = {
                                'data'  : [
                                    Scatter(
                                        x       = self._loader.x_axis[proj][regr],
                                        y       = y_axis_v[i],
                                        text    = i,
                                        name    = i 
                                    ) for i in y_axis_v.keys()
                                ],
                                'layout': layout
                            }
                        )
                    ],
                    style = {
                        'textAlign' : 'center',
                        'float'     : 'right',
                        'width'     : '90%',
                        'display'   : 'inline-block',
                        'marginTop' : '10',
                    }
                )
                divs[proj][regr] = div
        return divs
    
    def regr_table_div(self):
        divs = {}
        for proj in self._loader.proj_regr_dict:
            divs[proj] = {}
            for regr in self._loader.proj_regr_dict[proj]:
                ROW = []
                db = self._loader.regr_sts_db[proj][regr]
                for idx in range(len(db)):
                    item             = {}
                    item['Name']     = '_'.join((proj,regr))
                    item['Date']     = db[idx]['start_time']
                    item['Seed']     = db[idx]['plan_seed']
                    item['CommitID'] = db[idx]['unique_id'][0:10]
                    item['Status']   = db[idx]['status']
                    cov_file         = os.path.join(self._loader.db_dir,proj,regr,'coverage/report',
                                                    'report_'+db[idx]['start_time'],'dashboard.html')
                    if os.path.exists(cov_file):
                        item['Cov'] = html.A('Func:{:.2%} Code:{:.2%}'.format(
                            float(db[idx]['metrics_result']['functional_coverage']),
                            float(db[idx]['metrics_result']['code_coverage'])),
                            href  = 'https://nvtegra/'+cov_file)
                    else:
                        item['Cov'] = 'Func:{:.2%} Code:{:.2%}'.format(
                            float(db[idx]['metrics_result']['functional_coverage']),
                            float(db[idx]['metrics_result']['code_coverage']))
                    item['PassingRate'] = dcc.Link(
                        '{:.2%}'.format(db[idx]['metrics_result']['passing_rate']), 
                        href  = db[idx]['start_time'],
                        style = {'color':'green','textDecoration':'underline','cursor':'pointer'})
                    ROW.append(item)
                ROW = sorted(ROW, key=lambda k:k['Date'])
                ROW.reverse()
                div = html.Div(
                    id = 'regr_table_div',
                    children = [
                        html.H3('REGRESSION HISTORY', style={'textAlign':'center'}),
                        html.Hr(),
                        table.DataTable(
                            id                   = 'regr_table',
                            rows                 = ROW,
                            filterable           = True,
                            editable             = False,
                            enable_drag_and_drop = True,
                            row_selectable       = True,
#                           resizable            = True,
                            sortable             = True,
#                           column_width         = 200,
                            row_height           = 30,
                            min_height           = 500,
                            selected_row_indices = [],
                        )
                    ],
                    style = {
                        'textAlign' : 'center',
                        'float'     : 'right',
                        'width'     : '90%',
                        'display'   : 'inline-block',
                        'marginTop' : '10',
#                       'fontSize'  : '13',
                    }
                )
                divs[proj][regr] = div
        return divs
    
    def syndrome_table_div(self, test_db_files={}, synd_db={}):
        divs = {}
        for proj in self._loader.proj_regr_dict:
            divs[proj] = {}
            for regr in self._loader.proj_regr_dict[proj]:
                divs[proj][regr] = {}
                db               = self._loader.test_db_files[proj][regr]
                for idx in range(len(db)):
                    test_sts_name = os.path.basename(db[idx])
                    name = re.sub('.json', '_syndrome', test_sts_name.lstrip('test_status_'))
                    with open(db[idx], 'r') as fh:
                        test_db = json.load(fh)
                    ROW = []
                    for idx,info in test_db.items():
                        if info['syndrome'] != '':
                            item = {}
                            if info['syndrome'] in self._loader.synd_db:
                                item['Syndrome'] = info['syndrome']
                                item['BugID']    = self._loader.synd_db[info['syndrome']]['bugid']
                                item['Pattern']  = self._loader.synd_db[info['syndrome']]['pattern']
                                item['Desc']     = self._loader.synd_db[info['syndrome']]['desc']
                            else:
                                item['Syndrome'] = info['syndrome']
                                item['BugID']    = ''
                                item['Pattern']  = ''
                                item['Desc']     = ''
                            ROW.append(item)
                    if not ROW:
                        ROW = [dict(Syndrome='',BugID='',Pattern='',Desc='')]
                    div = html.Div(
                        id       = '_'.join((proj,regr,name)),
                        children = [
                            html.H3('Syndrome TABLE : '+name,style={'textAlign':'center'}),
                            html.Hr(),
                            table.DataTable(
                                id                   = '_'.join((proj,regr,name,'table')),
                                rows                 = ROW,
                                filterable           = True,
                                editable             = False,
                                enable_drag_and_drop = True,
                                row_selectable       = True,
#                               resizable            = True,
                                sortable             = True,
#                               column_width         = [50,320,100,200,400,400,],
                                row_height           = 80,
                                min_height           = 400,
                                selected_row_indices = [],
                            )
                        ],
                        style = {
                            'textAlign' : 'left',
                            'float'     : 'left',
                            'width'     : '100%',
                            'display'   : 'inline-block',
                            'fontSize'  : '13',
                            'marginTop' : '10',
                        }
                    )
                    divs[proj][regr][name] = div
        return divs

    def test_table_div(self):
        divs = {}
        for proj in self._loader.proj_regr_dict:
            divs[proj] = {}
            for regr in self._loader.proj_regr_dict[proj]:
                divs[proj][regr] = {}
                db               = self._loader.test_db_files[proj][regr]
                for idx in range(len(db)):
                    name = re.sub('.json', '', os.path.basename(db[idx]))
                    with open(db[idx], 'r') as fh:
                        test_db = json.load(fh)
                    ROW = []
                    for idx,info in test_db.items():
                        item             = {}
                        item['ID']       = int(idx)
                        item['TestName'] = info['name']
                        item['Status']   = info['status']
                        item['Tag']      = (' '.join(info['tags']))
                        item['Syndrome'] = info['syndrome']
                        item['ErrInfo']  = info['errinfo']
                        item['BugID']    = 'TBD'
                        ROW.append(item)
                    ROW = sorted(ROW, key=lambda k:int(k['ID']))
                    div = html.Div(
                        id       = name,
                        children = [
                            html.H3('TEST TABLE : '+name,style={'textAlign':'center'}),
                            html.Hr(),
                            table.DataTable(
                                id                   = '_'.join((proj,regr,name,'table')),
                                rows                 = ROW,
                                filterable           = True,
                                editable             = False,
                                enable_drag_and_drop = True,
                                row_selectable       = True,
#                               resizable            = True,
                                sortable             = True,
#                               column_width         = [50,320,100,200,400,400,],
                                row_height           = 80,
                                min_height           = 800,
                                selected_row_indices = [],
                            )
                        ],
                        style = {
                            'textAlign' : 'left',
                            'float'     : 'right',
                            'width'     : '90%',
                            'display'   : 'inline-block',
                            'fontSize'  : '12',
#                           'marginTop' : '10',
                        }
                    )
                    divs[proj][regr][name] = div
        return divs
    
    def syndrome_div(self):
        div = html.Div(
            id       = 'syndrome_div',
            children = [
                html.H3('SYNDROME DATABASE',style={'textAlign':'center'}),
                html.Hr(),
                html.Div(
                    children = [
                        html.H3('DataBase:', style={'marginTop':'25'}),
                        html.H3('Syndrome:', style={'marginTop':'29'}),
                        html.H3('BugID:',    style={'marginTop':'29'}),
                        html.H3('Pattern:',  style={'marginTop':'29'}),
                        html.H3('Desc:',     style={'marginTop':'29'}),
                        html.H3('Status:',   style={'marginTop':'29'}),
                    ],
                    style = {'dispaly':'inline-block', 'float':'left', 'marginLeft':'20%'}
                ),
                html.Div(
                    children = [
                        dcc.Dropdown(
                            id      = 'syn_dropdown',
                            options = [{'label': i, 'value':i} for i in self._loader.synd_db],
                            value   = '',
                            clearable = True,
                            multi = False,
                        ),
                        dcc.Input(
                            id    = 'syndrome',
                            type  = 'text',
                            style = {'marginTop':'13','width':'100%','height':'30','color':'green'}
                        ),
                        dcc.Input(
                            id    = 'bugid',
                            type  = 'text',
                            style = {'marginTop':'13','width':'100%','height':'30','color':'green'}
                        ),
                        dcc.Input(
                            id    = 'pattern',
                            type  = 'text',
                            style = {'marginTop':'13','width':'100%','height':'30','color':'green'}
                        ),
                        dcc.Input(
                            id    = 'desc',
                            type  = 'text',
                            style = {'marginTop':'13','width':'100%','height':'30','color':'green'}
                        ),
                        dcc.Input(
                            id    = 'status',
                            value = '',
                            type  = 'text', 
                            style = {'marginTop':'13','width':'100%','height':'30','color':'red'}
                        ),
                    ],
                    style = {
                        'dispaly'    : 'inline-block',
                        'width'      : '50%',
                        'marginLeft' : '20',
                        'marginTop'  : '20',
                        'fontWeight' : 'bold',
                        'float'      : 'left'
                    }
                ),
                html.Button(
                    'Update',
                    id       = 'up_button',
                    style    = {
                        'backgroundColor' : '#F0F0F0',
                        'color'           : 'green',
                        'marginLeft'      : '20%',
                        'marginTop'       : '15',
                        'fontSize'        : '18',
                        'fontWeight'      : 'bold',
                        'dispaly'         : 'inline-block'
                    },
                ),
                html.Button(
                    'Delete',
                    id       = 'del_button',
                    style    = {
                        'backgroundColor' : '#F0F0F0',
                        'color'           : 'green',
                        'marginLeft'      : '30',
                        'marginTop'       : '15',
                        'fontSize'        : '18',
                        'fontWeight'      : 'bold',
                        'dispaly'         : 'inline-block'
                    },
                ),
            ],
            style = {
                'textAlign' : 'left',
                'float'     : 'right',
                'width'     : '90%',
                'display'   : 'inline-block',
                'marginTop' : '50',
                'fontSize'  : '15',
#               'marginTop' : '10',
            }
        )
        return div

    def main_div_gen(self, proj, regr, div_pr, div_tn, div_co, div_rt):
        div  = html.Div([ 
            html.Div(
                id       = 'nav',
                children = [
                    html.A('PASSRATE',    href='#passing_rate_div', style={'color':'green'}),
                    html.Br(),html.Br(),
                    html.A('TESTNUM',     href='#test_num_div',     style={'color':'green'}),
                    html.Br(),html.Br(),
                    html.A('COVERAGE',    href='#coverage_div',     style={'color':'green'}),
                    html.Br(),html.Br(),
                    html.A('REGRTABLE',   href='#regr_table_div',   style={'color':'green'}),
                ],
                style = {
                    'float'           : 'left',
                    'border'          : 'solid #F1F1F1',
                    'backgroundColor' : 'rgba(240,240,240,0.85)',
                    'marginTop'       : '10',
                    'paddingLeft'     : '10',
                    'paddingRight'    : '10',
                    'paddingTop'      : '10',
                    'paddingBottom'   : '10',
                    'width'           : '7%',
                }
            ),
            html.Div(id='passing_rate_v', children = div_pr[proj][regr]),
            html.Div(id='test_num_v',     children = div_tn[proj][regr]),
            html.Div(id='coverage_v',     children = div_co[proj][regr]),
            html.Div(id='regr_table_v',   children = div_rt[proj][regr]),
            html.Div(
                id = 'synd_div',
                style = {
                    'textAlign' : 'left',
                    'float'     : 'right',
                    'width'     : '90%',
                    'display'   : 'inline-block',
                    'marginTop' : '10',
                }
            )
        ])
        return div

    def dash_gen(self):
        self._loader.load()

        project  = self._loader.projs
        db_dir   = self._loader.db_dir
        synd_dir = self._loader.synd_dir
        synd_db  = self._loader.synd_db
    
        head_div = html.Div(
            id       = 'head_div',
            children = [
                html.Img(
                    id     = 'logo',
                    src    = '/static/NVlogo.png',
                    width  = '87',
                    height = '65',
                    style  = {
                        'marginTop'     : '15',
                        'marginRight'   : '15',
                        'verticalAlign' : 'middle',
                    }
                ),
                'NVDLA REGRESSION REPORT',
            ],
            style    = {
                'textAlign'       : 'center',
                'verticalAlign'   : 'middle',
                'backgroundColor' : 'black',
                'height'          : '100',
                'width'           : '100%',
                'display'         :'inline-block',
                'fontSize'        :'27',
                'color'           : 'white'
            }
        )

        tab_div = html.Div(
            id = 'tab_div',
            children = [
                html.Div(
                    html.H4('PROJECT:  ', style={'marginTop':'30'}),
                    style = {'dispaly':'inline-block', 'float':'left', 'marginLeft':'15%'}
                ),
                html.Div(
                    dcc.Dropdown(
                        id        = 'proj_dp',
                        options   = [{'label':i, 'value':i,} for i in project],
                        value     = project[0],
                        clearable = True,
                        multi     = False,
                    ),
                    style = {
                        'dispaly'    : 'inline-block',
                        'width'      : '15%',
                        'marginLeft' : '3%',
                        'marginTop'  : '20',
                        'fontWeight' : 'bold',
                        'float'      : 'left'
                    }
                ),
                html.Div(
                    html.H4('REGRESSION:  ', style={'marginTop':'30'}),
                    style = {'dispaly':'inline-block', 'float':'left', 'marginLeft':'5%'}
                ),
                html.Div(
                    dcc.Dropdown(
                        id        = 'regr_dp',
                        options   = [],
                        value     = self._loader.proj_regr_dict[project[0]][0],
                        clearable = True,
                        multi     = False,
                    ),
                    style = {
                        'dispaly'    : 'inline-block',
                        'width'      : '15%',
                        'marginLeft' : '3%',
                        'marginTop'  : '20',
                        'fontWeight' : 'bold',
                        'float'      : 'left'
                    }
                ),
            ],
            style = {
                'textAlign'  : 'center',
                'float'      : 'right',
                'width'      : '90%',
                'display'    : 'inline-block',
#               'marginTop'  : '50',
                'fontSize'   : '17',
                'fontWeight' : 'bold',
            }
        )


        def full_div():
            self._loader.load()
            return html.Div(
                id = 'full',
                children = [
                    dcc.Location(id='url', pathname='', refresh=False),
                    head_div,
                    tab_div,
                    html.Div(
                        id       = 'main',
                        children = [
                            self.main_div_gen(
                                project[0], 
                                self._loader.proj_regr_dict[project[0]][0], 
                                self.passing_rate_div(), 
                                self.test_num_div(), 
                                self.coverage_div(), 
                                self.regr_table_div()
                            ),
                        ]
                    ),
                ],
                style = {
                    'backgroundColor' : 'snow'
                }
            )
        self._app.layout = full_div()

        @self._app.callback(dash.dependencies.Output('regr_dp', 'options'), 
                            [dash.dependencies.Input('proj_dp', 'value')])
        def display_content(selected_proj):
            if selected_proj in self._loader.proj_regr_dict:
                regr_list = self._loader.proj_regr_dict[selected_proj]
                return [{'label':i, 'value':i} for i in regr_list]
            else:
                return []

        # Add a static image route that serves images from desktop
        @self._app.server.route('{}<image_path>.png'.format('/static/'))
        def serve_image(image_path):
            image_name = '{}.png'.format(image_path)
            return flask.send_from_directory(db_dir, image_name)
    
        @self._app.callback(dash.dependencies.Output('passing_rate_v', 'children'),
                            [dash.dependencies.Input('proj_dp',        'value'), 
                             dash.dependencies.Input('regr_dp',        'value')])
        def show_passing_rate(proj,regr):
            self._proj = proj
            self._regr = regr
            if proj in self._loader.proj_regr_dict:
                if regr in self._loader.proj_regr_dict[proj]:
                    return self.passing_rate_div()[proj][regr]

        @self._app.callback(dash.dependencies.Output('test_num_v', 'children'),
                            [dash.dependencies.Input('proj_dp',    'value'), 
                             dash.dependencies.Input('regr_dp',    'value')])
        def show_test_num(proj,regr):
            if proj in self._loader.proj_regr_dict:
                if regr in self._loader.proj_regr_dict[proj]:
                    return self.test_num_div()[proj][regr]

        @self._app.callback(dash.dependencies.Output('coverage_v', 'children'),
                            [dash.dependencies.Input('proj_dp',    'value'), 
                             dash.dependencies.Input('regr_dp',    'value')])
        def show_coverage(proj,regr):
            if proj in self._loader.proj_regr_dict:
                if regr in self._loader.proj_regr_dict[proj]:
                    return self.coverage_div()[proj][regr]

        @self._app.callback(dash.dependencies.Output('regr_table_v', 'children'),
                            [dash.dependencies.Input('proj_dp',      'value'), 
                             dash.dependencies.Input('regr_dp',      'value')])
        def show_regr_table(proj,regr):
            if proj in self._loader.proj_regr_dict:
                if regr in self._loader.proj_regr_dict[proj]:
                    return self.regr_table_div()[proj][regr]

        @self._app.callback(dash.dependencies.Output('synd_div',   'children'),
                            [dash.dependencies.Input('regr_table', 'selected_row_indices'), 
                             dash.dependencies.Input('regr_table', 'rows'),])
        def display_syndrome(indices, rows):
            if self._proj in self._loader.proj_regr_dict:
                if self._regr in self._loader.proj_regr_dict[self._proj]:
                    if indices != []:
                        table_name = rows[indices[0]]['Date']+'_syndrome'
                        return self.syndrome_table_div()[self._proj][self._regr][table_name]

        @self._app.callback(dash.dependencies.Output('main', 'children'),
                            [dash.dependencies.Input('url',  'pathname')])
        def display_page(pathname):
            self._loader.load()
            table_name = 'test_status_'+pathname.lstrip('/')
            if self._proj != '' and self._regr != '':
                if table_name in self.test_table_div()[self._proj][self._regr]:
                    return html.Div([
                        self.test_table_div()[self._proj][self._regr][table_name],
                        html.Div(
                            children = [
                                dcc.Link(
                                    'BACK', 
                                    href  = '/nvdla', 
                                    style = {
                                        'color'          : 'green',
                                        'textDecoration' : 'underline',
                                        'cursor'         : 'pointer'
                                    }
                                ),
                            ],
                            style = {
                                'float'           : 'left',
#                               'border'          : 'solid #F1F1F1',
#                               'backgroundColor' : 'rgba(240,240,240,0.85)',
                                'marginTop'       : '10',
                                'marginLeft'      : '10',
                                'paddingLeft'     : '10',
                                'paddingRight'    : '10',
                                'paddingTop'      : '10',
                                'paddingBottom'   : '10',
                            }
                        ),
                        self.syndrome_div(),
                    ])
                else: 
                    return self.main_div_gen(
                        self._proj, 
                        self._regr, 
                        self.passing_rate_div(), 
                        self.test_num_div(), 
                        self.coverage_div(), 
                        self.regr_table_div()
                    )
            else:
                return self.main_div_gen(
                    project[0], 
                    self._loader.proj_regr_dict[project[0]][0],
                    self.passing_rate_div(), 
                    self.test_num_div(), 
                    self.coverage_div(), 
                    self.regr_table_div()
                )

        @self._app.callback(dash.dependencies.Output('syndrome',     'value'),
                            [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return value
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('pattern',      'value'),
                            [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return ';'.join(synd_db[value]['pattern'])
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('bugid',        'value'),
                            [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return ';'.join(synd_db[value]['bugid'])
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('desc',         'value'),
                            [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return synd_db[value]['desc']
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('syn_dropdown', 'options'),
                            [dash.dependencies.Input('up_button',    'n_clicks'),
                             dash.dependencies.Input('del_button',   'n_clicks')])
        def up_db(up_num,del_num):
            return [{'label': i, 'value':i} for i in synd_db]

        @self._app.callback(dash.dependencies.Output('status',     'value'),
                            [dash.dependencies.Input('up_button',  'n_clicks'),
                             dash.dependencies.Input('del_button', 'n_clicks'),
                             dash.dependencies.Input('syndrome',   'value'),
                             dash.dependencies.Input('bugid',      'value'),
                             dash.dependencies.Input('pattern',    'value'),
                             dash.dependencies.Input('desc',       'value')])
        def on_click(up_num,del_num,synd,bugid='',pattern='',desc=''):
            if (int(up_num or 0) > int(del_num or 0)) and synd != '':
                synd_info = dict(bugid   = str(bugid).split(';'),
                                 pattern = str(pattern).split(';'),
                                 desc    = desc)
                if synd not in synd_db:
                    synd_db[synd] = synd_info
                    with open(os.path.join(synd_dir,'syndrome.json'), 'w') as fh:
                        json.dump(synd_db, fh, sort_keys=True, indent=4)
                    return 'New syndrome registere done'
                elif synd_db[synd] != synd_info:
                    synd_db[synd] = synd_info
                    with open(os.path.join(synd_dir,'syndrome.json'), 'w') as fh:
                        json.dump(synd_db, fh, sort_keys=True, indent=4)
                    return 'Syndrome update done'
                else:
                    return 'Syndrome alredy existed'
            elif (int(up_num or 0)  < int(del_num or 0)) and synd != '':
                if synd in synd_db:
                    del(synd_db[synd])
                    with open(os.path.join(synd_dir,'syndrome.json'), 'w') as fh:
                        json.dump(synd_db, fh, sort_keys=True, indent=4)
                    return 'Syndrome delete done'
                else:
                    return 'Syndrome not existed'
            else:
                return ' '

        @self._app.callback(dash.dependencies.Output('up_button', 'n_clicks'),
                            [dash.dependencies.Input('syndrome',  'value'),
                             dash.dependencies.Input('bugid',     'value'),
                             dash.dependencies.Input('pattern',   'value'),
                             dash.dependencies.Input('desc',      'value')])
        def clear_click(synd,bugid,pat,desc):
            return 0

        @self._app.callback(dash.dependencies.Output('del_button', 'n_clicks'),
                            [dash.dependencies.Input('syndrome',   'value'),
                             dash.dependencies.Input('bugid',      'value'),
                             dash.dependencies.Input('pattern',    'value'),
                             dash.dependencies.Input('desc',       'value')])
        def clear_click(synd,bugid,pat,desc):
            return 0


    def run(self):
        self._app.run_server(debug=True)
#       self._app.run_server(debug=True, host='172.20.213.206')

def main():
    parser = argparse.ArgumentParser(formatter_class = argparse.RawDescriptionHelpFormatter, 
                                     description     = __DESCRIPTION__)
    parser.add_argument('--db_dir', '-db_dir', dest='db_dir', required=False, default='.',
                        help='Specify regression status database direcotry for loading json file')
    parser.add_argument('--syndrome_dir', '-syndrome_dir', dest='syndrome_dir', required=False, 
                        default='.', help='Specify direcotry for loading syndrome database')
    config      = vars(parser.parse_args())
    run_metrics = RunMetrics(config)
    run_metrics.run()


if __name__ == '__main__':
    main()
