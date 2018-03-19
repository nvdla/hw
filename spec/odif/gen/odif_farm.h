#if !defined(_farm_iface_H_)
#define _farm_iface_H_

#include <stdint.h>
typedef struct farm_s {
    sc_int<7> addr ; 
    sc_int<3> size ; 
    sc_int<2> flush ; 
    sc_int<3> reset[2] ; 
} farm_t;

#endif // !defined(_farm_iface_H_)
