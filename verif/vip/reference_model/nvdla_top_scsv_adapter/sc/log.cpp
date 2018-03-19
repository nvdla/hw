#include "log.h"

#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <vector>
#include <iostream>
#include <locale>

#include <stdio.h>
#include <systemc.h>

#define SC_ACTION_ENABLE  (SC_LOG | SC_DISPLAY)
#define SC_ACTION_DISABLE (SC_DO_NOTHING)

const char PCI_RPT_PROTOCOL_READ_RETRY[] = "PCI Read Retry";

using namespace std;
template <class Container>
static void split(const string& str, Container& cont, char delim)
{
    stringstream ss(str);
    string token;
    while (getline(ss, token, delim)) {
        cont.push_back(token);
    }
}

static string trim(const string &s)
{
    string::const_iterator it = s.begin();
    while (it != s.end() && isspace(*it))
        it++;
 
    string::const_reverse_iterator rit = s.rbegin();
    while (rit.base() != it && isspace(*rit))
        rit++;
 
    return string(it, rit.base());
}

static void set_sc_report(const string &msg, const string &level, int t)
{
    const char *msg_char = msg.c_str();

    if (0 == msg.compare("outfile"))
    {
        if(3 == t) {
            const char *file_name = level.c_str();
            sc_report_handler::set_log_file_name(file_name);
            cout << "Set SC LOG file to " << file_name << endl;
        } else if(1 == t) {
            const char file_name[] = "outfile";
            sc_report_handler::set_log_file_name(file_name);
            cout << "Set SC LOG file to default " << file_name << endl;
        } else {
            cout << "Error: Should not come here" << endl;
        }

        return;
    }

    if (0 == msg.compare("verbosity_level"))
    {
        int verbosity_lvl = -1;
        if (0 == level.compare("sc_none"))
            verbosity_lvl = SC_NONE;
        if (0 == level.compare("sc_low"))
            verbosity_lvl = SC_LOW;
        if (0 == level.compare("sc_medium"))
            verbosity_lvl = SC_MEDIUM;
        if (0 == level.compare("sc_high"))
            verbosity_lvl = SC_HIGH;
        if (0 == level.compare("sc_full"))
            verbosity_lvl = SC_FULL;
        if (0 == level.compare("sc_debug"))
            verbosity_lvl = SC_DEBUG;
        if (-1 == verbosity_lvl)
        {
            cout << "Invalid debug verbosity " << level << " ...Ignore it" << endl;
            return;
        }
        sc_report_handler::set_verbosity_level(verbosity_lvl);
        cout << "Set debug verbosity to " << level << endl;

        return;
    }
    int report_lvl = -1;
    if (0 == level.compare("info"))
        report_lvl = SC_INFO;
    if (0 == level.compare("warning"))
        report_lvl = SC_WARNING;
    if (0 == level.compare("error"))
        report_lvl = SC_ERROR;
    if (0 == level.compare("fatal"))
        report_lvl = SC_FATAL;
    if (0 == level.compare("enable"))
        report_lvl = 4;
    if (0 == level.compare("disable"))
        report_lvl = 5;

    if (-1 == report_lvl)
    {
        cout << "Invalid report level " << level << " ...Ignore it" << endl;
        return;
    }

    int sc_actions[4] = {0};
    sc_actions[0] = (report_lvl <= SC_INFO)?SC_DEFAULT_INFO_ACTIONS:SC_ACTION_DISABLE;
    sc_actions[1] = (report_lvl <= SC_WARNING)?SC_DEFAULT_WARNING_ACTIONS:SC_ACTION_DISABLE;
    sc_actions[2] = (report_lvl <= SC_ERROR)?SC_DEFAULT_ERROR_ACTIONS:SC_ACTION_DISABLE;
    sc_actions[3] = (report_lvl <= SC_FATAL)?SC_DEFAULT_FATAL_ACTIONS:SC_ACTION_DISABLE;

    if (4 == report_lvl) {
        sc_actions[0] = SC_DEFAULT_INFO_ACTIONS;
        sc_actions[1] = SC_DEFAULT_WARNING_ACTIONS;
        sc_actions[2] = SC_DEFAULT_ERROR_ACTIONS;
        sc_actions[3] = SC_DEFAULT_FATAL_ACTIONS;
    }
    if (5 == report_lvl) {
        sc_actions[0] = SC_ACTION_DISABLE;
        sc_actions[1] = SC_ACTION_DISABLE;
        sc_actions[2] = SC_ACTION_DISABLE;
        sc_actions[3] = SC_ACTION_DISABLE;
    }
    
    switch(t){
    case 0:
    case 1:
            cout << "Error: Invalid control string. Should not come here" << endl;
            break;
    case 2:
            sc_report_handler::set_actions(SC_INFO, sc_actions[0]);
            sc_report_handler::set_actions(SC_WARNING, sc_actions[1]);
            sc_report_handler::set_actions(SC_ERROR, sc_actions[2]);
            sc_report_handler::set_actions(SC_FATAL, sc_actions[3]);
            break;
    case 3:
            sc_report_handler::set_actions(msg_char, SC_INFO, sc_actions[0]);
            sc_report_handler::set_actions(msg_char, SC_WARNING, sc_actions[1]);
            sc_report_handler::set_actions(msg_char, SC_ERROR, sc_actions[2]);
            sc_report_handler::set_actions(msg_char, SC_FATAL, sc_actions[3]);
            break;
    }
}

void log_parse(const string &s)
{
    if (s.empty())
    {
        cout << "Warning: No SC_LOG env Here" << endl;
        return;
    }

    cout << "sc_log control string: [" << s << "]" << endl;
    vector<string> infos;
    split(s, infos, ';');
    // for (auto val : infos)
    for (vector<string>::iterator val = infos.begin(); val != infos.end(); ++val)
    {
        vector<string> info;
        if (val->find(':') == string::npos)
        {
            cout << "Error SC_LOG format '" << *val << "' in " << s;
            cout << " ...Ignore it" << endl;
            continue;
        }

        split(*val, info, ':');
        if (info.empty())
            continue;

        if (1 == info.size())
            info.push_back("");

        if (2 == info.size())
        {
            string msg_str = trim(info[0]);
            string level_str = trim(info[1]);
            int type = 0;
            if (0 != msg_str.compare(""))
            {
                type |= (1<<0);
            }
            if (0 != level_str.compare(""))
            {
                type |= (1<<1);
            }
            set_sc_report(msg_str, level_str, type);
        } else {
            cout << "Error SC_LOG format '" << *val << "' in " << s;
            cout << " ...Ignore it" << endl;
            continue;
        }
    }

    if (sc_report_handler::get_log_file_name() == NULL)
    {
        const char file_name[] = "outfile";
        sc_report_handler::set_log_file_name(file_name);
        cout << "Set SC LOG file to default " << file_name << endl;
    }
}
