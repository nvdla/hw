// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: gp_mm.cpp

#include "gp_mm.h"
USING_SCSIM_NAMESPACE(clib)


gp_mm* gp_mm::m_mm = NULL; 
 
gp_mm* gp_mm::getGPMemManager()
{
   if (!m_mm)   // Only allow one instance of class to be generated.
      m_mm = new gp_mm;

   return m_mm;
}

void gp_mm::deleteGPMemManager()
{
   delete m_mm;
}

gp_mm::gp_mm() : free_list(0), empties(0)/*, count(0)*/ {}

gp_mm::~gp_mm()
{

  gp_t* ptr;

  while (free_list)
  {
    ptr = free_list->trans;

    // Delete generic payload and all extensions
    assert(ptr);
    delete ptr;

    free_list = free_list->next;
  }

  while (empties)
  {
    access* x = empties;
    empties = empties->next;

    // Delete free list access struct
    delete x;
  }
}

gp_mm::gp_t* gp_mm::allocate()
{
  gp_t* ptr;
  if (free_list)
  {
    ptr = free_list->trans;
    empties = free_list;
    free_list = free_list->next;
  }
  else
  {
    ptr = new gp_t(this);
  }
  return ptr;
}

void gp_mm::free(gp_t* trans)
{
  trans->reset(); // Delete auto extensions
  if (!empties)
  {
    empties = new access;
    empties->next = free_list;
    empties->prev = 0;
    if (free_list)
      free_list->prev = empties;
  }
  free_list = empties;
  free_list->trans = trans;
  empties = free_list->prev;
}
