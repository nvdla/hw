
//------------------------------------------------------------//
//   Copyright 2009-2012 Mentor Graphics Corporation          //
//   All Rights Reserved Worldwid                             //
//                                                            //
//   Licensed under the Apache License, Version 2.0 (the      //
//   "License"); you may not use this file except in          //
//   compliance with the License.  You may obtain a copy of   //
//   the License at                                           //
//                                                            //
//       http://www.apache.org/licenses/LICENSE-2.0           //
//                                                            //
//   Unless required by applicable law or agreed to in        //
//   writing, software distributed under the License is       //
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR   //
//   CONDITIONS OF ANY KIND, either express or implied.  See  //
//   the License for the specific language governing          //
//   permissions and limitations under the License.           //
//------------------------------------------------------------//


// Todo
// - replace cout messages with SC_REPORTs


#include "uvmc_connect.h"

#include <iostream>
using std::ifstream;
using std::istringstream;

//------------------------------------------------------------------------------
// Function- SV2C_resolve_binding

using namespace uvmc;

int SV2C_resolve_binding(
    const char *sv_port_name,  // port name to use when looking for a match
    const char *sv_lookup,     // alternate name to look for match
    const char *sv_trans_type, // transaction type for checking compatibility
    int         dummy,
    int         sv_proxy_kind, // port type for checking compatibility
    int         sv_mask,       // mask for checking compatibility
    int         sv_id,         // IN: id of SV port/imp to map
    int *       sc_id)         // OUT: return id of mapped SC port/channel
{
  string lookup(sv_lookup);
  string port_name(sv_port_name);
  string trans_type(sv_trans_type);
  bool ok;

  //cout << "SV2C_resolve_binding - sv_port_name=" << sv_port_name << " sv_lookup=" << sv_lookup << " sv_trans_type=" << sv_trans_type << " dummy=" << dummy << " sv_proxy_kind=" << sv_proxy_kind << " sv_mask=" << sv_mask << " sv_id=" << sv_id << endl;

  if (!uvmc_pkg_scope) {
    uvmc_set_scope();
  }
  sv_ready_e.notify();

  ok = uvmc_proxy_base::resolve(port_name,lookup,sv_mask,
                                trans_type,sv_id,
                                sv_proxy_kind, sc_id);

  if (!ok) {
    cerr << "UVMC Error: Cannot find binding for port registered with ";
    if (lookup.compare("")) {
      cerr << "names '" << port_name << "' and '" << lookup << "'";
    }
    else {
          cerr << "name '" << port_name << "'";
    }
    cerr << endl;
    return 0;
  }
  return 1;
}




//------------------------------------------------------------------------------
namespace uvmc {

using std::string;
using std::map;

map<string,string> x_name_pairs;

// Function- uvmc_connect_by_name
//
// Makes a connection between two ports by name. The ports do not need to
// exist yet, but at least one must exist in SV by the time resolve_bindings
// is called.

int uvmc_connect_by_name(string port1_name, string port2_name)
{
  map<string,string>::iterator iter;
  iter = x_name_pairs.find(port1_name);
  if (iter != x_name_pairs.end() &&
      !x_name_pairs[port1_name].compare(port2_name)) {
    cout << "UVMC-C Fatal: Name '" << port1_name
         << "' is already mapped to '" << port2_name << "'" << endl;
    return 0;
  }
  iter = x_name_pairs.find(port2_name);
  if (iter != x_name_pairs.end() &&
      !x_name_pairs[port2_name].compare(port1_name)) {
    cout << "UVMC-C Fatal: Name '" << port1_name
         << "' is already mapped to '" << port2_name << "'" << endl;
    return 0;
  }
  // store away for later, during binding resolution
  x_name_pairs[port1_name] = port2_name;
  return 1;
}




// Function- uvmc_resolve_name_pair
//
//
// ISSUE: can not construct an object bystring name unless object
// was previously registered with a factory or object provides a factory-like
// method. Unfortunately, sc_port< tlm_*_if<T> > is not
// something we can automatically register with a factory.

int uvmc_resolve_name_pair(string port1_name, string port2_name)
{

  sc_object* obj;
  
  obj = sc_find_object(port1_name.c_str());
  sc_port_base *p1_base;
  if (obj != NULL) {
    if ((p1_base = dynamic_cast<sc_port_base*>(obj))) {
    }
    else {
      cout << "Fatal: Object with name '" << port1_name
           << "' is not a port" << endl;
    }
  }
  
  obj = sc_find_object(port2_name.c_str());
  sc_port_base *p2_base;
  if (obj != NULL) {
    if ((p2_base = dynamic_cast<sc_port_base*>(obj))) {
    }
    else {
      cout << "Fatal: Object with name '" << port2_name
           << "' is not a port" << endl;
    }
  }
  // sc_port< tlm_??_if<??> > port1;
  // sc_port< tlm_??_if<??> > port2;

  /*
  if (port1 != NULL && port2 == NULL) {
    port1.x_connect(port2_name);
    return 1;
  }
  else if (port1 != NULL && port1 == NULL) {
    //port2.x_connect(port1_name);
    return 1;
  }
  else if (port1 != null && port2 != null) {
    if (port1 == port2) {
      cout << "Fatal: Names '" << port1_name << "' and '" 
           << port2_name << "' are mapped to same port instance" << endl;
    }
    // connecting two SC-side ports - not supported (yet?)
    cout << "Fatal: Names '" << port1_name << "' and '" 
         << port2_name << "' both exist in SC" << endl;
    // port1.connect_(port2);
  }
  else {
    cout << "Fatal: Cannot find any port with the name '"
         << port2_name << "' or '" << port2_name << "'" << endl;
  }
  */
  return 0;
}


// Function- uvmc_resolve_name_bindings
//
//

int uvmc_resolve_name_bindings()
{
  static int resolved;
  if (resolved)
    return 1;
  map<string,string>::iterator iter;
  for (iter = x_name_pairs.begin(); iter != x_name_pairs.end(); iter++) {
    if (!uvmc_resolve_name_pair((*iter).first,(*iter).second))
      return 0;
  }
  return 1;
}


}; // namespace uvmc

using uvmc::uvmc_connect_by_name;


// Function- uvmc_read_connections_file
//
// Reads name pairs from an external file

int uvmc_read_connections_file(const string filename)
{
  ifstream file;
  int rd_err;
  string line;
  string port1_name, port2_name;
  istringstream istream;
  file.open(filename.c_str());
  if (file.is_open()) {
    getline(file,line);
    while (!file.eof()) {
      rd_err=0;
      istream.clear();
      istream.str(line);
      istream >> port1_name >> port2_name;

      if (!port1_name.substr(0,3).compare("SC:")) {
        port1_name = port1_name.substr(3);
        cout << endl << "*** TBD bind to SC port with this name: "
             << port1_name << endl << endl;
      }
      else if (!port1_name.substr(0,3).compare("SV:")) {
        port1_name = port1_name.substr(3);
      }
      else {
        cerr << "UVMC Error: reading file '" << filename << "'. First field '" 
             << port1_name << "' must start with SC: or SV:" << endl;
        rd_err=1;
      }
      if (!port2_name.substr(0,3).compare("SC:")) {
        port2_name = port2_name.substr(3);
        // lookup name in registry
        cout << endl << "*** TBD bind to SC port with this name: "
             << port2_name << endl << endl;
      }
      else if (!port2_name.substr(0,3).compare("SV:")) {
        port2_name = port2_name.substr(3);
      }
      else {
        cerr << "UVMC Error: reading file '" << filename << "'. Second field '" 
             << port2_name << "' must start with SC: or SV:" << endl;
        rd_err=1;
      }
      if (!rd_err) {
        uvmc_connect_by_name(port1_name,port2_name); 
      }
      //cout << "port1_name=" << port1_name << " port2_name=" << port2_name << endl;
      getline(file,line);
    }
    file.close();
  }
  else {
    cerr << "UVMC Error: Cannot open connections file '" << file << "'" << endl;
    return -1;
  }
  return 0;
}



