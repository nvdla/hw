// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_cbuf.v

#include "NV_NVDLA_CBUF.h"
`include "simulate_x_tick.vh"
module NV_NVDLA_cbuf (
   nvdla_core_clk       //|< i
  ,nvdla_core_rstn      //|< i
  //port 0 for data, 1 for weight
  //: for(my $i=0; $i<CBUF_WR_PORT_NUMBER ; $i++){   
  //: print qq(
  //: ,cdma2buf_wr_addr${i} //|< i
  //: ,cdma2buf_wr_data${i} //|< i
  //: ,cdma2buf_wr_en${i}   //|< i
  //: ,cdma2buf_wr_sel${i} //|< i
  //: )
  //: }
  ,pwrbus_ram_pd        //|< i
  ,sc2buf_dat_rd_addr   //|< i
  ,sc2buf_dat_rd_en     //|< i
  ,sc2buf_dat_rd_shift  //|< i
  ,sc2buf_dat_rd_next1_en //< i
  ,sc2buf_dat_rd_next1_addr //< i
  ,sc2buf_dat_rd_data   //|> o
  ,sc2buf_dat_rd_valid  //|> o
  ,sc2buf_wt_rd_addr    //|< i
  ,sc2buf_wt_rd_en      //|< i
  ,sc2buf_wt_rd_data    //|> o
  ,sc2buf_wt_rd_valid   //|> o
  `ifdef  CBUF_WEIGHT_COMPRESSED
  ,sc2buf_wmb_rd_addr   //|< i
  ,sc2buf_wmb_rd_en     //|< i
  ,sc2buf_wmb_rd_data   //|> o
  ,sc2buf_wmb_rd_valid  //|> o
  `endif
  );

input  nvdla_core_clk; 
input  nvdla_core_rstn;  
input [31:0] pwrbus_ram_pd;

//: for(my $i=0; $i<CBUF_WR_PORT_NUMBER ; $i++) {
//: print qq(
//: input[CBUF_ADDR_WIDTH-1:0] cdma2buf_wr_addr${i}; //|< i
//: input[CBUF_WR_PORT_WIDTH-1:0] cdma2buf_wr_data${i}; //|< i
//: input cdma2buf_wr_en${i};   //|< i
//: input[CBUF_WR_BANK_SEL_WIDTH-1:0] cdma2buf_wr_sel${i}; //|< i
//: )
//: }

input                       sc2buf_dat_rd_en;    /* data valid */
input [CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_addr;
input [CBUF_RD_DATA_SHIFT_WIDTH-1:0] sc2buf_dat_rd_shift;  //|< i
input                       sc2buf_dat_rd_next1_en; //< i
input [CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_next1_addr; //< i
output                      sc2buf_dat_rd_valid;  /* data valid */
output [CBUF_RD_PORT_WIDTH-1:0] sc2buf_dat_rd_data;

input                       sc2buf_wt_rd_en;    /* data valid */
input [CBUF_ADDR_WIDTH-1:0] sc2buf_wt_rd_addr;
output                      sc2buf_wt_rd_valid;  /* data valid */
output [CBUF_RD_PORT_WIDTH-1:0] sc2buf_wt_rd_data;

`ifdef  CBUF_WEIGHT_COMPRESSED
input                       sc2buf_wmb_rd_en;    /* data valid */
input [CBUF_ADDR_WIDTH-1:0] sc2buf_wmb_rd_addr;
output                      sc2buf_wmb_rd_valid;  /* data valid */
output [CBUF_RD_PORT_WIDTH-1:0] sc2buf_wmb_rd_data;
`endif

`ifndef SYNTHESIS
`ifdef CDMA2CBUF_DEBUG_PRINT
`ifdef VERILATOR
`else
reg cdma2cbuf_data_begin, cdma2cbuf_wt_begin;
integer data_file, wt_file;
initial begin
    assign cdma2cbuf_wt_begin=0;
    assign cdma2cbuf_data_begin=0;
    @(negedge cdma2buf_wr_en1)   assign cdma2cbuf_wt_begin=1;
    @(negedge cdma2buf_wr_en0)   assign cdma2cbuf_data_begin=1;
    data_file = $fopen("cdma2cbuf_data_rtl.dat");
    wt_file = $fopen("cdma2cbuf_weight_rtl.dat");
    if(cdma2cbuf_data_begin & cdma2cbuf_wt_begin) begin
        forever @(posedge nvdla_core_clk) begin
            if(cdma2buf_wr_en0) begin 
                $fwrite(data_file,"%h\n",cdma2buf_wr_data0);
            end
            if (cdma2buf_wr_en1) begin
                $fwrite(wt_file,"%h\n",cdma2buf_wr_data1);
            end
        end
    end
end
`endif
`endif
`endif // SYNTHESIS


//////////step1:write handle
//decode write address to sram
//: my $bank_slice= CBUF_BANK_SLICE;  #address part for select bank
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         for(my $i=0; $i<CBUF_WR_PORT_NUMBER ; $i++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire  bank${j}_ram${k}_wr${i}_en_d0 = cdma2buf_wr_en${i}&&(cdma2buf_wr_addr${i}[${bank_slice}]==${j}) &&(cdma2buf_wr_sel${i}[${k}]==1'b1);  );
//:             }
//:         if(CBUF_BANK_RAM_CASE==2){
//:         print qq(
//:     wire  bank${j}_ram${k}_wr${i}_en_d0 = cdma2buf_wr_en${i}&&(cdma2buf_wr_addr${i}[${bank_slice}]==${j})&&(cdma2buf_wr_addr${i}[0]==${k});  );
//:             }
//:         if(CBUF_BANK_RAM_CASE==3){
//:                         #complicated,reserve, no use currently
//:             }
//:         }
//:     }
//: }


//generate sram write en
//: my $t1="";
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         for(my $i=0; $i<CBUF_WR_PORT_NUMBER; $i++){
//:             ${t1} .= "bank${j}_ram${k}_wr${i}_en_d0 |";
//:         }
//:         print  "wire bank${j}_ram${k}_wr_en_d0  = ${t1}"."1'b0; \n";
//:         $t1="";
//:     &eperl::flop("-q bank${j}_ram${k}_wr_en_d1 -d bank${j}_ram${k}_wr_en_d0");
//:     }
//: }


// 1 pipe for timing
//: my $kk=CBUF_ADDR_WIDTH;
//: my $jj=CBUF_WR_PORT_WIDTH;
//: for(my $i=0; $i<CBUF_WR_PORT_NUMBER ; $i++){
//: &eperl::flop("-wid ${kk} -q cdma2buf_wr_addr${i}_d1 -d cdma2buf_wr_addr${i}");
//: &eperl::flop("-wid ${jj} -norst -q cdma2buf_wr_data${i}_d1 -d cdma2buf_wr_data${i}");
//: }

//generate bank write en
//: my $t1="";
//: for(my $i=0; $i<CBUF_WR_PORT_NUMBER; $i++){
//:     for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:         for(my $k=0; $k<CBUF_RAM_PER_BANK; $k++){
//:             $t1 .= "bank${j}_ram${k}_wr${i}_en_d0 |";
//:         }
//:         print "wire bank${j}_wr${i}_en_d0 = ${t1}"."1'b0; \n";
//: &eperl::flop("-q bank${j}_wr${i}_en_d1 -d bank${j}_wr${i}_en_d0");
//:         $t1="";
//:     }
//: }

//generate bank write addr/data
//: my $t1="";
//: my $d1="";
//: my $kk= CBUF_ADDR_WIDTH;
//: my $jj= CBUF_WR_PORT_WIDTH;
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:         for(my $i=0; $i<CBUF_WR_PORT_NUMBER; $i++){
//:         $t1 .="({${kk}{bank${j}_wr${i}_en_d1}}&cdma2buf_wr_addr${i}_d1)|";
//:         $d1 .="({${jj}{bank${j}_wr${i}_en_d1}}&cdma2buf_wr_data${i}_d1)|";
//:         }
//:         my $t2 .="{${kk}{1'b0}}";
//:         my $d2 .="{${jj}{1'b0}}";
//:         print "wire [${kk}-1:0] bank${j}_wr_addr_d1 = ${t1}${t2}; \n";
//:         print "wire [${jj}-1:0] bank${j}_wr_data_d1 = ${d1}${d2}; \n";
//:         $t1="";
//:         $d1="";
//: }


//map bank to sram.
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:                print qq(
//:        wire[CBUF_RAM_DEPTH_BITS-1:0]   bank${j}_ram${k}_wr_addr_d1 = bank${j}_wr_addr_d1[CBUF_RAM_DEPTH_BITS-1:0];
//:        wire[CBUF_WR_PORT_WIDTH-1:0]    bank${j}_ram${k}_wr_data_d1 = bank${j}_wr_data_d1;
//:        )
//:         }
//:         if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//:                print qq(
//:        wire[CBUF_RAM_DEPTH_BITS-1:0]   bank${j}_ram${k}_wr_addr_d1 = bank${j}_wr_addr_d1[CBUF_RAM_DEPTH_BITS:1];
//:        wire[CBUF_WR_PORT_WIDTH-1:0]    bank${j}_ram${k}_wr_data_d1 = bank${j}_wr_data_d1;
//:        )
//:         }
//:     }
//: }


// 1 pipe before write to sram, for timing
//: my $kk=CBUF_RAM_DEPTH_BITS;
//: my $jj=CBUF_WR_PORT_WIDTH;
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:     &eperl::flop("-q bank${j}_ram${k}_wr_en_d2 -d bank${j}_ram${k}_wr_en_d1"); 
//:     &eperl::flop("-wid ${kk} -q bank${j}_ram${k}_wr_addr_d2 -d bank${j}_ram${k}_wr_addr_d1");
//:     &eperl::flop("-wid ${jj} -norst -q bank${j}_ram${k}_wr_data_d2 -d bank${j}_ram${k}_wr_data_d1");
//:     }
//: }



//////////////////////step2: read data handle
//decode read data address to sram.
wire sc2buf_dat_rd_en0 =  sc2buf_dat_rd_en;
wire sc2buf_dat_rd_en1 =  sc2buf_dat_rd_en & sc2buf_dat_rd_next1_en;
wire[CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_addr0 = sc2buf_dat_rd_addr;
wire[CBUF_ADDR_WIDTH-1:0] sc2buf_dat_rd_addr1 = sc2buf_dat_rd_next1_addr;
//: my $bank_slice= CBUF_BANK_SLICE;  #address part for select bank
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire  bank${j}_ram${k}_data_rd_en = sc2buf_dat_rd_en&&(sc2buf_dat_rd_addr[${bank_slice}]==${j}); );
//:         }
//:         if(CBUF_BANK_RAM_CASE==2){
//:         for(my $i=0; $i<2; $i++){
//:         print qq(
//:     wire  bank${j}_ram${k}_data_rd${i}_en = sc2buf_dat_rd_en${i}&&(sc2buf_dat_rd_addr${i}[${bank_slice}]==${j})&&(sc2buf_dat_rd_addr${i}[0]==${k}); );
//:             }
//:         }
//:         if(CBUF_BANK_RAM_CASE==3){
//:             #complicated,reserve, no use currently
//:         }
//:     }
//: }


//get sram data read address.
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire [CBUF_RAM_DEPTH_BITS-1:0] bank${j}_ram${k}_data_rd_addr = {CBUF_RAM_DEPTH_BITS{bank${j}_ram${k}_data_rd_en}}&(sc2buf_dat_rd_addr[CBUF_RAM_DEPTH_BITS-1:0]); );
//:             }
//:         for(my $i=0; $i<2; $i++){
//:             if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//:         print qq(
//:     wire [CBUF_RAM_DEPTH_BITS-1:0] bank${j}_ram${k}_data_rd${i}_addr = {CBUF_RAM_DEPTH_BITS{bank${j}_ram${k}_data_rd${i}_en}}&(sc2buf_dat_rd_addr${i}[CBUF_RAM_DEPTH_BITS:1]); );
//:             }
//:         }
//:     }
//: }


//add flop for sram data read en
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//: &eperl::flop("-q bank${j}_ram${k}_data_rd_en_d1 -d  bank${j}_ram${k}_data_rd_en"); 
//: &eperl::flop("-q bank${j}_ram${k}_data_rd_en_d2 -d  bank${j}_ram${k}_data_rd_en_d1"); 
//:         }
//:         for(my $i=0; $i<2; $i++){
//:             if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//: &eperl::flop("-q bank${j}_ram${k}_data_rd${i}_en_d1 -d bank${j}_ram${k}_data_rd${i}_en"); 
//: &eperl::flop("-q bank${j}_ram${k}_data_rd${i}_en_d2 -d bank${j}_ram${k}_data_rd${i}_en_d1"); 
//:             }
//:         }
//:     }
//: }



//get sram data read valid.
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire  bank${j}_ram${k}_data_rd_valid = bank${j}_ram${k}_data_rd_en_d2; )
//:             }
//:         for(my $i=0; $i<2; $i++){
//:             if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//:         print qq(
//:     wire  bank${j}_ram${k}_data_rd${i}_valid = bank${j}_ram${k}_data_rd${i}_en_d2; )
//:             }
//:         }
//:     }
//: }


//get sc data read valid.
//: my $t1="";
//: my $t2="";
//: if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:     for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:         for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         $t1 .= "bank${j}_ram${k}_data_rd_valid|";
//:         }
//:     }
//: print "wire [0:0] sc2buf_dat_rd_valid_w = $t1"."1'b0; \n";
//: }
//: if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//:     for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:         for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         $t1 .= "bank${j}_ram${k}_data_rd0_valid|"; 
//:         $t2 .= "bank${j}_ram${k}_data_rd1_valid|"; 
//:         }
//:     }
//: print "wire sc2buf_dat_rd_valid0 = ${t1}"."1'b0; \n";
//: print "wire sc2buf_dat_rd_valid1 = ${t2}"."1'b0; \n";
//: print "wire [0:0] sc2buf_dat_rd_valid_w = sc2buf_dat_rd_valid0 || sc2buf_dat_rd_valid1; \n";
//: }
//: &eperl::retime("-O sc2buf_dat_rd_valid -i sc2buf_dat_rd_valid_w -stage 4 -clk nvdla_core_clk");

//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//: print qq(
//: wire [CBUF_RAM_WIDTH-1:0] bank${j}_ram${k}_rd_data; );
//:     }
//: }


//get sc data read bank output data. 
//: my $t1="";
//: my $kk=CBUF_RD_PORT_WIDTH;
//: if(CBUF_BANK_RAM_CASE==0){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//:  wire [${kk}-1:0] bank${j}_data_rd_data = bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd_valid}}; );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==1){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//:  wire [${kk}-1:0] bank${j}_data_rd_data = {bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_data_rd_valid}},
//:                                             bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd_valid}}};
//:     );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==2){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//:  wire [${kk}-1:0] bank${j}_data_rd0_data = (bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_data_rd0_valid}})|
//:                                             (bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd0_valid}});
//:  wire [${kk}-1:0] bank${j}_data_rd1_data = (bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_data_rd1_valid}})|
//:                                             (bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd1_valid}});
//:     );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==3){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//:  wire [${kk}-1:0] bank${j}_data_rd0_data = {bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_data_rd0_valid}},
//:                                             bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd0_valid}}}|
//:                                             {bank${j}_ram3_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram3_data_rd0_valid}},
//:                                             bank${j}_ram2_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram2_data_rd0_valid}}};
//: wire [${kk}-1:0]  bank${j}_data_rd1_data = {bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_data_rd1_valid}},
//:                                             bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd1_valid}}}|
//:                                             {bank${j}_ram3_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram3_data_rd1_valid}},
//:                                             bank${j}_ram2_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram2_data_rd1_valid}}};
//:     );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==4){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//:  wire [${kk}-1:0] bank${j}_data_rd_data = {bank${j}_ram3_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram3_data_rd_valid}},
//:                                             bank${j}_ram2_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram2_data_rd_valid}},
//:                                             bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_data_rd_valid}},
//:                                             bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_data_rd_valid}}};
//:     );
//:     }
//: }


//: my $kk=CBUF_RD_DATA_SHIFT_WIDTH;
//: &eperl::retime("-O sc2buf_dat_rd_shift_5T -i sc2buf_dat_rd_shift -wid ${kk} -stage 5 -clk nvdla_core_clk");

// pipe solution. for timing concern, 4 level pipe. 
//: my $kk=CBUF_RD_PORT_WIDTH;
//: if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//: for (my $i=0; $i<CBUF_BANK_NUMBER; $i++){
//: &eperl::flop("-wid ${kk} -norst -q l1group${i}_data_rd_data   -d bank${i}_data_rd_data");
//: }
//: 
//: for (my $i=0; $i<CBUF_BANK_NUMBER/4; $i++){
//: my $ni=$i*4;
//: my $nii=$i*4+1;
//: my $niii=$i*4+2;
//: my $niiii=$i*4+3;
//: print qq(
//: wire [${kk}-1:0] l2group${i}_data_rd_data_w = l1group${ni}_data_rd_data | l1group${nii}_data_rd_data | l1group${niii}_data_rd_data | l1group${niiii}_data_rd_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l2group${i}_data_rd_data   -d l2group${i}_data_rd_data_w");
//: }
//:
//: for (my $i=0; $i<CBUF_BANK_NUMBER/16; $i++){
//: my $ni=$i*4;
//: my $nii=$i*4+1;
//: my $niii=$i*4+2;
//: my $niiii=$i*4+3;
//: print qq(
//: wire [${kk}-1:0] l3group${i}_data_rd_data_w = l2group${ni}_data_rd_data | l2group${nii}_data_rd_data | l2group${niii}_data_rd_data | l2group${niiii}_data_rd_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l3group${i}_data_rd_data   -d l3group${i}_data_rd_data_w");
//: }
//: 
//: if(CBUF_BANK_NUMBER==16){
//: &eperl::flop("-wid ${kk} -norst -q l4group_data_rd_data   -d l3group0_data_rd_data"); 
//: }
//: if(CBUF_BANK_NUMBER==32) {
//: print qq(
//: wire [${kk}-1:0] l4group_data_rd_data_w = l3group0_data_rd_data | l3group1_data_rd_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l4group_data_rd_data   -d l4group_data_rd_data_w");
//: }
//: print "wire[${kk}-1:0] sc2buf_dat_rd_data = l4group_data_rd_data[${kk}-1:0]; \n";
//: }
//:
//:
//: my $kk=CBUF_RD_PORT_WIDTH;
//: if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//: for (my $i=0; $i<CBUF_BANK_NUMBER; $i++){
//: &eperl::flop("-wid ${kk} -norst -q l1group${i}_data_rd0_data   -d bank${i}_data_rd0_data");
//: &eperl::flop("-wid ${kk} -norst -q l1group${i}_data_rd1_data   -d bank${i}_data_rd1_data");
//: }
//: 
//: for (my $i=0; $i<CBUF_BANK_NUMBER/4; $i++){
//: my $ni=$i*4;
//: my $nii=$i*4+1;
//: my $niii=$i*4+2;
//: my $niiii=$i*4+3;
//: print qq(
//: wire [${kk}-1:0] l2group${i}_data_rd0_data_w = l1group${ni}_data_rd0_data | l1group${nii}_data_rd0_data | l1group${niii}_data_rd0_data | l1group${niiii}_data_rd0_data;
//: wire [${kk}-1:0] l2group${i}_data_rd1_data_w = l1group${ni}_data_rd1_data | l1group${nii}_data_rd1_data | l1group${niii}_data_rd1_data | l1group${niiii}_data_rd1_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l2group${i}_data_rd0_data   -d l2group${i}_data_rd0_data_w");
//: &eperl::flop("-wid ${kk} -norst -q l2group${i}_data_rd1_data   -d l2group${i}_data_rd1_data_w");
//: }
//:
//: for (my $i=0; $i<CBUF_BANK_NUMBER/16; $i++){
//: my $ni=$i*4;
//: my $nii=$i*4+1;
//: my $niii=$i*4+2;
//: my $niiii=$i*4+3;
//: print qq(
//: wire [${kk}-1:0] l3group${i}_data_rd0_data_w = l2group${ni}_data_rd0_data | l2group${nii}_data_rd0_data | l2group${niii}_data_rd0_data | l2group${niiii}_data_rd0_data;
//: wire [${kk}-1:0] l3group${i}_data_rd1_data_w = l2group${ni}_data_rd1_data | l2group${nii}_data_rd1_data | l2group${niii}_data_rd1_data | l2group${niiii}_data_rd1_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l3group${i}_data_rd0_data   -d l3group${i}_data_rd0_data_w");
//: &eperl::flop("-wid ${kk} -norst -q l3group${i}_data_rd1_data   -d l3group${i}_data_rd1_data_w");
//: }
//: 
//: if(CBUF_BANK_NUMBER==16){
//: print qq(
//: wire [${kk}-1:0] l4group_data_rd0_data = l3group0_data_rd0_data;
//: wire [${kk}-1:0] l4group_data_rd1_data = l3group0_data_rd1_data;
//: );
//: }
//: if(CBUF_BANK_NUMBER==32) {
//: print qq(
//: wire [${kk}-1:0] l4group_data_rd0_data = l3group0_data_rd0_data | l3group1_data_rd0_data;
//: wire [${kk}-1:0] l4group_data_rd1_data = l3group0_data_rd1_data | l3group1_data_rd1_data;
//: );
//: }
//: print qq(
//: wire [${kk}*2-1:0] l4group_data_rd_data_w = {l4group_data_rd1_data,l4group_data_rd0_data}>>{sc2buf_dat_rd_shift_5T,3'b0};
//: );
//: &eperl::flop("-wid ${kk} -norst -q l4group_data_rd_data   -d l4group_data_rd_data_w[${kk}-1:0]");
//: print "wire[${kk}-1:0] sc2buf_dat_rd_data = l4group_data_rd_data[${kk}-1:0]; \n";
//: }

////get sc data read data. no pipe
////: my $t1="";
////: my $t2="";
////: my $kk=CBUF_RD_PORT_WIDTH;
////: if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
////:     for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
////:         $t1 .= "bank${j}_data_rd_data|";    
////:     }
////: print "wire[${kk}-1:0] sc2buf_dat_rd_data =".${t1}."{${kk}{1'b0}}; \n";
////: }
////:     
////: if((CBUF_BANK_RAM_CASE==2)|(CBUF_BANK_RAM_CASE==3)){
////:     for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
////:         $t1 .= "bank${j}_data_rd0_data|";    
////:         $t2 .= "bank${j}_data_rd1_data|";    
////:     }
////: print "wire[${kk}-1:0] sc2buf_dat_rd_data0 =".${t1}."{${kk}{1'b0}}; \n";
////: print "wire[${kk}-1:0] sc2buf_dat_rd_data1 =".${t2}."{${kk}{1'b0}}; \n";
////: }
////:
//wire[CBUF_RD_PORT_WIDTH*2-1:0] sc2buf_dat_rd_data_temp = {sc2buf_dat_rd_data1,sc2buf_dat_rd_data0} >> {sc2buf_dat_rd_shift_5T,3'b0};
//wire[CBUF_RD_PORT_WIDTH-1:0] sc2buf_dat_rd_data = sc2buf_dat_rd_data_temp[CBUF_RD_PORT_WIDTH-1:0];



/////////////////////step3: read weight handle
//decode read weight address to sram.
//: my $bank_slice= CBUF_BANK_SLICE;  #address part for select bank
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire  bank${j}_ram${k}_wt_rd_en = sc2buf_wt_rd_en&&(sc2buf_wt_rd_addr[${bank_slice}]==${j}); )
//:         }
//:         if(CBUF_BANK_RAM_CASE==2){
//:         print qq(
//:     wire  bank${j}_ram${k}_wt_rd_en = sc2buf_wt_rd_en&&(sc2buf_wt_rd_addr[${bank_slice}]==${j})&&(sc2buf_wt_rd_addr[0]==${k}); )
//:         }
//:         if(CBUF_BANK_RAM_CASE==3){
//:         print qq(
//:     wire  bank${j}_ram${k}_wt_rd_en = sc2buf_wt_rd_en&&(sc2buf_wt_rd_addr[${bank_slice}]==${j})&&(sc2buf_wt_rd_addr[0]==${k}/2); )
//:         }
//:     }
//: }


//get sram weight read address.
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire [CBUF_RAM_DEPTH_BITS-1:0] bank${j}_ram${k}_wt_rd_addr = {CBUF_RAM_DEPTH_BITS{bank${j}_ram${k}_wt_rd_en}}&(sc2buf_wt_rd_addr[CBUF_RAM_DEPTH_BITS-1:0]); )
//:             }
//:         if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//:         print qq(
//:     wire [CBUF_RAM_DEPTH_BITS-1:0] bank${j}_ram${k}_wt_rd_addr = {CBUF_RAM_DEPTH_BITS{bank${j}_ram${k}_wt_rd_en}}&(sc2buf_wt_rd_addr[CBUF_RAM_DEPTH_BITS:1]); )
//:         }
//:     }
//: }


//add flop for sram weight read en
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//: &eperl::flop("-q bank${j}_ram${k}_wt_rd_en_d1 -d  bank${j}_ram${k}_wt_rd_en"); 
//: &eperl::flop("-q bank${j}_ram${k}_wt_rd_en_d2 -d  bank${j}_ram${k}_wt_rd_en_d1"); 
//:         }
//: }



//get sram weight read valid.
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:     print qq(
//:     wire  bank${j}_ram${k}_wt_rd_valid = bank${j}_ram${k}_wt_rd_en_d2; )
//:     }
//: }


//get sc weight read valid.
//: my $t1="";
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:     $t1 .= "bank${j}_ram${k}_wt_rd_valid|";
//:     }
//: }
//: print "wire [0:0] sc2buf_wt_rd_valid_w ="."${t1}"."1'b0 ;\n";
//: &eperl::retime("-O sc2buf_wt_rd_valid -i sc2buf_wt_rd_valid_w -stage 4 -clk nvdla_core_clk");

//get sc weight read bank output data. 
//: my $t1="";
//: my $kk=CBUF_RD_PORT_WIDTH;
//: if(CBUF_BANK_RAM_CASE==0){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//: wire [${kk}-1:0] bank${j}_wt_rd_data = bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_wt_rd_valid}}; );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==1){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//: wire [${kk}-1:0]  bank${j}_wt_rd_data = {bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_wt_rd_valid}},
//:                                                         bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_wt_rd_valid}}}; );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==2){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//: wire [${kk}-1:0]  bank${j}_wt_rd_data = (bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_wt_rd_valid}})|
//:                                                         (bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_wt_rd_valid}});
//:     );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==3){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//: wire [${kk}-1:0]  bank${j}_wt_rd_data = {bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_wt_rd_valid}},
//:                                                         bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_wt_rd_valid}}}|
//:                                                         {bank${j}_ram3_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram3_wt_rd_valid}},
//:                                                         bank${j}_ram2_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram2_wt_rd_valid}}};
//:     );
//:     }
//: }
//: if(CBUF_BANK_RAM_CASE==4){
//: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
//: print qq(
//: wire [${kk}-1:0]  bank${j}_wt_rd_data = {bank${j}_ram3_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram3_wt_rd_valid}},
//:                                                         bank${j}_ram2_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram2_wt_rd_valid}},
//:                                                         bank${j}_ram1_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram1_wt_rd_valid}},
//:                                                         bank${j}_ram0_rd_data&{CBUF_RAM_WIDTH{bank${j}_ram0_wt_rd_valid}}};
//:     );
//:     }
//: }


// pipe solution. for timing concern, 4 level pipe. 
//: my $kk=CBUF_RD_PORT_WIDTH;
//: for (my $i=0; $i<CBUF_BANK_NUMBER; $i++){
//: &eperl::flop("-wid ${kk} -norst -q l1group${i}_wt_rd_data   -d bank${i}_wt_rd_data");
//: }
//: 
//: for (my $i=0; $i<CBUF_BANK_NUMBER/4; $i++){
//: my $ni=$i*4;
//: my $nii=$i*4+1;
//: my $niii=$i*4+2;
//: my $niiii=$i*4+3;
//: print qq(
//: wire [${kk}-1:0] l2group${i}_wt_rd_data_w = l1group${ni}_wt_rd_data | l1group${nii}_wt_rd_data | l1group${niii}_wt_rd_data | l1group${niiii}_wt_rd_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l2group${i}_wt_rd_data   -d l2group${i}_wt_rd_data_w");
//: }
//:
//: for (my $i=0; $i<CBUF_BANK_NUMBER/16; $i++){
//: my $ni=$i*4;
//: my $nii=$i*4+1;
//: my $niii=$i*4+2;
//: my $niiii=$i*4+3;
//: print qq(
//: wire [${kk}-1:0] l3group${i}_wt_rd_data_w = l2group${ni}_wt_rd_data | l2group${nii}_wt_rd_data | l2group${niii}_wt_rd_data | l2group${niiii}_wt_rd_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l3group${i}_wt_rd_data   -d l3group${i}_wt_rd_data_w");
//: }
//: 
//: if(CBUF_BANK_NUMBER==16){
//: &eperl::flop("-wid ${kk} -norst -q l4group_wt_rd_data   -d l3group0_wt_rd_data"); 
//: }
//: if(CBUF_BANK_NUMBER==32) {
//: print qq(
//: wire [${kk}-1:0] l4group_wt_rd_data_w = l3group0_wt_rd_data | l3group1_wt_rd_data;
//: );
//: &eperl::flop("-wid ${kk} -norst -q l4group_wt_rd_data   -d l4group_wt_rd_data_w");
//: }
wire[CBUF_RD_PORT_WIDTH-1:0] sc2buf_wt_rd_data = l4group_wt_rd_data[CBUF_RD_PORT_WIDTH-1:0];

////get sc weight read data.
////: my $t1="";
////: my $kk=CBUF_RD_PORT_WIDTH;
////: for(my $j=0; $j<CBUF_BANK_NUMBER ; $j++){
////:         $t1 .= "bank${j}_wt_rd_data|";    
////:     }
////: print "wire[${kk}-1:0] sc2buf_wt_rd_data =".${t1}."{${kk}{1'b0}}; \n";



/////////////////step4: read WMB handle
//decode read wmb address to sram.
//: my $bank_slice= CBUF_BANK_SLICE;  #address part for select bank
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire  bank${j}_ram${k}_wmb_rd_en = sc2buf_wmb_rd_en&&(sc2buf_wmb_rd_addr[${bank_slice}]==${j}); )
//:         }
//:         if(CBUF_BANK_RAM_CASE==2){
//:         print qq(
//:     wire  bank${j}_ram${k}_wmb_rd_en = sc2buf_wmb_rd_en&&(sc2buf_wmb_rd_addr[${bank_slice}]==${j})&&(sc2buf_wmb_rd_addr[0]==${k}); )
//:         }
//:         if(CBUF_BANK_RAM_CASE==3){
//:         print qq(
//:     wire  bank${j}_ram${k}_wmb_rd_en = sc2buf_wmb_rd_en&&(sc2buf_wmb_rd_addr[${bank_slice}]==${j})&&(sc2buf_wmb_rd_addr[0]==${k}/2); )
//:         }
//:     }
//: }
`endif

//get sram wmb read address.
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         print qq(
//:     wire [CBUF_RAM_DEPTH_BITS-1:0] bank${j}_ram${k}_wmb_rd_addr = {CBUF_RAM_DEPTH_BITS{bank${j}_ram${k}_wmb_rd_en}}&(sc2buf_wmb_rd_addr[CBUF_RAM_DEPTH_BITS-1:0]); )
//:             }
//:         if((CBUF_BANK_RAM_CASE==2)||(CBUF_BANK_RAM_CASE==3)){
//:         print qq(
//:     wire [CBUF_RAM_DEPTH_BITS-1:0] bank${j}_ram${k}_wmb_rd_addr = {CBUF_RAM_DEPTH_BITS{bank${j}_ram${k}_wmb_rd_en}}&(sc2buf_wmb_rd_addr[CBUF_RAM_DEPTH_BITS:1]); )
//:         }
//:     }
//: }
`endif



//add flop for sram wmb read en
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED \n";
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//: &eperl::flop("-q bank${j}_ram${k}_wmb_rd_en_d1 -d  bank${j}_ram${k}_wmb_rd_en"); 
//: &eperl::flop("-q bank${j}_ram${k}_wmb_rd_en_d2 -d  bank${j}_ram${k}_wmb_rd_en_d1"); 
//:         }
//: }
`endif

//get sram wmb read valid.
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:     print qq(
//:     wire  bank${j}_ram${k}_wmb_rd_valid = bank${j}_ram${k}_wmb_rd_en_d2; )
//:     }
//: }
`endif


//get sc wmb read valid.
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: my $t1="";
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:     $t1 .= "bank${j}_ram${k}_wmb_rd_valid|";
//:     }
//: }
//: print " wire [0:0] sc2buf_wmb_rd_valid_w ="." ${t1}"."1'b0; \n";
//: &eperl::retime("-O sc2buf_wmb_rd_valid -i sc2buf_wmb_rd_valid_w -stage 4 -clk nvdla_core_clk");
`endif


//get sc wmb read data.
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: my $t1="";
//: my $t2="";
//: my $kk=CBUF_RD_PORT_WIDTH;
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:     for(my $k=0; $k<CBUF_RAM_PER_BANK ; $k++){
//:         if((CBUF_BANK_RAM_CASE==0)||(CBUF_BANK_RAM_CASE==1)||(CBUF_BANK_RAM_CASE==4)){
//:         $t1 .="{CBUF_RAM_WIDTH{bank${j}_ram${k}_wmb_rd_valid}} & bank${j}_ram${k}_wmb_rd_data ,";    
//:         }
//:     }
//: }
//: print "wire[${kk}-1:0] sc2buf_wmb_rd_data ="."{"."${t1}"."}; \n";
//: for(my $j=CBUF_BANK_NUMBER-1; $j<CBUF_BANK_NUMBER ; $j++){
//:         if(CBUF_BANK_RAM_CASE==2){
//:         $t1 .="{CBUF_RAM_WIDTH{bank${j}_ram0_wmb_rd_valid}} & bank${j}_ram0_wmb_rd_data"; 
//:         $t2 .="{CBUF_RAM_WIDTH{bank${j}_ram1_wmb_rd_valid}} & bank${j}_ram1_wmb_rd_data"; 
//:         }
//:         if(CBUF_BANK_RAM_CASE==3){
//:         $t1 .="{{CBUF_RAM_WIDTH{bank${j}_ram1_wmb_rd_valid}} & bank${j}_ram1_wmb_rd_data,{CBUF_RAM_WIDTH{bank${j}_ram0_wmb_rd_valid}} & bank${j}_ram0_wmb_rd_data}"; 
//:         $t2 .="{{CBUF_RAM_WIDTH{bank${j}_ram3_wmb_rd_valid}} & bank${j}_ram3_wmb_rd_data,{CBUF_RAM_WIDTH{bank${j}_ram2_wmb_rd_valid}} & bank${j}_ram2_wmb_rd_data}";
//:     }
//: }
//: print "wire[${kk}-1:0] wmb_rd_data ="."(${t1})|(${t2}); \n";
//: &eperl::retime("-wid ${kk} -o sc2buf_wmb_rd_data -i wmb_rd_data -stage 4 -clk nvdla_core_clk"); 
`endif


//get sram read en, data_rd0/data_rd1/weight/wmb
//: if ((CBUF_BANK_RAM_CASE==0)|(CBUF_BANK_RAM_CASE==1)|(CBUF_BANK_RAM_CASE==4)){
//: for (my $i=0; $i<CBUF_BANK_NUMBER-1; $i++){
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print qq(
//:     wire bank${i}_ram${j}_rd_en = bank${i}_ram${j}_data_rd_en|bank${i}_ram${j}_wt_rd_en;
//: );
//: }
//: }
//: my $i=CBUF_BANK_NUMBER-1;
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: print qq(
//: wire bank${i}_ram${j}_rd_en = bank${i}_ram${j}_data_rd_en|bank${i}_ram${j}_wt_rd_en|bank${i}_ram${j}_wmb_rd_en;
//: `else
//: wire bank${i}_ram${j}_rd_en = bank${i}_ram${j}_data_rd_en|bank${i}_ram${j}_wt_rd_en;
//: `endif
//: );
//: }
//: }
//:
//: if ((CBUF_BANK_RAM_CASE==2)|(CBUF_BANK_RAM_CASE==3)){
//: for (my $i=0; $i<CBUF_BANK_NUMBER-1; $i++){
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print qq(
//:     wire bank${i}_ram${j}_rd_en = bank${i}_ram${j}_data_rd0_en|bank${i}_ram${j}_data_rd1_en|bank${i}_ram${j}_wt_rd_en;
//: );
//: }
//: }
//: my $i=CBUF_BANK_NUMBER-1;
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: print qq(
//: wire bank${i}_ram${j}_rd_en = bank${i}_ram${j}_data_rd0_en|bank${i}_ram${j}_data_rd1_en|bank${i}_ram${j}_wt_rd_en|bank${i}_ram${j}_wmb_rd_en;
//: `else
//: wire bank${i}_ram${j}_rd_en = bank${i}_ram${j}_data_rd0_en|bank${i}_ram${j}_data_rd1_en|bank${i}_ram${j}_wt_rd_en;
//: `endif
//: );
//: }
//: }


//get sram read addr, data_rd0/data_rd1/weight/wmb
//: my $kk=CBUF_RAM_DEPTH_BITS;
//: if ((CBUF_BANK_RAM_CASE==0)|(CBUF_BANK_RAM_CASE==1)|(CBUF_BANK_RAM_CASE==4)){
//: for (my $i=0; $i<CBUF_BANK_NUMBER-1; $i++){
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print qq(
//:     wire[${kk}-1:0] bank${i}_ram${j}_rd_addr = {${kk}{bank${i}_ram${j}_data_rd_en}}&bank${i}_ram${j}_data_rd_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wt_rd_en}}&bank${i}_ram${j}_wt_rd_addr;
//: );
//: }
//: }
//: my $i=CBUF_BANK_NUMBER-1;
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: print qq(
//:     wire[${kk}-1:0] bank${i}_ram${j}_rd_addr = {${kk}{bank${i}_ram${j}_data_rd_en}}&bank${i}_ram${j}_data_rd_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wt_rd_en}}&bank${i}_ram${j}_wt_rd_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wmb_rd_en}}&bank${i}_ram${j}_wmb_rd_addr;
//: `else
//:     wire[${kk}-1:0] bank${i}_ram${j}_rd_addr = {${kk}{bank${i}_ram${j}_data_rd_en}}&bank${i}_ram${j}_data_rd_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wt_rd_en}}&bank${i}_ram${j}_wt_rd_addr;
//: `endif
//: );
//: }
//: }
//:
//: if ((CBUF_BANK_RAM_CASE==2)|(CBUF_BANK_RAM_CASE==3)){
//: for (my $i=0; $i<CBUF_BANK_NUMBER-1; $i++){
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print qq(
//:     wire[${kk}-1:0] bank${i}_ram${j}_rd_addr = {${kk}{bank${i}_ram${j}_data_rd0_en}}&bank${i}_ram${j}_data_rd0_addr|
//:                                                 {${kk}{bank${i}_ram${j}_data_rd1_en}}&bank${i}_ram${j}_data_rd1_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wt_rd_en}}&bank${i}_ram${j}_wt_rd_addr;
//: );
//: }
//: }
//: my $i=CBUF_BANK_NUMBER-1;
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print  "`ifdef  CBUF_WEIGHT_COMPRESSED";
//: print qq(
//: wire[${kk}-1:0] bank${i}_ram${j}_rd_addr = {${kk}{bank${i}_ram${j}_data_rd0_en}}&bank${i}_ram${j}_data_rd0_addr|
//:                                                 {${kk}{bank${i}_ram${j}_data_rd1_en}}&bank${i}_ram${j}_data_rd1_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wt_rd_en}}&bank${i}_ram${j}_wt_rd_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wmb_rd_en}}&bank${i}_ram${j}_wmb_rd_addr;
//: `else
//: wire[${kk}-1:0] bank${i}_ram${j}_rd_addr = {${kk}{bank${i}_ram${j}_data_rd0_en}}&bank${i}_ram${j}_data_rd0_addr|
//:                                                 {${kk}{bank${i}_ram${j}_data_rd1_en}}&bank${i}_ram${j}_data_rd1_addr|
//:                                                 {${kk}{bank${i}_ram${j}_wt_rd_en}}&bank${i}_ram${j}_wt_rd_addr;
//: `endif
//: );
//: }
//: }


// add 1 pipe for sram read control signal.
//: my $kk=CBUF_RAM_DEPTH_BITS;
//: for(my $i=0; $i<CBUF_BANK_NUMBER ; $i++){
//:     for(my $j=0; $j<CBUF_RAM_PER_BANK ; $j++){
//: &eperl::flop("-q bank${i}_ram${j}_rd_en_d1 -d bank${i}_ram${j}_rd_en");
//: &eperl::flop("-wid ${kk} -q bank${i}_ram${j}_rd_addr_d1 -d bank${i}_ram${j}_rd_addr");
//:     }
//: }


//instance SRAM. 
//: my $dep= CBUF_RAM_DEPTH; 
//: my $wid= CBUF_RAM_WIDTH;
//: for (my $i=0; $i<CBUF_BANK_NUMBER; $i++){
//:     for (my $j=0; $j<CBUF_RAM_PER_BANK; $j++){
//: print qq(
//: nv_ram_rws_${dep}x${wid} u_cbuf_ram_bank${i}_ram${j} (
//:    .clk           (nvdla_core_clk)            //|< i
//:   ,.ra            (bank${i}_ram${j}_rd_addr_d1[CBUF_RAM_DEPTH_BITS-1:0])         //|< r
//:   ,.re            (bank${i}_ram${j}_rd_en_d1)              //|< r
//:   ,.dout          (bank${i}_ram${j}_rd_data)     //|> w
//:   ,.wa            (bank${i}_ram${j}_wr_addr_d2[CBUF_RAM_DEPTH_BITS-1:0])      //|< r
//:   ,.we            (bank${i}_ram${j}_wr_en_d2)           //|< r
//:   ,.di            (bank${i}_ram${j}_wr_data_d2)  //|< r
//:   ,.pwrbus_ram_pd (pwrbus_ram_pd[31:0])       //|< i
//:   );
//:     );
//:     }
//: }

endmodule
