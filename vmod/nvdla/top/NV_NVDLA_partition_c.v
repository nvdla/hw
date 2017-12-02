// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_c.v

module NV_NVDLA_partition_c (
   accu2sc_credit_size           //|< i
  ,accu2sc_credit_vld            //|< i
  ,cacc2csb_resp_src_pd          //|< i
  ,cacc2csb_resp_src_valid       //|< i
  ,cacc2glb_done_intr_src_pd     //|< i
  ,cdma_dat2cvif_rd_req_ready    //|< i
  ,cdma_dat2mcif_rd_req_ready    //|< i
  ,cdma_wt2cvif_rd_req_ready     //|< i
  ,cdma_wt2mcif_rd_req_ready     //|< i
  ,cmac_b2csb_resp_src_pd        //|< i
  ,cmac_b2csb_resp_src_valid     //|< i
  ,csb2cacc_req_dst_prdy         //|< i
  ,csb2cacc_req_src_pd           //|< i
  ,csb2cacc_req_src_pvld         //|< i
  ,csb2cdma_req_pd               //|< i
  ,csb2cdma_req_pvld             //|< i
  ,csb2cmac_b_req_dst_prdy       //|< i
  ,csb2cmac_b_req_src_pd         //|< i
  ,csb2cmac_b_req_src_pvld       //|< i
  ,csb2csc_req_pd                //|< i
  ,csb2csc_req_pvld              //|< i
  ,cvif2cdma_dat_rd_rsp_pd       //|< i
  ,cvif2cdma_dat_rd_rsp_valid    //|< i
  ,cvif2cdma_wt_rd_rsp_pd        //|< i
  ,cvif2cdma_wt_rd_rsp_valid     //|< i
  ,direct_reset_                 //|< i
  ,dla_reset_rstn                //|< i
  ,global_clk_ovr_on             //|< i
  ,mcif2cdma_dat_rd_rsp_pd       //|< i
  ,mcif2cdma_dat_rd_rsp_valid    //|< i
  ,mcif2cdma_wt_rd_rsp_pd        //|< i
  ,mcif2cdma_wt_rd_rsp_valid     //|< i
  ,nvdla_clk_ovr_on              //|< i
  ,nvdla_core_clk                //|< i
  ,pwrbus_ram_pd                 //|< i
  ,test_mode                     //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,cacc2csb_resp_dst_pd          //|> o
  ,cacc2csb_resp_dst_valid       //|> o
  ,cacc2glb_done_intr_dst_pd     //|> o
  ,cdma2csb_resp_pd              //|> o
  ,cdma2csb_resp_valid           //|> o
  ,cdma_dat2cvif_rd_req_pd       //|> o
  ,cdma_dat2cvif_rd_req_valid    //|> o
  ,cdma_dat2glb_done_intr_pd     //|> o
  ,cdma_dat2mcif_rd_req_pd       //|> o
  ,cdma_dat2mcif_rd_req_valid    //|> o
  ,cdma_wt2cvif_rd_req_pd        //|> o
  ,cdma_wt2cvif_rd_req_valid     //|> o
  ,cdma_wt2glb_done_intr_pd      //|> o
  ,cdma_wt2mcif_rd_req_pd        //|> o
  ,cdma_wt2mcif_rd_req_valid     //|> o
  ,cmac_b2csb_resp_dst_pd        //|> o
  ,cmac_b2csb_resp_dst_valid     //|> o
  ,csb2cacc_req_dst_pd           //|> o
  ,csb2cacc_req_dst_pvld         //|> o
  ,csb2cacc_req_src_prdy         //|> o
  ,csb2cdma_req_prdy             //|> o
  ,csb2cmac_b_req_dst_pd         //|> o
  ,csb2cmac_b_req_dst_pvld       //|> o
  ,csb2cmac_b_req_src_prdy       //|> o
  ,csb2csc_req_prdy              //|> o
  ,csc2csb_resp_pd               //|> o
  ,csc2csb_resp_valid            //|> o
  ,cvif2cdma_dat_rd_rsp_ready    //|> o
  ,cvif2cdma_wt_rd_rsp_ready     //|> o
  ,mcif2cdma_dat_rd_rsp_ready    //|> o
  ,mcif2cdma_wt_rd_rsp_ready     //|> o
  ,sc2mac_dat_a_src_data0        //|> o
  ,sc2mac_dat_a_src_data1        //|> o
  ,sc2mac_dat_a_src_data10       //|> o
  ,sc2mac_dat_a_src_data100      //|> o
  ,sc2mac_dat_a_src_data101      //|> o
  ,sc2mac_dat_a_src_data102      //|> o
  ,sc2mac_dat_a_src_data103      //|> o
  ,sc2mac_dat_a_src_data104      //|> o
  ,sc2mac_dat_a_src_data105      //|> o
  ,sc2mac_dat_a_src_data106      //|> o
  ,sc2mac_dat_a_src_data107      //|> o
  ,sc2mac_dat_a_src_data108      //|> o
  ,sc2mac_dat_a_src_data109      //|> o
  ,sc2mac_dat_a_src_data11       //|> o
  ,sc2mac_dat_a_src_data110      //|> o
  ,sc2mac_dat_a_src_data111      //|> o
  ,sc2mac_dat_a_src_data112      //|> o
  ,sc2mac_dat_a_src_data113      //|> o
  ,sc2mac_dat_a_src_data114      //|> o
  ,sc2mac_dat_a_src_data115      //|> o
  ,sc2mac_dat_a_src_data116      //|> o
  ,sc2mac_dat_a_src_data117      //|> o
  ,sc2mac_dat_a_src_data118      //|> o
  ,sc2mac_dat_a_src_data119      //|> o
  ,sc2mac_dat_a_src_data12       //|> o
  ,sc2mac_dat_a_src_data120      //|> o
  ,sc2mac_dat_a_src_data121      //|> o
  ,sc2mac_dat_a_src_data122      //|> o
  ,sc2mac_dat_a_src_data123      //|> o
  ,sc2mac_dat_a_src_data124      //|> o
  ,sc2mac_dat_a_src_data125      //|> o
  ,sc2mac_dat_a_src_data126      //|> o
  ,sc2mac_dat_a_src_data127      //|> o
  ,sc2mac_dat_a_src_data13       //|> o
  ,sc2mac_dat_a_src_data14       //|> o
  ,sc2mac_dat_a_src_data15       //|> o
  ,sc2mac_dat_a_src_data16       //|> o
  ,sc2mac_dat_a_src_data17       //|> o
  ,sc2mac_dat_a_src_data18       //|> o
  ,sc2mac_dat_a_src_data19       //|> o
  ,sc2mac_dat_a_src_data2        //|> o
  ,sc2mac_dat_a_src_data20       //|> o
  ,sc2mac_dat_a_src_data21       //|> o
  ,sc2mac_dat_a_src_data22       //|> o
  ,sc2mac_dat_a_src_data23       //|> o
  ,sc2mac_dat_a_src_data24       //|> o
  ,sc2mac_dat_a_src_data25       //|> o
  ,sc2mac_dat_a_src_data26       //|> o
  ,sc2mac_dat_a_src_data27       //|> o
  ,sc2mac_dat_a_src_data28       //|> o
  ,sc2mac_dat_a_src_data29       //|> o
  ,sc2mac_dat_a_src_data3        //|> o
  ,sc2mac_dat_a_src_data30       //|> o
  ,sc2mac_dat_a_src_data31       //|> o
  ,sc2mac_dat_a_src_data32       //|> o
  ,sc2mac_dat_a_src_data33       //|> o
  ,sc2mac_dat_a_src_data34       //|> o
  ,sc2mac_dat_a_src_data35       //|> o
  ,sc2mac_dat_a_src_data36       //|> o
  ,sc2mac_dat_a_src_data37       //|> o
  ,sc2mac_dat_a_src_data38       //|> o
  ,sc2mac_dat_a_src_data39       //|> o
  ,sc2mac_dat_a_src_data4        //|> o
  ,sc2mac_dat_a_src_data40       //|> o
  ,sc2mac_dat_a_src_data41       //|> o
  ,sc2mac_dat_a_src_data42       //|> o
  ,sc2mac_dat_a_src_data43       //|> o
  ,sc2mac_dat_a_src_data44       //|> o
  ,sc2mac_dat_a_src_data45       //|> o
  ,sc2mac_dat_a_src_data46       //|> o
  ,sc2mac_dat_a_src_data47       //|> o
  ,sc2mac_dat_a_src_data48       //|> o
  ,sc2mac_dat_a_src_data49       //|> o
  ,sc2mac_dat_a_src_data5        //|> o
  ,sc2mac_dat_a_src_data50       //|> o
  ,sc2mac_dat_a_src_data51       //|> o
  ,sc2mac_dat_a_src_data52       //|> o
  ,sc2mac_dat_a_src_data53       //|> o
  ,sc2mac_dat_a_src_data54       //|> o
  ,sc2mac_dat_a_src_data55       //|> o
  ,sc2mac_dat_a_src_data56       //|> o
  ,sc2mac_dat_a_src_data57       //|> o
  ,sc2mac_dat_a_src_data58       //|> o
  ,sc2mac_dat_a_src_data59       //|> o
  ,sc2mac_dat_a_src_data6        //|> o
  ,sc2mac_dat_a_src_data60       //|> o
  ,sc2mac_dat_a_src_data61       //|> o
  ,sc2mac_dat_a_src_data62       //|> o
  ,sc2mac_dat_a_src_data63       //|> o
  ,sc2mac_dat_a_src_data64       //|> o
  ,sc2mac_dat_a_src_data65       //|> o
  ,sc2mac_dat_a_src_data66       //|> o
  ,sc2mac_dat_a_src_data67       //|> o
  ,sc2mac_dat_a_src_data68       //|> o
  ,sc2mac_dat_a_src_data69       //|> o
  ,sc2mac_dat_a_src_data7        //|> o
  ,sc2mac_dat_a_src_data70       //|> o
  ,sc2mac_dat_a_src_data71       //|> o
  ,sc2mac_dat_a_src_data72       //|> o
  ,sc2mac_dat_a_src_data73       //|> o
  ,sc2mac_dat_a_src_data74       //|> o
  ,sc2mac_dat_a_src_data75       //|> o
  ,sc2mac_dat_a_src_data76       //|> o
  ,sc2mac_dat_a_src_data77       //|> o
  ,sc2mac_dat_a_src_data78       //|> o
  ,sc2mac_dat_a_src_data79       //|> o
  ,sc2mac_dat_a_src_data8        //|> o
  ,sc2mac_dat_a_src_data80       //|> o
  ,sc2mac_dat_a_src_data81       //|> o
  ,sc2mac_dat_a_src_data82       //|> o
  ,sc2mac_dat_a_src_data83       //|> o
  ,sc2mac_dat_a_src_data84       //|> o
  ,sc2mac_dat_a_src_data85       //|> o
  ,sc2mac_dat_a_src_data86       //|> o
  ,sc2mac_dat_a_src_data87       //|> o
  ,sc2mac_dat_a_src_data88       //|> o
  ,sc2mac_dat_a_src_data89       //|> o
  ,sc2mac_dat_a_src_data9        //|> o
  ,sc2mac_dat_a_src_data90       //|> o
  ,sc2mac_dat_a_src_data91       //|> o
  ,sc2mac_dat_a_src_data92       //|> o
  ,sc2mac_dat_a_src_data93       //|> o
  ,sc2mac_dat_a_src_data94       //|> o
  ,sc2mac_dat_a_src_data95       //|> o
  ,sc2mac_dat_a_src_data96       //|> o
  ,sc2mac_dat_a_src_data97       //|> o
  ,sc2mac_dat_a_src_data98       //|> o
  ,sc2mac_dat_a_src_data99       //|> o
  ,sc2mac_dat_a_src_mask         //|> o
  ,sc2mac_dat_a_src_pd           //|> o
  ,sc2mac_dat_a_src_pvld         //|> o
  ,sc2mac_dat_b_dst_data0        //|> o
  ,sc2mac_dat_b_dst_data1        //|> o
  ,sc2mac_dat_b_dst_data10       //|> o
  ,sc2mac_dat_b_dst_data100      //|> o
  ,sc2mac_dat_b_dst_data101      //|> o
  ,sc2mac_dat_b_dst_data102      //|> o
  ,sc2mac_dat_b_dst_data103      //|> o
  ,sc2mac_dat_b_dst_data104      //|> o
  ,sc2mac_dat_b_dst_data105      //|> o
  ,sc2mac_dat_b_dst_data106      //|> o
  ,sc2mac_dat_b_dst_data107      //|> o
  ,sc2mac_dat_b_dst_data108      //|> o
  ,sc2mac_dat_b_dst_data109      //|> o
  ,sc2mac_dat_b_dst_data11       //|> o
  ,sc2mac_dat_b_dst_data110      //|> o
  ,sc2mac_dat_b_dst_data111      //|> o
  ,sc2mac_dat_b_dst_data112      //|> o
  ,sc2mac_dat_b_dst_data113      //|> o
  ,sc2mac_dat_b_dst_data114      //|> o
  ,sc2mac_dat_b_dst_data115      //|> o
  ,sc2mac_dat_b_dst_data116      //|> o
  ,sc2mac_dat_b_dst_data117      //|> o
  ,sc2mac_dat_b_dst_data118      //|> o
  ,sc2mac_dat_b_dst_data119      //|> o
  ,sc2mac_dat_b_dst_data12       //|> o
  ,sc2mac_dat_b_dst_data120      //|> o
  ,sc2mac_dat_b_dst_data121      //|> o
  ,sc2mac_dat_b_dst_data122      //|> o
  ,sc2mac_dat_b_dst_data123      //|> o
  ,sc2mac_dat_b_dst_data124      //|> o
  ,sc2mac_dat_b_dst_data125      //|> o
  ,sc2mac_dat_b_dst_data126      //|> o
  ,sc2mac_dat_b_dst_data127      //|> o
  ,sc2mac_dat_b_dst_data13       //|> o
  ,sc2mac_dat_b_dst_data14       //|> o
  ,sc2mac_dat_b_dst_data15       //|> o
  ,sc2mac_dat_b_dst_data16       //|> o
  ,sc2mac_dat_b_dst_data17       //|> o
  ,sc2mac_dat_b_dst_data18       //|> o
  ,sc2mac_dat_b_dst_data19       //|> o
  ,sc2mac_dat_b_dst_data2        //|> o
  ,sc2mac_dat_b_dst_data20       //|> o
  ,sc2mac_dat_b_dst_data21       //|> o
  ,sc2mac_dat_b_dst_data22       //|> o
  ,sc2mac_dat_b_dst_data23       //|> o
  ,sc2mac_dat_b_dst_data24       //|> o
  ,sc2mac_dat_b_dst_data25       //|> o
  ,sc2mac_dat_b_dst_data26       //|> o
  ,sc2mac_dat_b_dst_data27       //|> o
  ,sc2mac_dat_b_dst_data28       //|> o
  ,sc2mac_dat_b_dst_data29       //|> o
  ,sc2mac_dat_b_dst_data3        //|> o
  ,sc2mac_dat_b_dst_data30       //|> o
  ,sc2mac_dat_b_dst_data31       //|> o
  ,sc2mac_dat_b_dst_data32       //|> o
  ,sc2mac_dat_b_dst_data33       //|> o
  ,sc2mac_dat_b_dst_data34       //|> o
  ,sc2mac_dat_b_dst_data35       //|> o
  ,sc2mac_dat_b_dst_data36       //|> o
  ,sc2mac_dat_b_dst_data37       //|> o
  ,sc2mac_dat_b_dst_data38       //|> o
  ,sc2mac_dat_b_dst_data39       //|> o
  ,sc2mac_dat_b_dst_data4        //|> o
  ,sc2mac_dat_b_dst_data40       //|> o
  ,sc2mac_dat_b_dst_data41       //|> o
  ,sc2mac_dat_b_dst_data42       //|> o
  ,sc2mac_dat_b_dst_data43       //|> o
  ,sc2mac_dat_b_dst_data44       //|> o
  ,sc2mac_dat_b_dst_data45       //|> o
  ,sc2mac_dat_b_dst_data46       //|> o
  ,sc2mac_dat_b_dst_data47       //|> o
  ,sc2mac_dat_b_dst_data48       //|> o
  ,sc2mac_dat_b_dst_data49       //|> o
  ,sc2mac_dat_b_dst_data5        //|> o
  ,sc2mac_dat_b_dst_data50       //|> o
  ,sc2mac_dat_b_dst_data51       //|> o
  ,sc2mac_dat_b_dst_data52       //|> o
  ,sc2mac_dat_b_dst_data53       //|> o
  ,sc2mac_dat_b_dst_data54       //|> o
  ,sc2mac_dat_b_dst_data55       //|> o
  ,sc2mac_dat_b_dst_data56       //|> o
  ,sc2mac_dat_b_dst_data57       //|> o
  ,sc2mac_dat_b_dst_data58       //|> o
  ,sc2mac_dat_b_dst_data59       //|> o
  ,sc2mac_dat_b_dst_data6        //|> o
  ,sc2mac_dat_b_dst_data60       //|> o
  ,sc2mac_dat_b_dst_data61       //|> o
  ,sc2mac_dat_b_dst_data62       //|> o
  ,sc2mac_dat_b_dst_data63       //|> o
  ,sc2mac_dat_b_dst_data64       //|> o
  ,sc2mac_dat_b_dst_data65       //|> o
  ,sc2mac_dat_b_dst_data66       //|> o
  ,sc2mac_dat_b_dst_data67       //|> o
  ,sc2mac_dat_b_dst_data68       //|> o
  ,sc2mac_dat_b_dst_data69       //|> o
  ,sc2mac_dat_b_dst_data7        //|> o
  ,sc2mac_dat_b_dst_data70       //|> o
  ,sc2mac_dat_b_dst_data71       //|> o
  ,sc2mac_dat_b_dst_data72       //|> o
  ,sc2mac_dat_b_dst_data73       //|> o
  ,sc2mac_dat_b_dst_data74       //|> o
  ,sc2mac_dat_b_dst_data75       //|> o
  ,sc2mac_dat_b_dst_data76       //|> o
  ,sc2mac_dat_b_dst_data77       //|> o
  ,sc2mac_dat_b_dst_data78       //|> o
  ,sc2mac_dat_b_dst_data79       //|> o
  ,sc2mac_dat_b_dst_data8        //|> o
  ,sc2mac_dat_b_dst_data80       //|> o
  ,sc2mac_dat_b_dst_data81       //|> o
  ,sc2mac_dat_b_dst_data82       //|> o
  ,sc2mac_dat_b_dst_data83       //|> o
  ,sc2mac_dat_b_dst_data84       //|> o
  ,sc2mac_dat_b_dst_data85       //|> o
  ,sc2mac_dat_b_dst_data86       //|> o
  ,sc2mac_dat_b_dst_data87       //|> o
  ,sc2mac_dat_b_dst_data88       //|> o
  ,sc2mac_dat_b_dst_data89       //|> o
  ,sc2mac_dat_b_dst_data9        //|> o
  ,sc2mac_dat_b_dst_data90       //|> o
  ,sc2mac_dat_b_dst_data91       //|> o
  ,sc2mac_dat_b_dst_data92       //|> o
  ,sc2mac_dat_b_dst_data93       //|> o
  ,sc2mac_dat_b_dst_data94       //|> o
  ,sc2mac_dat_b_dst_data95       //|> o
  ,sc2mac_dat_b_dst_data96       //|> o
  ,sc2mac_dat_b_dst_data97       //|> o
  ,sc2mac_dat_b_dst_data98       //|> o
  ,sc2mac_dat_b_dst_data99       //|> o
  ,sc2mac_dat_b_dst_mask         //|> o
  ,sc2mac_dat_b_dst_pd           //|> o
  ,sc2mac_dat_b_dst_pvld         //|> o
  ,sc2mac_wt_a_src_data0         //|> o
  ,sc2mac_wt_a_src_data1         //|> o
  ,sc2mac_wt_a_src_data10        //|> o
  ,sc2mac_wt_a_src_data100       //|> o
  ,sc2mac_wt_a_src_data101       //|> o
  ,sc2mac_wt_a_src_data102       //|> o
  ,sc2mac_wt_a_src_data103       //|> o
  ,sc2mac_wt_a_src_data104       //|> o
  ,sc2mac_wt_a_src_data105       //|> o
  ,sc2mac_wt_a_src_data106       //|> o
  ,sc2mac_wt_a_src_data107       //|> o
  ,sc2mac_wt_a_src_data108       //|> o
  ,sc2mac_wt_a_src_data109       //|> o
  ,sc2mac_wt_a_src_data11        //|> o
  ,sc2mac_wt_a_src_data110       //|> o
  ,sc2mac_wt_a_src_data111       //|> o
  ,sc2mac_wt_a_src_data112       //|> o
  ,sc2mac_wt_a_src_data113       //|> o
  ,sc2mac_wt_a_src_data114       //|> o
  ,sc2mac_wt_a_src_data115       //|> o
  ,sc2mac_wt_a_src_data116       //|> o
  ,sc2mac_wt_a_src_data117       //|> o
  ,sc2mac_wt_a_src_data118       //|> o
  ,sc2mac_wt_a_src_data119       //|> o
  ,sc2mac_wt_a_src_data12        //|> o
  ,sc2mac_wt_a_src_data120       //|> o
  ,sc2mac_wt_a_src_data121       //|> o
  ,sc2mac_wt_a_src_data122       //|> o
  ,sc2mac_wt_a_src_data123       //|> o
  ,sc2mac_wt_a_src_data124       //|> o
  ,sc2mac_wt_a_src_data125       //|> o
  ,sc2mac_wt_a_src_data126       //|> o
  ,sc2mac_wt_a_src_data127       //|> o
  ,sc2mac_wt_a_src_data13        //|> o
  ,sc2mac_wt_a_src_data14        //|> o
  ,sc2mac_wt_a_src_data15        //|> o
  ,sc2mac_wt_a_src_data16        //|> o
  ,sc2mac_wt_a_src_data17        //|> o
  ,sc2mac_wt_a_src_data18        //|> o
  ,sc2mac_wt_a_src_data19        //|> o
  ,sc2mac_wt_a_src_data2         //|> o
  ,sc2mac_wt_a_src_data20        //|> o
  ,sc2mac_wt_a_src_data21        //|> o
  ,sc2mac_wt_a_src_data22        //|> o
  ,sc2mac_wt_a_src_data23        //|> o
  ,sc2mac_wt_a_src_data24        //|> o
  ,sc2mac_wt_a_src_data25        //|> o
  ,sc2mac_wt_a_src_data26        //|> o
  ,sc2mac_wt_a_src_data27        //|> o
  ,sc2mac_wt_a_src_data28        //|> o
  ,sc2mac_wt_a_src_data29        //|> o
  ,sc2mac_wt_a_src_data3         //|> o
  ,sc2mac_wt_a_src_data30        //|> o
  ,sc2mac_wt_a_src_data31        //|> o
  ,sc2mac_wt_a_src_data32        //|> o
  ,sc2mac_wt_a_src_data33        //|> o
  ,sc2mac_wt_a_src_data34        //|> o
  ,sc2mac_wt_a_src_data35        //|> o
  ,sc2mac_wt_a_src_data36        //|> o
  ,sc2mac_wt_a_src_data37        //|> o
  ,sc2mac_wt_a_src_data38        //|> o
  ,sc2mac_wt_a_src_data39        //|> o
  ,sc2mac_wt_a_src_data4         //|> o
  ,sc2mac_wt_a_src_data40        //|> o
  ,sc2mac_wt_a_src_data41        //|> o
  ,sc2mac_wt_a_src_data42        //|> o
  ,sc2mac_wt_a_src_data43        //|> o
  ,sc2mac_wt_a_src_data44        //|> o
  ,sc2mac_wt_a_src_data45        //|> o
  ,sc2mac_wt_a_src_data46        //|> o
  ,sc2mac_wt_a_src_data47        //|> o
  ,sc2mac_wt_a_src_data48        //|> o
  ,sc2mac_wt_a_src_data49        //|> o
  ,sc2mac_wt_a_src_data5         //|> o
  ,sc2mac_wt_a_src_data50        //|> o
  ,sc2mac_wt_a_src_data51        //|> o
  ,sc2mac_wt_a_src_data52        //|> o
  ,sc2mac_wt_a_src_data53        //|> o
  ,sc2mac_wt_a_src_data54        //|> o
  ,sc2mac_wt_a_src_data55        //|> o
  ,sc2mac_wt_a_src_data56        //|> o
  ,sc2mac_wt_a_src_data57        //|> o
  ,sc2mac_wt_a_src_data58        //|> o
  ,sc2mac_wt_a_src_data59        //|> o
  ,sc2mac_wt_a_src_data6         //|> o
  ,sc2mac_wt_a_src_data60        //|> o
  ,sc2mac_wt_a_src_data61        //|> o
  ,sc2mac_wt_a_src_data62        //|> o
  ,sc2mac_wt_a_src_data63        //|> o
  ,sc2mac_wt_a_src_data64        //|> o
  ,sc2mac_wt_a_src_data65        //|> o
  ,sc2mac_wt_a_src_data66        //|> o
  ,sc2mac_wt_a_src_data67        //|> o
  ,sc2mac_wt_a_src_data68        //|> o
  ,sc2mac_wt_a_src_data69        //|> o
  ,sc2mac_wt_a_src_data7         //|> o
  ,sc2mac_wt_a_src_data70        //|> o
  ,sc2mac_wt_a_src_data71        //|> o
  ,sc2mac_wt_a_src_data72        //|> o
  ,sc2mac_wt_a_src_data73        //|> o
  ,sc2mac_wt_a_src_data74        //|> o
  ,sc2mac_wt_a_src_data75        //|> o
  ,sc2mac_wt_a_src_data76        //|> o
  ,sc2mac_wt_a_src_data77        //|> o
  ,sc2mac_wt_a_src_data78        //|> o
  ,sc2mac_wt_a_src_data79        //|> o
  ,sc2mac_wt_a_src_data8         //|> o
  ,sc2mac_wt_a_src_data80        //|> o
  ,sc2mac_wt_a_src_data81        //|> o
  ,sc2mac_wt_a_src_data82        //|> o
  ,sc2mac_wt_a_src_data83        //|> o
  ,sc2mac_wt_a_src_data84        //|> o
  ,sc2mac_wt_a_src_data85        //|> o
  ,sc2mac_wt_a_src_data86        //|> o
  ,sc2mac_wt_a_src_data87        //|> o
  ,sc2mac_wt_a_src_data88        //|> o
  ,sc2mac_wt_a_src_data89        //|> o
  ,sc2mac_wt_a_src_data9         //|> o
  ,sc2mac_wt_a_src_data90        //|> o
  ,sc2mac_wt_a_src_data91        //|> o
  ,sc2mac_wt_a_src_data92        //|> o
  ,sc2mac_wt_a_src_data93        //|> o
  ,sc2mac_wt_a_src_data94        //|> o
  ,sc2mac_wt_a_src_data95        //|> o
  ,sc2mac_wt_a_src_data96        //|> o
  ,sc2mac_wt_a_src_data97        //|> o
  ,sc2mac_wt_a_src_data98        //|> o
  ,sc2mac_wt_a_src_data99        //|> o
  ,sc2mac_wt_a_src_mask          //|> o
  ,sc2mac_wt_a_src_pvld          //|> o
  ,sc2mac_wt_a_src_sel           //|> o
  ,sc2mac_wt_b_dst_data0         //|> o
  ,sc2mac_wt_b_dst_data1         //|> o
  ,sc2mac_wt_b_dst_data10        //|> o
  ,sc2mac_wt_b_dst_data100       //|> o
  ,sc2mac_wt_b_dst_data101       //|> o
  ,sc2mac_wt_b_dst_data102       //|> o
  ,sc2mac_wt_b_dst_data103       //|> o
  ,sc2mac_wt_b_dst_data104       //|> o
  ,sc2mac_wt_b_dst_data105       //|> o
  ,sc2mac_wt_b_dst_data106       //|> o
  ,sc2mac_wt_b_dst_data107       //|> o
  ,sc2mac_wt_b_dst_data108       //|> o
  ,sc2mac_wt_b_dst_data109       //|> o
  ,sc2mac_wt_b_dst_data11        //|> o
  ,sc2mac_wt_b_dst_data110       //|> o
  ,sc2mac_wt_b_dst_data111       //|> o
  ,sc2mac_wt_b_dst_data112       //|> o
  ,sc2mac_wt_b_dst_data113       //|> o
  ,sc2mac_wt_b_dst_data114       //|> o
  ,sc2mac_wt_b_dst_data115       //|> o
  ,sc2mac_wt_b_dst_data116       //|> o
  ,sc2mac_wt_b_dst_data117       //|> o
  ,sc2mac_wt_b_dst_data118       //|> o
  ,sc2mac_wt_b_dst_data119       //|> o
  ,sc2mac_wt_b_dst_data12        //|> o
  ,sc2mac_wt_b_dst_data120       //|> o
  ,sc2mac_wt_b_dst_data121       //|> o
  ,sc2mac_wt_b_dst_data122       //|> o
  ,sc2mac_wt_b_dst_data123       //|> o
  ,sc2mac_wt_b_dst_data124       //|> o
  ,sc2mac_wt_b_dst_data125       //|> o
  ,sc2mac_wt_b_dst_data126       //|> o
  ,sc2mac_wt_b_dst_data127       //|> o
  ,sc2mac_wt_b_dst_data13        //|> o
  ,sc2mac_wt_b_dst_data14        //|> o
  ,sc2mac_wt_b_dst_data15        //|> o
  ,sc2mac_wt_b_dst_data16        //|> o
  ,sc2mac_wt_b_dst_data17        //|> o
  ,sc2mac_wt_b_dst_data18        //|> o
  ,sc2mac_wt_b_dst_data19        //|> o
  ,sc2mac_wt_b_dst_data2         //|> o
  ,sc2mac_wt_b_dst_data20        //|> o
  ,sc2mac_wt_b_dst_data21        //|> o
  ,sc2mac_wt_b_dst_data22        //|> o
  ,sc2mac_wt_b_dst_data23        //|> o
  ,sc2mac_wt_b_dst_data24        //|> o
  ,sc2mac_wt_b_dst_data25        //|> o
  ,sc2mac_wt_b_dst_data26        //|> o
  ,sc2mac_wt_b_dst_data27        //|> o
  ,sc2mac_wt_b_dst_data28        //|> o
  ,sc2mac_wt_b_dst_data29        //|> o
  ,sc2mac_wt_b_dst_data3         //|> o
  ,sc2mac_wt_b_dst_data30        //|> o
  ,sc2mac_wt_b_dst_data31        //|> o
  ,sc2mac_wt_b_dst_data32        //|> o
  ,sc2mac_wt_b_dst_data33        //|> o
  ,sc2mac_wt_b_dst_data34        //|> o
  ,sc2mac_wt_b_dst_data35        //|> o
  ,sc2mac_wt_b_dst_data36        //|> o
  ,sc2mac_wt_b_dst_data37        //|> o
  ,sc2mac_wt_b_dst_data38        //|> o
  ,sc2mac_wt_b_dst_data39        //|> o
  ,sc2mac_wt_b_dst_data4         //|> o
  ,sc2mac_wt_b_dst_data40        //|> o
  ,sc2mac_wt_b_dst_data41        //|> o
  ,sc2mac_wt_b_dst_data42        //|> o
  ,sc2mac_wt_b_dst_data43        //|> o
  ,sc2mac_wt_b_dst_data44        //|> o
  ,sc2mac_wt_b_dst_data45        //|> o
  ,sc2mac_wt_b_dst_data46        //|> o
  ,sc2mac_wt_b_dst_data47        //|> o
  ,sc2mac_wt_b_dst_data48        //|> o
  ,sc2mac_wt_b_dst_data49        //|> o
  ,sc2mac_wt_b_dst_data5         //|> o
  ,sc2mac_wt_b_dst_data50        //|> o
  ,sc2mac_wt_b_dst_data51        //|> o
  ,sc2mac_wt_b_dst_data52        //|> o
  ,sc2mac_wt_b_dst_data53        //|> o
  ,sc2mac_wt_b_dst_data54        //|> o
  ,sc2mac_wt_b_dst_data55        //|> o
  ,sc2mac_wt_b_dst_data56        //|> o
  ,sc2mac_wt_b_dst_data57        //|> o
  ,sc2mac_wt_b_dst_data58        //|> o
  ,sc2mac_wt_b_dst_data59        //|> o
  ,sc2mac_wt_b_dst_data6         //|> o
  ,sc2mac_wt_b_dst_data60        //|> o
  ,sc2mac_wt_b_dst_data61        //|> o
  ,sc2mac_wt_b_dst_data62        //|> o
  ,sc2mac_wt_b_dst_data63        //|> o
  ,sc2mac_wt_b_dst_data64        //|> o
  ,sc2mac_wt_b_dst_data65        //|> o
  ,sc2mac_wt_b_dst_data66        //|> o
  ,sc2mac_wt_b_dst_data67        //|> o
  ,sc2mac_wt_b_dst_data68        //|> o
  ,sc2mac_wt_b_dst_data69        //|> o
  ,sc2mac_wt_b_dst_data7         //|> o
  ,sc2mac_wt_b_dst_data70        //|> o
  ,sc2mac_wt_b_dst_data71        //|> o
  ,sc2mac_wt_b_dst_data72        //|> o
  ,sc2mac_wt_b_dst_data73        //|> o
  ,sc2mac_wt_b_dst_data74        //|> o
  ,sc2mac_wt_b_dst_data75        //|> o
  ,sc2mac_wt_b_dst_data76        //|> o
  ,sc2mac_wt_b_dst_data77        //|> o
  ,sc2mac_wt_b_dst_data78        //|> o
  ,sc2mac_wt_b_dst_data79        //|> o
  ,sc2mac_wt_b_dst_data8         //|> o
  ,sc2mac_wt_b_dst_data80        //|> o
  ,sc2mac_wt_b_dst_data81        //|> o
  ,sc2mac_wt_b_dst_data82        //|> o
  ,sc2mac_wt_b_dst_data83        //|> o
  ,sc2mac_wt_b_dst_data84        //|> o
  ,sc2mac_wt_b_dst_data85        //|> o
  ,sc2mac_wt_b_dst_data86        //|> o
  ,sc2mac_wt_b_dst_data87        //|> o
  ,sc2mac_wt_b_dst_data88        //|> o
  ,sc2mac_wt_b_dst_data89        //|> o
  ,sc2mac_wt_b_dst_data9         //|> o
  ,sc2mac_wt_b_dst_data90        //|> o
  ,sc2mac_wt_b_dst_data91        //|> o
  ,sc2mac_wt_b_dst_data92        //|> o
  ,sc2mac_wt_b_dst_data93        //|> o
  ,sc2mac_wt_b_dst_data94        //|> o
  ,sc2mac_wt_b_dst_data95        //|> o
  ,sc2mac_wt_b_dst_data96        //|> o
  ,sc2mac_wt_b_dst_data97        //|> o
  ,sc2mac_wt_b_dst_data98        //|> o
  ,sc2mac_wt_b_dst_data99        //|> o
  ,sc2mac_wt_b_dst_mask          //|> o
  ,sc2mac_wt_b_dst_pvld          //|> o
  ,sc2mac_wt_b_dst_sel           //|> o
  );

//
// NV_NVDLA_partition_c_io.v
//

input  test_mode;
input  direct_reset_;

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

input       accu2sc_credit_vld;   /* data valid */
input [2:0] accu2sc_credit_size;

output        cacc2csb_resp_dst_valid;  /* data valid */
output [33:0] cacc2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input        cacc2csb_resp_src_valid;  /* data valid */
input [33:0] cacc2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output [1:0] cacc2glb_done_intr_dst_pd;

input [1:0] cacc2glb_done_intr_src_pd;

output        cdma2csb_resp_valid;  /* data valid */
output [33:0] cdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        cdma_dat2cvif_rd_req_valid;  /* data valid */
input         cdma_dat2cvif_rd_req_ready;  /* data return handshake */
output [78:0] cdma_dat2cvif_rd_req_pd;

output [1:0] cdma_dat2glb_done_intr_pd;

output        cdma_dat2mcif_rd_req_valid;  /* data valid */
input         cdma_dat2mcif_rd_req_ready;  /* data return handshake */
output [78:0] cdma_dat2mcif_rd_req_pd;

output        cdma_wt2cvif_rd_req_valid;  /* data valid */
input         cdma_wt2cvif_rd_req_ready;  /* data return handshake */
output [78:0] cdma_wt2cvif_rd_req_pd;

output [1:0] cdma_wt2glb_done_intr_pd;

output        cdma_wt2mcif_rd_req_valid;  /* data valid */
input         cdma_wt2mcif_rd_req_ready;  /* data return handshake */
output [78:0] cdma_wt2mcif_rd_req_pd;

output        cmac_b2csb_resp_dst_valid;  /* data valid */
output [33:0] cmac_b2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input        cmac_b2csb_resp_src_valid;  /* data valid */
input [33:0] cmac_b2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cacc_req_dst_pvld;  /* data valid */
input         csb2cacc_req_dst_prdy;  /* data return handshake */
output [62:0] csb2cacc_req_dst_pd;

input         csb2cacc_req_src_pvld;  /* data valid */
output        csb2cacc_req_src_prdy;  /* data return handshake */
input  [62:0] csb2cacc_req_src_pd;

input         csb2cdma_req_pvld;  /* data valid */
output        csb2cdma_req_prdy;  /* data return handshake */
input  [62:0] csb2cdma_req_pd;

output        csb2cmac_b_req_dst_pvld;  /* data valid */
input         csb2cmac_b_req_dst_prdy;  /* data return handshake */
output [62:0] csb2cmac_b_req_dst_pd;

input         csb2cmac_b_req_src_pvld;  /* data valid */
output        csb2cmac_b_req_src_prdy;  /* data return handshake */
input  [62:0] csb2cmac_b_req_src_pd;

input         csb2csc_req_pvld;  /* data valid */
output        csb2csc_req_prdy;  /* data return handshake */
input  [62:0] csb2csc_req_pd;

output        csc2csb_resp_valid;  /* data valid */
output [33:0] csc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input          cvif2cdma_dat_rd_rsp_valid;  /* data valid */
output         cvif2cdma_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2cdma_dat_rd_rsp_pd;

input          cvif2cdma_wt_rd_rsp_valid;  /* data valid */
output         cvif2cdma_wt_rd_rsp_ready;  /* data return handshake */
input  [513:0] cvif2cdma_wt_rd_rsp_pd;

input          mcif2cdma_dat_rd_rsp_valid;  /* data valid */
output         mcif2cdma_dat_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2cdma_dat_rd_rsp_pd;

input          mcif2cdma_wt_rd_rsp_valid;  /* data valid */
output         mcif2cdma_wt_rd_rsp_ready;  /* data return handshake */
input  [513:0] mcif2cdma_wt_rd_rsp_pd;

input [31:0] pwrbus_ram_pd;

output         sc2mac_dat_a_src_pvld;     /* data valid */
output [127:0] sc2mac_dat_a_src_mask;
output   [7:0] sc2mac_dat_a_src_data0;
output   [7:0] sc2mac_dat_a_src_data1;
output   [7:0] sc2mac_dat_a_src_data2;
output   [7:0] sc2mac_dat_a_src_data3;
output   [7:0] sc2mac_dat_a_src_data4;
output   [7:0] sc2mac_dat_a_src_data5;
output   [7:0] sc2mac_dat_a_src_data6;
output   [7:0] sc2mac_dat_a_src_data7;
output   [7:0] sc2mac_dat_a_src_data8;
output   [7:0] sc2mac_dat_a_src_data9;
output   [7:0] sc2mac_dat_a_src_data10;
output   [7:0] sc2mac_dat_a_src_data11;
output   [7:0] sc2mac_dat_a_src_data12;
output   [7:0] sc2mac_dat_a_src_data13;
output   [7:0] sc2mac_dat_a_src_data14;
output   [7:0] sc2mac_dat_a_src_data15;
output   [7:0] sc2mac_dat_a_src_data16;
output   [7:0] sc2mac_dat_a_src_data17;
output   [7:0] sc2mac_dat_a_src_data18;
output   [7:0] sc2mac_dat_a_src_data19;
output   [7:0] sc2mac_dat_a_src_data20;
output   [7:0] sc2mac_dat_a_src_data21;
output   [7:0] sc2mac_dat_a_src_data22;
output   [7:0] sc2mac_dat_a_src_data23;
output   [7:0] sc2mac_dat_a_src_data24;
output   [7:0] sc2mac_dat_a_src_data25;
output   [7:0] sc2mac_dat_a_src_data26;
output   [7:0] sc2mac_dat_a_src_data27;
output   [7:0] sc2mac_dat_a_src_data28;
output   [7:0] sc2mac_dat_a_src_data29;
output   [7:0] sc2mac_dat_a_src_data30;
output   [7:0] sc2mac_dat_a_src_data31;
output   [7:0] sc2mac_dat_a_src_data32;
output   [7:0] sc2mac_dat_a_src_data33;
output   [7:0] sc2mac_dat_a_src_data34;
output   [7:0] sc2mac_dat_a_src_data35;
output   [7:0] sc2mac_dat_a_src_data36;
output   [7:0] sc2mac_dat_a_src_data37;
output   [7:0] sc2mac_dat_a_src_data38;
output   [7:0] sc2mac_dat_a_src_data39;
output   [7:0] sc2mac_dat_a_src_data40;
output   [7:0] sc2mac_dat_a_src_data41;
output   [7:0] sc2mac_dat_a_src_data42;
output   [7:0] sc2mac_dat_a_src_data43;
output   [7:0] sc2mac_dat_a_src_data44;
output   [7:0] sc2mac_dat_a_src_data45;
output   [7:0] sc2mac_dat_a_src_data46;
output   [7:0] sc2mac_dat_a_src_data47;
output   [7:0] sc2mac_dat_a_src_data48;
output   [7:0] sc2mac_dat_a_src_data49;
output   [7:0] sc2mac_dat_a_src_data50;
output   [7:0] sc2mac_dat_a_src_data51;
output   [7:0] sc2mac_dat_a_src_data52;
output   [7:0] sc2mac_dat_a_src_data53;
output   [7:0] sc2mac_dat_a_src_data54;
output   [7:0] sc2mac_dat_a_src_data55;
output   [7:0] sc2mac_dat_a_src_data56;
output   [7:0] sc2mac_dat_a_src_data57;
output   [7:0] sc2mac_dat_a_src_data58;
output   [7:0] sc2mac_dat_a_src_data59;
output   [7:0] sc2mac_dat_a_src_data60;
output   [7:0] sc2mac_dat_a_src_data61;
output   [7:0] sc2mac_dat_a_src_data62;
output   [7:0] sc2mac_dat_a_src_data63;
output   [7:0] sc2mac_dat_a_src_data64;
output   [7:0] sc2mac_dat_a_src_data65;
output   [7:0] sc2mac_dat_a_src_data66;
output   [7:0] sc2mac_dat_a_src_data67;
output   [7:0] sc2mac_dat_a_src_data68;
output   [7:0] sc2mac_dat_a_src_data69;
output   [7:0] sc2mac_dat_a_src_data70;
output   [7:0] sc2mac_dat_a_src_data71;
output   [7:0] sc2mac_dat_a_src_data72;
output   [7:0] sc2mac_dat_a_src_data73;
output   [7:0] sc2mac_dat_a_src_data74;
output   [7:0] sc2mac_dat_a_src_data75;
output   [7:0] sc2mac_dat_a_src_data76;
output   [7:0] sc2mac_dat_a_src_data77;
output   [7:0] sc2mac_dat_a_src_data78;
output   [7:0] sc2mac_dat_a_src_data79;
output   [7:0] sc2mac_dat_a_src_data80;
output   [7:0] sc2mac_dat_a_src_data81;
output   [7:0] sc2mac_dat_a_src_data82;
output   [7:0] sc2mac_dat_a_src_data83;
output   [7:0] sc2mac_dat_a_src_data84;
output   [7:0] sc2mac_dat_a_src_data85;
output   [7:0] sc2mac_dat_a_src_data86;
output   [7:0] sc2mac_dat_a_src_data87;
output   [7:0] sc2mac_dat_a_src_data88;
output   [7:0] sc2mac_dat_a_src_data89;
output   [7:0] sc2mac_dat_a_src_data90;
output   [7:0] sc2mac_dat_a_src_data91;
output   [7:0] sc2mac_dat_a_src_data92;
output   [7:0] sc2mac_dat_a_src_data93;
output   [7:0] sc2mac_dat_a_src_data94;
output   [7:0] sc2mac_dat_a_src_data95;
output   [7:0] sc2mac_dat_a_src_data96;
output   [7:0] sc2mac_dat_a_src_data97;
output   [7:0] sc2mac_dat_a_src_data98;
output   [7:0] sc2mac_dat_a_src_data99;
output   [7:0] sc2mac_dat_a_src_data100;
output   [7:0] sc2mac_dat_a_src_data101;
output   [7:0] sc2mac_dat_a_src_data102;
output   [7:0] sc2mac_dat_a_src_data103;
output   [7:0] sc2mac_dat_a_src_data104;
output   [7:0] sc2mac_dat_a_src_data105;
output   [7:0] sc2mac_dat_a_src_data106;
output   [7:0] sc2mac_dat_a_src_data107;
output   [7:0] sc2mac_dat_a_src_data108;
output   [7:0] sc2mac_dat_a_src_data109;
output   [7:0] sc2mac_dat_a_src_data110;
output   [7:0] sc2mac_dat_a_src_data111;
output   [7:0] sc2mac_dat_a_src_data112;
output   [7:0] sc2mac_dat_a_src_data113;
output   [7:0] sc2mac_dat_a_src_data114;
output   [7:0] sc2mac_dat_a_src_data115;
output   [7:0] sc2mac_dat_a_src_data116;
output   [7:0] sc2mac_dat_a_src_data117;
output   [7:0] sc2mac_dat_a_src_data118;
output   [7:0] sc2mac_dat_a_src_data119;
output   [7:0] sc2mac_dat_a_src_data120;
output   [7:0] sc2mac_dat_a_src_data121;
output   [7:0] sc2mac_dat_a_src_data122;
output   [7:0] sc2mac_dat_a_src_data123;
output   [7:0] sc2mac_dat_a_src_data124;
output   [7:0] sc2mac_dat_a_src_data125;
output   [7:0] sc2mac_dat_a_src_data126;
output   [7:0] sc2mac_dat_a_src_data127;
output   [8:0] sc2mac_dat_a_src_pd;

output         sc2mac_dat_b_dst_pvld;     /* data valid */
output [127:0] sc2mac_dat_b_dst_mask;
output   [7:0] sc2mac_dat_b_dst_data0;
output   [7:0] sc2mac_dat_b_dst_data1;
output   [7:0] sc2mac_dat_b_dst_data2;
output   [7:0] sc2mac_dat_b_dst_data3;
output   [7:0] sc2mac_dat_b_dst_data4;
output   [7:0] sc2mac_dat_b_dst_data5;
output   [7:0] sc2mac_dat_b_dst_data6;
output   [7:0] sc2mac_dat_b_dst_data7;
output   [7:0] sc2mac_dat_b_dst_data8;
output   [7:0] sc2mac_dat_b_dst_data9;
output   [7:0] sc2mac_dat_b_dst_data10;
output   [7:0] sc2mac_dat_b_dst_data11;
output   [7:0] sc2mac_dat_b_dst_data12;
output   [7:0] sc2mac_dat_b_dst_data13;
output   [7:0] sc2mac_dat_b_dst_data14;
output   [7:0] sc2mac_dat_b_dst_data15;
output   [7:0] sc2mac_dat_b_dst_data16;
output   [7:0] sc2mac_dat_b_dst_data17;
output   [7:0] sc2mac_dat_b_dst_data18;
output   [7:0] sc2mac_dat_b_dst_data19;
output   [7:0] sc2mac_dat_b_dst_data20;
output   [7:0] sc2mac_dat_b_dst_data21;
output   [7:0] sc2mac_dat_b_dst_data22;
output   [7:0] sc2mac_dat_b_dst_data23;
output   [7:0] sc2mac_dat_b_dst_data24;
output   [7:0] sc2mac_dat_b_dst_data25;
output   [7:0] sc2mac_dat_b_dst_data26;
output   [7:0] sc2mac_dat_b_dst_data27;
output   [7:0] sc2mac_dat_b_dst_data28;
output   [7:0] sc2mac_dat_b_dst_data29;
output   [7:0] sc2mac_dat_b_dst_data30;
output   [7:0] sc2mac_dat_b_dst_data31;
output   [7:0] sc2mac_dat_b_dst_data32;
output   [7:0] sc2mac_dat_b_dst_data33;
output   [7:0] sc2mac_dat_b_dst_data34;
output   [7:0] sc2mac_dat_b_dst_data35;
output   [7:0] sc2mac_dat_b_dst_data36;
output   [7:0] sc2mac_dat_b_dst_data37;
output   [7:0] sc2mac_dat_b_dst_data38;
output   [7:0] sc2mac_dat_b_dst_data39;
output   [7:0] sc2mac_dat_b_dst_data40;
output   [7:0] sc2mac_dat_b_dst_data41;
output   [7:0] sc2mac_dat_b_dst_data42;
output   [7:0] sc2mac_dat_b_dst_data43;
output   [7:0] sc2mac_dat_b_dst_data44;
output   [7:0] sc2mac_dat_b_dst_data45;
output   [7:0] sc2mac_dat_b_dst_data46;
output   [7:0] sc2mac_dat_b_dst_data47;
output   [7:0] sc2mac_dat_b_dst_data48;
output   [7:0] sc2mac_dat_b_dst_data49;
output   [7:0] sc2mac_dat_b_dst_data50;
output   [7:0] sc2mac_dat_b_dst_data51;
output   [7:0] sc2mac_dat_b_dst_data52;
output   [7:0] sc2mac_dat_b_dst_data53;
output   [7:0] sc2mac_dat_b_dst_data54;
output   [7:0] sc2mac_dat_b_dst_data55;
output   [7:0] sc2mac_dat_b_dst_data56;
output   [7:0] sc2mac_dat_b_dst_data57;
output   [7:0] sc2mac_dat_b_dst_data58;
output   [7:0] sc2mac_dat_b_dst_data59;
output   [7:0] sc2mac_dat_b_dst_data60;
output   [7:0] sc2mac_dat_b_dst_data61;
output   [7:0] sc2mac_dat_b_dst_data62;
output   [7:0] sc2mac_dat_b_dst_data63;
output   [7:0] sc2mac_dat_b_dst_data64;
output   [7:0] sc2mac_dat_b_dst_data65;
output   [7:0] sc2mac_dat_b_dst_data66;
output   [7:0] sc2mac_dat_b_dst_data67;
output   [7:0] sc2mac_dat_b_dst_data68;
output   [7:0] sc2mac_dat_b_dst_data69;
output   [7:0] sc2mac_dat_b_dst_data70;
output   [7:0] sc2mac_dat_b_dst_data71;
output   [7:0] sc2mac_dat_b_dst_data72;
output   [7:0] sc2mac_dat_b_dst_data73;
output   [7:0] sc2mac_dat_b_dst_data74;
output   [7:0] sc2mac_dat_b_dst_data75;
output   [7:0] sc2mac_dat_b_dst_data76;
output   [7:0] sc2mac_dat_b_dst_data77;
output   [7:0] sc2mac_dat_b_dst_data78;
output   [7:0] sc2mac_dat_b_dst_data79;
output   [7:0] sc2mac_dat_b_dst_data80;
output   [7:0] sc2mac_dat_b_dst_data81;
output   [7:0] sc2mac_dat_b_dst_data82;
output   [7:0] sc2mac_dat_b_dst_data83;
output   [7:0] sc2mac_dat_b_dst_data84;
output   [7:0] sc2mac_dat_b_dst_data85;
output   [7:0] sc2mac_dat_b_dst_data86;
output   [7:0] sc2mac_dat_b_dst_data87;
output   [7:0] sc2mac_dat_b_dst_data88;
output   [7:0] sc2mac_dat_b_dst_data89;
output   [7:0] sc2mac_dat_b_dst_data90;
output   [7:0] sc2mac_dat_b_dst_data91;
output   [7:0] sc2mac_dat_b_dst_data92;
output   [7:0] sc2mac_dat_b_dst_data93;
output   [7:0] sc2mac_dat_b_dst_data94;
output   [7:0] sc2mac_dat_b_dst_data95;
output   [7:0] sc2mac_dat_b_dst_data96;
output   [7:0] sc2mac_dat_b_dst_data97;
output   [7:0] sc2mac_dat_b_dst_data98;
output   [7:0] sc2mac_dat_b_dst_data99;
output   [7:0] sc2mac_dat_b_dst_data100;
output   [7:0] sc2mac_dat_b_dst_data101;
output   [7:0] sc2mac_dat_b_dst_data102;
output   [7:0] sc2mac_dat_b_dst_data103;
output   [7:0] sc2mac_dat_b_dst_data104;
output   [7:0] sc2mac_dat_b_dst_data105;
output   [7:0] sc2mac_dat_b_dst_data106;
output   [7:0] sc2mac_dat_b_dst_data107;
output   [7:0] sc2mac_dat_b_dst_data108;
output   [7:0] sc2mac_dat_b_dst_data109;
output   [7:0] sc2mac_dat_b_dst_data110;
output   [7:0] sc2mac_dat_b_dst_data111;
output   [7:0] sc2mac_dat_b_dst_data112;
output   [7:0] sc2mac_dat_b_dst_data113;
output   [7:0] sc2mac_dat_b_dst_data114;
output   [7:0] sc2mac_dat_b_dst_data115;
output   [7:0] sc2mac_dat_b_dst_data116;
output   [7:0] sc2mac_dat_b_dst_data117;
output   [7:0] sc2mac_dat_b_dst_data118;
output   [7:0] sc2mac_dat_b_dst_data119;
output   [7:0] sc2mac_dat_b_dst_data120;
output   [7:0] sc2mac_dat_b_dst_data121;
output   [7:0] sc2mac_dat_b_dst_data122;
output   [7:0] sc2mac_dat_b_dst_data123;
output   [7:0] sc2mac_dat_b_dst_data124;
output   [7:0] sc2mac_dat_b_dst_data125;
output   [7:0] sc2mac_dat_b_dst_data126;
output   [7:0] sc2mac_dat_b_dst_data127;
output   [8:0] sc2mac_dat_b_dst_pd;

output         sc2mac_wt_a_src_pvld;     /* data valid */
output [127:0] sc2mac_wt_a_src_mask;
output   [7:0] sc2mac_wt_a_src_data0;
output   [7:0] sc2mac_wt_a_src_data1;
output   [7:0] sc2mac_wt_a_src_data2;
output   [7:0] sc2mac_wt_a_src_data3;
output   [7:0] sc2mac_wt_a_src_data4;
output   [7:0] sc2mac_wt_a_src_data5;
output   [7:0] sc2mac_wt_a_src_data6;
output   [7:0] sc2mac_wt_a_src_data7;
output   [7:0] sc2mac_wt_a_src_data8;
output   [7:0] sc2mac_wt_a_src_data9;
output   [7:0] sc2mac_wt_a_src_data10;
output   [7:0] sc2mac_wt_a_src_data11;
output   [7:0] sc2mac_wt_a_src_data12;
output   [7:0] sc2mac_wt_a_src_data13;
output   [7:0] sc2mac_wt_a_src_data14;
output   [7:0] sc2mac_wt_a_src_data15;
output   [7:0] sc2mac_wt_a_src_data16;
output   [7:0] sc2mac_wt_a_src_data17;
output   [7:0] sc2mac_wt_a_src_data18;
output   [7:0] sc2mac_wt_a_src_data19;
output   [7:0] sc2mac_wt_a_src_data20;
output   [7:0] sc2mac_wt_a_src_data21;
output   [7:0] sc2mac_wt_a_src_data22;
output   [7:0] sc2mac_wt_a_src_data23;
output   [7:0] sc2mac_wt_a_src_data24;
output   [7:0] sc2mac_wt_a_src_data25;
output   [7:0] sc2mac_wt_a_src_data26;
output   [7:0] sc2mac_wt_a_src_data27;
output   [7:0] sc2mac_wt_a_src_data28;
output   [7:0] sc2mac_wt_a_src_data29;
output   [7:0] sc2mac_wt_a_src_data30;
output   [7:0] sc2mac_wt_a_src_data31;
output   [7:0] sc2mac_wt_a_src_data32;
output   [7:0] sc2mac_wt_a_src_data33;
output   [7:0] sc2mac_wt_a_src_data34;
output   [7:0] sc2mac_wt_a_src_data35;
output   [7:0] sc2mac_wt_a_src_data36;
output   [7:0] sc2mac_wt_a_src_data37;
output   [7:0] sc2mac_wt_a_src_data38;
output   [7:0] sc2mac_wt_a_src_data39;
output   [7:0] sc2mac_wt_a_src_data40;
output   [7:0] sc2mac_wt_a_src_data41;
output   [7:0] sc2mac_wt_a_src_data42;
output   [7:0] sc2mac_wt_a_src_data43;
output   [7:0] sc2mac_wt_a_src_data44;
output   [7:0] sc2mac_wt_a_src_data45;
output   [7:0] sc2mac_wt_a_src_data46;
output   [7:0] sc2mac_wt_a_src_data47;
output   [7:0] sc2mac_wt_a_src_data48;
output   [7:0] sc2mac_wt_a_src_data49;
output   [7:0] sc2mac_wt_a_src_data50;
output   [7:0] sc2mac_wt_a_src_data51;
output   [7:0] sc2mac_wt_a_src_data52;
output   [7:0] sc2mac_wt_a_src_data53;
output   [7:0] sc2mac_wt_a_src_data54;
output   [7:0] sc2mac_wt_a_src_data55;
output   [7:0] sc2mac_wt_a_src_data56;
output   [7:0] sc2mac_wt_a_src_data57;
output   [7:0] sc2mac_wt_a_src_data58;
output   [7:0] sc2mac_wt_a_src_data59;
output   [7:0] sc2mac_wt_a_src_data60;
output   [7:0] sc2mac_wt_a_src_data61;
output   [7:0] sc2mac_wt_a_src_data62;
output   [7:0] sc2mac_wt_a_src_data63;
output   [7:0] sc2mac_wt_a_src_data64;
output   [7:0] sc2mac_wt_a_src_data65;
output   [7:0] sc2mac_wt_a_src_data66;
output   [7:0] sc2mac_wt_a_src_data67;
output   [7:0] sc2mac_wt_a_src_data68;
output   [7:0] sc2mac_wt_a_src_data69;
output   [7:0] sc2mac_wt_a_src_data70;
output   [7:0] sc2mac_wt_a_src_data71;
output   [7:0] sc2mac_wt_a_src_data72;
output   [7:0] sc2mac_wt_a_src_data73;
output   [7:0] sc2mac_wt_a_src_data74;
output   [7:0] sc2mac_wt_a_src_data75;
output   [7:0] sc2mac_wt_a_src_data76;
output   [7:0] sc2mac_wt_a_src_data77;
output   [7:0] sc2mac_wt_a_src_data78;
output   [7:0] sc2mac_wt_a_src_data79;
output   [7:0] sc2mac_wt_a_src_data80;
output   [7:0] sc2mac_wt_a_src_data81;
output   [7:0] sc2mac_wt_a_src_data82;
output   [7:0] sc2mac_wt_a_src_data83;
output   [7:0] sc2mac_wt_a_src_data84;
output   [7:0] sc2mac_wt_a_src_data85;
output   [7:0] sc2mac_wt_a_src_data86;
output   [7:0] sc2mac_wt_a_src_data87;
output   [7:0] sc2mac_wt_a_src_data88;
output   [7:0] sc2mac_wt_a_src_data89;
output   [7:0] sc2mac_wt_a_src_data90;
output   [7:0] sc2mac_wt_a_src_data91;
output   [7:0] sc2mac_wt_a_src_data92;
output   [7:0] sc2mac_wt_a_src_data93;
output   [7:0] sc2mac_wt_a_src_data94;
output   [7:0] sc2mac_wt_a_src_data95;
output   [7:0] sc2mac_wt_a_src_data96;
output   [7:0] sc2mac_wt_a_src_data97;
output   [7:0] sc2mac_wt_a_src_data98;
output   [7:0] sc2mac_wt_a_src_data99;
output   [7:0] sc2mac_wt_a_src_data100;
output   [7:0] sc2mac_wt_a_src_data101;
output   [7:0] sc2mac_wt_a_src_data102;
output   [7:0] sc2mac_wt_a_src_data103;
output   [7:0] sc2mac_wt_a_src_data104;
output   [7:0] sc2mac_wt_a_src_data105;
output   [7:0] sc2mac_wt_a_src_data106;
output   [7:0] sc2mac_wt_a_src_data107;
output   [7:0] sc2mac_wt_a_src_data108;
output   [7:0] sc2mac_wt_a_src_data109;
output   [7:0] sc2mac_wt_a_src_data110;
output   [7:0] sc2mac_wt_a_src_data111;
output   [7:0] sc2mac_wt_a_src_data112;
output   [7:0] sc2mac_wt_a_src_data113;
output   [7:0] sc2mac_wt_a_src_data114;
output   [7:0] sc2mac_wt_a_src_data115;
output   [7:0] sc2mac_wt_a_src_data116;
output   [7:0] sc2mac_wt_a_src_data117;
output   [7:0] sc2mac_wt_a_src_data118;
output   [7:0] sc2mac_wt_a_src_data119;
output   [7:0] sc2mac_wt_a_src_data120;
output   [7:0] sc2mac_wt_a_src_data121;
output   [7:0] sc2mac_wt_a_src_data122;
output   [7:0] sc2mac_wt_a_src_data123;
output   [7:0] sc2mac_wt_a_src_data124;
output   [7:0] sc2mac_wt_a_src_data125;
output   [7:0] sc2mac_wt_a_src_data126;
output   [7:0] sc2mac_wt_a_src_data127;
output   [7:0] sc2mac_wt_a_src_sel;

output         sc2mac_wt_b_dst_pvld;     /* data valid */
output [127:0] sc2mac_wt_b_dst_mask;
output   [7:0] sc2mac_wt_b_dst_data0;
output   [7:0] sc2mac_wt_b_dst_data1;
output   [7:0] sc2mac_wt_b_dst_data2;
output   [7:0] sc2mac_wt_b_dst_data3;
output   [7:0] sc2mac_wt_b_dst_data4;
output   [7:0] sc2mac_wt_b_dst_data5;
output   [7:0] sc2mac_wt_b_dst_data6;
output   [7:0] sc2mac_wt_b_dst_data7;
output   [7:0] sc2mac_wt_b_dst_data8;
output   [7:0] sc2mac_wt_b_dst_data9;
output   [7:0] sc2mac_wt_b_dst_data10;
output   [7:0] sc2mac_wt_b_dst_data11;
output   [7:0] sc2mac_wt_b_dst_data12;
output   [7:0] sc2mac_wt_b_dst_data13;
output   [7:0] sc2mac_wt_b_dst_data14;
output   [7:0] sc2mac_wt_b_dst_data15;
output   [7:0] sc2mac_wt_b_dst_data16;
output   [7:0] sc2mac_wt_b_dst_data17;
output   [7:0] sc2mac_wt_b_dst_data18;
output   [7:0] sc2mac_wt_b_dst_data19;
output   [7:0] sc2mac_wt_b_dst_data20;
output   [7:0] sc2mac_wt_b_dst_data21;
output   [7:0] sc2mac_wt_b_dst_data22;
output   [7:0] sc2mac_wt_b_dst_data23;
output   [7:0] sc2mac_wt_b_dst_data24;
output   [7:0] sc2mac_wt_b_dst_data25;
output   [7:0] sc2mac_wt_b_dst_data26;
output   [7:0] sc2mac_wt_b_dst_data27;
output   [7:0] sc2mac_wt_b_dst_data28;
output   [7:0] sc2mac_wt_b_dst_data29;
output   [7:0] sc2mac_wt_b_dst_data30;
output   [7:0] sc2mac_wt_b_dst_data31;
output   [7:0] sc2mac_wt_b_dst_data32;
output   [7:0] sc2mac_wt_b_dst_data33;
output   [7:0] sc2mac_wt_b_dst_data34;
output   [7:0] sc2mac_wt_b_dst_data35;
output   [7:0] sc2mac_wt_b_dst_data36;
output   [7:0] sc2mac_wt_b_dst_data37;
output   [7:0] sc2mac_wt_b_dst_data38;
output   [7:0] sc2mac_wt_b_dst_data39;
output   [7:0] sc2mac_wt_b_dst_data40;
output   [7:0] sc2mac_wt_b_dst_data41;
output   [7:0] sc2mac_wt_b_dst_data42;
output   [7:0] sc2mac_wt_b_dst_data43;
output   [7:0] sc2mac_wt_b_dst_data44;
output   [7:0] sc2mac_wt_b_dst_data45;
output   [7:0] sc2mac_wt_b_dst_data46;
output   [7:0] sc2mac_wt_b_dst_data47;
output   [7:0] sc2mac_wt_b_dst_data48;
output   [7:0] sc2mac_wt_b_dst_data49;
output   [7:0] sc2mac_wt_b_dst_data50;
output   [7:0] sc2mac_wt_b_dst_data51;
output   [7:0] sc2mac_wt_b_dst_data52;
output   [7:0] sc2mac_wt_b_dst_data53;
output   [7:0] sc2mac_wt_b_dst_data54;
output   [7:0] sc2mac_wt_b_dst_data55;
output   [7:0] sc2mac_wt_b_dst_data56;
output   [7:0] sc2mac_wt_b_dst_data57;
output   [7:0] sc2mac_wt_b_dst_data58;
output   [7:0] sc2mac_wt_b_dst_data59;
output   [7:0] sc2mac_wt_b_dst_data60;
output   [7:0] sc2mac_wt_b_dst_data61;
output   [7:0] sc2mac_wt_b_dst_data62;
output   [7:0] sc2mac_wt_b_dst_data63;
output   [7:0] sc2mac_wt_b_dst_data64;
output   [7:0] sc2mac_wt_b_dst_data65;
output   [7:0] sc2mac_wt_b_dst_data66;
output   [7:0] sc2mac_wt_b_dst_data67;
output   [7:0] sc2mac_wt_b_dst_data68;
output   [7:0] sc2mac_wt_b_dst_data69;
output   [7:0] sc2mac_wt_b_dst_data70;
output   [7:0] sc2mac_wt_b_dst_data71;
output   [7:0] sc2mac_wt_b_dst_data72;
output   [7:0] sc2mac_wt_b_dst_data73;
output   [7:0] sc2mac_wt_b_dst_data74;
output   [7:0] sc2mac_wt_b_dst_data75;
output   [7:0] sc2mac_wt_b_dst_data76;
output   [7:0] sc2mac_wt_b_dst_data77;
output   [7:0] sc2mac_wt_b_dst_data78;
output   [7:0] sc2mac_wt_b_dst_data79;
output   [7:0] sc2mac_wt_b_dst_data80;
output   [7:0] sc2mac_wt_b_dst_data81;
output   [7:0] sc2mac_wt_b_dst_data82;
output   [7:0] sc2mac_wt_b_dst_data83;
output   [7:0] sc2mac_wt_b_dst_data84;
output   [7:0] sc2mac_wt_b_dst_data85;
output   [7:0] sc2mac_wt_b_dst_data86;
output   [7:0] sc2mac_wt_b_dst_data87;
output   [7:0] sc2mac_wt_b_dst_data88;
output   [7:0] sc2mac_wt_b_dst_data89;
output   [7:0] sc2mac_wt_b_dst_data90;
output   [7:0] sc2mac_wt_b_dst_data91;
output   [7:0] sc2mac_wt_b_dst_data92;
output   [7:0] sc2mac_wt_b_dst_data93;
output   [7:0] sc2mac_wt_b_dst_data94;
output   [7:0] sc2mac_wt_b_dst_data95;
output   [7:0] sc2mac_wt_b_dst_data96;
output   [7:0] sc2mac_wt_b_dst_data97;
output   [7:0] sc2mac_wt_b_dst_data98;
output   [7:0] sc2mac_wt_b_dst_data99;
output   [7:0] sc2mac_wt_b_dst_data100;
output   [7:0] sc2mac_wt_b_dst_data101;
output   [7:0] sc2mac_wt_b_dst_data102;
output   [7:0] sc2mac_wt_b_dst_data103;
output   [7:0] sc2mac_wt_b_dst_data104;
output   [7:0] sc2mac_wt_b_dst_data105;
output   [7:0] sc2mac_wt_b_dst_data106;
output   [7:0] sc2mac_wt_b_dst_data107;
output   [7:0] sc2mac_wt_b_dst_data108;
output   [7:0] sc2mac_wt_b_dst_data109;
output   [7:0] sc2mac_wt_b_dst_data110;
output   [7:0] sc2mac_wt_b_dst_data111;
output   [7:0] sc2mac_wt_b_dst_data112;
output   [7:0] sc2mac_wt_b_dst_data113;
output   [7:0] sc2mac_wt_b_dst_data114;
output   [7:0] sc2mac_wt_b_dst_data115;
output   [7:0] sc2mac_wt_b_dst_data116;
output   [7:0] sc2mac_wt_b_dst_data117;
output   [7:0] sc2mac_wt_b_dst_data118;
output   [7:0] sc2mac_wt_b_dst_data119;
output   [7:0] sc2mac_wt_b_dst_data120;
output   [7:0] sc2mac_wt_b_dst_data121;
output   [7:0] sc2mac_wt_b_dst_data122;
output   [7:0] sc2mac_wt_b_dst_data123;
output   [7:0] sc2mac_wt_b_dst_data124;
output   [7:0] sc2mac_wt_b_dst_data125;
output   [7:0] sc2mac_wt_b_dst_data126;
output   [7:0] sc2mac_wt_b_dst_data127;
output   [7:0] sc2mac_wt_b_dst_sel;

//input  Jtag_reg_clk;       
//input  Jtag_reg_reset_;    
//input  la_r_clk;           
//input  larstn;             
input  nvdla_core_clk;     
input  dla_reset_rstn;     

input          nvdla_clk_ovr_on;

wire    [11:0] cdma2buf_dat_wr_addr;
wire  [1023:0] cdma2buf_dat_wr_data;
wire           cdma2buf_dat_wr_en;
wire     [1:0] cdma2buf_dat_wr_hsel;
wire    [11:0] cdma2buf_wt_wr_addr;
wire   [511:0] cdma2buf_wt_wr_data;
wire           cdma2buf_wt_wr_en;
wire           cdma2buf_wt_wr_hsel;
wire    [11:0] cdma2sc_dat_entries;
wire           cdma2sc_dat_pending_ack;
wire    [11:0] cdma2sc_dat_slices;
wire           cdma2sc_dat_updt;
wire     [8:0] cdma2sc_wmb_entries;
wire    [11:0] cdma2sc_wt_entries;
wire    [13:0] cdma2sc_wt_kernels;
wire           cdma2sc_wt_pending_ack;
wire           cdma2sc_wt_updt;
wire           cdma_dla_clk_ovr_on_sync;
wire           cdma_global_clk_ovr_on_sync;
wire           csc_dla_clk_ovr_on_sync;
wire           csc_global_clk_ovr_on_sync;
wire           nvdla_core_rstn;
wire    [11:0] sc2buf_dat_rd_addr;
wire  [1023:0] sc2buf_dat_rd_data;
wire           sc2buf_dat_rd_en;
wire           sc2buf_dat_rd_valid;
wire     [7:0] sc2buf_wmb_rd_addr;
wire  [1023:0] sc2buf_wmb_rd_data;
wire           sc2buf_wmb_rd_en;
wire           sc2buf_wmb_rd_valid;
wire    [11:0] sc2buf_wt_rd_addr;
wire  [1023:0] sc2buf_wt_rd_data;
wire           sc2buf_wt_rd_en;
wire           sc2buf_wt_rd_valid;
wire    [11:0] sc2cdma_dat_entries;
wire           sc2cdma_dat_pending_req;
wire    [11:0] sc2cdma_dat_slices;
wire           sc2cdma_dat_updt;
wire     [8:0] sc2cdma_wmb_entries;
wire    [11:0] sc2cdma_wt_entries;
wire    [13:0] sc2cdma_wt_kernels;
wire           sc2cdma_wt_pending_req;
wire           sc2cdma_wt_updt;
wire     [7:0] sc2mac_dat_b_src_data0;
wire     [7:0] sc2mac_dat_b_src_data1;
wire     [7:0] sc2mac_dat_b_src_data10;
wire     [7:0] sc2mac_dat_b_src_data100;
wire     [7:0] sc2mac_dat_b_src_data101;
wire     [7:0] sc2mac_dat_b_src_data102;
wire     [7:0] sc2mac_dat_b_src_data103;
wire     [7:0] sc2mac_dat_b_src_data104;
wire     [7:0] sc2mac_dat_b_src_data105;
wire     [7:0] sc2mac_dat_b_src_data106;
wire     [7:0] sc2mac_dat_b_src_data107;
wire     [7:0] sc2mac_dat_b_src_data108;
wire     [7:0] sc2mac_dat_b_src_data109;
wire     [7:0] sc2mac_dat_b_src_data11;
wire     [7:0] sc2mac_dat_b_src_data110;
wire     [7:0] sc2mac_dat_b_src_data111;
wire     [7:0] sc2mac_dat_b_src_data112;
wire     [7:0] sc2mac_dat_b_src_data113;
wire     [7:0] sc2mac_dat_b_src_data114;
wire     [7:0] sc2mac_dat_b_src_data115;
wire     [7:0] sc2mac_dat_b_src_data116;
wire     [7:0] sc2mac_dat_b_src_data117;
wire     [7:0] sc2mac_dat_b_src_data118;
wire     [7:0] sc2mac_dat_b_src_data119;
wire     [7:0] sc2mac_dat_b_src_data12;
wire     [7:0] sc2mac_dat_b_src_data120;
wire     [7:0] sc2mac_dat_b_src_data121;
wire     [7:0] sc2mac_dat_b_src_data122;
wire     [7:0] sc2mac_dat_b_src_data123;
wire     [7:0] sc2mac_dat_b_src_data124;
wire     [7:0] sc2mac_dat_b_src_data125;
wire     [7:0] sc2mac_dat_b_src_data126;
wire     [7:0] sc2mac_dat_b_src_data127;
wire     [7:0] sc2mac_dat_b_src_data13;
wire     [7:0] sc2mac_dat_b_src_data14;
wire     [7:0] sc2mac_dat_b_src_data15;
wire     [7:0] sc2mac_dat_b_src_data16;
wire     [7:0] sc2mac_dat_b_src_data17;
wire     [7:0] sc2mac_dat_b_src_data18;
wire     [7:0] sc2mac_dat_b_src_data19;
wire     [7:0] sc2mac_dat_b_src_data2;
wire     [7:0] sc2mac_dat_b_src_data20;
wire     [7:0] sc2mac_dat_b_src_data21;
wire     [7:0] sc2mac_dat_b_src_data22;
wire     [7:0] sc2mac_dat_b_src_data23;
wire     [7:0] sc2mac_dat_b_src_data24;
wire     [7:0] sc2mac_dat_b_src_data25;
wire     [7:0] sc2mac_dat_b_src_data26;
wire     [7:0] sc2mac_dat_b_src_data27;
wire     [7:0] sc2mac_dat_b_src_data28;
wire     [7:0] sc2mac_dat_b_src_data29;
wire     [7:0] sc2mac_dat_b_src_data3;
wire     [7:0] sc2mac_dat_b_src_data30;
wire     [7:0] sc2mac_dat_b_src_data31;
wire     [7:0] sc2mac_dat_b_src_data32;
wire     [7:0] sc2mac_dat_b_src_data33;
wire     [7:0] sc2mac_dat_b_src_data34;
wire     [7:0] sc2mac_dat_b_src_data35;
wire     [7:0] sc2mac_dat_b_src_data36;
wire     [7:0] sc2mac_dat_b_src_data37;
wire     [7:0] sc2mac_dat_b_src_data38;
wire     [7:0] sc2mac_dat_b_src_data39;
wire     [7:0] sc2mac_dat_b_src_data4;
wire     [7:0] sc2mac_dat_b_src_data40;
wire     [7:0] sc2mac_dat_b_src_data41;
wire     [7:0] sc2mac_dat_b_src_data42;
wire     [7:0] sc2mac_dat_b_src_data43;
wire     [7:0] sc2mac_dat_b_src_data44;
wire     [7:0] sc2mac_dat_b_src_data45;
wire     [7:0] sc2mac_dat_b_src_data46;
wire     [7:0] sc2mac_dat_b_src_data47;
wire     [7:0] sc2mac_dat_b_src_data48;
wire     [7:0] sc2mac_dat_b_src_data49;
wire     [7:0] sc2mac_dat_b_src_data5;
wire     [7:0] sc2mac_dat_b_src_data50;
wire     [7:0] sc2mac_dat_b_src_data51;
wire     [7:0] sc2mac_dat_b_src_data52;
wire     [7:0] sc2mac_dat_b_src_data53;
wire     [7:0] sc2mac_dat_b_src_data54;
wire     [7:0] sc2mac_dat_b_src_data55;
wire     [7:0] sc2mac_dat_b_src_data56;
wire     [7:0] sc2mac_dat_b_src_data57;
wire     [7:0] sc2mac_dat_b_src_data58;
wire     [7:0] sc2mac_dat_b_src_data59;
wire     [7:0] sc2mac_dat_b_src_data6;
wire     [7:0] sc2mac_dat_b_src_data60;
wire     [7:0] sc2mac_dat_b_src_data61;
wire     [7:0] sc2mac_dat_b_src_data62;
wire     [7:0] sc2mac_dat_b_src_data63;
wire     [7:0] sc2mac_dat_b_src_data64;
wire     [7:0] sc2mac_dat_b_src_data65;
wire     [7:0] sc2mac_dat_b_src_data66;
wire     [7:0] sc2mac_dat_b_src_data67;
wire     [7:0] sc2mac_dat_b_src_data68;
wire     [7:0] sc2mac_dat_b_src_data69;
wire     [7:0] sc2mac_dat_b_src_data7;
wire     [7:0] sc2mac_dat_b_src_data70;
wire     [7:0] sc2mac_dat_b_src_data71;
wire     [7:0] sc2mac_dat_b_src_data72;
wire     [7:0] sc2mac_dat_b_src_data73;
wire     [7:0] sc2mac_dat_b_src_data74;
wire     [7:0] sc2mac_dat_b_src_data75;
wire     [7:0] sc2mac_dat_b_src_data76;
wire     [7:0] sc2mac_dat_b_src_data77;
wire     [7:0] sc2mac_dat_b_src_data78;
wire     [7:0] sc2mac_dat_b_src_data79;
wire     [7:0] sc2mac_dat_b_src_data8;
wire     [7:0] sc2mac_dat_b_src_data80;
wire     [7:0] sc2mac_dat_b_src_data81;
wire     [7:0] sc2mac_dat_b_src_data82;
wire     [7:0] sc2mac_dat_b_src_data83;
wire     [7:0] sc2mac_dat_b_src_data84;
wire     [7:0] sc2mac_dat_b_src_data85;
wire     [7:0] sc2mac_dat_b_src_data86;
wire     [7:0] sc2mac_dat_b_src_data87;
wire     [7:0] sc2mac_dat_b_src_data88;
wire     [7:0] sc2mac_dat_b_src_data89;
wire     [7:0] sc2mac_dat_b_src_data9;
wire     [7:0] sc2mac_dat_b_src_data90;
wire     [7:0] sc2mac_dat_b_src_data91;
wire     [7:0] sc2mac_dat_b_src_data92;
wire     [7:0] sc2mac_dat_b_src_data93;
wire     [7:0] sc2mac_dat_b_src_data94;
wire     [7:0] sc2mac_dat_b_src_data95;
wire     [7:0] sc2mac_dat_b_src_data96;
wire     [7:0] sc2mac_dat_b_src_data97;
wire     [7:0] sc2mac_dat_b_src_data98;
wire     [7:0] sc2mac_dat_b_src_data99;
wire   [127:0] sc2mac_dat_b_src_mask;
wire     [8:0] sc2mac_dat_b_src_pd;
wire           sc2mac_dat_b_src_pvld;
wire     [7:0] sc2mac_wt_b_src_data0;
wire     [7:0] sc2mac_wt_b_src_data1;
wire     [7:0] sc2mac_wt_b_src_data10;
wire     [7:0] sc2mac_wt_b_src_data100;
wire     [7:0] sc2mac_wt_b_src_data101;
wire     [7:0] sc2mac_wt_b_src_data102;
wire     [7:0] sc2mac_wt_b_src_data103;
wire     [7:0] sc2mac_wt_b_src_data104;
wire     [7:0] sc2mac_wt_b_src_data105;
wire     [7:0] sc2mac_wt_b_src_data106;
wire     [7:0] sc2mac_wt_b_src_data107;
wire     [7:0] sc2mac_wt_b_src_data108;
wire     [7:0] sc2mac_wt_b_src_data109;
wire     [7:0] sc2mac_wt_b_src_data11;
wire     [7:0] sc2mac_wt_b_src_data110;
wire     [7:0] sc2mac_wt_b_src_data111;
wire     [7:0] sc2mac_wt_b_src_data112;
wire     [7:0] sc2mac_wt_b_src_data113;
wire     [7:0] sc2mac_wt_b_src_data114;
wire     [7:0] sc2mac_wt_b_src_data115;
wire     [7:0] sc2mac_wt_b_src_data116;
wire     [7:0] sc2mac_wt_b_src_data117;
wire     [7:0] sc2mac_wt_b_src_data118;
wire     [7:0] sc2mac_wt_b_src_data119;
wire     [7:0] sc2mac_wt_b_src_data12;
wire     [7:0] sc2mac_wt_b_src_data120;
wire     [7:0] sc2mac_wt_b_src_data121;
wire     [7:0] sc2mac_wt_b_src_data122;
wire     [7:0] sc2mac_wt_b_src_data123;
wire     [7:0] sc2mac_wt_b_src_data124;
wire     [7:0] sc2mac_wt_b_src_data125;
wire     [7:0] sc2mac_wt_b_src_data126;
wire     [7:0] sc2mac_wt_b_src_data127;
wire     [7:0] sc2mac_wt_b_src_data13;
wire     [7:0] sc2mac_wt_b_src_data14;
wire     [7:0] sc2mac_wt_b_src_data15;
wire     [7:0] sc2mac_wt_b_src_data16;
wire     [7:0] sc2mac_wt_b_src_data17;
wire     [7:0] sc2mac_wt_b_src_data18;
wire     [7:0] sc2mac_wt_b_src_data19;
wire     [7:0] sc2mac_wt_b_src_data2;
wire     [7:0] sc2mac_wt_b_src_data20;
wire     [7:0] sc2mac_wt_b_src_data21;
wire     [7:0] sc2mac_wt_b_src_data22;
wire     [7:0] sc2mac_wt_b_src_data23;
wire     [7:0] sc2mac_wt_b_src_data24;
wire     [7:0] sc2mac_wt_b_src_data25;
wire     [7:0] sc2mac_wt_b_src_data26;
wire     [7:0] sc2mac_wt_b_src_data27;
wire     [7:0] sc2mac_wt_b_src_data28;
wire     [7:0] sc2mac_wt_b_src_data29;
wire     [7:0] sc2mac_wt_b_src_data3;
wire     [7:0] sc2mac_wt_b_src_data30;
wire     [7:0] sc2mac_wt_b_src_data31;
wire     [7:0] sc2mac_wt_b_src_data32;
wire     [7:0] sc2mac_wt_b_src_data33;
wire     [7:0] sc2mac_wt_b_src_data34;
wire     [7:0] sc2mac_wt_b_src_data35;
wire     [7:0] sc2mac_wt_b_src_data36;
wire     [7:0] sc2mac_wt_b_src_data37;
wire     [7:0] sc2mac_wt_b_src_data38;
wire     [7:0] sc2mac_wt_b_src_data39;
wire     [7:0] sc2mac_wt_b_src_data4;
wire     [7:0] sc2mac_wt_b_src_data40;
wire     [7:0] sc2mac_wt_b_src_data41;
wire     [7:0] sc2mac_wt_b_src_data42;
wire     [7:0] sc2mac_wt_b_src_data43;
wire     [7:0] sc2mac_wt_b_src_data44;
wire     [7:0] sc2mac_wt_b_src_data45;
wire     [7:0] sc2mac_wt_b_src_data46;
wire     [7:0] sc2mac_wt_b_src_data47;
wire     [7:0] sc2mac_wt_b_src_data48;
wire     [7:0] sc2mac_wt_b_src_data49;
wire     [7:0] sc2mac_wt_b_src_data5;
wire     [7:0] sc2mac_wt_b_src_data50;
wire     [7:0] sc2mac_wt_b_src_data51;
wire     [7:0] sc2mac_wt_b_src_data52;
wire     [7:0] sc2mac_wt_b_src_data53;
wire     [7:0] sc2mac_wt_b_src_data54;
wire     [7:0] sc2mac_wt_b_src_data55;
wire     [7:0] sc2mac_wt_b_src_data56;
wire     [7:0] sc2mac_wt_b_src_data57;
wire     [7:0] sc2mac_wt_b_src_data58;
wire     [7:0] sc2mac_wt_b_src_data59;
wire     [7:0] sc2mac_wt_b_src_data6;
wire     [7:0] sc2mac_wt_b_src_data60;
wire     [7:0] sc2mac_wt_b_src_data61;
wire     [7:0] sc2mac_wt_b_src_data62;
wire     [7:0] sc2mac_wt_b_src_data63;
wire     [7:0] sc2mac_wt_b_src_data64;
wire     [7:0] sc2mac_wt_b_src_data65;
wire     [7:0] sc2mac_wt_b_src_data66;
wire     [7:0] sc2mac_wt_b_src_data67;
wire     [7:0] sc2mac_wt_b_src_data68;
wire     [7:0] sc2mac_wt_b_src_data69;
wire     [7:0] sc2mac_wt_b_src_data7;
wire     [7:0] sc2mac_wt_b_src_data70;
wire     [7:0] sc2mac_wt_b_src_data71;
wire     [7:0] sc2mac_wt_b_src_data72;
wire     [7:0] sc2mac_wt_b_src_data73;
wire     [7:0] sc2mac_wt_b_src_data74;
wire     [7:0] sc2mac_wt_b_src_data75;
wire     [7:0] sc2mac_wt_b_src_data76;
wire     [7:0] sc2mac_wt_b_src_data77;
wire     [7:0] sc2mac_wt_b_src_data78;
wire     [7:0] sc2mac_wt_b_src_data79;
wire     [7:0] sc2mac_wt_b_src_data8;
wire     [7:0] sc2mac_wt_b_src_data80;
wire     [7:0] sc2mac_wt_b_src_data81;
wire     [7:0] sc2mac_wt_b_src_data82;
wire     [7:0] sc2mac_wt_b_src_data83;
wire     [7:0] sc2mac_wt_b_src_data84;
wire     [7:0] sc2mac_wt_b_src_data85;
wire     [7:0] sc2mac_wt_b_src_data86;
wire     [7:0] sc2mac_wt_b_src_data87;
wire     [7:0] sc2mac_wt_b_src_data88;
wire     [7:0] sc2mac_wt_b_src_data89;
wire     [7:0] sc2mac_wt_b_src_data9;
wire     [7:0] sc2mac_wt_b_src_data90;
wire     [7:0] sc2mac_wt_b_src_data91;
wire     [7:0] sc2mac_wt_b_src_data92;
wire     [7:0] sc2mac_wt_b_src_data93;
wire     [7:0] sc2mac_wt_b_src_data94;
wire     [7:0] sc2mac_wt_b_src_data95;
wire     [7:0] sc2mac_wt_b_src_data96;
wire     [7:0] sc2mac_wt_b_src_data97;
wire     [7:0] sc2mac_wt_b_src_data98;
wire     [7:0] sc2mac_wt_b_src_data99;
wire   [127:0] sc2mac_wt_b_src_mask;
wire           sc2mac_wt_b_src_pvld;
wire     [7:0] sc2mac_wt_b_src_sel;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Reset Sync                                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_partition_c_reset (
   .dla_reset_rstn                (dla_reset_rstn)                 //|< i
  ,.direct_reset_                 (direct_reset_)                  //|< i
  ,.test_mode                     (test_mode)                      //|< i
  ,.synced_rstn                   (nvdla_core_rstn)                //|> w
  ,.nvdla_clk                     (nvdla_core_clk)                 //|< i
  );

////////////////////////////////////////////////////////////////////////
// SLCG override
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_csc_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.sync_i                        (nvdla_clk_ovr_on)               //|< i
  ,.sync_o                        (csc_dla_clk_ovr_on_sync)        //|> w
  );

NV_NVDLA_sync3d u_cdma_dla_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.sync_i                        (nvdla_clk_ovr_on)               //|< i
  ,.sync_o                        (cdma_dla_clk_ovr_on_sync)       //|> w
  );

//&Instance NV_NVDLA_sync3d u_dla_clk_ovr_on_sync;
//&Connect clk      nvdla_core_clk;
//&Connect sync_i   nvdla_clk_ovr_on;
//&Connect sync_o   dla_clk_ovr_on_sync;

NV_NVDLA_sync3d_s u_global_csc_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.prst                          (nvdla_core_rstn)                //|< w
  ,.sync_i                        (global_clk_ovr_on)              //|< i
  ,.sync_o                        (csc_global_clk_ovr_on_sync)     //|> w
  );

NV_NVDLA_sync3d_s u_global_cdma_clk_ovr_on_sync (
   .clk                           (nvdla_core_clk)                 //|< i
  ,.prst                          (nvdla_core_rstn)                //|< w
  ,.sync_i                        (global_clk_ovr_on)              //|< i
  ,.sync_o                        (cdma_global_clk_ovr_on_sync)    //|> w
  );

//&Instance NV_NVDLA_sync3d_s u_global_clk_ovr_on_sync;
//&Connect clk      nvdla_core_clk;
//&Connect prst     nvdla_core_rstn;
//&Connect sync_i   global_clk_ovr_on;
//&Connect sync_o   global_clk_ovr_on_sync;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Convolution DMA                             //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cdma u_NV_NVDLA_cdma (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.cdma2buf_dat_wr_en            (cdma2buf_dat_wr_en)             //|> w
  ,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr[11:0])     //|> w
  ,.cdma2buf_dat_wr_hsel          (cdma2buf_dat_wr_hsel[1:0])      //|> w
  ,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data[1023:0])   //|> w
  ,.cdma2buf_wt_wr_en             (cdma2buf_wt_wr_en)              //|> w
  ,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr[11:0])      //|> w
  ,.cdma2buf_wt_wr_hsel           (cdma2buf_wt_wr_hsel)            //|> w
  ,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data[511:0])     //|> w
  ,.cdma2csb_resp_valid           (cdma2csb_resp_valid)            //|> o
  ,.cdma2csb_resp_pd              (cdma2csb_resp_pd[33:0])         //|> o
  ,.cdma2sc_dat_pending_ack       (cdma2sc_dat_pending_ack)        //|> w
  ,.cdma2sc_wt_pending_ack        (cdma2sc_wt_pending_ack)         //|> w
  ,.cdma_dat2cvif_rd_req_valid    (cdma_dat2cvif_rd_req_valid)     //|> o
  ,.cdma_dat2cvif_rd_req_ready    (cdma_dat2cvif_rd_req_ready)     //|< i
  ,.cdma_dat2cvif_rd_req_pd       (cdma_dat2cvif_rd_req_pd[78:0])  //|> o
  ,.cdma_dat2glb_done_intr_pd     (cdma_dat2glb_done_intr_pd[1:0]) //|> o
  ,.cdma_dat2mcif_rd_req_valid    (cdma_dat2mcif_rd_req_valid)     //|> o
  ,.cdma_dat2mcif_rd_req_ready    (cdma_dat2mcif_rd_req_ready)     //|< i
  ,.cdma_dat2mcif_rd_req_pd       (cdma_dat2mcif_rd_req_pd[78:0])  //|> o
  ,.cdma_wt2cvif_rd_req_valid     (cdma_wt2cvif_rd_req_valid)      //|> o
  ,.cdma_wt2cvif_rd_req_ready     (cdma_wt2cvif_rd_req_ready)      //|< i
  ,.cdma_wt2cvif_rd_req_pd        (cdma_wt2cvif_rd_req_pd[78:0])   //|> o
  ,.cdma_wt2glb_done_intr_pd      (cdma_wt2glb_done_intr_pd[1:0])  //|> o
  ,.cdma_wt2mcif_rd_req_valid     (cdma_wt2mcif_rd_req_valid)      //|> o
  ,.cdma_wt2mcif_rd_req_ready     (cdma_wt2mcif_rd_req_ready)      //|< i
  ,.cdma_wt2mcif_rd_req_pd        (cdma_wt2mcif_rd_req_pd[78:0])   //|> o
  ,.csb2cdma_req_pvld             (csb2cdma_req_pvld)              //|< i
  ,.csb2cdma_req_prdy             (csb2cdma_req_prdy)              //|> o
  ,.csb2cdma_req_pd               (csb2cdma_req_pd[62:0])          //|< i
  ,.cvif2cdma_dat_rd_rsp_valid    (cvif2cdma_dat_rd_rsp_valid)     //|< i
  ,.cvif2cdma_dat_rd_rsp_ready    (cvif2cdma_dat_rd_rsp_ready)     //|> o
  ,.cvif2cdma_dat_rd_rsp_pd       (cvif2cdma_dat_rd_rsp_pd[513:0]) //|< i
  ,.cvif2cdma_wt_rd_rsp_valid     (cvif2cdma_wt_rd_rsp_valid)      //|< i
  ,.cvif2cdma_wt_rd_rsp_ready     (cvif2cdma_wt_rd_rsp_ready)      //|> o
  ,.cvif2cdma_wt_rd_rsp_pd        (cvif2cdma_wt_rd_rsp_pd[513:0])  //|< i
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)               //|> w
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[11:0])      //|> w
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[11:0])       //|> w
  ,.sc2cdma_dat_updt              (sc2cdma_dat_updt)               //|< w
  ,.sc2cdma_dat_entries           (sc2cdma_dat_entries[11:0])      //|< w
  ,.sc2cdma_dat_slices            (sc2cdma_dat_slices[11:0])       //|< w
  ,.mcif2cdma_dat_rd_rsp_valid    (mcif2cdma_dat_rd_rsp_valid)     //|< i
  ,.mcif2cdma_dat_rd_rsp_ready    (mcif2cdma_dat_rd_rsp_ready)     //|> o
  ,.mcif2cdma_dat_rd_rsp_pd       (mcif2cdma_dat_rd_rsp_pd[513:0]) //|< i
  ,.mcif2cdma_wt_rd_rsp_valid     (mcif2cdma_wt_rd_rsp_valid)      //|< i
  ,.mcif2cdma_wt_rd_rsp_ready     (mcif2cdma_wt_rd_rsp_ready)      //|> o
  ,.mcif2cdma_wt_rd_rsp_pd        (mcif2cdma_wt_rd_rsp_pd[513:0])  //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])            //|< i
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)        //|< w
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)         //|< w
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)                //|> w
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels[13:0])       //|> w
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries[11:0])       //|> w
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries[8:0])       //|> w
  ,.sc2cdma_wt_updt               (sc2cdma_wt_updt)                //|< w
  ,.sc2cdma_wt_kernels            (sc2cdma_wt_kernels[13:0])       //|< w
  ,.sc2cdma_wt_entries            (sc2cdma_wt_entries[11:0])       //|< w
  ,.sc2cdma_wmb_entries           (sc2cdma_wmb_entries[8:0])       //|< w
  ,.dla_clk_ovr_on_sync           (cdma_dla_clk_ovr_on_sync)       //|< w
  ,.global_clk_ovr_on_sync        (cdma_global_clk_ovr_on_sync)    //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)  //|< i
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Convolution Buffer                          //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cbuf u_NV_NVDLA_cbuf (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])            //|< i
  ,.cdma2buf_dat_wr_en            (cdma2buf_dat_wr_en)             //|< w
  ,.cdma2buf_dat_wr_addr          (cdma2buf_dat_wr_addr[11:0])     //|< w
  ,.cdma2buf_dat_wr_hsel          (cdma2buf_dat_wr_hsel[1:0])      //|< w
  ,.cdma2buf_dat_wr_data          (cdma2buf_dat_wr_data[1023:0])   //|< w
  ,.cdma2buf_wt_wr_en             (cdma2buf_wt_wr_en)              //|< w
  ,.cdma2buf_wt_wr_addr           (cdma2buf_wt_wr_addr[11:0])      //|< w
  ,.cdma2buf_wt_wr_hsel           (cdma2buf_wt_wr_hsel)            //|< w
  ,.cdma2buf_wt_wr_data           (cdma2buf_wt_wr_data[511:0])     //|< w
  ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)               //|< w
  ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr[11:0])       //|< w
  ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)            //|> w
  ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data[1023:0])     //|> w
  ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)                //|< w
  ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr[11:0])        //|< w
  ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)             //|> w
  ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data[1023:0])      //|> w
  ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)               //|< w
  ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr[7:0])        //|< w
  ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)            //|> w
  ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data[1023:0])     //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Convolution Sequence Controller             //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_csc u_NV_NVDLA_csc (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)        //|> w
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)         //|> w
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)             //|< i
  ,.accu2sc_credit_size           (accu2sc_credit_size[2:0])       //|< i
  ,.cdma2sc_dat_pending_ack       (cdma2sc_dat_pending_ack)        //|< w
  ,.cdma2sc_wt_pending_ack        (cdma2sc_wt_pending_ack)         //|< w
  ,.csb2csc_req_pvld              (csb2csc_req_pvld)               //|< i
  ,.csb2csc_req_prdy              (csb2csc_req_prdy)               //|> o
  ,.csb2csc_req_pd                (csb2csc_req_pd[62:0])           //|< i
  ,.csc2csb_resp_valid            (csc2csb_resp_valid)             //|> o
  ,.csc2csb_resp_pd               (csc2csb_resp_pd[33:0])          //|> o
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)               //|< w
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[11:0])      //|< w
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[11:0])       //|< w
  ,.sc2cdma_dat_updt              (sc2cdma_dat_updt)               //|> w
  ,.sc2cdma_dat_entries           (sc2cdma_dat_entries[11:0])      //|> w
  ,.sc2cdma_dat_slices            (sc2cdma_dat_slices[11:0])       //|> w
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])            //|< i
  ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)               //|> w
  ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr[11:0])       //|> w
  ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)            //|< w
  ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data[1023:0])     //|< w
  ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)               //|> w
  ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr[7:0])        //|> w
  ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)            //|< w
  ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data[1023:0])     //|< w
  ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)                //|> w
  ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr[11:0])        //|> w
  ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)             //|< w
  ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data[1023:0])      //|< w
  ,.sc2mac_dat_a_pvld             (sc2mac_dat_a_src_pvld)          //|> o
  ,.sc2mac_dat_a_mask             (sc2mac_dat_a_src_mask[127:0])   //|> o
  ,.sc2mac_dat_a_data0            (sc2mac_dat_a_src_data0[7:0])    //|> o
  ,.sc2mac_dat_a_data1            (sc2mac_dat_a_src_data1[7:0])    //|> o
  ,.sc2mac_dat_a_data2            (sc2mac_dat_a_src_data2[7:0])    //|> o
  ,.sc2mac_dat_a_data3            (sc2mac_dat_a_src_data3[7:0])    //|> o
  ,.sc2mac_dat_a_data4            (sc2mac_dat_a_src_data4[7:0])    //|> o
  ,.sc2mac_dat_a_data5            (sc2mac_dat_a_src_data5[7:0])    //|> o
  ,.sc2mac_dat_a_data6            (sc2mac_dat_a_src_data6[7:0])    //|> o
  ,.sc2mac_dat_a_data7            (sc2mac_dat_a_src_data7[7:0])    //|> o
  ,.sc2mac_dat_a_data8            (sc2mac_dat_a_src_data8[7:0])    //|> o
  ,.sc2mac_dat_a_data9            (sc2mac_dat_a_src_data9[7:0])    //|> o
  ,.sc2mac_dat_a_data10           (sc2mac_dat_a_src_data10[7:0])   //|> o
  ,.sc2mac_dat_a_data11           (sc2mac_dat_a_src_data11[7:0])   //|> o
  ,.sc2mac_dat_a_data12           (sc2mac_dat_a_src_data12[7:0])   //|> o
  ,.sc2mac_dat_a_data13           (sc2mac_dat_a_src_data13[7:0])   //|> o
  ,.sc2mac_dat_a_data14           (sc2mac_dat_a_src_data14[7:0])   //|> o
  ,.sc2mac_dat_a_data15           (sc2mac_dat_a_src_data15[7:0])   //|> o
  ,.sc2mac_dat_a_data16           (sc2mac_dat_a_src_data16[7:0])   //|> o
  ,.sc2mac_dat_a_data17           (sc2mac_dat_a_src_data17[7:0])   //|> o
  ,.sc2mac_dat_a_data18           (sc2mac_dat_a_src_data18[7:0])   //|> o
  ,.sc2mac_dat_a_data19           (sc2mac_dat_a_src_data19[7:0])   //|> o
  ,.sc2mac_dat_a_data20           (sc2mac_dat_a_src_data20[7:0])   //|> o
  ,.sc2mac_dat_a_data21           (sc2mac_dat_a_src_data21[7:0])   //|> o
  ,.sc2mac_dat_a_data22           (sc2mac_dat_a_src_data22[7:0])   //|> o
  ,.sc2mac_dat_a_data23           (sc2mac_dat_a_src_data23[7:0])   //|> o
  ,.sc2mac_dat_a_data24           (sc2mac_dat_a_src_data24[7:0])   //|> o
  ,.sc2mac_dat_a_data25           (sc2mac_dat_a_src_data25[7:0])   //|> o
  ,.sc2mac_dat_a_data26           (sc2mac_dat_a_src_data26[7:0])   //|> o
  ,.sc2mac_dat_a_data27           (sc2mac_dat_a_src_data27[7:0])   //|> o
  ,.sc2mac_dat_a_data28           (sc2mac_dat_a_src_data28[7:0])   //|> o
  ,.sc2mac_dat_a_data29           (sc2mac_dat_a_src_data29[7:0])   //|> o
  ,.sc2mac_dat_a_data30           (sc2mac_dat_a_src_data30[7:0])   //|> o
  ,.sc2mac_dat_a_data31           (sc2mac_dat_a_src_data31[7:0])   //|> o
  ,.sc2mac_dat_a_data32           (sc2mac_dat_a_src_data32[7:0])   //|> o
  ,.sc2mac_dat_a_data33           (sc2mac_dat_a_src_data33[7:0])   //|> o
  ,.sc2mac_dat_a_data34           (sc2mac_dat_a_src_data34[7:0])   //|> o
  ,.sc2mac_dat_a_data35           (sc2mac_dat_a_src_data35[7:0])   //|> o
  ,.sc2mac_dat_a_data36           (sc2mac_dat_a_src_data36[7:0])   //|> o
  ,.sc2mac_dat_a_data37           (sc2mac_dat_a_src_data37[7:0])   //|> o
  ,.sc2mac_dat_a_data38           (sc2mac_dat_a_src_data38[7:0])   //|> o
  ,.sc2mac_dat_a_data39           (sc2mac_dat_a_src_data39[7:0])   //|> o
  ,.sc2mac_dat_a_data40           (sc2mac_dat_a_src_data40[7:0])   //|> o
  ,.sc2mac_dat_a_data41           (sc2mac_dat_a_src_data41[7:0])   //|> o
  ,.sc2mac_dat_a_data42           (sc2mac_dat_a_src_data42[7:0])   //|> o
  ,.sc2mac_dat_a_data43           (sc2mac_dat_a_src_data43[7:0])   //|> o
  ,.sc2mac_dat_a_data44           (sc2mac_dat_a_src_data44[7:0])   //|> o
  ,.sc2mac_dat_a_data45           (sc2mac_dat_a_src_data45[7:0])   //|> o
  ,.sc2mac_dat_a_data46           (sc2mac_dat_a_src_data46[7:0])   //|> o
  ,.sc2mac_dat_a_data47           (sc2mac_dat_a_src_data47[7:0])   //|> o
  ,.sc2mac_dat_a_data48           (sc2mac_dat_a_src_data48[7:0])   //|> o
  ,.sc2mac_dat_a_data49           (sc2mac_dat_a_src_data49[7:0])   //|> o
  ,.sc2mac_dat_a_data50           (sc2mac_dat_a_src_data50[7:0])   //|> o
  ,.sc2mac_dat_a_data51           (sc2mac_dat_a_src_data51[7:0])   //|> o
  ,.sc2mac_dat_a_data52           (sc2mac_dat_a_src_data52[7:0])   //|> o
  ,.sc2mac_dat_a_data53           (sc2mac_dat_a_src_data53[7:0])   //|> o
  ,.sc2mac_dat_a_data54           (sc2mac_dat_a_src_data54[7:0])   //|> o
  ,.sc2mac_dat_a_data55           (sc2mac_dat_a_src_data55[7:0])   //|> o
  ,.sc2mac_dat_a_data56           (sc2mac_dat_a_src_data56[7:0])   //|> o
  ,.sc2mac_dat_a_data57           (sc2mac_dat_a_src_data57[7:0])   //|> o
  ,.sc2mac_dat_a_data58           (sc2mac_dat_a_src_data58[7:0])   //|> o
  ,.sc2mac_dat_a_data59           (sc2mac_dat_a_src_data59[7:0])   //|> o
  ,.sc2mac_dat_a_data60           (sc2mac_dat_a_src_data60[7:0])   //|> o
  ,.sc2mac_dat_a_data61           (sc2mac_dat_a_src_data61[7:0])   //|> o
  ,.sc2mac_dat_a_data62           (sc2mac_dat_a_src_data62[7:0])   //|> o
  ,.sc2mac_dat_a_data63           (sc2mac_dat_a_src_data63[7:0])   //|> o
  ,.sc2mac_dat_a_data64           (sc2mac_dat_a_src_data64[7:0])   //|> o
  ,.sc2mac_dat_a_data65           (sc2mac_dat_a_src_data65[7:0])   //|> o
  ,.sc2mac_dat_a_data66           (sc2mac_dat_a_src_data66[7:0])   //|> o
  ,.sc2mac_dat_a_data67           (sc2mac_dat_a_src_data67[7:0])   //|> o
  ,.sc2mac_dat_a_data68           (sc2mac_dat_a_src_data68[7:0])   //|> o
  ,.sc2mac_dat_a_data69           (sc2mac_dat_a_src_data69[7:0])   //|> o
  ,.sc2mac_dat_a_data70           (sc2mac_dat_a_src_data70[7:0])   //|> o
  ,.sc2mac_dat_a_data71           (sc2mac_dat_a_src_data71[7:0])   //|> o
  ,.sc2mac_dat_a_data72           (sc2mac_dat_a_src_data72[7:0])   //|> o
  ,.sc2mac_dat_a_data73           (sc2mac_dat_a_src_data73[7:0])   //|> o
  ,.sc2mac_dat_a_data74           (sc2mac_dat_a_src_data74[7:0])   //|> o
  ,.sc2mac_dat_a_data75           (sc2mac_dat_a_src_data75[7:0])   //|> o
  ,.sc2mac_dat_a_data76           (sc2mac_dat_a_src_data76[7:0])   //|> o
  ,.sc2mac_dat_a_data77           (sc2mac_dat_a_src_data77[7:0])   //|> o
  ,.sc2mac_dat_a_data78           (sc2mac_dat_a_src_data78[7:0])   //|> o
  ,.sc2mac_dat_a_data79           (sc2mac_dat_a_src_data79[7:0])   //|> o
  ,.sc2mac_dat_a_data80           (sc2mac_dat_a_src_data80[7:0])   //|> o
  ,.sc2mac_dat_a_data81           (sc2mac_dat_a_src_data81[7:0])   //|> o
  ,.sc2mac_dat_a_data82           (sc2mac_dat_a_src_data82[7:0])   //|> o
  ,.sc2mac_dat_a_data83           (sc2mac_dat_a_src_data83[7:0])   //|> o
  ,.sc2mac_dat_a_data84           (sc2mac_dat_a_src_data84[7:0])   //|> o
  ,.sc2mac_dat_a_data85           (sc2mac_dat_a_src_data85[7:0])   //|> o
  ,.sc2mac_dat_a_data86           (sc2mac_dat_a_src_data86[7:0])   //|> o
  ,.sc2mac_dat_a_data87           (sc2mac_dat_a_src_data87[7:0])   //|> o
  ,.sc2mac_dat_a_data88           (sc2mac_dat_a_src_data88[7:0])   //|> o
  ,.sc2mac_dat_a_data89           (sc2mac_dat_a_src_data89[7:0])   //|> o
  ,.sc2mac_dat_a_data90           (sc2mac_dat_a_src_data90[7:0])   //|> o
  ,.sc2mac_dat_a_data91           (sc2mac_dat_a_src_data91[7:0])   //|> o
  ,.sc2mac_dat_a_data92           (sc2mac_dat_a_src_data92[7:0])   //|> o
  ,.sc2mac_dat_a_data93           (sc2mac_dat_a_src_data93[7:0])   //|> o
  ,.sc2mac_dat_a_data94           (sc2mac_dat_a_src_data94[7:0])   //|> o
  ,.sc2mac_dat_a_data95           (sc2mac_dat_a_src_data95[7:0])   //|> o
  ,.sc2mac_dat_a_data96           (sc2mac_dat_a_src_data96[7:0])   //|> o
  ,.sc2mac_dat_a_data97           (sc2mac_dat_a_src_data97[7:0])   //|> o
  ,.sc2mac_dat_a_data98           (sc2mac_dat_a_src_data98[7:0])   //|> o
  ,.sc2mac_dat_a_data99           (sc2mac_dat_a_src_data99[7:0])   //|> o
  ,.sc2mac_dat_a_data100          (sc2mac_dat_a_src_data100[7:0])  //|> o
  ,.sc2mac_dat_a_data101          (sc2mac_dat_a_src_data101[7:0])  //|> o
  ,.sc2mac_dat_a_data102          (sc2mac_dat_a_src_data102[7:0])  //|> o
  ,.sc2mac_dat_a_data103          (sc2mac_dat_a_src_data103[7:0])  //|> o
  ,.sc2mac_dat_a_data104          (sc2mac_dat_a_src_data104[7:0])  //|> o
  ,.sc2mac_dat_a_data105          (sc2mac_dat_a_src_data105[7:0])  //|> o
  ,.sc2mac_dat_a_data106          (sc2mac_dat_a_src_data106[7:0])  //|> o
  ,.sc2mac_dat_a_data107          (sc2mac_dat_a_src_data107[7:0])  //|> o
  ,.sc2mac_dat_a_data108          (sc2mac_dat_a_src_data108[7:0])  //|> o
  ,.sc2mac_dat_a_data109          (sc2mac_dat_a_src_data109[7:0])  //|> o
  ,.sc2mac_dat_a_data110          (sc2mac_dat_a_src_data110[7:0])  //|> o
  ,.sc2mac_dat_a_data111          (sc2mac_dat_a_src_data111[7:0])  //|> o
  ,.sc2mac_dat_a_data112          (sc2mac_dat_a_src_data112[7:0])  //|> o
  ,.sc2mac_dat_a_data113          (sc2mac_dat_a_src_data113[7:0])  //|> o
  ,.sc2mac_dat_a_data114          (sc2mac_dat_a_src_data114[7:0])  //|> o
  ,.sc2mac_dat_a_data115          (sc2mac_dat_a_src_data115[7:0])  //|> o
  ,.sc2mac_dat_a_data116          (sc2mac_dat_a_src_data116[7:0])  //|> o
  ,.sc2mac_dat_a_data117          (sc2mac_dat_a_src_data117[7:0])  //|> o
  ,.sc2mac_dat_a_data118          (sc2mac_dat_a_src_data118[7:0])  //|> o
  ,.sc2mac_dat_a_data119          (sc2mac_dat_a_src_data119[7:0])  //|> o
  ,.sc2mac_dat_a_data120          (sc2mac_dat_a_src_data120[7:0])  //|> o
  ,.sc2mac_dat_a_data121          (sc2mac_dat_a_src_data121[7:0])  //|> o
  ,.sc2mac_dat_a_data122          (sc2mac_dat_a_src_data122[7:0])  //|> o
  ,.sc2mac_dat_a_data123          (sc2mac_dat_a_src_data123[7:0])  //|> o
  ,.sc2mac_dat_a_data124          (sc2mac_dat_a_src_data124[7:0])  //|> o
  ,.sc2mac_dat_a_data125          (sc2mac_dat_a_src_data125[7:0])  //|> o
  ,.sc2mac_dat_a_data126          (sc2mac_dat_a_src_data126[7:0])  //|> o
  ,.sc2mac_dat_a_data127          (sc2mac_dat_a_src_data127[7:0])  //|> o
  ,.sc2mac_dat_a_pd               (sc2mac_dat_a_src_pd[8:0])       //|> o
  ,.sc2mac_dat_b_pvld             (sc2mac_dat_b_src_pvld)          //|> w
  ,.sc2mac_dat_b_mask             (sc2mac_dat_b_src_mask[127:0])   //|> w
  ,.sc2mac_dat_b_data0            (sc2mac_dat_b_src_data0[7:0])    //|> w
  ,.sc2mac_dat_b_data1            (sc2mac_dat_b_src_data1[7:0])    //|> w
  ,.sc2mac_dat_b_data2            (sc2mac_dat_b_src_data2[7:0])    //|> w
  ,.sc2mac_dat_b_data3            (sc2mac_dat_b_src_data3[7:0])    //|> w
  ,.sc2mac_dat_b_data4            (sc2mac_dat_b_src_data4[7:0])    //|> w
  ,.sc2mac_dat_b_data5            (sc2mac_dat_b_src_data5[7:0])    //|> w
  ,.sc2mac_dat_b_data6            (sc2mac_dat_b_src_data6[7:0])    //|> w
  ,.sc2mac_dat_b_data7            (sc2mac_dat_b_src_data7[7:0])    //|> w
  ,.sc2mac_dat_b_data8            (sc2mac_dat_b_src_data8[7:0])    //|> w
  ,.sc2mac_dat_b_data9            (sc2mac_dat_b_src_data9[7:0])    //|> w
  ,.sc2mac_dat_b_data10           (sc2mac_dat_b_src_data10[7:0])   //|> w
  ,.sc2mac_dat_b_data11           (sc2mac_dat_b_src_data11[7:0])   //|> w
  ,.sc2mac_dat_b_data12           (sc2mac_dat_b_src_data12[7:0])   //|> w
  ,.sc2mac_dat_b_data13           (sc2mac_dat_b_src_data13[7:0])   //|> w
  ,.sc2mac_dat_b_data14           (sc2mac_dat_b_src_data14[7:0])   //|> w
  ,.sc2mac_dat_b_data15           (sc2mac_dat_b_src_data15[7:0])   //|> w
  ,.sc2mac_dat_b_data16           (sc2mac_dat_b_src_data16[7:0])   //|> w
  ,.sc2mac_dat_b_data17           (sc2mac_dat_b_src_data17[7:0])   //|> w
  ,.sc2mac_dat_b_data18           (sc2mac_dat_b_src_data18[7:0])   //|> w
  ,.sc2mac_dat_b_data19           (sc2mac_dat_b_src_data19[7:0])   //|> w
  ,.sc2mac_dat_b_data20           (sc2mac_dat_b_src_data20[7:0])   //|> w
  ,.sc2mac_dat_b_data21           (sc2mac_dat_b_src_data21[7:0])   //|> w
  ,.sc2mac_dat_b_data22           (sc2mac_dat_b_src_data22[7:0])   //|> w
  ,.sc2mac_dat_b_data23           (sc2mac_dat_b_src_data23[7:0])   //|> w
  ,.sc2mac_dat_b_data24           (sc2mac_dat_b_src_data24[7:0])   //|> w
  ,.sc2mac_dat_b_data25           (sc2mac_dat_b_src_data25[7:0])   //|> w
  ,.sc2mac_dat_b_data26           (sc2mac_dat_b_src_data26[7:0])   //|> w
  ,.sc2mac_dat_b_data27           (sc2mac_dat_b_src_data27[7:0])   //|> w
  ,.sc2mac_dat_b_data28           (sc2mac_dat_b_src_data28[7:0])   //|> w
  ,.sc2mac_dat_b_data29           (sc2mac_dat_b_src_data29[7:0])   //|> w
  ,.sc2mac_dat_b_data30           (sc2mac_dat_b_src_data30[7:0])   //|> w
  ,.sc2mac_dat_b_data31           (sc2mac_dat_b_src_data31[7:0])   //|> w
  ,.sc2mac_dat_b_data32           (sc2mac_dat_b_src_data32[7:0])   //|> w
  ,.sc2mac_dat_b_data33           (sc2mac_dat_b_src_data33[7:0])   //|> w
  ,.sc2mac_dat_b_data34           (sc2mac_dat_b_src_data34[7:0])   //|> w
  ,.sc2mac_dat_b_data35           (sc2mac_dat_b_src_data35[7:0])   //|> w
  ,.sc2mac_dat_b_data36           (sc2mac_dat_b_src_data36[7:0])   //|> w
  ,.sc2mac_dat_b_data37           (sc2mac_dat_b_src_data37[7:0])   //|> w
  ,.sc2mac_dat_b_data38           (sc2mac_dat_b_src_data38[7:0])   //|> w
  ,.sc2mac_dat_b_data39           (sc2mac_dat_b_src_data39[7:0])   //|> w
  ,.sc2mac_dat_b_data40           (sc2mac_dat_b_src_data40[7:0])   //|> w
  ,.sc2mac_dat_b_data41           (sc2mac_dat_b_src_data41[7:0])   //|> w
  ,.sc2mac_dat_b_data42           (sc2mac_dat_b_src_data42[7:0])   //|> w
  ,.sc2mac_dat_b_data43           (sc2mac_dat_b_src_data43[7:0])   //|> w
  ,.sc2mac_dat_b_data44           (sc2mac_dat_b_src_data44[7:0])   //|> w
  ,.sc2mac_dat_b_data45           (sc2mac_dat_b_src_data45[7:0])   //|> w
  ,.sc2mac_dat_b_data46           (sc2mac_dat_b_src_data46[7:0])   //|> w
  ,.sc2mac_dat_b_data47           (sc2mac_dat_b_src_data47[7:0])   //|> w
  ,.sc2mac_dat_b_data48           (sc2mac_dat_b_src_data48[7:0])   //|> w
  ,.sc2mac_dat_b_data49           (sc2mac_dat_b_src_data49[7:0])   //|> w
  ,.sc2mac_dat_b_data50           (sc2mac_dat_b_src_data50[7:0])   //|> w
  ,.sc2mac_dat_b_data51           (sc2mac_dat_b_src_data51[7:0])   //|> w
  ,.sc2mac_dat_b_data52           (sc2mac_dat_b_src_data52[7:0])   //|> w
  ,.sc2mac_dat_b_data53           (sc2mac_dat_b_src_data53[7:0])   //|> w
  ,.sc2mac_dat_b_data54           (sc2mac_dat_b_src_data54[7:0])   //|> w
  ,.sc2mac_dat_b_data55           (sc2mac_dat_b_src_data55[7:0])   //|> w
  ,.sc2mac_dat_b_data56           (sc2mac_dat_b_src_data56[7:0])   //|> w
  ,.sc2mac_dat_b_data57           (sc2mac_dat_b_src_data57[7:0])   //|> w
  ,.sc2mac_dat_b_data58           (sc2mac_dat_b_src_data58[7:0])   //|> w
  ,.sc2mac_dat_b_data59           (sc2mac_dat_b_src_data59[7:0])   //|> w
  ,.sc2mac_dat_b_data60           (sc2mac_dat_b_src_data60[7:0])   //|> w
  ,.sc2mac_dat_b_data61           (sc2mac_dat_b_src_data61[7:0])   //|> w
  ,.sc2mac_dat_b_data62           (sc2mac_dat_b_src_data62[7:0])   //|> w
  ,.sc2mac_dat_b_data63           (sc2mac_dat_b_src_data63[7:0])   //|> w
  ,.sc2mac_dat_b_data64           (sc2mac_dat_b_src_data64[7:0])   //|> w
  ,.sc2mac_dat_b_data65           (sc2mac_dat_b_src_data65[7:0])   //|> w
  ,.sc2mac_dat_b_data66           (sc2mac_dat_b_src_data66[7:0])   //|> w
  ,.sc2mac_dat_b_data67           (sc2mac_dat_b_src_data67[7:0])   //|> w
  ,.sc2mac_dat_b_data68           (sc2mac_dat_b_src_data68[7:0])   //|> w
  ,.sc2mac_dat_b_data69           (sc2mac_dat_b_src_data69[7:0])   //|> w
  ,.sc2mac_dat_b_data70           (sc2mac_dat_b_src_data70[7:0])   //|> w
  ,.sc2mac_dat_b_data71           (sc2mac_dat_b_src_data71[7:0])   //|> w
  ,.sc2mac_dat_b_data72           (sc2mac_dat_b_src_data72[7:0])   //|> w
  ,.sc2mac_dat_b_data73           (sc2mac_dat_b_src_data73[7:0])   //|> w
  ,.sc2mac_dat_b_data74           (sc2mac_dat_b_src_data74[7:0])   //|> w
  ,.sc2mac_dat_b_data75           (sc2mac_dat_b_src_data75[7:0])   //|> w
  ,.sc2mac_dat_b_data76           (sc2mac_dat_b_src_data76[7:0])   //|> w
  ,.sc2mac_dat_b_data77           (sc2mac_dat_b_src_data77[7:0])   //|> w
  ,.sc2mac_dat_b_data78           (sc2mac_dat_b_src_data78[7:0])   //|> w
  ,.sc2mac_dat_b_data79           (sc2mac_dat_b_src_data79[7:0])   //|> w
  ,.sc2mac_dat_b_data80           (sc2mac_dat_b_src_data80[7:0])   //|> w
  ,.sc2mac_dat_b_data81           (sc2mac_dat_b_src_data81[7:0])   //|> w
  ,.sc2mac_dat_b_data82           (sc2mac_dat_b_src_data82[7:0])   //|> w
  ,.sc2mac_dat_b_data83           (sc2mac_dat_b_src_data83[7:0])   //|> w
  ,.sc2mac_dat_b_data84           (sc2mac_dat_b_src_data84[7:0])   //|> w
  ,.sc2mac_dat_b_data85           (sc2mac_dat_b_src_data85[7:0])   //|> w
  ,.sc2mac_dat_b_data86           (sc2mac_dat_b_src_data86[7:0])   //|> w
  ,.sc2mac_dat_b_data87           (sc2mac_dat_b_src_data87[7:0])   //|> w
  ,.sc2mac_dat_b_data88           (sc2mac_dat_b_src_data88[7:0])   //|> w
  ,.sc2mac_dat_b_data89           (sc2mac_dat_b_src_data89[7:0])   //|> w
  ,.sc2mac_dat_b_data90           (sc2mac_dat_b_src_data90[7:0])   //|> w
  ,.sc2mac_dat_b_data91           (sc2mac_dat_b_src_data91[7:0])   //|> w
  ,.sc2mac_dat_b_data92           (sc2mac_dat_b_src_data92[7:0])   //|> w
  ,.sc2mac_dat_b_data93           (sc2mac_dat_b_src_data93[7:0])   //|> w
  ,.sc2mac_dat_b_data94           (sc2mac_dat_b_src_data94[7:0])   //|> w
  ,.sc2mac_dat_b_data95           (sc2mac_dat_b_src_data95[7:0])   //|> w
  ,.sc2mac_dat_b_data96           (sc2mac_dat_b_src_data96[7:0])   //|> w
  ,.sc2mac_dat_b_data97           (sc2mac_dat_b_src_data97[7:0])   //|> w
  ,.sc2mac_dat_b_data98           (sc2mac_dat_b_src_data98[7:0])   //|> w
  ,.sc2mac_dat_b_data99           (sc2mac_dat_b_src_data99[7:0])   //|> w
  ,.sc2mac_dat_b_data100          (sc2mac_dat_b_src_data100[7:0])  //|> w
  ,.sc2mac_dat_b_data101          (sc2mac_dat_b_src_data101[7:0])  //|> w
  ,.sc2mac_dat_b_data102          (sc2mac_dat_b_src_data102[7:0])  //|> w
  ,.sc2mac_dat_b_data103          (sc2mac_dat_b_src_data103[7:0])  //|> w
  ,.sc2mac_dat_b_data104          (sc2mac_dat_b_src_data104[7:0])  //|> w
  ,.sc2mac_dat_b_data105          (sc2mac_dat_b_src_data105[7:0])  //|> w
  ,.sc2mac_dat_b_data106          (sc2mac_dat_b_src_data106[7:0])  //|> w
  ,.sc2mac_dat_b_data107          (sc2mac_dat_b_src_data107[7:0])  //|> w
  ,.sc2mac_dat_b_data108          (sc2mac_dat_b_src_data108[7:0])  //|> w
  ,.sc2mac_dat_b_data109          (sc2mac_dat_b_src_data109[7:0])  //|> w
  ,.sc2mac_dat_b_data110          (sc2mac_dat_b_src_data110[7:0])  //|> w
  ,.sc2mac_dat_b_data111          (sc2mac_dat_b_src_data111[7:0])  //|> w
  ,.sc2mac_dat_b_data112          (sc2mac_dat_b_src_data112[7:0])  //|> w
  ,.sc2mac_dat_b_data113          (sc2mac_dat_b_src_data113[7:0])  //|> w
  ,.sc2mac_dat_b_data114          (sc2mac_dat_b_src_data114[7:0])  //|> w
  ,.sc2mac_dat_b_data115          (sc2mac_dat_b_src_data115[7:0])  //|> w
  ,.sc2mac_dat_b_data116          (sc2mac_dat_b_src_data116[7:0])  //|> w
  ,.sc2mac_dat_b_data117          (sc2mac_dat_b_src_data117[7:0])  //|> w
  ,.sc2mac_dat_b_data118          (sc2mac_dat_b_src_data118[7:0])  //|> w
  ,.sc2mac_dat_b_data119          (sc2mac_dat_b_src_data119[7:0])  //|> w
  ,.sc2mac_dat_b_data120          (sc2mac_dat_b_src_data120[7:0])  //|> w
  ,.sc2mac_dat_b_data121          (sc2mac_dat_b_src_data121[7:0])  //|> w
  ,.sc2mac_dat_b_data122          (sc2mac_dat_b_src_data122[7:0])  //|> w
  ,.sc2mac_dat_b_data123          (sc2mac_dat_b_src_data123[7:0])  //|> w
  ,.sc2mac_dat_b_data124          (sc2mac_dat_b_src_data124[7:0])  //|> w
  ,.sc2mac_dat_b_data125          (sc2mac_dat_b_src_data125[7:0])  //|> w
  ,.sc2mac_dat_b_data126          (sc2mac_dat_b_src_data126[7:0])  //|> w
  ,.sc2mac_dat_b_data127          (sc2mac_dat_b_src_data127[7:0])  //|> w
  ,.sc2mac_dat_b_pd               (sc2mac_dat_b_src_pd[8:0])       //|> w
  ,.sc2mac_wt_a_pvld              (sc2mac_wt_a_src_pvld)           //|> o
  ,.sc2mac_wt_a_mask              (sc2mac_wt_a_src_mask[127:0])    //|> o
  ,.sc2mac_wt_a_data0             (sc2mac_wt_a_src_data0[7:0])     //|> o
  ,.sc2mac_wt_a_data1             (sc2mac_wt_a_src_data1[7:0])     //|> o
  ,.sc2mac_wt_a_data2             (sc2mac_wt_a_src_data2[7:0])     //|> o
  ,.sc2mac_wt_a_data3             (sc2mac_wt_a_src_data3[7:0])     //|> o
  ,.sc2mac_wt_a_data4             (sc2mac_wt_a_src_data4[7:0])     //|> o
  ,.sc2mac_wt_a_data5             (sc2mac_wt_a_src_data5[7:0])     //|> o
  ,.sc2mac_wt_a_data6             (sc2mac_wt_a_src_data6[7:0])     //|> o
  ,.sc2mac_wt_a_data7             (sc2mac_wt_a_src_data7[7:0])     //|> o
  ,.sc2mac_wt_a_data8             (sc2mac_wt_a_src_data8[7:0])     //|> o
  ,.sc2mac_wt_a_data9             (sc2mac_wt_a_src_data9[7:0])     //|> o
  ,.sc2mac_wt_a_data10            (sc2mac_wt_a_src_data10[7:0])    //|> o
  ,.sc2mac_wt_a_data11            (sc2mac_wt_a_src_data11[7:0])    //|> o
  ,.sc2mac_wt_a_data12            (sc2mac_wt_a_src_data12[7:0])    //|> o
  ,.sc2mac_wt_a_data13            (sc2mac_wt_a_src_data13[7:0])    //|> o
  ,.sc2mac_wt_a_data14            (sc2mac_wt_a_src_data14[7:0])    //|> o
  ,.sc2mac_wt_a_data15            (sc2mac_wt_a_src_data15[7:0])    //|> o
  ,.sc2mac_wt_a_data16            (sc2mac_wt_a_src_data16[7:0])    //|> o
  ,.sc2mac_wt_a_data17            (sc2mac_wt_a_src_data17[7:0])    //|> o
  ,.sc2mac_wt_a_data18            (sc2mac_wt_a_src_data18[7:0])    //|> o
  ,.sc2mac_wt_a_data19            (sc2mac_wt_a_src_data19[7:0])    //|> o
  ,.sc2mac_wt_a_data20            (sc2mac_wt_a_src_data20[7:0])    //|> o
  ,.sc2mac_wt_a_data21            (sc2mac_wt_a_src_data21[7:0])    //|> o
  ,.sc2mac_wt_a_data22            (sc2mac_wt_a_src_data22[7:0])    //|> o
  ,.sc2mac_wt_a_data23            (sc2mac_wt_a_src_data23[7:0])    //|> o
  ,.sc2mac_wt_a_data24            (sc2mac_wt_a_src_data24[7:0])    //|> o
  ,.sc2mac_wt_a_data25            (sc2mac_wt_a_src_data25[7:0])    //|> o
  ,.sc2mac_wt_a_data26            (sc2mac_wt_a_src_data26[7:0])    //|> o
  ,.sc2mac_wt_a_data27            (sc2mac_wt_a_src_data27[7:0])    //|> o
  ,.sc2mac_wt_a_data28            (sc2mac_wt_a_src_data28[7:0])    //|> o
  ,.sc2mac_wt_a_data29            (sc2mac_wt_a_src_data29[7:0])    //|> o
  ,.sc2mac_wt_a_data30            (sc2mac_wt_a_src_data30[7:0])    //|> o
  ,.sc2mac_wt_a_data31            (sc2mac_wt_a_src_data31[7:0])    //|> o
  ,.sc2mac_wt_a_data32            (sc2mac_wt_a_src_data32[7:0])    //|> o
  ,.sc2mac_wt_a_data33            (sc2mac_wt_a_src_data33[7:0])    //|> o
  ,.sc2mac_wt_a_data34            (sc2mac_wt_a_src_data34[7:0])    //|> o
  ,.sc2mac_wt_a_data35            (sc2mac_wt_a_src_data35[7:0])    //|> o
  ,.sc2mac_wt_a_data36            (sc2mac_wt_a_src_data36[7:0])    //|> o
  ,.sc2mac_wt_a_data37            (sc2mac_wt_a_src_data37[7:0])    //|> o
  ,.sc2mac_wt_a_data38            (sc2mac_wt_a_src_data38[7:0])    //|> o
  ,.sc2mac_wt_a_data39            (sc2mac_wt_a_src_data39[7:0])    //|> o
  ,.sc2mac_wt_a_data40            (sc2mac_wt_a_src_data40[7:0])    //|> o
  ,.sc2mac_wt_a_data41            (sc2mac_wt_a_src_data41[7:0])    //|> o
  ,.sc2mac_wt_a_data42            (sc2mac_wt_a_src_data42[7:0])    //|> o
  ,.sc2mac_wt_a_data43            (sc2mac_wt_a_src_data43[7:0])    //|> o
  ,.sc2mac_wt_a_data44            (sc2mac_wt_a_src_data44[7:0])    //|> o
  ,.sc2mac_wt_a_data45            (sc2mac_wt_a_src_data45[7:0])    //|> o
  ,.sc2mac_wt_a_data46            (sc2mac_wt_a_src_data46[7:0])    //|> o
  ,.sc2mac_wt_a_data47            (sc2mac_wt_a_src_data47[7:0])    //|> o
  ,.sc2mac_wt_a_data48            (sc2mac_wt_a_src_data48[7:0])    //|> o
  ,.sc2mac_wt_a_data49            (sc2mac_wt_a_src_data49[7:0])    //|> o
  ,.sc2mac_wt_a_data50            (sc2mac_wt_a_src_data50[7:0])    //|> o
  ,.sc2mac_wt_a_data51            (sc2mac_wt_a_src_data51[7:0])    //|> o
  ,.sc2mac_wt_a_data52            (sc2mac_wt_a_src_data52[7:0])    //|> o
  ,.sc2mac_wt_a_data53            (sc2mac_wt_a_src_data53[7:0])    //|> o
  ,.sc2mac_wt_a_data54            (sc2mac_wt_a_src_data54[7:0])    //|> o
  ,.sc2mac_wt_a_data55            (sc2mac_wt_a_src_data55[7:0])    //|> o
  ,.sc2mac_wt_a_data56            (sc2mac_wt_a_src_data56[7:0])    //|> o
  ,.sc2mac_wt_a_data57            (sc2mac_wt_a_src_data57[7:0])    //|> o
  ,.sc2mac_wt_a_data58            (sc2mac_wt_a_src_data58[7:0])    //|> o
  ,.sc2mac_wt_a_data59            (sc2mac_wt_a_src_data59[7:0])    //|> o
  ,.sc2mac_wt_a_data60            (sc2mac_wt_a_src_data60[7:0])    //|> o
  ,.sc2mac_wt_a_data61            (sc2mac_wt_a_src_data61[7:0])    //|> o
  ,.sc2mac_wt_a_data62            (sc2mac_wt_a_src_data62[7:0])    //|> o
  ,.sc2mac_wt_a_data63            (sc2mac_wt_a_src_data63[7:0])    //|> o
  ,.sc2mac_wt_a_data64            (sc2mac_wt_a_src_data64[7:0])    //|> o
  ,.sc2mac_wt_a_data65            (sc2mac_wt_a_src_data65[7:0])    //|> o
  ,.sc2mac_wt_a_data66            (sc2mac_wt_a_src_data66[7:0])    //|> o
  ,.sc2mac_wt_a_data67            (sc2mac_wt_a_src_data67[7:0])    //|> o
  ,.sc2mac_wt_a_data68            (sc2mac_wt_a_src_data68[7:0])    //|> o
  ,.sc2mac_wt_a_data69            (sc2mac_wt_a_src_data69[7:0])    //|> o
  ,.sc2mac_wt_a_data70            (sc2mac_wt_a_src_data70[7:0])    //|> o
  ,.sc2mac_wt_a_data71            (sc2mac_wt_a_src_data71[7:0])    //|> o
  ,.sc2mac_wt_a_data72            (sc2mac_wt_a_src_data72[7:0])    //|> o
  ,.sc2mac_wt_a_data73            (sc2mac_wt_a_src_data73[7:0])    //|> o
  ,.sc2mac_wt_a_data74            (sc2mac_wt_a_src_data74[7:0])    //|> o
  ,.sc2mac_wt_a_data75            (sc2mac_wt_a_src_data75[7:0])    //|> o
  ,.sc2mac_wt_a_data76            (sc2mac_wt_a_src_data76[7:0])    //|> o
  ,.sc2mac_wt_a_data77            (sc2mac_wt_a_src_data77[7:0])    //|> o
  ,.sc2mac_wt_a_data78            (sc2mac_wt_a_src_data78[7:0])    //|> o
  ,.sc2mac_wt_a_data79            (sc2mac_wt_a_src_data79[7:0])    //|> o
  ,.sc2mac_wt_a_data80            (sc2mac_wt_a_src_data80[7:0])    //|> o
  ,.sc2mac_wt_a_data81            (sc2mac_wt_a_src_data81[7:0])    //|> o
  ,.sc2mac_wt_a_data82            (sc2mac_wt_a_src_data82[7:0])    //|> o
  ,.sc2mac_wt_a_data83            (sc2mac_wt_a_src_data83[7:0])    //|> o
  ,.sc2mac_wt_a_data84            (sc2mac_wt_a_src_data84[7:0])    //|> o
  ,.sc2mac_wt_a_data85            (sc2mac_wt_a_src_data85[7:0])    //|> o
  ,.sc2mac_wt_a_data86            (sc2mac_wt_a_src_data86[7:0])    //|> o
  ,.sc2mac_wt_a_data87            (sc2mac_wt_a_src_data87[7:0])    //|> o
  ,.sc2mac_wt_a_data88            (sc2mac_wt_a_src_data88[7:0])    //|> o
  ,.sc2mac_wt_a_data89            (sc2mac_wt_a_src_data89[7:0])    //|> o
  ,.sc2mac_wt_a_data90            (sc2mac_wt_a_src_data90[7:0])    //|> o
  ,.sc2mac_wt_a_data91            (sc2mac_wt_a_src_data91[7:0])    //|> o
  ,.sc2mac_wt_a_data92            (sc2mac_wt_a_src_data92[7:0])    //|> o
  ,.sc2mac_wt_a_data93            (sc2mac_wt_a_src_data93[7:0])    //|> o
  ,.sc2mac_wt_a_data94            (sc2mac_wt_a_src_data94[7:0])    //|> o
  ,.sc2mac_wt_a_data95            (sc2mac_wt_a_src_data95[7:0])    //|> o
  ,.sc2mac_wt_a_data96            (sc2mac_wt_a_src_data96[7:0])    //|> o
  ,.sc2mac_wt_a_data97            (sc2mac_wt_a_src_data97[7:0])    //|> o
  ,.sc2mac_wt_a_data98            (sc2mac_wt_a_src_data98[7:0])    //|> o
  ,.sc2mac_wt_a_data99            (sc2mac_wt_a_src_data99[7:0])    //|> o
  ,.sc2mac_wt_a_data100           (sc2mac_wt_a_src_data100[7:0])   //|> o
  ,.sc2mac_wt_a_data101           (sc2mac_wt_a_src_data101[7:0])   //|> o
  ,.sc2mac_wt_a_data102           (sc2mac_wt_a_src_data102[7:0])   //|> o
  ,.sc2mac_wt_a_data103           (sc2mac_wt_a_src_data103[7:0])   //|> o
  ,.sc2mac_wt_a_data104           (sc2mac_wt_a_src_data104[7:0])   //|> o
  ,.sc2mac_wt_a_data105           (sc2mac_wt_a_src_data105[7:0])   //|> o
  ,.sc2mac_wt_a_data106           (sc2mac_wt_a_src_data106[7:0])   //|> o
  ,.sc2mac_wt_a_data107           (sc2mac_wt_a_src_data107[7:0])   //|> o
  ,.sc2mac_wt_a_data108           (sc2mac_wt_a_src_data108[7:0])   //|> o
  ,.sc2mac_wt_a_data109           (sc2mac_wt_a_src_data109[7:0])   //|> o
  ,.sc2mac_wt_a_data110           (sc2mac_wt_a_src_data110[7:0])   //|> o
  ,.sc2mac_wt_a_data111           (sc2mac_wt_a_src_data111[7:0])   //|> o
  ,.sc2mac_wt_a_data112           (sc2mac_wt_a_src_data112[7:0])   //|> o
  ,.sc2mac_wt_a_data113           (sc2mac_wt_a_src_data113[7:0])   //|> o
  ,.sc2mac_wt_a_data114           (sc2mac_wt_a_src_data114[7:0])   //|> o
  ,.sc2mac_wt_a_data115           (sc2mac_wt_a_src_data115[7:0])   //|> o
  ,.sc2mac_wt_a_data116           (sc2mac_wt_a_src_data116[7:0])   //|> o
  ,.sc2mac_wt_a_data117           (sc2mac_wt_a_src_data117[7:0])   //|> o
  ,.sc2mac_wt_a_data118           (sc2mac_wt_a_src_data118[7:0])   //|> o
  ,.sc2mac_wt_a_data119           (sc2mac_wt_a_src_data119[7:0])   //|> o
  ,.sc2mac_wt_a_data120           (sc2mac_wt_a_src_data120[7:0])   //|> o
  ,.sc2mac_wt_a_data121           (sc2mac_wt_a_src_data121[7:0])   //|> o
  ,.sc2mac_wt_a_data122           (sc2mac_wt_a_src_data122[7:0])   //|> o
  ,.sc2mac_wt_a_data123           (sc2mac_wt_a_src_data123[7:0])   //|> o
  ,.sc2mac_wt_a_data124           (sc2mac_wt_a_src_data124[7:0])   //|> o
  ,.sc2mac_wt_a_data125           (sc2mac_wt_a_src_data125[7:0])   //|> o
  ,.sc2mac_wt_a_data126           (sc2mac_wt_a_src_data126[7:0])   //|> o
  ,.sc2mac_wt_a_data127           (sc2mac_wt_a_src_data127[7:0])   //|> o
  ,.sc2mac_wt_a_sel               (sc2mac_wt_a_src_sel[7:0])       //|> o
  ,.sc2mac_wt_b_pvld              (sc2mac_wt_b_src_pvld)           //|> w
  ,.sc2mac_wt_b_mask              (sc2mac_wt_b_src_mask[127:0])    //|> w
  ,.sc2mac_wt_b_data0             (sc2mac_wt_b_src_data0[7:0])     //|> w
  ,.sc2mac_wt_b_data1             (sc2mac_wt_b_src_data1[7:0])     //|> w
  ,.sc2mac_wt_b_data2             (sc2mac_wt_b_src_data2[7:0])     //|> w
  ,.sc2mac_wt_b_data3             (sc2mac_wt_b_src_data3[7:0])     //|> w
  ,.sc2mac_wt_b_data4             (sc2mac_wt_b_src_data4[7:0])     //|> w
  ,.sc2mac_wt_b_data5             (sc2mac_wt_b_src_data5[7:0])     //|> w
  ,.sc2mac_wt_b_data6             (sc2mac_wt_b_src_data6[7:0])     //|> w
  ,.sc2mac_wt_b_data7             (sc2mac_wt_b_src_data7[7:0])     //|> w
  ,.sc2mac_wt_b_data8             (sc2mac_wt_b_src_data8[7:0])     //|> w
  ,.sc2mac_wt_b_data9             (sc2mac_wt_b_src_data9[7:0])     //|> w
  ,.sc2mac_wt_b_data10            (sc2mac_wt_b_src_data10[7:0])    //|> w
  ,.sc2mac_wt_b_data11            (sc2mac_wt_b_src_data11[7:0])    //|> w
  ,.sc2mac_wt_b_data12            (sc2mac_wt_b_src_data12[7:0])    //|> w
  ,.sc2mac_wt_b_data13            (sc2mac_wt_b_src_data13[7:0])    //|> w
  ,.sc2mac_wt_b_data14            (sc2mac_wt_b_src_data14[7:0])    //|> w
  ,.sc2mac_wt_b_data15            (sc2mac_wt_b_src_data15[7:0])    //|> w
  ,.sc2mac_wt_b_data16            (sc2mac_wt_b_src_data16[7:0])    //|> w
  ,.sc2mac_wt_b_data17            (sc2mac_wt_b_src_data17[7:0])    //|> w
  ,.sc2mac_wt_b_data18            (sc2mac_wt_b_src_data18[7:0])    //|> w
  ,.sc2mac_wt_b_data19            (sc2mac_wt_b_src_data19[7:0])    //|> w
  ,.sc2mac_wt_b_data20            (sc2mac_wt_b_src_data20[7:0])    //|> w
  ,.sc2mac_wt_b_data21            (sc2mac_wt_b_src_data21[7:0])    //|> w
  ,.sc2mac_wt_b_data22            (sc2mac_wt_b_src_data22[7:0])    //|> w
  ,.sc2mac_wt_b_data23            (sc2mac_wt_b_src_data23[7:0])    //|> w
  ,.sc2mac_wt_b_data24            (sc2mac_wt_b_src_data24[7:0])    //|> w
  ,.sc2mac_wt_b_data25            (sc2mac_wt_b_src_data25[7:0])    //|> w
  ,.sc2mac_wt_b_data26            (sc2mac_wt_b_src_data26[7:0])    //|> w
  ,.sc2mac_wt_b_data27            (sc2mac_wt_b_src_data27[7:0])    //|> w
  ,.sc2mac_wt_b_data28            (sc2mac_wt_b_src_data28[7:0])    //|> w
  ,.sc2mac_wt_b_data29            (sc2mac_wt_b_src_data29[7:0])    //|> w
  ,.sc2mac_wt_b_data30            (sc2mac_wt_b_src_data30[7:0])    //|> w
  ,.sc2mac_wt_b_data31            (sc2mac_wt_b_src_data31[7:0])    //|> w
  ,.sc2mac_wt_b_data32            (sc2mac_wt_b_src_data32[7:0])    //|> w
  ,.sc2mac_wt_b_data33            (sc2mac_wt_b_src_data33[7:0])    //|> w
  ,.sc2mac_wt_b_data34            (sc2mac_wt_b_src_data34[7:0])    //|> w
  ,.sc2mac_wt_b_data35            (sc2mac_wt_b_src_data35[7:0])    //|> w
  ,.sc2mac_wt_b_data36            (sc2mac_wt_b_src_data36[7:0])    //|> w
  ,.sc2mac_wt_b_data37            (sc2mac_wt_b_src_data37[7:0])    //|> w
  ,.sc2mac_wt_b_data38            (sc2mac_wt_b_src_data38[7:0])    //|> w
  ,.sc2mac_wt_b_data39            (sc2mac_wt_b_src_data39[7:0])    //|> w
  ,.sc2mac_wt_b_data40            (sc2mac_wt_b_src_data40[7:0])    //|> w
  ,.sc2mac_wt_b_data41            (sc2mac_wt_b_src_data41[7:0])    //|> w
  ,.sc2mac_wt_b_data42            (sc2mac_wt_b_src_data42[7:0])    //|> w
  ,.sc2mac_wt_b_data43            (sc2mac_wt_b_src_data43[7:0])    //|> w
  ,.sc2mac_wt_b_data44            (sc2mac_wt_b_src_data44[7:0])    //|> w
  ,.sc2mac_wt_b_data45            (sc2mac_wt_b_src_data45[7:0])    //|> w
  ,.sc2mac_wt_b_data46            (sc2mac_wt_b_src_data46[7:0])    //|> w
  ,.sc2mac_wt_b_data47            (sc2mac_wt_b_src_data47[7:0])    //|> w
  ,.sc2mac_wt_b_data48            (sc2mac_wt_b_src_data48[7:0])    //|> w
  ,.sc2mac_wt_b_data49            (sc2mac_wt_b_src_data49[7:0])    //|> w
  ,.sc2mac_wt_b_data50            (sc2mac_wt_b_src_data50[7:0])    //|> w
  ,.sc2mac_wt_b_data51            (sc2mac_wt_b_src_data51[7:0])    //|> w
  ,.sc2mac_wt_b_data52            (sc2mac_wt_b_src_data52[7:0])    //|> w
  ,.sc2mac_wt_b_data53            (sc2mac_wt_b_src_data53[7:0])    //|> w
  ,.sc2mac_wt_b_data54            (sc2mac_wt_b_src_data54[7:0])    //|> w
  ,.sc2mac_wt_b_data55            (sc2mac_wt_b_src_data55[7:0])    //|> w
  ,.sc2mac_wt_b_data56            (sc2mac_wt_b_src_data56[7:0])    //|> w
  ,.sc2mac_wt_b_data57            (sc2mac_wt_b_src_data57[7:0])    //|> w
  ,.sc2mac_wt_b_data58            (sc2mac_wt_b_src_data58[7:0])    //|> w
  ,.sc2mac_wt_b_data59            (sc2mac_wt_b_src_data59[7:0])    //|> w
  ,.sc2mac_wt_b_data60            (sc2mac_wt_b_src_data60[7:0])    //|> w
  ,.sc2mac_wt_b_data61            (sc2mac_wt_b_src_data61[7:0])    //|> w
  ,.sc2mac_wt_b_data62            (sc2mac_wt_b_src_data62[7:0])    //|> w
  ,.sc2mac_wt_b_data63            (sc2mac_wt_b_src_data63[7:0])    //|> w
  ,.sc2mac_wt_b_data64            (sc2mac_wt_b_src_data64[7:0])    //|> w
  ,.sc2mac_wt_b_data65            (sc2mac_wt_b_src_data65[7:0])    //|> w
  ,.sc2mac_wt_b_data66            (sc2mac_wt_b_src_data66[7:0])    //|> w
  ,.sc2mac_wt_b_data67            (sc2mac_wt_b_src_data67[7:0])    //|> w
  ,.sc2mac_wt_b_data68            (sc2mac_wt_b_src_data68[7:0])    //|> w
  ,.sc2mac_wt_b_data69            (sc2mac_wt_b_src_data69[7:0])    //|> w
  ,.sc2mac_wt_b_data70            (sc2mac_wt_b_src_data70[7:0])    //|> w
  ,.sc2mac_wt_b_data71            (sc2mac_wt_b_src_data71[7:0])    //|> w
  ,.sc2mac_wt_b_data72            (sc2mac_wt_b_src_data72[7:0])    //|> w
  ,.sc2mac_wt_b_data73            (sc2mac_wt_b_src_data73[7:0])    //|> w
  ,.sc2mac_wt_b_data74            (sc2mac_wt_b_src_data74[7:0])    //|> w
  ,.sc2mac_wt_b_data75            (sc2mac_wt_b_src_data75[7:0])    //|> w
  ,.sc2mac_wt_b_data76            (sc2mac_wt_b_src_data76[7:0])    //|> w
  ,.sc2mac_wt_b_data77            (sc2mac_wt_b_src_data77[7:0])    //|> w
  ,.sc2mac_wt_b_data78            (sc2mac_wt_b_src_data78[7:0])    //|> w
  ,.sc2mac_wt_b_data79            (sc2mac_wt_b_src_data79[7:0])    //|> w
  ,.sc2mac_wt_b_data80            (sc2mac_wt_b_src_data80[7:0])    //|> w
  ,.sc2mac_wt_b_data81            (sc2mac_wt_b_src_data81[7:0])    //|> w
  ,.sc2mac_wt_b_data82            (sc2mac_wt_b_src_data82[7:0])    //|> w
  ,.sc2mac_wt_b_data83            (sc2mac_wt_b_src_data83[7:0])    //|> w
  ,.sc2mac_wt_b_data84            (sc2mac_wt_b_src_data84[7:0])    //|> w
  ,.sc2mac_wt_b_data85            (sc2mac_wt_b_src_data85[7:0])    //|> w
  ,.sc2mac_wt_b_data86            (sc2mac_wt_b_src_data86[7:0])    //|> w
  ,.sc2mac_wt_b_data87            (sc2mac_wt_b_src_data87[7:0])    //|> w
  ,.sc2mac_wt_b_data88            (sc2mac_wt_b_src_data88[7:0])    //|> w
  ,.sc2mac_wt_b_data89            (sc2mac_wt_b_src_data89[7:0])    //|> w
  ,.sc2mac_wt_b_data90            (sc2mac_wt_b_src_data90[7:0])    //|> w
  ,.sc2mac_wt_b_data91            (sc2mac_wt_b_src_data91[7:0])    //|> w
  ,.sc2mac_wt_b_data92            (sc2mac_wt_b_src_data92[7:0])    //|> w
  ,.sc2mac_wt_b_data93            (sc2mac_wt_b_src_data93[7:0])    //|> w
  ,.sc2mac_wt_b_data94            (sc2mac_wt_b_src_data94[7:0])    //|> w
  ,.sc2mac_wt_b_data95            (sc2mac_wt_b_src_data95[7:0])    //|> w
  ,.sc2mac_wt_b_data96            (sc2mac_wt_b_src_data96[7:0])    //|> w
  ,.sc2mac_wt_b_data97            (sc2mac_wt_b_src_data97[7:0])    //|> w
  ,.sc2mac_wt_b_data98            (sc2mac_wt_b_src_data98[7:0])    //|> w
  ,.sc2mac_wt_b_data99            (sc2mac_wt_b_src_data99[7:0])    //|> w
  ,.sc2mac_wt_b_data100           (sc2mac_wt_b_src_data100[7:0])   //|> w
  ,.sc2mac_wt_b_data101           (sc2mac_wt_b_src_data101[7:0])   //|> w
  ,.sc2mac_wt_b_data102           (sc2mac_wt_b_src_data102[7:0])   //|> w
  ,.sc2mac_wt_b_data103           (sc2mac_wt_b_src_data103[7:0])   //|> w
  ,.sc2mac_wt_b_data104           (sc2mac_wt_b_src_data104[7:0])   //|> w
  ,.sc2mac_wt_b_data105           (sc2mac_wt_b_src_data105[7:0])   //|> w
  ,.sc2mac_wt_b_data106           (sc2mac_wt_b_src_data106[7:0])   //|> w
  ,.sc2mac_wt_b_data107           (sc2mac_wt_b_src_data107[7:0])   //|> w
  ,.sc2mac_wt_b_data108           (sc2mac_wt_b_src_data108[7:0])   //|> w
  ,.sc2mac_wt_b_data109           (sc2mac_wt_b_src_data109[7:0])   //|> w
  ,.sc2mac_wt_b_data110           (sc2mac_wt_b_src_data110[7:0])   //|> w
  ,.sc2mac_wt_b_data111           (sc2mac_wt_b_src_data111[7:0])   //|> w
  ,.sc2mac_wt_b_data112           (sc2mac_wt_b_src_data112[7:0])   //|> w
  ,.sc2mac_wt_b_data113           (sc2mac_wt_b_src_data113[7:0])   //|> w
  ,.sc2mac_wt_b_data114           (sc2mac_wt_b_src_data114[7:0])   //|> w
  ,.sc2mac_wt_b_data115           (sc2mac_wt_b_src_data115[7:0])   //|> w
  ,.sc2mac_wt_b_data116           (sc2mac_wt_b_src_data116[7:0])   //|> w
  ,.sc2mac_wt_b_data117           (sc2mac_wt_b_src_data117[7:0])   //|> w
  ,.sc2mac_wt_b_data118           (sc2mac_wt_b_src_data118[7:0])   //|> w
  ,.sc2mac_wt_b_data119           (sc2mac_wt_b_src_data119[7:0])   //|> w
  ,.sc2mac_wt_b_data120           (sc2mac_wt_b_src_data120[7:0])   //|> w
  ,.sc2mac_wt_b_data121           (sc2mac_wt_b_src_data121[7:0])   //|> w
  ,.sc2mac_wt_b_data122           (sc2mac_wt_b_src_data122[7:0])   //|> w
  ,.sc2mac_wt_b_data123           (sc2mac_wt_b_src_data123[7:0])   //|> w
  ,.sc2mac_wt_b_data124           (sc2mac_wt_b_src_data124[7:0])   //|> w
  ,.sc2mac_wt_b_data125           (sc2mac_wt_b_src_data125[7:0])   //|> w
  ,.sc2mac_wt_b_data126           (sc2mac_wt_b_src_data126[7:0])   //|> w
  ,.sc2mac_wt_b_data127           (sc2mac_wt_b_src_data127[7:0])   //|> w
  ,.sc2mac_wt_b_sel               (sc2mac_wt_b_src_sel[7:0])       //|> w
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)                //|< w
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels[13:0])       //|< w
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries[11:0])       //|< w
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries[8:0])       //|< w
  ,.sc2cdma_wt_updt               (sc2cdma_wt_updt)                //|> w
  ,.sc2cdma_wt_kernels            (sc2cdma_wt_kernels[13:0])       //|> w
  ,.sc2cdma_wt_entries            (sc2cdma_wt_entries[11:0])       //|> w
  ,.sc2cdma_wmb_entries           (sc2cdma_wmb_entries[8:0])       //|> w
  ,.dla_clk_ovr_on_sync           (csc_dla_clk_ovr_on_sync)        //|< w
  ,.global_clk_ovr_on_sync        (csc_global_clk_ovr_on_sync)     //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)  //|< i
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    OBS                                         //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_C_obs;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path csc->cmac_b                   //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csc2cmac_b u_NV_NVDLA_RT_csc2cmac_b (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.sc2mac_wt_src_pvld            (sc2mac_wt_b_src_pvld)           //|< w
  ,.sc2mac_wt_src_mask            (sc2mac_wt_b_src_mask[127:0])    //|< w
  ,.sc2mac_wt_src_data0           (sc2mac_wt_b_src_data0[7:0])     //|< w
  ,.sc2mac_wt_src_data1           (sc2mac_wt_b_src_data1[7:0])     //|< w
  ,.sc2mac_wt_src_data2           (sc2mac_wt_b_src_data2[7:0])     //|< w
  ,.sc2mac_wt_src_data3           (sc2mac_wt_b_src_data3[7:0])     //|< w
  ,.sc2mac_wt_src_data4           (sc2mac_wt_b_src_data4[7:0])     //|< w
  ,.sc2mac_wt_src_data5           (sc2mac_wt_b_src_data5[7:0])     //|< w
  ,.sc2mac_wt_src_data6           (sc2mac_wt_b_src_data6[7:0])     //|< w
  ,.sc2mac_wt_src_data7           (sc2mac_wt_b_src_data7[7:0])     //|< w
  ,.sc2mac_wt_src_data8           (sc2mac_wt_b_src_data8[7:0])     //|< w
  ,.sc2mac_wt_src_data9           (sc2mac_wt_b_src_data9[7:0])     //|< w
  ,.sc2mac_wt_src_data10          (sc2mac_wt_b_src_data10[7:0])    //|< w
  ,.sc2mac_wt_src_data11          (sc2mac_wt_b_src_data11[7:0])    //|< w
  ,.sc2mac_wt_src_data12          (sc2mac_wt_b_src_data12[7:0])    //|< w
  ,.sc2mac_wt_src_data13          (sc2mac_wt_b_src_data13[7:0])    //|< w
  ,.sc2mac_wt_src_data14          (sc2mac_wt_b_src_data14[7:0])    //|< w
  ,.sc2mac_wt_src_data15          (sc2mac_wt_b_src_data15[7:0])    //|< w
  ,.sc2mac_wt_src_data16          (sc2mac_wt_b_src_data16[7:0])    //|< w
  ,.sc2mac_wt_src_data17          (sc2mac_wt_b_src_data17[7:0])    //|< w
  ,.sc2mac_wt_src_data18          (sc2mac_wt_b_src_data18[7:0])    //|< w
  ,.sc2mac_wt_src_data19          (sc2mac_wt_b_src_data19[7:0])    //|< w
  ,.sc2mac_wt_src_data20          (sc2mac_wt_b_src_data20[7:0])    //|< w
  ,.sc2mac_wt_src_data21          (sc2mac_wt_b_src_data21[7:0])    //|< w
  ,.sc2mac_wt_src_data22          (sc2mac_wt_b_src_data22[7:0])    //|< w
  ,.sc2mac_wt_src_data23          (sc2mac_wt_b_src_data23[7:0])    //|< w
  ,.sc2mac_wt_src_data24          (sc2mac_wt_b_src_data24[7:0])    //|< w
  ,.sc2mac_wt_src_data25          (sc2mac_wt_b_src_data25[7:0])    //|< w
  ,.sc2mac_wt_src_data26          (sc2mac_wt_b_src_data26[7:0])    //|< w
  ,.sc2mac_wt_src_data27          (sc2mac_wt_b_src_data27[7:0])    //|< w
  ,.sc2mac_wt_src_data28          (sc2mac_wt_b_src_data28[7:0])    //|< w
  ,.sc2mac_wt_src_data29          (sc2mac_wt_b_src_data29[7:0])    //|< w
  ,.sc2mac_wt_src_data30          (sc2mac_wt_b_src_data30[7:0])    //|< w
  ,.sc2mac_wt_src_data31          (sc2mac_wt_b_src_data31[7:0])    //|< w
  ,.sc2mac_wt_src_data32          (sc2mac_wt_b_src_data32[7:0])    //|< w
  ,.sc2mac_wt_src_data33          (sc2mac_wt_b_src_data33[7:0])    //|< w
  ,.sc2mac_wt_src_data34          (sc2mac_wt_b_src_data34[7:0])    //|< w
  ,.sc2mac_wt_src_data35          (sc2mac_wt_b_src_data35[7:0])    //|< w
  ,.sc2mac_wt_src_data36          (sc2mac_wt_b_src_data36[7:0])    //|< w
  ,.sc2mac_wt_src_data37          (sc2mac_wt_b_src_data37[7:0])    //|< w
  ,.sc2mac_wt_src_data38          (sc2mac_wt_b_src_data38[7:0])    //|< w
  ,.sc2mac_wt_src_data39          (sc2mac_wt_b_src_data39[7:0])    //|< w
  ,.sc2mac_wt_src_data40          (sc2mac_wt_b_src_data40[7:0])    //|< w
  ,.sc2mac_wt_src_data41          (sc2mac_wt_b_src_data41[7:0])    //|< w
  ,.sc2mac_wt_src_data42          (sc2mac_wt_b_src_data42[7:0])    //|< w
  ,.sc2mac_wt_src_data43          (sc2mac_wt_b_src_data43[7:0])    //|< w
  ,.sc2mac_wt_src_data44          (sc2mac_wt_b_src_data44[7:0])    //|< w
  ,.sc2mac_wt_src_data45          (sc2mac_wt_b_src_data45[7:0])    //|< w
  ,.sc2mac_wt_src_data46          (sc2mac_wt_b_src_data46[7:0])    //|< w
  ,.sc2mac_wt_src_data47          (sc2mac_wt_b_src_data47[7:0])    //|< w
  ,.sc2mac_wt_src_data48          (sc2mac_wt_b_src_data48[7:0])    //|< w
  ,.sc2mac_wt_src_data49          (sc2mac_wt_b_src_data49[7:0])    //|< w
  ,.sc2mac_wt_src_data50          (sc2mac_wt_b_src_data50[7:0])    //|< w
  ,.sc2mac_wt_src_data51          (sc2mac_wt_b_src_data51[7:0])    //|< w
  ,.sc2mac_wt_src_data52          (sc2mac_wt_b_src_data52[7:0])    //|< w
  ,.sc2mac_wt_src_data53          (sc2mac_wt_b_src_data53[7:0])    //|< w
  ,.sc2mac_wt_src_data54          (sc2mac_wt_b_src_data54[7:0])    //|< w
  ,.sc2mac_wt_src_data55          (sc2mac_wt_b_src_data55[7:0])    //|< w
  ,.sc2mac_wt_src_data56          (sc2mac_wt_b_src_data56[7:0])    //|< w
  ,.sc2mac_wt_src_data57          (sc2mac_wt_b_src_data57[7:0])    //|< w
  ,.sc2mac_wt_src_data58          (sc2mac_wt_b_src_data58[7:0])    //|< w
  ,.sc2mac_wt_src_data59          (sc2mac_wt_b_src_data59[7:0])    //|< w
  ,.sc2mac_wt_src_data60          (sc2mac_wt_b_src_data60[7:0])    //|< w
  ,.sc2mac_wt_src_data61          (sc2mac_wt_b_src_data61[7:0])    //|< w
  ,.sc2mac_wt_src_data62          (sc2mac_wt_b_src_data62[7:0])    //|< w
  ,.sc2mac_wt_src_data63          (sc2mac_wt_b_src_data63[7:0])    //|< w
  ,.sc2mac_wt_src_data64          (sc2mac_wt_b_src_data64[7:0])    //|< w
  ,.sc2mac_wt_src_data65          (sc2mac_wt_b_src_data65[7:0])    //|< w
  ,.sc2mac_wt_src_data66          (sc2mac_wt_b_src_data66[7:0])    //|< w
  ,.sc2mac_wt_src_data67          (sc2mac_wt_b_src_data67[7:0])    //|< w
  ,.sc2mac_wt_src_data68          (sc2mac_wt_b_src_data68[7:0])    //|< w
  ,.sc2mac_wt_src_data69          (sc2mac_wt_b_src_data69[7:0])    //|< w
  ,.sc2mac_wt_src_data70          (sc2mac_wt_b_src_data70[7:0])    //|< w
  ,.sc2mac_wt_src_data71          (sc2mac_wt_b_src_data71[7:0])    //|< w
  ,.sc2mac_wt_src_data72          (sc2mac_wt_b_src_data72[7:0])    //|< w
  ,.sc2mac_wt_src_data73          (sc2mac_wt_b_src_data73[7:0])    //|< w
  ,.sc2mac_wt_src_data74          (sc2mac_wt_b_src_data74[7:0])    //|< w
  ,.sc2mac_wt_src_data75          (sc2mac_wt_b_src_data75[7:0])    //|< w
  ,.sc2mac_wt_src_data76          (sc2mac_wt_b_src_data76[7:0])    //|< w
  ,.sc2mac_wt_src_data77          (sc2mac_wt_b_src_data77[7:0])    //|< w
  ,.sc2mac_wt_src_data78          (sc2mac_wt_b_src_data78[7:0])    //|< w
  ,.sc2mac_wt_src_data79          (sc2mac_wt_b_src_data79[7:0])    //|< w
  ,.sc2mac_wt_src_data80          (sc2mac_wt_b_src_data80[7:0])    //|< w
  ,.sc2mac_wt_src_data81          (sc2mac_wt_b_src_data81[7:0])    //|< w
  ,.sc2mac_wt_src_data82          (sc2mac_wt_b_src_data82[7:0])    //|< w
  ,.sc2mac_wt_src_data83          (sc2mac_wt_b_src_data83[7:0])    //|< w
  ,.sc2mac_wt_src_data84          (sc2mac_wt_b_src_data84[7:0])    //|< w
  ,.sc2mac_wt_src_data85          (sc2mac_wt_b_src_data85[7:0])    //|< w
  ,.sc2mac_wt_src_data86          (sc2mac_wt_b_src_data86[7:0])    //|< w
  ,.sc2mac_wt_src_data87          (sc2mac_wt_b_src_data87[7:0])    //|< w
  ,.sc2mac_wt_src_data88          (sc2mac_wt_b_src_data88[7:0])    //|< w
  ,.sc2mac_wt_src_data89          (sc2mac_wt_b_src_data89[7:0])    //|< w
  ,.sc2mac_wt_src_data90          (sc2mac_wt_b_src_data90[7:0])    //|< w
  ,.sc2mac_wt_src_data91          (sc2mac_wt_b_src_data91[7:0])    //|< w
  ,.sc2mac_wt_src_data92          (sc2mac_wt_b_src_data92[7:0])    //|< w
  ,.sc2mac_wt_src_data93          (sc2mac_wt_b_src_data93[7:0])    //|< w
  ,.sc2mac_wt_src_data94          (sc2mac_wt_b_src_data94[7:0])    //|< w
  ,.sc2mac_wt_src_data95          (sc2mac_wt_b_src_data95[7:0])    //|< w
  ,.sc2mac_wt_src_data96          (sc2mac_wt_b_src_data96[7:0])    //|< w
  ,.sc2mac_wt_src_data97          (sc2mac_wt_b_src_data97[7:0])    //|< w
  ,.sc2mac_wt_src_data98          (sc2mac_wt_b_src_data98[7:0])    //|< w
  ,.sc2mac_wt_src_data99          (sc2mac_wt_b_src_data99[7:0])    //|< w
  ,.sc2mac_wt_src_data100         (sc2mac_wt_b_src_data100[7:0])   //|< w
  ,.sc2mac_wt_src_data101         (sc2mac_wt_b_src_data101[7:0])   //|< w
  ,.sc2mac_wt_src_data102         (sc2mac_wt_b_src_data102[7:0])   //|< w
  ,.sc2mac_wt_src_data103         (sc2mac_wt_b_src_data103[7:0])   //|< w
  ,.sc2mac_wt_src_data104         (sc2mac_wt_b_src_data104[7:0])   //|< w
  ,.sc2mac_wt_src_data105         (sc2mac_wt_b_src_data105[7:0])   //|< w
  ,.sc2mac_wt_src_data106         (sc2mac_wt_b_src_data106[7:0])   //|< w
  ,.sc2mac_wt_src_data107         (sc2mac_wt_b_src_data107[7:0])   //|< w
  ,.sc2mac_wt_src_data108         (sc2mac_wt_b_src_data108[7:0])   //|< w
  ,.sc2mac_wt_src_data109         (sc2mac_wt_b_src_data109[7:0])   //|< w
  ,.sc2mac_wt_src_data110         (sc2mac_wt_b_src_data110[7:0])   //|< w
  ,.sc2mac_wt_src_data111         (sc2mac_wt_b_src_data111[7:0])   //|< w
  ,.sc2mac_wt_src_data112         (sc2mac_wt_b_src_data112[7:0])   //|< w
  ,.sc2mac_wt_src_data113         (sc2mac_wt_b_src_data113[7:0])   //|< w
  ,.sc2mac_wt_src_data114         (sc2mac_wt_b_src_data114[7:0])   //|< w
  ,.sc2mac_wt_src_data115         (sc2mac_wt_b_src_data115[7:0])   //|< w
  ,.sc2mac_wt_src_data116         (sc2mac_wt_b_src_data116[7:0])   //|< w
  ,.sc2mac_wt_src_data117         (sc2mac_wt_b_src_data117[7:0])   //|< w
  ,.sc2mac_wt_src_data118         (sc2mac_wt_b_src_data118[7:0])   //|< w
  ,.sc2mac_wt_src_data119         (sc2mac_wt_b_src_data119[7:0])   //|< w
  ,.sc2mac_wt_src_data120         (sc2mac_wt_b_src_data120[7:0])   //|< w
  ,.sc2mac_wt_src_data121         (sc2mac_wt_b_src_data121[7:0])   //|< w
  ,.sc2mac_wt_src_data122         (sc2mac_wt_b_src_data122[7:0])   //|< w
  ,.sc2mac_wt_src_data123         (sc2mac_wt_b_src_data123[7:0])   //|< w
  ,.sc2mac_wt_src_data124         (sc2mac_wt_b_src_data124[7:0])   //|< w
  ,.sc2mac_wt_src_data125         (sc2mac_wt_b_src_data125[7:0])   //|< w
  ,.sc2mac_wt_src_data126         (sc2mac_wt_b_src_data126[7:0])   //|< w
  ,.sc2mac_wt_src_data127         (sc2mac_wt_b_src_data127[7:0])   //|< w
  ,.sc2mac_wt_src_sel             (sc2mac_wt_b_src_sel[7:0])       //|< w
  ,.sc2mac_dat_src_pvld           (sc2mac_dat_b_src_pvld)          //|< w
  ,.sc2mac_dat_src_mask           (sc2mac_dat_b_src_mask[127:0])   //|< w
  ,.sc2mac_dat_src_data0          (sc2mac_dat_b_src_data0[7:0])    //|< w
  ,.sc2mac_dat_src_data1          (sc2mac_dat_b_src_data1[7:0])    //|< w
  ,.sc2mac_dat_src_data2          (sc2mac_dat_b_src_data2[7:0])    //|< w
  ,.sc2mac_dat_src_data3          (sc2mac_dat_b_src_data3[7:0])    //|< w
  ,.sc2mac_dat_src_data4          (sc2mac_dat_b_src_data4[7:0])    //|< w
  ,.sc2mac_dat_src_data5          (sc2mac_dat_b_src_data5[7:0])    //|< w
  ,.sc2mac_dat_src_data6          (sc2mac_dat_b_src_data6[7:0])    //|< w
  ,.sc2mac_dat_src_data7          (sc2mac_dat_b_src_data7[7:0])    //|< w
  ,.sc2mac_dat_src_data8          (sc2mac_dat_b_src_data8[7:0])    //|< w
  ,.sc2mac_dat_src_data9          (sc2mac_dat_b_src_data9[7:0])    //|< w
  ,.sc2mac_dat_src_data10         (sc2mac_dat_b_src_data10[7:0])   //|< w
  ,.sc2mac_dat_src_data11         (sc2mac_dat_b_src_data11[7:0])   //|< w
  ,.sc2mac_dat_src_data12         (sc2mac_dat_b_src_data12[7:0])   //|< w
  ,.sc2mac_dat_src_data13         (sc2mac_dat_b_src_data13[7:0])   //|< w
  ,.sc2mac_dat_src_data14         (sc2mac_dat_b_src_data14[7:0])   //|< w
  ,.sc2mac_dat_src_data15         (sc2mac_dat_b_src_data15[7:0])   //|< w
  ,.sc2mac_dat_src_data16         (sc2mac_dat_b_src_data16[7:0])   //|< w
  ,.sc2mac_dat_src_data17         (sc2mac_dat_b_src_data17[7:0])   //|< w
  ,.sc2mac_dat_src_data18         (sc2mac_dat_b_src_data18[7:0])   //|< w
  ,.sc2mac_dat_src_data19         (sc2mac_dat_b_src_data19[7:0])   //|< w
  ,.sc2mac_dat_src_data20         (sc2mac_dat_b_src_data20[7:0])   //|< w
  ,.sc2mac_dat_src_data21         (sc2mac_dat_b_src_data21[7:0])   //|< w
  ,.sc2mac_dat_src_data22         (sc2mac_dat_b_src_data22[7:0])   //|< w
  ,.sc2mac_dat_src_data23         (sc2mac_dat_b_src_data23[7:0])   //|< w
  ,.sc2mac_dat_src_data24         (sc2mac_dat_b_src_data24[7:0])   //|< w
  ,.sc2mac_dat_src_data25         (sc2mac_dat_b_src_data25[7:0])   //|< w
  ,.sc2mac_dat_src_data26         (sc2mac_dat_b_src_data26[7:0])   //|< w
  ,.sc2mac_dat_src_data27         (sc2mac_dat_b_src_data27[7:0])   //|< w
  ,.sc2mac_dat_src_data28         (sc2mac_dat_b_src_data28[7:0])   //|< w
  ,.sc2mac_dat_src_data29         (sc2mac_dat_b_src_data29[7:0])   //|< w
  ,.sc2mac_dat_src_data30         (sc2mac_dat_b_src_data30[7:0])   //|< w
  ,.sc2mac_dat_src_data31         (sc2mac_dat_b_src_data31[7:0])   //|< w
  ,.sc2mac_dat_src_data32         (sc2mac_dat_b_src_data32[7:0])   //|< w
  ,.sc2mac_dat_src_data33         (sc2mac_dat_b_src_data33[7:0])   //|< w
  ,.sc2mac_dat_src_data34         (sc2mac_dat_b_src_data34[7:0])   //|< w
  ,.sc2mac_dat_src_data35         (sc2mac_dat_b_src_data35[7:0])   //|< w
  ,.sc2mac_dat_src_data36         (sc2mac_dat_b_src_data36[7:0])   //|< w
  ,.sc2mac_dat_src_data37         (sc2mac_dat_b_src_data37[7:0])   //|< w
  ,.sc2mac_dat_src_data38         (sc2mac_dat_b_src_data38[7:0])   //|< w
  ,.sc2mac_dat_src_data39         (sc2mac_dat_b_src_data39[7:0])   //|< w
  ,.sc2mac_dat_src_data40         (sc2mac_dat_b_src_data40[7:0])   //|< w
  ,.sc2mac_dat_src_data41         (sc2mac_dat_b_src_data41[7:0])   //|< w
  ,.sc2mac_dat_src_data42         (sc2mac_dat_b_src_data42[7:0])   //|< w
  ,.sc2mac_dat_src_data43         (sc2mac_dat_b_src_data43[7:0])   //|< w
  ,.sc2mac_dat_src_data44         (sc2mac_dat_b_src_data44[7:0])   //|< w
  ,.sc2mac_dat_src_data45         (sc2mac_dat_b_src_data45[7:0])   //|< w
  ,.sc2mac_dat_src_data46         (sc2mac_dat_b_src_data46[7:0])   //|< w
  ,.sc2mac_dat_src_data47         (sc2mac_dat_b_src_data47[7:0])   //|< w
  ,.sc2mac_dat_src_data48         (sc2mac_dat_b_src_data48[7:0])   //|< w
  ,.sc2mac_dat_src_data49         (sc2mac_dat_b_src_data49[7:0])   //|< w
  ,.sc2mac_dat_src_data50         (sc2mac_dat_b_src_data50[7:0])   //|< w
  ,.sc2mac_dat_src_data51         (sc2mac_dat_b_src_data51[7:0])   //|< w
  ,.sc2mac_dat_src_data52         (sc2mac_dat_b_src_data52[7:0])   //|< w
  ,.sc2mac_dat_src_data53         (sc2mac_dat_b_src_data53[7:0])   //|< w
  ,.sc2mac_dat_src_data54         (sc2mac_dat_b_src_data54[7:0])   //|< w
  ,.sc2mac_dat_src_data55         (sc2mac_dat_b_src_data55[7:0])   //|< w
  ,.sc2mac_dat_src_data56         (sc2mac_dat_b_src_data56[7:0])   //|< w
  ,.sc2mac_dat_src_data57         (sc2mac_dat_b_src_data57[7:0])   //|< w
  ,.sc2mac_dat_src_data58         (sc2mac_dat_b_src_data58[7:0])   //|< w
  ,.sc2mac_dat_src_data59         (sc2mac_dat_b_src_data59[7:0])   //|< w
  ,.sc2mac_dat_src_data60         (sc2mac_dat_b_src_data60[7:0])   //|< w
  ,.sc2mac_dat_src_data61         (sc2mac_dat_b_src_data61[7:0])   //|< w
  ,.sc2mac_dat_src_data62         (sc2mac_dat_b_src_data62[7:0])   //|< w
  ,.sc2mac_dat_src_data63         (sc2mac_dat_b_src_data63[7:0])   //|< w
  ,.sc2mac_dat_src_data64         (sc2mac_dat_b_src_data64[7:0])   //|< w
  ,.sc2mac_dat_src_data65         (sc2mac_dat_b_src_data65[7:0])   //|< w
  ,.sc2mac_dat_src_data66         (sc2mac_dat_b_src_data66[7:0])   //|< w
  ,.sc2mac_dat_src_data67         (sc2mac_dat_b_src_data67[7:0])   //|< w
  ,.sc2mac_dat_src_data68         (sc2mac_dat_b_src_data68[7:0])   //|< w
  ,.sc2mac_dat_src_data69         (sc2mac_dat_b_src_data69[7:0])   //|< w
  ,.sc2mac_dat_src_data70         (sc2mac_dat_b_src_data70[7:0])   //|< w
  ,.sc2mac_dat_src_data71         (sc2mac_dat_b_src_data71[7:0])   //|< w
  ,.sc2mac_dat_src_data72         (sc2mac_dat_b_src_data72[7:0])   //|< w
  ,.sc2mac_dat_src_data73         (sc2mac_dat_b_src_data73[7:0])   //|< w
  ,.sc2mac_dat_src_data74         (sc2mac_dat_b_src_data74[7:0])   //|< w
  ,.sc2mac_dat_src_data75         (sc2mac_dat_b_src_data75[7:0])   //|< w
  ,.sc2mac_dat_src_data76         (sc2mac_dat_b_src_data76[7:0])   //|< w
  ,.sc2mac_dat_src_data77         (sc2mac_dat_b_src_data77[7:0])   //|< w
  ,.sc2mac_dat_src_data78         (sc2mac_dat_b_src_data78[7:0])   //|< w
  ,.sc2mac_dat_src_data79         (sc2mac_dat_b_src_data79[7:0])   //|< w
  ,.sc2mac_dat_src_data80         (sc2mac_dat_b_src_data80[7:0])   //|< w
  ,.sc2mac_dat_src_data81         (sc2mac_dat_b_src_data81[7:0])   //|< w
  ,.sc2mac_dat_src_data82         (sc2mac_dat_b_src_data82[7:0])   //|< w
  ,.sc2mac_dat_src_data83         (sc2mac_dat_b_src_data83[7:0])   //|< w
  ,.sc2mac_dat_src_data84         (sc2mac_dat_b_src_data84[7:0])   //|< w
  ,.sc2mac_dat_src_data85         (sc2mac_dat_b_src_data85[7:0])   //|< w
  ,.sc2mac_dat_src_data86         (sc2mac_dat_b_src_data86[7:0])   //|< w
  ,.sc2mac_dat_src_data87         (sc2mac_dat_b_src_data87[7:0])   //|< w
  ,.sc2mac_dat_src_data88         (sc2mac_dat_b_src_data88[7:0])   //|< w
  ,.sc2mac_dat_src_data89         (sc2mac_dat_b_src_data89[7:0])   //|< w
  ,.sc2mac_dat_src_data90         (sc2mac_dat_b_src_data90[7:0])   //|< w
  ,.sc2mac_dat_src_data91         (sc2mac_dat_b_src_data91[7:0])   //|< w
  ,.sc2mac_dat_src_data92         (sc2mac_dat_b_src_data92[7:0])   //|< w
  ,.sc2mac_dat_src_data93         (sc2mac_dat_b_src_data93[7:0])   //|< w
  ,.sc2mac_dat_src_data94         (sc2mac_dat_b_src_data94[7:0])   //|< w
  ,.sc2mac_dat_src_data95         (sc2mac_dat_b_src_data95[7:0])   //|< w
  ,.sc2mac_dat_src_data96         (sc2mac_dat_b_src_data96[7:0])   //|< w
  ,.sc2mac_dat_src_data97         (sc2mac_dat_b_src_data97[7:0])   //|< w
  ,.sc2mac_dat_src_data98         (sc2mac_dat_b_src_data98[7:0])   //|< w
  ,.sc2mac_dat_src_data99         (sc2mac_dat_b_src_data99[7:0])   //|< w
  ,.sc2mac_dat_src_data100        (sc2mac_dat_b_src_data100[7:0])  //|< w
  ,.sc2mac_dat_src_data101        (sc2mac_dat_b_src_data101[7:0])  //|< w
  ,.sc2mac_dat_src_data102        (sc2mac_dat_b_src_data102[7:0])  //|< w
  ,.sc2mac_dat_src_data103        (sc2mac_dat_b_src_data103[7:0])  //|< w
  ,.sc2mac_dat_src_data104        (sc2mac_dat_b_src_data104[7:0])  //|< w
  ,.sc2mac_dat_src_data105        (sc2mac_dat_b_src_data105[7:0])  //|< w
  ,.sc2mac_dat_src_data106        (sc2mac_dat_b_src_data106[7:0])  //|< w
  ,.sc2mac_dat_src_data107        (sc2mac_dat_b_src_data107[7:0])  //|< w
  ,.sc2mac_dat_src_data108        (sc2mac_dat_b_src_data108[7:0])  //|< w
  ,.sc2mac_dat_src_data109        (sc2mac_dat_b_src_data109[7:0])  //|< w
  ,.sc2mac_dat_src_data110        (sc2mac_dat_b_src_data110[7:0])  //|< w
  ,.sc2mac_dat_src_data111        (sc2mac_dat_b_src_data111[7:0])  //|< w
  ,.sc2mac_dat_src_data112        (sc2mac_dat_b_src_data112[7:0])  //|< w
  ,.sc2mac_dat_src_data113        (sc2mac_dat_b_src_data113[7:0])  //|< w
  ,.sc2mac_dat_src_data114        (sc2mac_dat_b_src_data114[7:0])  //|< w
  ,.sc2mac_dat_src_data115        (sc2mac_dat_b_src_data115[7:0])  //|< w
  ,.sc2mac_dat_src_data116        (sc2mac_dat_b_src_data116[7:0])  //|< w
  ,.sc2mac_dat_src_data117        (sc2mac_dat_b_src_data117[7:0])  //|< w
  ,.sc2mac_dat_src_data118        (sc2mac_dat_b_src_data118[7:0])  //|< w
  ,.sc2mac_dat_src_data119        (sc2mac_dat_b_src_data119[7:0])  //|< w
  ,.sc2mac_dat_src_data120        (sc2mac_dat_b_src_data120[7:0])  //|< w
  ,.sc2mac_dat_src_data121        (sc2mac_dat_b_src_data121[7:0])  //|< w
  ,.sc2mac_dat_src_data122        (sc2mac_dat_b_src_data122[7:0])  //|< w
  ,.sc2mac_dat_src_data123        (sc2mac_dat_b_src_data123[7:0])  //|< w
  ,.sc2mac_dat_src_data124        (sc2mac_dat_b_src_data124[7:0])  //|< w
  ,.sc2mac_dat_src_data125        (sc2mac_dat_b_src_data125[7:0])  //|< w
  ,.sc2mac_dat_src_data126        (sc2mac_dat_b_src_data126[7:0])  //|< w
  ,.sc2mac_dat_src_data127        (sc2mac_dat_b_src_data127[7:0])  //|< w
  ,.sc2mac_dat_src_pd             (sc2mac_dat_b_src_pd[8:0])       //|< w
  ,.sc2mac_wt_dst_pvld            (sc2mac_wt_b_dst_pvld)           //|> o
  ,.sc2mac_wt_dst_mask            (sc2mac_wt_b_dst_mask[127:0])    //|> o
  ,.sc2mac_wt_dst_data0           (sc2mac_wt_b_dst_data0[7:0])     //|> o
  ,.sc2mac_wt_dst_data1           (sc2mac_wt_b_dst_data1[7:0])     //|> o
  ,.sc2mac_wt_dst_data2           (sc2mac_wt_b_dst_data2[7:0])     //|> o
  ,.sc2mac_wt_dst_data3           (sc2mac_wt_b_dst_data3[7:0])     //|> o
  ,.sc2mac_wt_dst_data4           (sc2mac_wt_b_dst_data4[7:0])     //|> o
  ,.sc2mac_wt_dst_data5           (sc2mac_wt_b_dst_data5[7:0])     //|> o
  ,.sc2mac_wt_dst_data6           (sc2mac_wt_b_dst_data6[7:0])     //|> o
  ,.sc2mac_wt_dst_data7           (sc2mac_wt_b_dst_data7[7:0])     //|> o
  ,.sc2mac_wt_dst_data8           (sc2mac_wt_b_dst_data8[7:0])     //|> o
  ,.sc2mac_wt_dst_data9           (sc2mac_wt_b_dst_data9[7:0])     //|> o
  ,.sc2mac_wt_dst_data10          (sc2mac_wt_b_dst_data10[7:0])    //|> o
  ,.sc2mac_wt_dst_data11          (sc2mac_wt_b_dst_data11[7:0])    //|> o
  ,.sc2mac_wt_dst_data12          (sc2mac_wt_b_dst_data12[7:0])    //|> o
  ,.sc2mac_wt_dst_data13          (sc2mac_wt_b_dst_data13[7:0])    //|> o
  ,.sc2mac_wt_dst_data14          (sc2mac_wt_b_dst_data14[7:0])    //|> o
  ,.sc2mac_wt_dst_data15          (sc2mac_wt_b_dst_data15[7:0])    //|> o
  ,.sc2mac_wt_dst_data16          (sc2mac_wt_b_dst_data16[7:0])    //|> o
  ,.sc2mac_wt_dst_data17          (sc2mac_wt_b_dst_data17[7:0])    //|> o
  ,.sc2mac_wt_dst_data18          (sc2mac_wt_b_dst_data18[7:0])    //|> o
  ,.sc2mac_wt_dst_data19          (sc2mac_wt_b_dst_data19[7:0])    //|> o
  ,.sc2mac_wt_dst_data20          (sc2mac_wt_b_dst_data20[7:0])    //|> o
  ,.sc2mac_wt_dst_data21          (sc2mac_wt_b_dst_data21[7:0])    //|> o
  ,.sc2mac_wt_dst_data22          (sc2mac_wt_b_dst_data22[7:0])    //|> o
  ,.sc2mac_wt_dst_data23          (sc2mac_wt_b_dst_data23[7:0])    //|> o
  ,.sc2mac_wt_dst_data24          (sc2mac_wt_b_dst_data24[7:0])    //|> o
  ,.sc2mac_wt_dst_data25          (sc2mac_wt_b_dst_data25[7:0])    //|> o
  ,.sc2mac_wt_dst_data26          (sc2mac_wt_b_dst_data26[7:0])    //|> o
  ,.sc2mac_wt_dst_data27          (sc2mac_wt_b_dst_data27[7:0])    //|> o
  ,.sc2mac_wt_dst_data28          (sc2mac_wt_b_dst_data28[7:0])    //|> o
  ,.sc2mac_wt_dst_data29          (sc2mac_wt_b_dst_data29[7:0])    //|> o
  ,.sc2mac_wt_dst_data30          (sc2mac_wt_b_dst_data30[7:0])    //|> o
  ,.sc2mac_wt_dst_data31          (sc2mac_wt_b_dst_data31[7:0])    //|> o
  ,.sc2mac_wt_dst_data32          (sc2mac_wt_b_dst_data32[7:0])    //|> o
  ,.sc2mac_wt_dst_data33          (sc2mac_wt_b_dst_data33[7:0])    //|> o
  ,.sc2mac_wt_dst_data34          (sc2mac_wt_b_dst_data34[7:0])    //|> o
  ,.sc2mac_wt_dst_data35          (sc2mac_wt_b_dst_data35[7:0])    //|> o
  ,.sc2mac_wt_dst_data36          (sc2mac_wt_b_dst_data36[7:0])    //|> o
  ,.sc2mac_wt_dst_data37          (sc2mac_wt_b_dst_data37[7:0])    //|> o
  ,.sc2mac_wt_dst_data38          (sc2mac_wt_b_dst_data38[7:0])    //|> o
  ,.sc2mac_wt_dst_data39          (sc2mac_wt_b_dst_data39[7:0])    //|> o
  ,.sc2mac_wt_dst_data40          (sc2mac_wt_b_dst_data40[7:0])    //|> o
  ,.sc2mac_wt_dst_data41          (sc2mac_wt_b_dst_data41[7:0])    //|> o
  ,.sc2mac_wt_dst_data42          (sc2mac_wt_b_dst_data42[7:0])    //|> o
  ,.sc2mac_wt_dst_data43          (sc2mac_wt_b_dst_data43[7:0])    //|> o
  ,.sc2mac_wt_dst_data44          (sc2mac_wt_b_dst_data44[7:0])    //|> o
  ,.sc2mac_wt_dst_data45          (sc2mac_wt_b_dst_data45[7:0])    //|> o
  ,.sc2mac_wt_dst_data46          (sc2mac_wt_b_dst_data46[7:0])    //|> o
  ,.sc2mac_wt_dst_data47          (sc2mac_wt_b_dst_data47[7:0])    //|> o
  ,.sc2mac_wt_dst_data48          (sc2mac_wt_b_dst_data48[7:0])    //|> o
  ,.sc2mac_wt_dst_data49          (sc2mac_wt_b_dst_data49[7:0])    //|> o
  ,.sc2mac_wt_dst_data50          (sc2mac_wt_b_dst_data50[7:0])    //|> o
  ,.sc2mac_wt_dst_data51          (sc2mac_wt_b_dst_data51[7:0])    //|> o
  ,.sc2mac_wt_dst_data52          (sc2mac_wt_b_dst_data52[7:0])    //|> o
  ,.sc2mac_wt_dst_data53          (sc2mac_wt_b_dst_data53[7:0])    //|> o
  ,.sc2mac_wt_dst_data54          (sc2mac_wt_b_dst_data54[7:0])    //|> o
  ,.sc2mac_wt_dst_data55          (sc2mac_wt_b_dst_data55[7:0])    //|> o
  ,.sc2mac_wt_dst_data56          (sc2mac_wt_b_dst_data56[7:0])    //|> o
  ,.sc2mac_wt_dst_data57          (sc2mac_wt_b_dst_data57[7:0])    //|> o
  ,.sc2mac_wt_dst_data58          (sc2mac_wt_b_dst_data58[7:0])    //|> o
  ,.sc2mac_wt_dst_data59          (sc2mac_wt_b_dst_data59[7:0])    //|> o
  ,.sc2mac_wt_dst_data60          (sc2mac_wt_b_dst_data60[7:0])    //|> o
  ,.sc2mac_wt_dst_data61          (sc2mac_wt_b_dst_data61[7:0])    //|> o
  ,.sc2mac_wt_dst_data62          (sc2mac_wt_b_dst_data62[7:0])    //|> o
  ,.sc2mac_wt_dst_data63          (sc2mac_wt_b_dst_data63[7:0])    //|> o
  ,.sc2mac_wt_dst_data64          (sc2mac_wt_b_dst_data64[7:0])    //|> o
  ,.sc2mac_wt_dst_data65          (sc2mac_wt_b_dst_data65[7:0])    //|> o
  ,.sc2mac_wt_dst_data66          (sc2mac_wt_b_dst_data66[7:0])    //|> o
  ,.sc2mac_wt_dst_data67          (sc2mac_wt_b_dst_data67[7:0])    //|> o
  ,.sc2mac_wt_dst_data68          (sc2mac_wt_b_dst_data68[7:0])    //|> o
  ,.sc2mac_wt_dst_data69          (sc2mac_wt_b_dst_data69[7:0])    //|> o
  ,.sc2mac_wt_dst_data70          (sc2mac_wt_b_dst_data70[7:0])    //|> o
  ,.sc2mac_wt_dst_data71          (sc2mac_wt_b_dst_data71[7:0])    //|> o
  ,.sc2mac_wt_dst_data72          (sc2mac_wt_b_dst_data72[7:0])    //|> o
  ,.sc2mac_wt_dst_data73          (sc2mac_wt_b_dst_data73[7:0])    //|> o
  ,.sc2mac_wt_dst_data74          (sc2mac_wt_b_dst_data74[7:0])    //|> o
  ,.sc2mac_wt_dst_data75          (sc2mac_wt_b_dst_data75[7:0])    //|> o
  ,.sc2mac_wt_dst_data76          (sc2mac_wt_b_dst_data76[7:0])    //|> o
  ,.sc2mac_wt_dst_data77          (sc2mac_wt_b_dst_data77[7:0])    //|> o
  ,.sc2mac_wt_dst_data78          (sc2mac_wt_b_dst_data78[7:0])    //|> o
  ,.sc2mac_wt_dst_data79          (sc2mac_wt_b_dst_data79[7:0])    //|> o
  ,.sc2mac_wt_dst_data80          (sc2mac_wt_b_dst_data80[7:0])    //|> o
  ,.sc2mac_wt_dst_data81          (sc2mac_wt_b_dst_data81[7:0])    //|> o
  ,.sc2mac_wt_dst_data82          (sc2mac_wt_b_dst_data82[7:0])    //|> o
  ,.sc2mac_wt_dst_data83          (sc2mac_wt_b_dst_data83[7:0])    //|> o
  ,.sc2mac_wt_dst_data84          (sc2mac_wt_b_dst_data84[7:0])    //|> o
  ,.sc2mac_wt_dst_data85          (sc2mac_wt_b_dst_data85[7:0])    //|> o
  ,.sc2mac_wt_dst_data86          (sc2mac_wt_b_dst_data86[7:0])    //|> o
  ,.sc2mac_wt_dst_data87          (sc2mac_wt_b_dst_data87[7:0])    //|> o
  ,.sc2mac_wt_dst_data88          (sc2mac_wt_b_dst_data88[7:0])    //|> o
  ,.sc2mac_wt_dst_data89          (sc2mac_wt_b_dst_data89[7:0])    //|> o
  ,.sc2mac_wt_dst_data90          (sc2mac_wt_b_dst_data90[7:0])    //|> o
  ,.sc2mac_wt_dst_data91          (sc2mac_wt_b_dst_data91[7:0])    //|> o
  ,.sc2mac_wt_dst_data92          (sc2mac_wt_b_dst_data92[7:0])    //|> o
  ,.sc2mac_wt_dst_data93          (sc2mac_wt_b_dst_data93[7:0])    //|> o
  ,.sc2mac_wt_dst_data94          (sc2mac_wt_b_dst_data94[7:0])    //|> o
  ,.sc2mac_wt_dst_data95          (sc2mac_wt_b_dst_data95[7:0])    //|> o
  ,.sc2mac_wt_dst_data96          (sc2mac_wt_b_dst_data96[7:0])    //|> o
  ,.sc2mac_wt_dst_data97          (sc2mac_wt_b_dst_data97[7:0])    //|> o
  ,.sc2mac_wt_dst_data98          (sc2mac_wt_b_dst_data98[7:0])    //|> o
  ,.sc2mac_wt_dst_data99          (sc2mac_wt_b_dst_data99[7:0])    //|> o
  ,.sc2mac_wt_dst_data100         (sc2mac_wt_b_dst_data100[7:0])   //|> o
  ,.sc2mac_wt_dst_data101         (sc2mac_wt_b_dst_data101[7:0])   //|> o
  ,.sc2mac_wt_dst_data102         (sc2mac_wt_b_dst_data102[7:0])   //|> o
  ,.sc2mac_wt_dst_data103         (sc2mac_wt_b_dst_data103[7:0])   //|> o
  ,.sc2mac_wt_dst_data104         (sc2mac_wt_b_dst_data104[7:0])   //|> o
  ,.sc2mac_wt_dst_data105         (sc2mac_wt_b_dst_data105[7:0])   //|> o
  ,.sc2mac_wt_dst_data106         (sc2mac_wt_b_dst_data106[7:0])   //|> o
  ,.sc2mac_wt_dst_data107         (sc2mac_wt_b_dst_data107[7:0])   //|> o
  ,.sc2mac_wt_dst_data108         (sc2mac_wt_b_dst_data108[7:0])   //|> o
  ,.sc2mac_wt_dst_data109         (sc2mac_wt_b_dst_data109[7:0])   //|> o
  ,.sc2mac_wt_dst_data110         (sc2mac_wt_b_dst_data110[7:0])   //|> o
  ,.sc2mac_wt_dst_data111         (sc2mac_wt_b_dst_data111[7:0])   //|> o
  ,.sc2mac_wt_dst_data112         (sc2mac_wt_b_dst_data112[7:0])   //|> o
  ,.sc2mac_wt_dst_data113         (sc2mac_wt_b_dst_data113[7:0])   //|> o
  ,.sc2mac_wt_dst_data114         (sc2mac_wt_b_dst_data114[7:0])   //|> o
  ,.sc2mac_wt_dst_data115         (sc2mac_wt_b_dst_data115[7:0])   //|> o
  ,.sc2mac_wt_dst_data116         (sc2mac_wt_b_dst_data116[7:0])   //|> o
  ,.sc2mac_wt_dst_data117         (sc2mac_wt_b_dst_data117[7:0])   //|> o
  ,.sc2mac_wt_dst_data118         (sc2mac_wt_b_dst_data118[7:0])   //|> o
  ,.sc2mac_wt_dst_data119         (sc2mac_wt_b_dst_data119[7:0])   //|> o
  ,.sc2mac_wt_dst_data120         (sc2mac_wt_b_dst_data120[7:0])   //|> o
  ,.sc2mac_wt_dst_data121         (sc2mac_wt_b_dst_data121[7:0])   //|> o
  ,.sc2mac_wt_dst_data122         (sc2mac_wt_b_dst_data122[7:0])   //|> o
  ,.sc2mac_wt_dst_data123         (sc2mac_wt_b_dst_data123[7:0])   //|> o
  ,.sc2mac_wt_dst_data124         (sc2mac_wt_b_dst_data124[7:0])   //|> o
  ,.sc2mac_wt_dst_data125         (sc2mac_wt_b_dst_data125[7:0])   //|> o
  ,.sc2mac_wt_dst_data126         (sc2mac_wt_b_dst_data126[7:0])   //|> o
  ,.sc2mac_wt_dst_data127         (sc2mac_wt_b_dst_data127[7:0])   //|> o
  ,.sc2mac_wt_dst_sel             (sc2mac_wt_b_dst_sel[7:0])       //|> o
  ,.sc2mac_dat_dst_pvld           (sc2mac_dat_b_dst_pvld)          //|> o
  ,.sc2mac_dat_dst_mask           (sc2mac_dat_b_dst_mask[127:0])   //|> o
  ,.sc2mac_dat_dst_data0          (sc2mac_dat_b_dst_data0[7:0])    //|> o
  ,.sc2mac_dat_dst_data1          (sc2mac_dat_b_dst_data1[7:0])    //|> o
  ,.sc2mac_dat_dst_data2          (sc2mac_dat_b_dst_data2[7:0])    //|> o
  ,.sc2mac_dat_dst_data3          (sc2mac_dat_b_dst_data3[7:0])    //|> o
  ,.sc2mac_dat_dst_data4          (sc2mac_dat_b_dst_data4[7:0])    //|> o
  ,.sc2mac_dat_dst_data5          (sc2mac_dat_b_dst_data5[7:0])    //|> o
  ,.sc2mac_dat_dst_data6          (sc2mac_dat_b_dst_data6[7:0])    //|> o
  ,.sc2mac_dat_dst_data7          (sc2mac_dat_b_dst_data7[7:0])    //|> o
  ,.sc2mac_dat_dst_data8          (sc2mac_dat_b_dst_data8[7:0])    //|> o
  ,.sc2mac_dat_dst_data9          (sc2mac_dat_b_dst_data9[7:0])    //|> o
  ,.sc2mac_dat_dst_data10         (sc2mac_dat_b_dst_data10[7:0])   //|> o
  ,.sc2mac_dat_dst_data11         (sc2mac_dat_b_dst_data11[7:0])   //|> o
  ,.sc2mac_dat_dst_data12         (sc2mac_dat_b_dst_data12[7:0])   //|> o
  ,.sc2mac_dat_dst_data13         (sc2mac_dat_b_dst_data13[7:0])   //|> o
  ,.sc2mac_dat_dst_data14         (sc2mac_dat_b_dst_data14[7:0])   //|> o
  ,.sc2mac_dat_dst_data15         (sc2mac_dat_b_dst_data15[7:0])   //|> o
  ,.sc2mac_dat_dst_data16         (sc2mac_dat_b_dst_data16[7:0])   //|> o
  ,.sc2mac_dat_dst_data17         (sc2mac_dat_b_dst_data17[7:0])   //|> o
  ,.sc2mac_dat_dst_data18         (sc2mac_dat_b_dst_data18[7:0])   //|> o
  ,.sc2mac_dat_dst_data19         (sc2mac_dat_b_dst_data19[7:0])   //|> o
  ,.sc2mac_dat_dst_data20         (sc2mac_dat_b_dst_data20[7:0])   //|> o
  ,.sc2mac_dat_dst_data21         (sc2mac_dat_b_dst_data21[7:0])   //|> o
  ,.sc2mac_dat_dst_data22         (sc2mac_dat_b_dst_data22[7:0])   //|> o
  ,.sc2mac_dat_dst_data23         (sc2mac_dat_b_dst_data23[7:0])   //|> o
  ,.sc2mac_dat_dst_data24         (sc2mac_dat_b_dst_data24[7:0])   //|> o
  ,.sc2mac_dat_dst_data25         (sc2mac_dat_b_dst_data25[7:0])   //|> o
  ,.sc2mac_dat_dst_data26         (sc2mac_dat_b_dst_data26[7:0])   //|> o
  ,.sc2mac_dat_dst_data27         (sc2mac_dat_b_dst_data27[7:0])   //|> o
  ,.sc2mac_dat_dst_data28         (sc2mac_dat_b_dst_data28[7:0])   //|> o
  ,.sc2mac_dat_dst_data29         (sc2mac_dat_b_dst_data29[7:0])   //|> o
  ,.sc2mac_dat_dst_data30         (sc2mac_dat_b_dst_data30[7:0])   //|> o
  ,.sc2mac_dat_dst_data31         (sc2mac_dat_b_dst_data31[7:0])   //|> o
  ,.sc2mac_dat_dst_data32         (sc2mac_dat_b_dst_data32[7:0])   //|> o
  ,.sc2mac_dat_dst_data33         (sc2mac_dat_b_dst_data33[7:0])   //|> o
  ,.sc2mac_dat_dst_data34         (sc2mac_dat_b_dst_data34[7:0])   //|> o
  ,.sc2mac_dat_dst_data35         (sc2mac_dat_b_dst_data35[7:0])   //|> o
  ,.sc2mac_dat_dst_data36         (sc2mac_dat_b_dst_data36[7:0])   //|> o
  ,.sc2mac_dat_dst_data37         (sc2mac_dat_b_dst_data37[7:0])   //|> o
  ,.sc2mac_dat_dst_data38         (sc2mac_dat_b_dst_data38[7:0])   //|> o
  ,.sc2mac_dat_dst_data39         (sc2mac_dat_b_dst_data39[7:0])   //|> o
  ,.sc2mac_dat_dst_data40         (sc2mac_dat_b_dst_data40[7:0])   //|> o
  ,.sc2mac_dat_dst_data41         (sc2mac_dat_b_dst_data41[7:0])   //|> o
  ,.sc2mac_dat_dst_data42         (sc2mac_dat_b_dst_data42[7:0])   //|> o
  ,.sc2mac_dat_dst_data43         (sc2mac_dat_b_dst_data43[7:0])   //|> o
  ,.sc2mac_dat_dst_data44         (sc2mac_dat_b_dst_data44[7:0])   //|> o
  ,.sc2mac_dat_dst_data45         (sc2mac_dat_b_dst_data45[7:0])   //|> o
  ,.sc2mac_dat_dst_data46         (sc2mac_dat_b_dst_data46[7:0])   //|> o
  ,.sc2mac_dat_dst_data47         (sc2mac_dat_b_dst_data47[7:0])   //|> o
  ,.sc2mac_dat_dst_data48         (sc2mac_dat_b_dst_data48[7:0])   //|> o
  ,.sc2mac_dat_dst_data49         (sc2mac_dat_b_dst_data49[7:0])   //|> o
  ,.sc2mac_dat_dst_data50         (sc2mac_dat_b_dst_data50[7:0])   //|> o
  ,.sc2mac_dat_dst_data51         (sc2mac_dat_b_dst_data51[7:0])   //|> o
  ,.sc2mac_dat_dst_data52         (sc2mac_dat_b_dst_data52[7:0])   //|> o
  ,.sc2mac_dat_dst_data53         (sc2mac_dat_b_dst_data53[7:0])   //|> o
  ,.sc2mac_dat_dst_data54         (sc2mac_dat_b_dst_data54[7:0])   //|> o
  ,.sc2mac_dat_dst_data55         (sc2mac_dat_b_dst_data55[7:0])   //|> o
  ,.sc2mac_dat_dst_data56         (sc2mac_dat_b_dst_data56[7:0])   //|> o
  ,.sc2mac_dat_dst_data57         (sc2mac_dat_b_dst_data57[7:0])   //|> o
  ,.sc2mac_dat_dst_data58         (sc2mac_dat_b_dst_data58[7:0])   //|> o
  ,.sc2mac_dat_dst_data59         (sc2mac_dat_b_dst_data59[7:0])   //|> o
  ,.sc2mac_dat_dst_data60         (sc2mac_dat_b_dst_data60[7:0])   //|> o
  ,.sc2mac_dat_dst_data61         (sc2mac_dat_b_dst_data61[7:0])   //|> o
  ,.sc2mac_dat_dst_data62         (sc2mac_dat_b_dst_data62[7:0])   //|> o
  ,.sc2mac_dat_dst_data63         (sc2mac_dat_b_dst_data63[7:0])   //|> o
  ,.sc2mac_dat_dst_data64         (sc2mac_dat_b_dst_data64[7:0])   //|> o
  ,.sc2mac_dat_dst_data65         (sc2mac_dat_b_dst_data65[7:0])   //|> o
  ,.sc2mac_dat_dst_data66         (sc2mac_dat_b_dst_data66[7:0])   //|> o
  ,.sc2mac_dat_dst_data67         (sc2mac_dat_b_dst_data67[7:0])   //|> o
  ,.sc2mac_dat_dst_data68         (sc2mac_dat_b_dst_data68[7:0])   //|> o
  ,.sc2mac_dat_dst_data69         (sc2mac_dat_b_dst_data69[7:0])   //|> o
  ,.sc2mac_dat_dst_data70         (sc2mac_dat_b_dst_data70[7:0])   //|> o
  ,.sc2mac_dat_dst_data71         (sc2mac_dat_b_dst_data71[7:0])   //|> o
  ,.sc2mac_dat_dst_data72         (sc2mac_dat_b_dst_data72[7:0])   //|> o
  ,.sc2mac_dat_dst_data73         (sc2mac_dat_b_dst_data73[7:0])   //|> o
  ,.sc2mac_dat_dst_data74         (sc2mac_dat_b_dst_data74[7:0])   //|> o
  ,.sc2mac_dat_dst_data75         (sc2mac_dat_b_dst_data75[7:0])   //|> o
  ,.sc2mac_dat_dst_data76         (sc2mac_dat_b_dst_data76[7:0])   //|> o
  ,.sc2mac_dat_dst_data77         (sc2mac_dat_b_dst_data77[7:0])   //|> o
  ,.sc2mac_dat_dst_data78         (sc2mac_dat_b_dst_data78[7:0])   //|> o
  ,.sc2mac_dat_dst_data79         (sc2mac_dat_b_dst_data79[7:0])   //|> o
  ,.sc2mac_dat_dst_data80         (sc2mac_dat_b_dst_data80[7:0])   //|> o
  ,.sc2mac_dat_dst_data81         (sc2mac_dat_b_dst_data81[7:0])   //|> o
  ,.sc2mac_dat_dst_data82         (sc2mac_dat_b_dst_data82[7:0])   //|> o
  ,.sc2mac_dat_dst_data83         (sc2mac_dat_b_dst_data83[7:0])   //|> o
  ,.sc2mac_dat_dst_data84         (sc2mac_dat_b_dst_data84[7:0])   //|> o
  ,.sc2mac_dat_dst_data85         (sc2mac_dat_b_dst_data85[7:0])   //|> o
  ,.sc2mac_dat_dst_data86         (sc2mac_dat_b_dst_data86[7:0])   //|> o
  ,.sc2mac_dat_dst_data87         (sc2mac_dat_b_dst_data87[7:0])   //|> o
  ,.sc2mac_dat_dst_data88         (sc2mac_dat_b_dst_data88[7:0])   //|> o
  ,.sc2mac_dat_dst_data89         (sc2mac_dat_b_dst_data89[7:0])   //|> o
  ,.sc2mac_dat_dst_data90         (sc2mac_dat_b_dst_data90[7:0])   //|> o
  ,.sc2mac_dat_dst_data91         (sc2mac_dat_b_dst_data91[7:0])   //|> o
  ,.sc2mac_dat_dst_data92         (sc2mac_dat_b_dst_data92[7:0])   //|> o
  ,.sc2mac_dat_dst_data93         (sc2mac_dat_b_dst_data93[7:0])   //|> o
  ,.sc2mac_dat_dst_data94         (sc2mac_dat_b_dst_data94[7:0])   //|> o
  ,.sc2mac_dat_dst_data95         (sc2mac_dat_b_dst_data95[7:0])   //|> o
  ,.sc2mac_dat_dst_data96         (sc2mac_dat_b_dst_data96[7:0])   //|> o
  ,.sc2mac_dat_dst_data97         (sc2mac_dat_b_dst_data97[7:0])   //|> o
  ,.sc2mac_dat_dst_data98         (sc2mac_dat_b_dst_data98[7:0])   //|> o
  ,.sc2mac_dat_dst_data99         (sc2mac_dat_b_dst_data99[7:0])   //|> o
  ,.sc2mac_dat_dst_data100        (sc2mac_dat_b_dst_data100[7:0])  //|> o
  ,.sc2mac_dat_dst_data101        (sc2mac_dat_b_dst_data101[7:0])  //|> o
  ,.sc2mac_dat_dst_data102        (sc2mac_dat_b_dst_data102[7:0])  //|> o
  ,.sc2mac_dat_dst_data103        (sc2mac_dat_b_dst_data103[7:0])  //|> o
  ,.sc2mac_dat_dst_data104        (sc2mac_dat_b_dst_data104[7:0])  //|> o
  ,.sc2mac_dat_dst_data105        (sc2mac_dat_b_dst_data105[7:0])  //|> o
  ,.sc2mac_dat_dst_data106        (sc2mac_dat_b_dst_data106[7:0])  //|> o
  ,.sc2mac_dat_dst_data107        (sc2mac_dat_b_dst_data107[7:0])  //|> o
  ,.sc2mac_dat_dst_data108        (sc2mac_dat_b_dst_data108[7:0])  //|> o
  ,.sc2mac_dat_dst_data109        (sc2mac_dat_b_dst_data109[7:0])  //|> o
  ,.sc2mac_dat_dst_data110        (sc2mac_dat_b_dst_data110[7:0])  //|> o
  ,.sc2mac_dat_dst_data111        (sc2mac_dat_b_dst_data111[7:0])  //|> o
  ,.sc2mac_dat_dst_data112        (sc2mac_dat_b_dst_data112[7:0])  //|> o
  ,.sc2mac_dat_dst_data113        (sc2mac_dat_b_dst_data113[7:0])  //|> o
  ,.sc2mac_dat_dst_data114        (sc2mac_dat_b_dst_data114[7:0])  //|> o
  ,.sc2mac_dat_dst_data115        (sc2mac_dat_b_dst_data115[7:0])  //|> o
  ,.sc2mac_dat_dst_data116        (sc2mac_dat_b_dst_data116[7:0])  //|> o
  ,.sc2mac_dat_dst_data117        (sc2mac_dat_b_dst_data117[7:0])  //|> o
  ,.sc2mac_dat_dst_data118        (sc2mac_dat_b_dst_data118[7:0])  //|> o
  ,.sc2mac_dat_dst_data119        (sc2mac_dat_b_dst_data119[7:0])  //|> o
  ,.sc2mac_dat_dst_data120        (sc2mac_dat_b_dst_data120[7:0])  //|> o
  ,.sc2mac_dat_dst_data121        (sc2mac_dat_b_dst_data121[7:0])  //|> o
  ,.sc2mac_dat_dst_data122        (sc2mac_dat_b_dst_data122[7:0])  //|> o
  ,.sc2mac_dat_dst_data123        (sc2mac_dat_b_dst_data123[7:0])  //|> o
  ,.sc2mac_dat_dst_data124        (sc2mac_dat_b_dst_data124[7:0])  //|> o
  ,.sc2mac_dat_dst_data125        (sc2mac_dat_b_dst_data125[7:0])  //|> o
  ,.sc2mac_dat_dst_data126        (sc2mac_dat_b_dst_data126[7:0])  //|> o
  ,.sc2mac_dat_dst_data127        (sc2mac_dat_b_dst_data127[7:0])  //|> o
  ,.sc2mac_dat_dst_pd             (sc2mac_dat_b_dst_pd[8:0])       //|> o
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path csb->cmac_b                   //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csb2cmac u_NV_NVDLA_RT_csb2cmac (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.csb2cmac_req_src_pvld         (csb2cmac_b_req_src_pvld)        //|< i
  ,.csb2cmac_req_src_prdy         (csb2cmac_b_req_src_prdy)        //|> o
  ,.csb2cmac_req_src_pd           (csb2cmac_b_req_src_pd[62:0])    //|< i
  ,.cmac2csb_resp_src_valid       (cmac_b2csb_resp_src_valid)      //|< i
  ,.cmac2csb_resp_src_pd          (cmac_b2csb_resp_src_pd[33:0])   //|< i
  ,.csb2cmac_req_dst_pvld         (csb2cmac_b_req_dst_pvld)        //|> o
  ,.csb2cmac_req_dst_prdy         (csb2cmac_b_req_dst_prdy)        //|< i
  ,.csb2cmac_req_dst_pd           (csb2cmac_b_req_dst_pd[62:0])    //|> o
  ,.cmac2csb_resp_dst_valid       (cmac_b2csb_resp_dst_valid)      //|> o
  ,.cmac2csb_resp_dst_pd          (cmac_b2csb_resp_dst_pd[33:0])   //|> o
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path csb<->cacc                    //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csb2cacc u_NV_NVDLA_RT_csb2cacc (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.csb2cacc_req_src_pvld         (csb2cacc_req_src_pvld)          //|< i
  ,.csb2cacc_req_src_prdy         (csb2cacc_req_src_prdy)          //|> o
  ,.csb2cacc_req_src_pd           (csb2cacc_req_src_pd[62:0])      //|< i
  ,.cacc2csb_resp_src_valid       (cacc2csb_resp_src_valid)        //|< i
  ,.cacc2csb_resp_src_pd          (cacc2csb_resp_src_pd[33:0])     //|< i
  ,.csb2cacc_req_dst_pvld         (csb2cacc_req_dst_pvld)          //|> o
  ,.csb2cacc_req_dst_prdy         (csb2cacc_req_dst_prdy)          //|< i
  ,.csb2cacc_req_dst_pd           (csb2cacc_req_dst_pd[62:0])      //|> o
  ,.cacc2csb_resp_dst_valid       (cacc2csb_resp_dst_valid)        //|> o
  ,.cacc2csb_resp_dst_pd          (cacc2csb_resp_dst_pd[33:0])     //|> o
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition C:    Retiming path cacc->glbc                    //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_cacc2glb u_NV_NVDLA_RT_cacc2glb (
   .nvdla_core_clk                (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                //|< w
  ,.cacc2glb_done_intr_src_pd     (cacc2glb_done_intr_src_pd[1:0]) //|< i
  ,.cacc2glb_done_intr_dst_pd     (cacc2glb_done_intr_dst_pd[1:0]) //|> o
  );

//&Instance NV_NVDLA_RT_sdp2nocif;

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|

endmodule // NV_NVDLA_partition_c


