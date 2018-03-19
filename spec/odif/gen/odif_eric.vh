#if !defined(_eric_IFACE)
#define _eric_IFACE

#define PKT_aaa0_addr_WIDTH 7
#define PKT_aaa0_addr_LSB 0
#define PKT_aaa0_addr_MSB 6
#define PKT_aaa0_addr_FIELD 6:0
#define PKT_aaa0_size_WIDTH 3
#define PKT_aaa0_size_LSB 7
#define PKT_aaa0_size_MSB 9
#define PKT_aaa0_size_FIELD 9:7
#define PKT_aaa0_flush_WIDTH 2
#define PKT_aaa0_flush_LSB 10
#define PKT_aaa0_flush_MSB 11
#define PKT_aaa0_flush_FIELD 11:10
#define PKT_aaa0_WIDTH 12

#define PKT_aaa1_addr_WIDTH 7
#define PKT_aaa1_addr_LSB 0
#define PKT_aaa1_addr_MSB 6
#define PKT_aaa1_addr_FIELD 6:0
#define PKT_aaa1_size_WIDTH 3
#define PKT_aaa1_size_LSB 7
#define PKT_aaa1_size_MSB 9
#define PKT_aaa1_size_FIELD 9:7
#define PKT_aaa1_data0_WIDTH 5
#define PKT_aaa1_data0_LSB 10
#define PKT_aaa1_data0_MSB 14
#define PKT_aaa1_data0_FIELD 14:10
#define PKT_aaa1_data1_WIDTH 5
#define PKT_aaa1_data1_LSB 15
#define PKT_aaa1_data1_MSB 19
#define PKT_aaa1_data1_FIELD 19:15
#define PKT_aaa1_data2_WIDTH 5
#define PKT_aaa1_data2_LSB 20
#define PKT_aaa1_data2_MSB 24
#define PKT_aaa1_data2_FIELD 24:20
#define PKT_aaa1_WIDTH 25

#define PKT_aaa2_cmd_WIDTH 3
#define PKT_aaa2_cmd_LSB 0
#define PKT_aaa2_cmd_MSB 2
#define PKT_aaa2_cmd_FIELD 2:0
#define PKT_aaa2_WIDTH 3

#define FLOW_eric valid_ready

#define SIG_eric_PD_WIDTH 27
#define SIG_eric_PD_FIELD 26:0

#define PKT_eric_PAYLOAD_WIDTH    25
#define PKT_eric_PAYLOAD_FIELD    24:0
#define PKT_eric_ID_WIDTH    2
#define PKT_eric_ID_FIELD    26:25
#define PKT_eric_aaa0_FIELD    11:0
#define PKT_eric_aaa0_ID       2'd0  
#define PKT_eric_aaa0_int_ID   0
#define PKT_eric_aaa1_FIELD    24:0
#define PKT_eric_aaa1_ID       2'd1  
#define PKT_eric_aaa1_int_ID   1
#define PKT_eric_aaa2_FIELD    2:0
#define PKT_eric_aaa2_ID       2'd2  
#define PKT_eric_aaa2_int_ID   2

#endif // !defined(_eric_IFACE)
