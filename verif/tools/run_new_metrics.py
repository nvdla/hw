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

    def __init__(self, config):
        self._cfg         = dict(config)
        self._regr_db     = []
        self._syndrome_db = {}
        self._x_axis      = []
        self._y_axis      = []
        self._tests_db    = []

    def natural_sort(self, text):
        return int(re.sub('\D+','',text))

    def load_db(self):
        self._tests_db = [x for x in glob.glob('{}/test*.json'.format(self._cfg['db_dir']))]
        self._tests_db.sort(key=self.natural_sort)
        db_list = [x for x in glob.glob('{}/regr*.json'.format(self._cfg['db_dir']))]
        db_list.sort(key=self.natural_sort)
        for idx in range(len(db_list)):
            sts_file = db_list[idx]
            with open(sts_file, 'r') as fh:
                db = json.load(fh)
            self._regr_db.append(db)
        with open(os.path.join(self._cfg['syndrome_dir'],'syndrome.json'), 'r') as syn_fh:
            self._syndrome_db = json.load(syn_fh)

    def load_x_axis(self):
        for idx in range(len(self._regr_db)):
            db = self._regr_db[idx]
            time_str = db['start_time'].split('-')
            date = list(map(int, time_str)) 
            self._x_axis.append(datetime(date[0],date[1],date[2],date[3],date[4],date[5]))

    def load_y_axis(self):
        passing_rate_dict = {'total':[]}
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
            planned_test_num.append(db['metrics_result']['planned_test_number'])
            running_test_num.append(db['metrics_result']['running_test_number'])
            code_cov.append(db['metrics_result']['code_coverage'])
            func_cov.append(db['metrics_result']['functional_coverage'])
        self._y_axis = [passing_rate_dict, planned_test_num, running_test_num, code_cov, func_cov]

    def load(self):
        self.load_db()
        self.load_x_axis()
        self.load_y_axis()

    def run(self):
        div_plot = DivPlot()
        div_plot.test_table_div(self._tests_db)
        div_plot.syndrome_table_div(self._tests_db, self._syndrome_db)
        div_plot.dash_gen(self._x_axis, self._y_axis, self._regr_db, self._syndrome_db, self._cfg['regression_name'], self._cfg['db_dir'], self._cfg['syndrome_dir'])
        div_plot.run()


class DivPlot():
    def __init__(self):
        self._app                                     = dash.Dash()
        self._app.scripts.config.serve_locally        = True,
        self._app.css.config.serve_locally            = True,
        self._test_table_divs                         = {}
        self._syndrome_table_divs                     = {}
        self._app.config.suppress_callback_exceptions = True

    def passing_rate_div(self, x_axis=[], y_axis=[]):
        div = html.Div(
            id       = 'passing_rate_div', 
            children = [
                html.H3('PASSING RATE'),
                html.Hr(),
                dcc.Graph(
                    id     = 'passing_rate',
                    figure = {
                        'data'  : [
                            Scatter(
                                x       = x_axis,
                                y       = y_axis[i],
                                text    = i,
                                name    = re.sub('_passing_rate','',i)
                            ) for i in y_axis.keys()
                        ],
                        'layout': Layout(
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
        return div

    def test_num_div(self, x_axis=[], y_axis=[]):
        div = html.Div(
            id       = 'test_num_div', 
            children = [
                html.H3('TEST NUM'),
                html.Hr(),
                dcc.Graph(
                    id     = 'test_num',
                    figure = {
                        'data'  : [
                            Scatter(
                                x       = x_axis,
                                y       = y_axis[i],
                                text    = i,
                                name    = i 
                            ) for i in y_axis.keys()
                        ],
                        'layout': Layout(
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
        return div
    
    def coverage_div(self, x_axis=[], y_axis=[]):
        div = html.Div(
            id       = 'coverage_div', 
            children = [
                html.H3('COVERAGE'),
                html.Hr(),
                dcc.Graph(
                    id     = 'coverage',
                    figure = {
                        'data'  : [
                            Scatter(
                                x       = x_axis,
                                y       = y_axis[i],
                                text    = i,
                                name    = i 
                            ) for i in y_axis.keys()
                        ],
                        'layout': Layout(
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
                            yaxis         = dict(tickformat='.2%', linewidth=2, showline=True, range=[0,1], title='Value'),
                            height        = '700',
                            legend        = dict(x=0, y=1),
                            paper_bgcolor = 'rgba(240,240,240,0.85)',
                            plot_bgcolor  = 'rgba(240,255,255,0.85)',
                            hovermode     = 'closet'
                        )
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
        return div
    
    def regr_table_div(self, db=[], name =''):
        ROW = []
        for idx in range(len(db)):
            item              = {}
            item['Name']      = name
            item['Date']      = db[idx]['start_time']
            item['Seed']      = db[idx]['plan_seed']
            item['CommitID']  = db[idx]['unique_id'][0:10]
            item['Status']    = db[idx]['status']
            item['Cov']       = 'Func:{:.2%} Code:{:.2%}'.format(db[idx]['metrics_result']['functional_coverage'],db[idx]['metrics_result']['code_coverage'])
            item['PassingRate']       = dcc.Link('{:.2%}'.format(db[idx]['metrics_result']['passing_rate']), href=db[idx]['start_time'])
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
                    #resizable           = True,
                    sortable             = True,
                    #column_width        = 200,
                    row_height           = 30,
                    min_height           = 400,
                    selected_row_indices = [],
                )
            ],
            style = {
                'textAlign' : 'left',
                'float'     : 'right',
                'width'     : '90%',
                'display'   : 'inline-block',
                'marginTop' : '10',
            }
        )
        return div
    
    def syndrome_table_div(self, db=[], synd_db={}):
        for idx in range(len(db)):
            name = re.sub('.json', '', os.path.basename(db[idx])).lstrip('test_status_') + '_syndrome'
            with open(db[idx], 'r') as fh:
                test_db = json.load(fh)

            ROW = []
            for idx,info in test_db.items():
                if info['syndrome'] != '':
                    item = {}
                    if info['syndrome'] in synd_db:
                        item['Syndrome'] = info['syndrome']
                        item['BugID']    = synd_db[info['syndrome']]['bugid']
                        item['Pattern']  = synd_db[info['syndrome']]['pattern']
                        item['Desc']     = synd_db[info['syndrome']]['desc']
                    else:
                        item['Syndrome'] = info['syndrome']
                        item['BugID']    = ''
                        item['Pattern']  = ''
                        item['Desc']     = ''
                    ROW.append(item)
            if not ROW:
                ROW = [dict(Syndrome='',BugID='',Pattern='',Desc='')]
            div = html.Div(
                id       = name,
                children = [
                    html.H3('Syndrome TABLE : '+name,style={'textAlign':'center'}),
                    html.Hr(),
                    table.DataTable(
                        id                   = name+'_table',
                        rows                 = ROW,
                        filterable           = True,
                        editable             = False,
                        enable_drag_and_drop = True,
                        row_selectable       = True,
                        #resizable           = True,
                        sortable             = True,
                        #column_width        = [50,320,100,200,400,400,],
                        row_height           = 120,
                        min_height           = 500,
                        selected_row_indices = [],
                    )
                ],
                style = {
                    'textAlign' : 'left',
                    'float'     : 'left',
                    'width'     : '100%',
                    'display'   : 'inline-block',
                    'fontSize'  : '12',
                    'marginTop' : '10',
                }
            )
            self._syndrome_table_divs[name] = div

    def test_table_div(self, db=[]):
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
                        id                   = name+'_table',
                        rows                 = ROW,
                        filterable           = True,
                        editable             = False,
                        enable_drag_and_drop = True,
                        row_selectable       = True,
                        #resizable           = True,
                        sortable             = True,
                        #column_width        = [50,320,100,200,400,400,],
                        row_height           = 30,
                        min_height           = 800,
                        selected_row_indices = [],
                    )
                ],
                style = {
                    'textAlign' : 'left',
                    'float'     : 'right',
                    'width'     : '90%',
                    'display'   : 'inline-block',
                    'fontSize'  : '15',
                    #'marginTop' : '10',
                }
            )
            self._test_table_divs[name] = div
    
    def syndrome_div(self, synd_db={}):
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
                    style = {'dispaly':'inline-block', 'float':'left', 'marginLeft':'300'}
                ),
                html.Div(
                    children = [
                        dcc.Dropdown(
                            id      = 'syn_dropdown',
                            options = [{'label': i, 'value':i} for i in synd_db],
                            value   = '',
                            clearable = True,
                            multi = False,
                        ),
                        dcc.Input(id='syndrome', type='text', style={'marginTop':'13','width':'845','height':'30','color':'green'}),
                        dcc.Input(id='bugid',    type='text', style={'marginTop':'13','width':'845','height':'30','color':'green'}),
                        dcc.Input(id='pattern',  type='text', style={'marginTop':'13','width':'845','height':'30','color':'green'}),
                        dcc.Input(id='desc',     type='text', style={'marginTop':'13','width':'845','height':'30','color':'green'}),
                        dcc.Input(id='status',  value='', type='text', style={'marginTop':'13','width':'845','height':'30','color':'red'}),
                    ],
                    style = {'dispaly':'inline-block', 'width':'50%', 'marginLeft':'20','marginTop':'20', 'fontWeight':'bold', 'float':'left'}
                ),
                html.Button(
                    'Update',
                    id       = 'up_button',
                    style    = {'backgroundColor' : '#F0F0F0', 'color':'green', 'marginLeft':'330', 'marginTop':'15', 'fontSize':'18', 'fontWeight':'bold', 'dispaly':'inline-block'},
                ),
                html.Button(
                    'Delete',
                    id       = 'del_button',
                    style    = {'backgroundColor' : '#F0F0F0', 'color':'green', 'marginLeft':'30', 'marginTop':'15', 'fontSize':'18', 'fontWeight':'bold', 'dispaly':'inline-block'},
                ),
            ],
            style = {
                'textAlign' : 'left',
                'float'     : 'right',
                'width'     : '90%',
                'display'   : 'inline-block',
                'marginTop' : '50',
                'fontSize'  : '15',
                #'marginTop' : '10',
            }
        )
        return div


    def dash_gen(self, x_axis=[], y_axis=[], regr_db=[], synd_db={}, regr_name='', db_dir='', synd_dir=''):
    
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

        main_div  = html.Div([ 
            html.Div(
                id       = 'nav',
                children = [
                    html.A('PASSINGRATE', href='#passing_rate_div', style={'color':'green'}),
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
                }
            ),
            self.passing_rate_div(x_axis, y_axis[0]),
            self.test_num_div(x_axis, dict(PLANNED=y_axis[1], RUNNING=y_axis[2])),
            self.coverage_div(x_axis, dict(CODE=y_axis[3], FUNC=y_axis[4])),
            self.regr_table_div(regr_db, regr_name),
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

        self._app.layout = html.Div(
            id = 'full',
            children = [
                dcc.Location(id='url', pathname='', refresh=False),
                head_div,
                html.Div(
                    id       = 'main',
                    children = [
                        main_div,
                    ]
                ),
            ],
            style = {
                'backgroundColor' : 'snow'
            }
        )


        # Add a static image route that serves images from desktop
        @self._app.server.route('{}<image_path>.png'.format('/static/'))
        def serve_image(image_path):
            image_name = '{}.png'.format(image_path)
            return flask.send_from_directory(db_dir+'/../../../', image_name)
    
        @self._app.callback(dash.dependencies.Output('synd_div', 'children'),
                           [dash.dependencies.Input('regr_table','selected_row_indices'), dash.dependencies.Input('regr_table','rows')])
        def display_syndrome(indices, rows):
            if indices != []:
                table_name = rows[indices[0]]['Date']+'_syndrome'
                return self._syndrome_table_divs[table_name]
            else:
                table_name = rows[0]['Date']+'_syndrome'
                return self._syndrome_table_divs[table_name]

        @self._app.callback(dash.dependencies.Output('main', 'children'),
                      [dash.dependencies.Input('url', 'pathname')])
        def display_page(pathname):
            table_name = 'test_status_'+pathname.lstrip('/')
            if table_name in self._test_table_divs:
                return html.Div([
                    self._test_table_divs[table_name],
                    html.Div(
                        children = [
                            html.A('BACK', href='/', style={'color':'green'}),
                        ],
                        style = {
                            'float'           : 'left',
                            'border'          : 'solid #F1F1F1',
                            'backgroundColor' : 'rgba(240,240,240,0.85)',
                            'marginTop'       : '10',
                            'marginLeft'      : '10',
                            'paddingLeft'     : '10',
                            'paddingRight'    : '10',
                            'paddingTop'      : '10',
                            'paddingBottom'   : '10',
                        }
                    ),
                    self.syndrome_div(synd_db)
                ])
            else:
                return main_div

        @self._app.callback(dash.dependencies.Output('syndrome', 'value'),
                      [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return value
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('pattern', 'value'),
                      [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return ';'.join(synd_db[value]['pattern'])
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('bugid', 'value'),
                      [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return ';'.join(synd_db[value]['bugid'])
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('desc', 'value'),
                      [dash.dependencies.Input('syn_dropdown', 'value')])
        def show_synd_bugid(value):
            if value in synd_db:
                return synd_db[value]['desc']
            else:
                return ''

        @self._app.callback(dash.dependencies.Output('status', 'value'),
                            [dash.dependencies.Input('up_button', 'n_clicks'),dash.dependencies.Input('del_button', 'n_clicks'),dash.dependencies.Input('syndrome', 'value'),
                            dash.dependencies.Input('bugid', 'value'),dash.dependencies.Input('pattern', 'value'),  dash.dependencies.Input('desc', 'value')])
        def on_click(up_num,del_num,synd,bugid='',pattern='',desc=''):
            if (int(up_num or 0) > int(del_num or 0)) and synd != '':
                synd_info = dict(bugid=str(bugid).split(';'),pattern=str(pattern).split(';'),desc=desc)
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
                            [dash.dependencies.Input('syndrome', 'value'),dash.dependencies.Input('bugid', 'value'),
                             dash.dependencies.Input('pattern', 'value'), dash.dependencies.Input('desc', 'value')])
        def clear_click(synd,bugid,pat,desc):
            return 0

        @self._app.callback(dash.dependencies.Output('del_button', 'n_clicks'),
                            [dash.dependencies.Input('syndrome', 'value'),dash.dependencies.Input('bugid', 'value'),
                             dash.dependencies.Input('pattern', 'value'), dash.dependencies.Input('desc', 'value')])
        def clear_click(synd,bugid,pat,desc):
            return 0


    def run(self):
        self._app.run_server(debug=True)

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=__DESCRIPTION__)
    parser.add_argument('--db_dir', '-db_dir', dest='db_dir', required=False, default='.',
                        help='Specify regression status database direcotry for loading json file')
    parser.add_argument('--syndrome_dir', '-syndrome_dir', dest='syndrome_dir', required=False, default='.',
                        help='Specify direcotry for loading syndrome database')
    parser.add_argument('--regression_name', '--regr_name', '-regression_name', '-regr_name', dest='regression_name', 
                        required=True, default='random',
                        help='Specify regression name which is used as the name of generated web page')
    config = vars(parser.parse_args())
    run_metrics = RunMetrics(config)
    run_metrics.load()
    run_metrics.run()


if __name__ == '__main__':
    main()
