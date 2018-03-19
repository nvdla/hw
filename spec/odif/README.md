# ODIF: Open DLA Interface Definition

## Introduction
This document is a basic tutorial of the Odif specification system.  Its purpose is to familiarize you with how designs are specified in the Odif language and the products that Odif produces from these design specifications

### Purpose
Odif is a means of centralizing information about how interfaces in a design are specified so that from a single point of specification about interfaces can be generated for multiple customers (such as c++, verilog, system verilog, python, perl, etc)


## Syntax

### Interface
An interface specification is a description of a set of wires that carry information between modules.

Let's create an interface called request that will be able to either request read information or to send write data. 
```
interface request    
  flow valid_ready
  field addr   12    
  field write   1 
  field data   32
```
The three 'field' statements designate the three signals in this interface. 

The "flow" statement designates the handshake protocol approach that an interface is going to use. Lets make our interface use the 'valid_ready' 'flow' protocol.

Odif will implicitly create a one bit control signal called 'valid' that says the information on the data signals is valid and create a one bit control signal called 'ready' that the consumer of the interface drives to indicate back-pressure. A transaction happens when both "valid" and "ready" is true . 

The 'flow' command is an important element distinguishing an interface from a plain data structure. An interface in fact defines a channel to transport transactions from producer to consumer. the 'field' statements define the payload structure of the transaction. The 'flow' statement defines the transfer protocol for these transactions, and extra control signals are added to manage the flow of transactions from producer to consumer. 

#### Backend
##### c++
```
typedef struct request_s {
        sc_int<12> addr ;
        sc_int<1> write ;
        sc_int<32> data ;
} request_t;
```
##### macro
```
#define FLOW_request valid_ready

#define SIG_request_addr_WIDTH 12
#define SIG_request_addr_FIELD 11:0
#define SIG_request_write_WIDTH 1
#define SIG_request_write_FIELD 0:0
#define SIG_request_data_WIDTH 32
#define SIG_request_data_FIELD 31:0
```

Array of signals are also supported, such as we will have below specification if "data" is an array of 3 elements.
```
interface request    
field addr     12    
field write     1 
field data[2]  32
```

#### Backend
##### c++
```
typedef struct request_s {
        sc_int<12> addr ;
        sc_int<1> write ;
        sc_int<32> data[2] ;
} request_t;
```
##### macro
```
#define FLOW_request valid_ready

#define SIG_request_addr_WIDTH 12
#define SIG_request_addr_FIELD 11:0
#define SIG_request_write_WIDTH 1
#define SIG_request_write_FIELD 0:0
#define SIG_request_data0_WIDTH 32
#define SIG_request_data0_FIELD 31:0
#define SIG_request_data1_WIDTH 32
#define SIG_request_data1_FIELD 31:0
```


### Module

The module token declares a module type.  It takes the module name.  Under a module declaration, you may specify input and output ports
```
module sub_a
  out request a2b_req

module sub_b
  in request a2b_req
```
#### Backend
##### c++
```
example to be added
```
##### verilog

```
// odif_sub_a_ports.v
,output a2b_req_valid
,input  a2b_req_ready
,output [11:0] a2b_req_addr
,output        a2b_req_write
,output [31:0] a2b_req_data

// odif_sub_b_ports.v
,input  a2b_req_valid
,output a2b_req_ready
,input [11:0] a2b_req_addr
,input        a2b_req_write
,input [31:0] a2b_req_data
```

### group
Sometimes sets of signals are shared between multiple interfaces or interfaces may want to transmit different sets of signals at different times. To allow for this we create 'groups' of signals. 

```
group request_signals    
field addr   12    
field write   1 
field data   32

interface request    
flow valid_ready
add request_signals
```
The above 'request' interface is effectively the same as before. The 'add' is functionally equivalent to a cut-n-paste of the group's signals.

### packet
Groups are often used for creating different packet types to be transmitted on interfaces that are packet based. In this manner the interface is a union of the groups. The union is specified with the 'packet' keyword on the interface.
```
group Write 
  field addr  12 
  field data  32

group Read 
  field addr  12
  field size  4

group Flush 
  field addr_start 1 
  field addr_end   1

interface command
  flow valid_ready
  packet Write Read Flush

module sub_x
  out command x2y_cmd

module sub_y
  in  command x2y_cmd

```

Packet will introduce more one layer between group and interface named "pd" by default.
#### Backend
##### c++:
```
typedef struct Write_s {
        sc_int<12> addr ;
        sc_int<32> data ;
} Write_t;

typedef struct Read_s {
        sc_int<12> addr ;
        sc_int<4> size ;
} Read_t;

typedef struct Flush_s {
        sc_int<1> addr_start ;
        sc_int<1> addr_end ;
} Flush_t;

union command_u {
    Write_t Write;
    Read_t Read;
    Flush_t Flush;
};

typedef struct command_s {
    union command_u pd ;
} command_t;

```

##### verilog

```
// odif_sub_x_ports.v
,output x2y_cmd_valid
,input  x2y_cmd_ready
,output [45:0] x2y_cmd_pd

// odif_sub_y_ports.v
,input  x2y_cmd_valid
,output x2y_cmd_ready
,input [45:0] x2y_cmd_pd
```

##### macro
```
#define PKT_Write_addr_WIDTH 12
#define PKT_Write_addr_LSB 0
#define PKT_Write_addr_MSB 11
#define PKT_Write_addr_FIELD 11:0
#define PKT_Write_data_WIDTH 32
#define PKT_Write_data_LSB 12
#define PKT_Write_data_MSB 43
#define PKT_Write_data_FIELD 43:12
#define PKT_Write_WIDTH 44

#define PKT_Read_addr_WIDTH 12
#define PKT_Read_addr_LSB 0
#define PKT_Read_addr_MSB 11
#define PKT_Read_addr_FIELD 11:0
#define PKT_Read_size_WIDTH 4
#define PKT_Read_size_LSB 12
#define PKT_Read_size_MSB 15
#define PKT_Read_size_FIELD 15:12
#define PKT_Read_WIDTH 16

#define PKT_Flush_addr_start_WIDTH 1
#define PKT_Flush_addr_start_LSB 0
#define PKT_Flush_addr_start_MSB 0
#define PKT_Flush_addr_start_FIELD 0:0
#define PKT_Flush_addr_end_WIDTH 1
#define PKT_Flush_addr_end_LSB 1
#define PKT_Flush_addr_end_MSB 1
#define PKT_Flush_addr_end_FIELD 1:1
#define PKT_Flush_WIDTH 2

#define FLOW_command valid_ready

#define SIG_command_PD_WIDTH 46
#define SIG_command_PD_FIELD 45:0

#define PKT_command_PAYLOAD_WIDTH    44
#define PKT_command_PAYLOAD_FIELD    43:0
#define PKT_command_ID_WIDTH    2
#define PKT_command_ID_FIELD    45:44
#define PKT_command_Write_FIELD    43:0
#define PKT_command_Write_ID       2'd0
#define PKT_command_Write_int_ID   0
#define PKT_command_Read_FIELD    15:0
#define PKT_command_Read_ID       2'd1
#define PKT_command_Read_int_ID   1
#define PKT_command_Flush_FIELD    1:0
#define PKT_command_Flush_ID       2'd2
#define PKT_command_Flush_int_ID   2

```
