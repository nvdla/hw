// DBB Address width
`ifndef DBB_ADDR_WIDTH
`define DBB_ADDR_WIDTH         64
`endif


// DBB Data Width. Can be up to 1024 bits wide,
// DBB Agent is parameterized for MEM_DATA_WIDTH
`ifndef DBB_DATA_WIDTH
`define DBB_DATA_WIDTH         512
`endif


`ifndef DBB_ALEN_WIDTH
`define DBB_ALEN_WIDTH         4
`endif

`ifndef DBB_ASIZE_WIDTH
`define DBB_ASIZE_WIDTH        3
`endif

`ifndef DBB_ABURST_WIDTH
`define DBB_ABURST_WIDTH       2
`endif

`ifndef DBB_AID_WIDTH
`define DBB_AID_WIDTH          8
`endif

`ifndef DBB_AVALID_WIDTH
`define DBB_AVALID_WIDTH       1
`endif

`ifndef DBB_AREADY_WIDTH
`define DBB_AREADY_WIDTH       1
`endif


`ifndef DBB_RID_WIDTH
`define DBB_RID_WIDTH          `DBB_AID_WIDTH
`endif

`ifndef DBB_MASTER_RID_WIDTH
`define DBB_MASTER_RID_WIDTH   `DBB_AID_WIDTH
`endif

`ifndef DBB_SLAVE_RID_WIDTH
`define DBB_SLAVE_RID_WIDTH    `DBB_AID_WIDTH
`endif


// DBB Agent is parameterized for MEM_WSTRB_WIDTH
`ifndef DBB_WSTRB_WIDTH
`define DBB_WSTRB_WIDTH        `DBB_DATA_WIDTH/8
`endif

`ifndef DBB_WID_WIDTH
`define DBB_WID_WIDTH          `DBB_AID_WIDTH
`endif

`ifndef DBB_MASTER_WID_WIDTH
`define DBB_MASTER_WID_WIDTH   `DBB_AID_WIDTH 
`endif

`ifndef DBB_SLAVE_WID_WIDTH
`define DBB_SLAVE_WID_WIDTH    `DBB_AID_WIDTH
`endif


`ifndef DBB_BRESP_WIDTH
`define DBB_BRESP_WIDTH        2
`endif

`ifndef DBB_BID_WIDTH
`define DBB_BID_WIDTH          `DBB_AID_WIDTH
`endif

`ifndef DBB_MASTER_BID_WIDTH
`define DBB_MASTER_BID_WIDTH   `DBB_AID_WIDTH
`endif

`ifndef DBB_SLAVE_BID_WIDTH
`define DBB_SLAVE_BID_WIDTH    `DBB_AID_WIDTH
`endif


// Setup and hold times for DBB interfaces.
`ifndef DBB_IF_SETUP
`define DBB_IF_SETUP           1ps
`endif

`ifndef DBB_IF_HOLD
`define DBB_IF_HOLD            1ps
`endif

// The following parameters are not physical limitations of bus sizes. They are used
// simply to set default values for bus drivers and checkers, which can be overridden
// with local parameters.

// maximum write interleave depth
`ifndef DBB_WDEPTH
`define DBB_WDEPTH             8
`endif

// maximum read interleave depth
`ifndef DBB_RDEPTH
`define DBB_RDEPTH             8
`endif

// maximum number of outstanding DBB transactions that the Master will allow
`ifndef DBB_MAX_OUTSTANDING
`define DBB_MAX_OUTSTANDING    16
`endif

// maximum number of cycles between VALID high and READY high before a warning is generated.
`ifndef DBB_MAXWAITS
`define DBB_MAXWAITS            16
`endif

// Set EXMON_WIDTH to the exclusive access monitor width required
`ifndef DBB_EXMON_WIDTH
`define DBB_EXMON_WIDTH         4
`endif

`ifndef BUFFER_SIZE
`define BUFFER_SIZE                 20'h40000       // This is the size of the buffer. Load the memory these many bytes at a time. 
                                                    // If the size of the section is larger than this it will iterate the loop
                                                    // till the section is read completely. 
`endif
