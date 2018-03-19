#if !defined(_eric_iface_H_)
#define _eric_iface_H_

#include <stdint.h>
#ifndef _aaa0_struct_H_
#define _aaa0_struct_H_

typedef struct aaa0_s {
    sc_int<7> addr ; 
    sc_int<3> size ; 
    sc_int<2> flush ; 
} aaa0_t;

#endif
#ifndef _aaa1_struct_H_
#define _aaa1_struct_H_

typedef struct aaa1_s {
    sc_int<7> addr ; 
    sc_int<3> size ; 
    sc_int<5> data[3] ; 
} aaa1_t;

#endif
#ifndef _aaa2_struct_H_
#define _aaa2_struct_H_

typedef struct aaa2_s {
    sc_int<3> cmd ; 
} aaa2_t;

#endif

union eric_u {
    aaa0_t aaa0;
    aaa1_t aaa1;
    aaa2_t aaa2;
};
typedef struct eric_s {
    union eric_u pd ; 
} eric_t;

#endif // !defined(_eric_iface_H_)
