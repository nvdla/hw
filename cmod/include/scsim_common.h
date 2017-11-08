//GP Router Header 
#ifndef _SCSIM_COMMON_H_
#define _SCSIM_COMMON_H_
// clib 
// cmod
#define SCSIM_NAMESPACE_START(type) \
    namespace scsim {\
    namespace type {

#define SCSIM_NAMESPACE_END() \
    }\
    }

#define USING_SCSIM_NAMESPACE(type) \
    using namespace scsim::type;


typedef unsigned long long            BUS_ADDR_TYPE_64;
typedef unsigned char                 BUS_DATA_TYPE_8;
typedef unsigned short                BUS_DATA_TYPE_16;
typedef unsigned int                  BUS_DATA_TYPE_32;
typedef unsigned long long            BUS_DATA_TYPE_64;

// #include <systemc.h>
// #include <tlm.h>

// Dummy namespace to reserve namespace
SCSIM_NAMESPACE_START(clib)

// Calculate bus widths in 32-bit integers
// Helper macro to calculate bus widths in 32-bit integers
#define BUS_INTS( w ) (((w) + 31) >> 5)

SCSIM_NAMESPACE_END()

SCSIM_NAMESPACE_START(cmod)
SCSIM_NAMESPACE_END()

#endif
