`ifndef MEM_MAN_DEFINE_SVH
`define MEM_MAN_DEFINE_SVH

`ifndef MEM_ADDR_SIZE_MAX
    `define MEM_ADDR_SIZE_MAX       64
`endif

typedef enum { ALLOC_FROM_LOW  = 'h0
             , ALLOC_FROM_HIGH = 'h1
             , ALLOC_RANDOM    = 'h2
             } alloc_policy_e;

`endif
