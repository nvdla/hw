// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: gp_mm.h

#ifndef _GP_MM_H_
#define _GP_MM_H_

#include "tlm.h"
#include <sstream>
#include <iomanip>
#include <stdint.h>
#include "scsim_common.h"
#include "log.h"



SCSIM_NAMESPACE_START(clib)


class gp_mm: public tlm::tlm_mm_interface
{
  typedef tlm::tlm_generic_payload gp_t;

public:
  static gp_mm* getGPMemManager();
 
  gp_t* allocate();
  
  void  free(gp_t* trans);
 
  static void deleteGPMemManager();

private:
  gp_mm(); 

  gp_mm(gp_mm const&) { }           

  gp_mm& operator=(gp_mm const&) { return *m_mm; }

  virtual ~gp_mm();

  static gp_mm* m_mm;

  struct access
  {
    gp_t* trans;
    access* next;
    access* prev;
  };

  access* free_list;
  access* empties;
 // int count;
};

SCSIM_NAMESPACE_END()

#endif
