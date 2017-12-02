// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_partition_o.v

module NV_NVDLA_partition_o (
   test_mode                      //|< i
  ,direct_reset_                  //|< i
  ,global_clk_ovr_on              //|< i
  ,tmc2slcg_disable_clock_gating  //|< i
  ,cacc2csb_resp_dst_valid        //|< i
  ,cacc2csb_resp_dst_pd           //|< i
  ,cacc2glb_done_intr_dst_pd      //|< i
  ,cdma2csb_resp_valid            //|< i
  ,cdma2csb_resp_pd               //|< i
  ,cdma_dat2cvif_rd_req_valid     //|< i
  ,cdma_dat2cvif_rd_req_ready     //|> o
  ,cdma_dat2cvif_rd_req_pd        //|< i
  ,cdma_dat2glb_done_intr_pd      //|< i
  ,cdma_dat2mcif_rd_req_valid     //|< i
  ,cdma_dat2mcif_rd_req_ready     //|> o
  ,cdma_dat2mcif_rd_req_pd        //|< i
  ,cdma_wt2cvif_rd_req_valid      //|< i
  ,cdma_wt2cvif_rd_req_ready      //|> o
  ,cdma_wt2cvif_rd_req_pd         //|< i
  ,cdma_wt2glb_done_intr_pd       //|< i
  ,cdma_wt2mcif_rd_req_valid      //|< i
  ,cdma_wt2mcif_rd_req_ready      //|> o
  ,cdma_wt2mcif_rd_req_pd         //|< i
  ,cmac_a2csb_resp_src_valid      //|< i
  ,cmac_a2csb_resp_src_pd         //|< i
  ,cmac_b2csb_resp_dst_valid      //|< i
  ,cmac_b2csb_resp_dst_pd         //|< i
  ,csb2cacc_req_src_pvld          //|> o
  ,csb2cacc_req_src_prdy          //|< i
  ,csb2cacc_req_src_pd            //|> o
  ,csb2cdma_req_pvld              //|> o
  ,csb2cdma_req_prdy              //|< i
  ,csb2cdma_req_pd                //|> o
  ,csb2cmac_a_req_dst_pvld        //|> o
  ,csb2cmac_a_req_dst_prdy        //|< i
  ,csb2cmac_a_req_dst_pd          //|> o
  ,csb2cmac_b_req_src_pvld        //|> o
  ,csb2cmac_b_req_src_prdy        //|< i
  ,csb2cmac_b_req_src_pd          //|> o
  ,csb2csc_req_pvld               //|> o
  ,csb2csc_req_prdy               //|< i
  ,csb2csc_req_pd                 //|> o
  ,csb2nvdla_valid                //|< i
  ,csb2nvdla_ready                //|> o
  ,csb2nvdla_addr                 //|< i
  ,csb2nvdla_wdat                 //|< i
  ,csb2nvdla_write                //|< i
  ,csb2nvdla_nposted              //|< i
  ,csb2sdp_rdma_req_pvld          //|> o
  ,csb2sdp_rdma_req_prdy          //|< i
  ,csb2sdp_rdma_req_pd            //|> o
  ,csb2sdp_req_pvld               //|> o
  ,csb2sdp_req_prdy               //|< i
  ,csb2sdp_req_pd                 //|> o
  ,csc2csb_resp_valid             //|< i
  ,csc2csb_resp_pd                //|< i
  ,cvif2cdma_dat_rd_rsp_valid     //|> o
  ,cvif2cdma_dat_rd_rsp_ready     //|< i
  ,cvif2cdma_dat_rd_rsp_pd        //|> o
  ,cvif2cdma_wt_rd_rsp_valid      //|> o
  ,cvif2cdma_wt_rd_rsp_ready      //|< i
  ,cvif2cdma_wt_rd_rsp_pd         //|> o
  ,cvif2noc_axi_ar_arvalid        //|> o
  ,cvif2noc_axi_ar_arready        //|< i
  ,cvif2noc_axi_ar_arid           //|> o
  ,cvif2noc_axi_ar_arlen          //|> o
  ,cvif2noc_axi_ar_araddr         //|> o
  ,cvif2noc_axi_aw_awvalid        //|> o
  ,cvif2noc_axi_aw_awready        //|< i
  ,cvif2noc_axi_aw_awid           //|> o
  ,cvif2noc_axi_aw_awlen          //|> o
  ,cvif2noc_axi_aw_awaddr         //|> o
  ,cvif2noc_axi_w_wvalid          //|> o
  ,cvif2noc_axi_w_wready          //|< i
  ,cvif2noc_axi_w_wdata           //|> o
  ,cvif2noc_axi_w_wstrb           //|> o
  ,cvif2noc_axi_w_wlast           //|> o
  ,cvif2sdp_b_rd_rsp_valid        //|> o
  ,cvif2sdp_b_rd_rsp_ready        //|< i
  ,cvif2sdp_b_rd_rsp_pd           //|> o
  ,cvif2sdp_e_rd_rsp_valid        //|> o
  ,cvif2sdp_e_rd_rsp_ready        //|< i
  ,cvif2sdp_e_rd_rsp_pd           //|> o
  ,cvif2sdp_n_rd_rsp_valid        //|> o
  ,cvif2sdp_n_rd_rsp_ready        //|< i
  ,cvif2sdp_n_rd_rsp_pd           //|> o
  ,cvif2sdp_rd_rsp_valid          //|> o
  ,cvif2sdp_rd_rsp_ready          //|< i
  ,cvif2sdp_rd_rsp_pd             //|> o
  ,cvif2sdp_wr_rsp_complete       //|> o
  ,mcif2cdma_dat_rd_rsp_valid     //|> o
  ,mcif2cdma_dat_rd_rsp_ready     //|< i
  ,mcif2cdma_dat_rd_rsp_pd        //|> o
  ,mcif2cdma_wt_rd_rsp_valid      //|> o
  ,mcif2cdma_wt_rd_rsp_ready      //|< i
  ,mcif2cdma_wt_rd_rsp_pd         //|> o
  ,mcif2noc_axi_ar_arvalid        //|> o
  ,mcif2noc_axi_ar_arready        //|< i
  ,mcif2noc_axi_ar_arid           //|> o
  ,mcif2noc_axi_ar_arlen          //|> o
  ,mcif2noc_axi_ar_araddr         //|> o
  ,mcif2noc_axi_aw_awvalid        //|> o
  ,mcif2noc_axi_aw_awready        //|< i
  ,mcif2noc_axi_aw_awid           //|> o
  ,mcif2noc_axi_aw_awlen          //|> o
  ,mcif2noc_axi_aw_awaddr         //|> o
  ,mcif2noc_axi_w_wvalid          //|> o
  ,mcif2noc_axi_w_wready          //|< i
  ,mcif2noc_axi_w_wdata           //|> o
  ,mcif2noc_axi_w_wstrb           //|> o
  ,mcif2noc_axi_w_wlast           //|> o
  ,mcif2sdp_b_rd_rsp_valid        //|> o
  ,mcif2sdp_b_rd_rsp_ready        //|< i
  ,mcif2sdp_b_rd_rsp_pd           //|> o
  ,mcif2sdp_e_rd_rsp_valid        //|> o
  ,mcif2sdp_e_rd_rsp_ready        //|< i
  ,mcif2sdp_e_rd_rsp_pd           //|> o
  ,mcif2sdp_n_rd_rsp_valid        //|> o
  ,mcif2sdp_n_rd_rsp_ready        //|< i
  ,mcif2sdp_n_rd_rsp_pd           //|> o
  ,mcif2sdp_rd_rsp_valid          //|> o
  ,mcif2sdp_rd_rsp_ready          //|< i
  ,mcif2sdp_rd_rsp_pd             //|> o
  ,mcif2sdp_wr_rsp_complete       //|> o
  ,noc2cvif_axi_b_bvalid          //|< i
  ,noc2cvif_axi_b_bready          //|> o
  ,noc2cvif_axi_b_bid             //|< i
  ,noc2cvif_axi_r_rvalid          //|< i
  ,noc2cvif_axi_r_rready          //|> o
  ,noc2cvif_axi_r_rid             //|< i
  ,noc2cvif_axi_r_rlast           //|< i
  ,noc2cvif_axi_r_rdata           //|< i
  ,noc2mcif_axi_b_bvalid          //|< i
  ,noc2mcif_axi_b_bready          //|> o
  ,noc2mcif_axi_b_bid             //|< i
  ,noc2mcif_axi_r_rvalid          //|< i
  ,noc2mcif_axi_r_rready          //|> o
  ,noc2mcif_axi_r_rid             //|< i
  ,noc2mcif_axi_r_rlast           //|< i
  ,noc2mcif_axi_r_rdata           //|< i
  ,nvdla2csb_valid                //|> o
  ,nvdla2csb_data                 //|> o
  ,nvdla2csb_wr_complete          //|> o
  ,core_intr                      //|> o
  ,pwrbus_ram_pd                  //|< i
  ,sc2mac_dat_a_dst_pvld          //|> o
  ,sc2mac_dat_a_dst_mask          //|> o
  ,sc2mac_dat_a_dst_data0         //|> o
  ,sc2mac_dat_a_dst_data1         //|> o
  ,sc2mac_dat_a_dst_data2         //|> o
  ,sc2mac_dat_a_dst_data3         //|> o
  ,sc2mac_dat_a_dst_data4         //|> o
  ,sc2mac_dat_a_dst_data5         //|> o
  ,sc2mac_dat_a_dst_data6         //|> o
  ,sc2mac_dat_a_dst_data7         //|> o
  ,sc2mac_dat_a_dst_data8         //|> o
  ,sc2mac_dat_a_dst_data9         //|> o
  ,sc2mac_dat_a_dst_data10        //|> o
  ,sc2mac_dat_a_dst_data11        //|> o
  ,sc2mac_dat_a_dst_data12        //|> o
  ,sc2mac_dat_a_dst_data13        //|> o
  ,sc2mac_dat_a_dst_data14        //|> o
  ,sc2mac_dat_a_dst_data15        //|> o
  ,sc2mac_dat_a_dst_data16        //|> o
  ,sc2mac_dat_a_dst_data17        //|> o
  ,sc2mac_dat_a_dst_data18        //|> o
  ,sc2mac_dat_a_dst_data19        //|> o
  ,sc2mac_dat_a_dst_data20        //|> o
  ,sc2mac_dat_a_dst_data21        //|> o
  ,sc2mac_dat_a_dst_data22        //|> o
  ,sc2mac_dat_a_dst_data23        //|> o
  ,sc2mac_dat_a_dst_data24        //|> o
  ,sc2mac_dat_a_dst_data25        //|> o
  ,sc2mac_dat_a_dst_data26        //|> o
  ,sc2mac_dat_a_dst_data27        //|> o
  ,sc2mac_dat_a_dst_data28        //|> o
  ,sc2mac_dat_a_dst_data29        //|> o
  ,sc2mac_dat_a_dst_data30        //|> o
  ,sc2mac_dat_a_dst_data31        //|> o
  ,sc2mac_dat_a_dst_data32        //|> o
  ,sc2mac_dat_a_dst_data33        //|> o
  ,sc2mac_dat_a_dst_data34        //|> o
  ,sc2mac_dat_a_dst_data35        //|> o
  ,sc2mac_dat_a_dst_data36        //|> o
  ,sc2mac_dat_a_dst_data37        //|> o
  ,sc2mac_dat_a_dst_data38        //|> o
  ,sc2mac_dat_a_dst_data39        //|> o
  ,sc2mac_dat_a_dst_data40        //|> o
  ,sc2mac_dat_a_dst_data41        //|> o
  ,sc2mac_dat_a_dst_data42        //|> o
  ,sc2mac_dat_a_dst_data43        //|> o
  ,sc2mac_dat_a_dst_data44        //|> o
  ,sc2mac_dat_a_dst_data45        //|> o
  ,sc2mac_dat_a_dst_data46        //|> o
  ,sc2mac_dat_a_dst_data47        //|> o
  ,sc2mac_dat_a_dst_data48        //|> o
  ,sc2mac_dat_a_dst_data49        //|> o
  ,sc2mac_dat_a_dst_data50        //|> o
  ,sc2mac_dat_a_dst_data51        //|> o
  ,sc2mac_dat_a_dst_data52        //|> o
  ,sc2mac_dat_a_dst_data53        //|> o
  ,sc2mac_dat_a_dst_data54        //|> o
  ,sc2mac_dat_a_dst_data55        //|> o
  ,sc2mac_dat_a_dst_data56        //|> o
  ,sc2mac_dat_a_dst_data57        //|> o
  ,sc2mac_dat_a_dst_data58        //|> o
  ,sc2mac_dat_a_dst_data59        //|> o
  ,sc2mac_dat_a_dst_data60        //|> o
  ,sc2mac_dat_a_dst_data61        //|> o
  ,sc2mac_dat_a_dst_data62        //|> o
  ,sc2mac_dat_a_dst_data63        //|> o
  ,sc2mac_dat_a_dst_data64        //|> o
  ,sc2mac_dat_a_dst_data65        //|> o
  ,sc2mac_dat_a_dst_data66        //|> o
  ,sc2mac_dat_a_dst_data67        //|> o
  ,sc2mac_dat_a_dst_data68        //|> o
  ,sc2mac_dat_a_dst_data69        //|> o
  ,sc2mac_dat_a_dst_data70        //|> o
  ,sc2mac_dat_a_dst_data71        //|> o
  ,sc2mac_dat_a_dst_data72        //|> o
  ,sc2mac_dat_a_dst_data73        //|> o
  ,sc2mac_dat_a_dst_data74        //|> o
  ,sc2mac_dat_a_dst_data75        //|> o
  ,sc2mac_dat_a_dst_data76        //|> o
  ,sc2mac_dat_a_dst_data77        //|> o
  ,sc2mac_dat_a_dst_data78        //|> o
  ,sc2mac_dat_a_dst_data79        //|> o
  ,sc2mac_dat_a_dst_data80        //|> o
  ,sc2mac_dat_a_dst_data81        //|> o
  ,sc2mac_dat_a_dst_data82        //|> o
  ,sc2mac_dat_a_dst_data83        //|> o
  ,sc2mac_dat_a_dst_data84        //|> o
  ,sc2mac_dat_a_dst_data85        //|> o
  ,sc2mac_dat_a_dst_data86        //|> o
  ,sc2mac_dat_a_dst_data87        //|> o
  ,sc2mac_dat_a_dst_data88        //|> o
  ,sc2mac_dat_a_dst_data89        //|> o
  ,sc2mac_dat_a_dst_data90        //|> o
  ,sc2mac_dat_a_dst_data91        //|> o
  ,sc2mac_dat_a_dst_data92        //|> o
  ,sc2mac_dat_a_dst_data93        //|> o
  ,sc2mac_dat_a_dst_data94        //|> o
  ,sc2mac_dat_a_dst_data95        //|> o
  ,sc2mac_dat_a_dst_data96        //|> o
  ,sc2mac_dat_a_dst_data97        //|> o
  ,sc2mac_dat_a_dst_data98        //|> o
  ,sc2mac_dat_a_dst_data99        //|> o
  ,sc2mac_dat_a_dst_data100       //|> o
  ,sc2mac_dat_a_dst_data101       //|> o
  ,sc2mac_dat_a_dst_data102       //|> o
  ,sc2mac_dat_a_dst_data103       //|> o
  ,sc2mac_dat_a_dst_data104       //|> o
  ,sc2mac_dat_a_dst_data105       //|> o
  ,sc2mac_dat_a_dst_data106       //|> o
  ,sc2mac_dat_a_dst_data107       //|> o
  ,sc2mac_dat_a_dst_data108       //|> o
  ,sc2mac_dat_a_dst_data109       //|> o
  ,sc2mac_dat_a_dst_data110       //|> o
  ,sc2mac_dat_a_dst_data111       //|> o
  ,sc2mac_dat_a_dst_data112       //|> o
  ,sc2mac_dat_a_dst_data113       //|> o
  ,sc2mac_dat_a_dst_data114       //|> o
  ,sc2mac_dat_a_dst_data115       //|> o
  ,sc2mac_dat_a_dst_data116       //|> o
  ,sc2mac_dat_a_dst_data117       //|> o
  ,sc2mac_dat_a_dst_data118       //|> o
  ,sc2mac_dat_a_dst_data119       //|> o
  ,sc2mac_dat_a_dst_data120       //|> o
  ,sc2mac_dat_a_dst_data121       //|> o
  ,sc2mac_dat_a_dst_data122       //|> o
  ,sc2mac_dat_a_dst_data123       //|> o
  ,sc2mac_dat_a_dst_data124       //|> o
  ,sc2mac_dat_a_dst_data125       //|> o
  ,sc2mac_dat_a_dst_data126       //|> o
  ,sc2mac_dat_a_dst_data127       //|> o
  ,sc2mac_dat_a_dst_pd            //|> o
  ,sc2mac_dat_a_src_pvld          //|< i
  ,sc2mac_dat_a_src_mask          //|< i
  ,sc2mac_dat_a_src_data0         //|< i
  ,sc2mac_dat_a_src_data1         //|< i
  ,sc2mac_dat_a_src_data2         //|< i
  ,sc2mac_dat_a_src_data3         //|< i
  ,sc2mac_dat_a_src_data4         //|< i
  ,sc2mac_dat_a_src_data5         //|< i
  ,sc2mac_dat_a_src_data6         //|< i
  ,sc2mac_dat_a_src_data7         //|< i
  ,sc2mac_dat_a_src_data8         //|< i
  ,sc2mac_dat_a_src_data9         //|< i
  ,sc2mac_dat_a_src_data10        //|< i
  ,sc2mac_dat_a_src_data11        //|< i
  ,sc2mac_dat_a_src_data12        //|< i
  ,sc2mac_dat_a_src_data13        //|< i
  ,sc2mac_dat_a_src_data14        //|< i
  ,sc2mac_dat_a_src_data15        //|< i
  ,sc2mac_dat_a_src_data16        //|< i
  ,sc2mac_dat_a_src_data17        //|< i
  ,sc2mac_dat_a_src_data18        //|< i
  ,sc2mac_dat_a_src_data19        //|< i
  ,sc2mac_dat_a_src_data20        //|< i
  ,sc2mac_dat_a_src_data21        //|< i
  ,sc2mac_dat_a_src_data22        //|< i
  ,sc2mac_dat_a_src_data23        //|< i
  ,sc2mac_dat_a_src_data24        //|< i
  ,sc2mac_dat_a_src_data25        //|< i
  ,sc2mac_dat_a_src_data26        //|< i
  ,sc2mac_dat_a_src_data27        //|< i
  ,sc2mac_dat_a_src_data28        //|< i
  ,sc2mac_dat_a_src_data29        //|< i
  ,sc2mac_dat_a_src_data30        //|< i
  ,sc2mac_dat_a_src_data31        //|< i
  ,sc2mac_dat_a_src_data32        //|< i
  ,sc2mac_dat_a_src_data33        //|< i
  ,sc2mac_dat_a_src_data34        //|< i
  ,sc2mac_dat_a_src_data35        //|< i
  ,sc2mac_dat_a_src_data36        //|< i
  ,sc2mac_dat_a_src_data37        //|< i
  ,sc2mac_dat_a_src_data38        //|< i
  ,sc2mac_dat_a_src_data39        //|< i
  ,sc2mac_dat_a_src_data40        //|< i
  ,sc2mac_dat_a_src_data41        //|< i
  ,sc2mac_dat_a_src_data42        //|< i
  ,sc2mac_dat_a_src_data43        //|< i
  ,sc2mac_dat_a_src_data44        //|< i
  ,sc2mac_dat_a_src_data45        //|< i
  ,sc2mac_dat_a_src_data46        //|< i
  ,sc2mac_dat_a_src_data47        //|< i
  ,sc2mac_dat_a_src_data48        //|< i
  ,sc2mac_dat_a_src_data49        //|< i
  ,sc2mac_dat_a_src_data50        //|< i
  ,sc2mac_dat_a_src_data51        //|< i
  ,sc2mac_dat_a_src_data52        //|< i
  ,sc2mac_dat_a_src_data53        //|< i
  ,sc2mac_dat_a_src_data54        //|< i
  ,sc2mac_dat_a_src_data55        //|< i
  ,sc2mac_dat_a_src_data56        //|< i
  ,sc2mac_dat_a_src_data57        //|< i
  ,sc2mac_dat_a_src_data58        //|< i
  ,sc2mac_dat_a_src_data59        //|< i
  ,sc2mac_dat_a_src_data60        //|< i
  ,sc2mac_dat_a_src_data61        //|< i
  ,sc2mac_dat_a_src_data62        //|< i
  ,sc2mac_dat_a_src_data63        //|< i
  ,sc2mac_dat_a_src_data64        //|< i
  ,sc2mac_dat_a_src_data65        //|< i
  ,sc2mac_dat_a_src_data66        //|< i
  ,sc2mac_dat_a_src_data67        //|< i
  ,sc2mac_dat_a_src_data68        //|< i
  ,sc2mac_dat_a_src_data69        //|< i
  ,sc2mac_dat_a_src_data70        //|< i
  ,sc2mac_dat_a_src_data71        //|< i
  ,sc2mac_dat_a_src_data72        //|< i
  ,sc2mac_dat_a_src_data73        //|< i
  ,sc2mac_dat_a_src_data74        //|< i
  ,sc2mac_dat_a_src_data75        //|< i
  ,sc2mac_dat_a_src_data76        //|< i
  ,sc2mac_dat_a_src_data77        //|< i
  ,sc2mac_dat_a_src_data78        //|< i
  ,sc2mac_dat_a_src_data79        //|< i
  ,sc2mac_dat_a_src_data80        //|< i
  ,sc2mac_dat_a_src_data81        //|< i
  ,sc2mac_dat_a_src_data82        //|< i
  ,sc2mac_dat_a_src_data83        //|< i
  ,sc2mac_dat_a_src_data84        //|< i
  ,sc2mac_dat_a_src_data85        //|< i
  ,sc2mac_dat_a_src_data86        //|< i
  ,sc2mac_dat_a_src_data87        //|< i
  ,sc2mac_dat_a_src_data88        //|< i
  ,sc2mac_dat_a_src_data89        //|< i
  ,sc2mac_dat_a_src_data90        //|< i
  ,sc2mac_dat_a_src_data91        //|< i
  ,sc2mac_dat_a_src_data92        //|< i
  ,sc2mac_dat_a_src_data93        //|< i
  ,sc2mac_dat_a_src_data94        //|< i
  ,sc2mac_dat_a_src_data95        //|< i
  ,sc2mac_dat_a_src_data96        //|< i
  ,sc2mac_dat_a_src_data97        //|< i
  ,sc2mac_dat_a_src_data98        //|< i
  ,sc2mac_dat_a_src_data99        //|< i
  ,sc2mac_dat_a_src_data100       //|< i
  ,sc2mac_dat_a_src_data101       //|< i
  ,sc2mac_dat_a_src_data102       //|< i
  ,sc2mac_dat_a_src_data103       //|< i
  ,sc2mac_dat_a_src_data104       //|< i
  ,sc2mac_dat_a_src_data105       //|< i
  ,sc2mac_dat_a_src_data106       //|< i
  ,sc2mac_dat_a_src_data107       //|< i
  ,sc2mac_dat_a_src_data108       //|< i
  ,sc2mac_dat_a_src_data109       //|< i
  ,sc2mac_dat_a_src_data110       //|< i
  ,sc2mac_dat_a_src_data111       //|< i
  ,sc2mac_dat_a_src_data112       //|< i
  ,sc2mac_dat_a_src_data113       //|< i
  ,sc2mac_dat_a_src_data114       //|< i
  ,sc2mac_dat_a_src_data115       //|< i
  ,sc2mac_dat_a_src_data116       //|< i
  ,sc2mac_dat_a_src_data117       //|< i
  ,sc2mac_dat_a_src_data118       //|< i
  ,sc2mac_dat_a_src_data119       //|< i
  ,sc2mac_dat_a_src_data120       //|< i
  ,sc2mac_dat_a_src_data121       //|< i
  ,sc2mac_dat_a_src_data122       //|< i
  ,sc2mac_dat_a_src_data123       //|< i
  ,sc2mac_dat_a_src_data124       //|< i
  ,sc2mac_dat_a_src_data125       //|< i
  ,sc2mac_dat_a_src_data126       //|< i
  ,sc2mac_dat_a_src_data127       //|< i
  ,sc2mac_dat_a_src_pd            //|< i
  ,sc2mac_wt_a_dst_pvld           //|> o
  ,sc2mac_wt_a_dst_mask           //|> o
  ,sc2mac_wt_a_dst_data0          //|> o
  ,sc2mac_wt_a_dst_data1          //|> o
  ,sc2mac_wt_a_dst_data2          //|> o
  ,sc2mac_wt_a_dst_data3          //|> o
  ,sc2mac_wt_a_dst_data4          //|> o
  ,sc2mac_wt_a_dst_data5          //|> o
  ,sc2mac_wt_a_dst_data6          //|> o
  ,sc2mac_wt_a_dst_data7          //|> o
  ,sc2mac_wt_a_dst_data8          //|> o
  ,sc2mac_wt_a_dst_data9          //|> o
  ,sc2mac_wt_a_dst_data10         //|> o
  ,sc2mac_wt_a_dst_data11         //|> o
  ,sc2mac_wt_a_dst_data12         //|> o
  ,sc2mac_wt_a_dst_data13         //|> o
  ,sc2mac_wt_a_dst_data14         //|> o
  ,sc2mac_wt_a_dst_data15         //|> o
  ,sc2mac_wt_a_dst_data16         //|> o
  ,sc2mac_wt_a_dst_data17         //|> o
  ,sc2mac_wt_a_dst_data18         //|> o
  ,sc2mac_wt_a_dst_data19         //|> o
  ,sc2mac_wt_a_dst_data20         //|> o
  ,sc2mac_wt_a_dst_data21         //|> o
  ,sc2mac_wt_a_dst_data22         //|> o
  ,sc2mac_wt_a_dst_data23         //|> o
  ,sc2mac_wt_a_dst_data24         //|> o
  ,sc2mac_wt_a_dst_data25         //|> o
  ,sc2mac_wt_a_dst_data26         //|> o
  ,sc2mac_wt_a_dst_data27         //|> o
  ,sc2mac_wt_a_dst_data28         //|> o
  ,sc2mac_wt_a_dst_data29         //|> o
  ,sc2mac_wt_a_dst_data30         //|> o
  ,sc2mac_wt_a_dst_data31         //|> o
  ,sc2mac_wt_a_dst_data32         //|> o
  ,sc2mac_wt_a_dst_data33         //|> o
  ,sc2mac_wt_a_dst_data34         //|> o
  ,sc2mac_wt_a_dst_data35         //|> o
  ,sc2mac_wt_a_dst_data36         //|> o
  ,sc2mac_wt_a_dst_data37         //|> o
  ,sc2mac_wt_a_dst_data38         //|> o
  ,sc2mac_wt_a_dst_data39         //|> o
  ,sc2mac_wt_a_dst_data40         //|> o
  ,sc2mac_wt_a_dst_data41         //|> o
  ,sc2mac_wt_a_dst_data42         //|> o
  ,sc2mac_wt_a_dst_data43         //|> o
  ,sc2mac_wt_a_dst_data44         //|> o
  ,sc2mac_wt_a_dst_data45         //|> o
  ,sc2mac_wt_a_dst_data46         //|> o
  ,sc2mac_wt_a_dst_data47         //|> o
  ,sc2mac_wt_a_dst_data48         //|> o
  ,sc2mac_wt_a_dst_data49         //|> o
  ,sc2mac_wt_a_dst_data50         //|> o
  ,sc2mac_wt_a_dst_data51         //|> o
  ,sc2mac_wt_a_dst_data52         //|> o
  ,sc2mac_wt_a_dst_data53         //|> o
  ,sc2mac_wt_a_dst_data54         //|> o
  ,sc2mac_wt_a_dst_data55         //|> o
  ,sc2mac_wt_a_dst_data56         //|> o
  ,sc2mac_wt_a_dst_data57         //|> o
  ,sc2mac_wt_a_dst_data58         //|> o
  ,sc2mac_wt_a_dst_data59         //|> o
  ,sc2mac_wt_a_dst_data60         //|> o
  ,sc2mac_wt_a_dst_data61         //|> o
  ,sc2mac_wt_a_dst_data62         //|> o
  ,sc2mac_wt_a_dst_data63         //|> o
  ,sc2mac_wt_a_dst_data64         //|> o
  ,sc2mac_wt_a_dst_data65         //|> o
  ,sc2mac_wt_a_dst_data66         //|> o
  ,sc2mac_wt_a_dst_data67         //|> o
  ,sc2mac_wt_a_dst_data68         //|> o
  ,sc2mac_wt_a_dst_data69         //|> o
  ,sc2mac_wt_a_dst_data70         //|> o
  ,sc2mac_wt_a_dst_data71         //|> o
  ,sc2mac_wt_a_dst_data72         //|> o
  ,sc2mac_wt_a_dst_data73         //|> o
  ,sc2mac_wt_a_dst_data74         //|> o
  ,sc2mac_wt_a_dst_data75         //|> o
  ,sc2mac_wt_a_dst_data76         //|> o
  ,sc2mac_wt_a_dst_data77         //|> o
  ,sc2mac_wt_a_dst_data78         //|> o
  ,sc2mac_wt_a_dst_data79         //|> o
  ,sc2mac_wt_a_dst_data80         //|> o
  ,sc2mac_wt_a_dst_data81         //|> o
  ,sc2mac_wt_a_dst_data82         //|> o
  ,sc2mac_wt_a_dst_data83         //|> o
  ,sc2mac_wt_a_dst_data84         //|> o
  ,sc2mac_wt_a_dst_data85         //|> o
  ,sc2mac_wt_a_dst_data86         //|> o
  ,sc2mac_wt_a_dst_data87         //|> o
  ,sc2mac_wt_a_dst_data88         //|> o
  ,sc2mac_wt_a_dst_data89         //|> o
  ,sc2mac_wt_a_dst_data90         //|> o
  ,sc2mac_wt_a_dst_data91         //|> o
  ,sc2mac_wt_a_dst_data92         //|> o
  ,sc2mac_wt_a_dst_data93         //|> o
  ,sc2mac_wt_a_dst_data94         //|> o
  ,sc2mac_wt_a_dst_data95         //|> o
  ,sc2mac_wt_a_dst_data96         //|> o
  ,sc2mac_wt_a_dst_data97         //|> o
  ,sc2mac_wt_a_dst_data98         //|> o
  ,sc2mac_wt_a_dst_data99         //|> o
  ,sc2mac_wt_a_dst_data100        //|> o
  ,sc2mac_wt_a_dst_data101        //|> o
  ,sc2mac_wt_a_dst_data102        //|> o
  ,sc2mac_wt_a_dst_data103        //|> o
  ,sc2mac_wt_a_dst_data104        //|> o
  ,sc2mac_wt_a_dst_data105        //|> o
  ,sc2mac_wt_a_dst_data106        //|> o
  ,sc2mac_wt_a_dst_data107        //|> o
  ,sc2mac_wt_a_dst_data108        //|> o
  ,sc2mac_wt_a_dst_data109        //|> o
  ,sc2mac_wt_a_dst_data110        //|> o
  ,sc2mac_wt_a_dst_data111        //|> o
  ,sc2mac_wt_a_dst_data112        //|> o
  ,sc2mac_wt_a_dst_data113        //|> o
  ,sc2mac_wt_a_dst_data114        //|> o
  ,sc2mac_wt_a_dst_data115        //|> o
  ,sc2mac_wt_a_dst_data116        //|> o
  ,sc2mac_wt_a_dst_data117        //|> o
  ,sc2mac_wt_a_dst_data118        //|> o
  ,sc2mac_wt_a_dst_data119        //|> o
  ,sc2mac_wt_a_dst_data120        //|> o
  ,sc2mac_wt_a_dst_data121        //|> o
  ,sc2mac_wt_a_dst_data122        //|> o
  ,sc2mac_wt_a_dst_data123        //|> o
  ,sc2mac_wt_a_dst_data124        //|> o
  ,sc2mac_wt_a_dst_data125        //|> o
  ,sc2mac_wt_a_dst_data126        //|> o
  ,sc2mac_wt_a_dst_data127        //|> o
  ,sc2mac_wt_a_dst_sel            //|> o
  ,sc2mac_wt_a_src_pvld           //|< i
  ,sc2mac_wt_a_src_mask           //|< i
  ,sc2mac_wt_a_src_data0          //|< i
  ,sc2mac_wt_a_src_data1          //|< i
  ,sc2mac_wt_a_src_data2          //|< i
  ,sc2mac_wt_a_src_data3          //|< i
  ,sc2mac_wt_a_src_data4          //|< i
  ,sc2mac_wt_a_src_data5          //|< i
  ,sc2mac_wt_a_src_data6          //|< i
  ,sc2mac_wt_a_src_data7          //|< i
  ,sc2mac_wt_a_src_data8          //|< i
  ,sc2mac_wt_a_src_data9          //|< i
  ,sc2mac_wt_a_src_data10         //|< i
  ,sc2mac_wt_a_src_data11         //|< i
  ,sc2mac_wt_a_src_data12         //|< i
  ,sc2mac_wt_a_src_data13         //|< i
  ,sc2mac_wt_a_src_data14         //|< i
  ,sc2mac_wt_a_src_data15         //|< i
  ,sc2mac_wt_a_src_data16         //|< i
  ,sc2mac_wt_a_src_data17         //|< i
  ,sc2mac_wt_a_src_data18         //|< i
  ,sc2mac_wt_a_src_data19         //|< i
  ,sc2mac_wt_a_src_data20         //|< i
  ,sc2mac_wt_a_src_data21         //|< i
  ,sc2mac_wt_a_src_data22         //|< i
  ,sc2mac_wt_a_src_data23         //|< i
  ,sc2mac_wt_a_src_data24         //|< i
  ,sc2mac_wt_a_src_data25         //|< i
  ,sc2mac_wt_a_src_data26         //|< i
  ,sc2mac_wt_a_src_data27         //|< i
  ,sc2mac_wt_a_src_data28         //|< i
  ,sc2mac_wt_a_src_data29         //|< i
  ,sc2mac_wt_a_src_data30         //|< i
  ,sc2mac_wt_a_src_data31         //|< i
  ,sc2mac_wt_a_src_data32         //|< i
  ,sc2mac_wt_a_src_data33         //|< i
  ,sc2mac_wt_a_src_data34         //|< i
  ,sc2mac_wt_a_src_data35         //|< i
  ,sc2mac_wt_a_src_data36         //|< i
  ,sc2mac_wt_a_src_data37         //|< i
  ,sc2mac_wt_a_src_data38         //|< i
  ,sc2mac_wt_a_src_data39         //|< i
  ,sc2mac_wt_a_src_data40         //|< i
  ,sc2mac_wt_a_src_data41         //|< i
  ,sc2mac_wt_a_src_data42         //|< i
  ,sc2mac_wt_a_src_data43         //|< i
  ,sc2mac_wt_a_src_data44         //|< i
  ,sc2mac_wt_a_src_data45         //|< i
  ,sc2mac_wt_a_src_data46         //|< i
  ,sc2mac_wt_a_src_data47         //|< i
  ,sc2mac_wt_a_src_data48         //|< i
  ,sc2mac_wt_a_src_data49         //|< i
  ,sc2mac_wt_a_src_data50         //|< i
  ,sc2mac_wt_a_src_data51         //|< i
  ,sc2mac_wt_a_src_data52         //|< i
  ,sc2mac_wt_a_src_data53         //|< i
  ,sc2mac_wt_a_src_data54         //|< i
  ,sc2mac_wt_a_src_data55         //|< i
  ,sc2mac_wt_a_src_data56         //|< i
  ,sc2mac_wt_a_src_data57         //|< i
  ,sc2mac_wt_a_src_data58         //|< i
  ,sc2mac_wt_a_src_data59         //|< i
  ,sc2mac_wt_a_src_data60         //|< i
  ,sc2mac_wt_a_src_data61         //|< i
  ,sc2mac_wt_a_src_data62         //|< i
  ,sc2mac_wt_a_src_data63         //|< i
  ,sc2mac_wt_a_src_data64         //|< i
  ,sc2mac_wt_a_src_data65         //|< i
  ,sc2mac_wt_a_src_data66         //|< i
  ,sc2mac_wt_a_src_data67         //|< i
  ,sc2mac_wt_a_src_data68         //|< i
  ,sc2mac_wt_a_src_data69         //|< i
  ,sc2mac_wt_a_src_data70         //|< i
  ,sc2mac_wt_a_src_data71         //|< i
  ,sc2mac_wt_a_src_data72         //|< i
  ,sc2mac_wt_a_src_data73         //|< i
  ,sc2mac_wt_a_src_data74         //|< i
  ,sc2mac_wt_a_src_data75         //|< i
  ,sc2mac_wt_a_src_data76         //|< i
  ,sc2mac_wt_a_src_data77         //|< i
  ,sc2mac_wt_a_src_data78         //|< i
  ,sc2mac_wt_a_src_data79         //|< i
  ,sc2mac_wt_a_src_data80         //|< i
  ,sc2mac_wt_a_src_data81         //|< i
  ,sc2mac_wt_a_src_data82         //|< i
  ,sc2mac_wt_a_src_data83         //|< i
  ,sc2mac_wt_a_src_data84         //|< i
  ,sc2mac_wt_a_src_data85         //|< i
  ,sc2mac_wt_a_src_data86         //|< i
  ,sc2mac_wt_a_src_data87         //|< i
  ,sc2mac_wt_a_src_data88         //|< i
  ,sc2mac_wt_a_src_data89         //|< i
  ,sc2mac_wt_a_src_data90         //|< i
  ,sc2mac_wt_a_src_data91         //|< i
  ,sc2mac_wt_a_src_data92         //|< i
  ,sc2mac_wt_a_src_data93         //|< i
  ,sc2mac_wt_a_src_data94         //|< i
  ,sc2mac_wt_a_src_data95         //|< i
  ,sc2mac_wt_a_src_data96         //|< i
  ,sc2mac_wt_a_src_data97         //|< i
  ,sc2mac_wt_a_src_data98         //|< i
  ,sc2mac_wt_a_src_data99         //|< i
  ,sc2mac_wt_a_src_data100        //|< i
  ,sc2mac_wt_a_src_data101        //|< i
  ,sc2mac_wt_a_src_data102        //|< i
  ,sc2mac_wt_a_src_data103        //|< i
  ,sc2mac_wt_a_src_data104        //|< i
  ,sc2mac_wt_a_src_data105        //|< i
  ,sc2mac_wt_a_src_data106        //|< i
  ,sc2mac_wt_a_src_data107        //|< i
  ,sc2mac_wt_a_src_data108        //|< i
  ,sc2mac_wt_a_src_data109        //|< i
  ,sc2mac_wt_a_src_data110        //|< i
  ,sc2mac_wt_a_src_data111        //|< i
  ,sc2mac_wt_a_src_data112        //|< i
  ,sc2mac_wt_a_src_data113        //|< i
  ,sc2mac_wt_a_src_data114        //|< i
  ,sc2mac_wt_a_src_data115        //|< i
  ,sc2mac_wt_a_src_data116        //|< i
  ,sc2mac_wt_a_src_data117        //|< i
  ,sc2mac_wt_a_src_data118        //|< i
  ,sc2mac_wt_a_src_data119        //|< i
  ,sc2mac_wt_a_src_data120        //|< i
  ,sc2mac_wt_a_src_data121        //|< i
  ,sc2mac_wt_a_src_data122        //|< i
  ,sc2mac_wt_a_src_data123        //|< i
  ,sc2mac_wt_a_src_data124        //|< i
  ,sc2mac_wt_a_src_data125        //|< i
  ,sc2mac_wt_a_src_data126        //|< i
  ,sc2mac_wt_a_src_data127        //|< i
  ,sc2mac_wt_a_src_sel            //|< i
  ,sdp2csb_resp_valid             //|< i
  ,sdp2csb_resp_pd                //|< i
  ,sdp2cvif_rd_cdt_lat_fifo_pop   //|< i
  ,sdp2cvif_rd_req_valid          //|< i
  ,sdp2cvif_rd_req_ready          //|> o
  ,sdp2cvif_rd_req_pd             //|< i
  ,sdp2cvif_wr_req_valid          //|< i
  ,sdp2cvif_wr_req_ready          //|> o
  ,sdp2cvif_wr_req_pd             //|< i
  ,sdp2glb_done_intr_pd           //|< i
  ,sdp2mcif_rd_cdt_lat_fifo_pop   //|< i
  ,sdp2mcif_rd_req_valid          //|< i
  ,sdp2mcif_rd_req_ready          //|> o
  ,sdp2mcif_rd_req_pd             //|< i
  ,sdp2mcif_wr_req_valid          //|< i
  ,sdp2mcif_wr_req_ready          //|> o
  ,sdp2mcif_wr_req_pd             //|< i
  ,sdp2pdp_valid                  //|< i
  ,sdp2pdp_ready                  //|> o
  ,sdp2pdp_pd                     //|< i
  ,sdp_b2cvif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_b2cvif_rd_req_valid        //|< i
  ,sdp_b2cvif_rd_req_ready        //|> o
  ,sdp_b2cvif_rd_req_pd           //|< i
  ,sdp_b2mcif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_b2mcif_rd_req_valid        //|< i
  ,sdp_b2mcif_rd_req_ready        //|> o
  ,sdp_b2mcif_rd_req_pd           //|< i
  ,sdp_e2cvif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_e2cvif_rd_req_valid        //|< i
  ,sdp_e2cvif_rd_req_ready        //|> o
  ,sdp_e2cvif_rd_req_pd           //|< i
  ,sdp_e2mcif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_e2mcif_rd_req_valid        //|< i
  ,sdp_e2mcif_rd_req_ready        //|> o
  ,sdp_e2mcif_rd_req_pd           //|< i
  ,sdp_n2cvif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_n2cvif_rd_req_valid        //|< i
  ,sdp_n2cvif_rd_req_ready        //|> o
  ,sdp_n2cvif_rd_req_pd           //|< i
  ,sdp_n2mcif_rd_cdt_lat_fifo_pop //|< i
  ,sdp_n2mcif_rd_req_valid        //|< i
  ,sdp_n2mcif_rd_req_ready        //|> o
  ,sdp_n2mcif_rd_req_pd           //|< i
  ,sdp_rdma2csb_resp_valid        //|< i
  ,sdp_rdma2csb_resp_pd           //|< i
  ,nvdla_core_clk                 //|< i
  ,dla_reset_rstn                 //|< i
  ,nvdla_core_rstn                //|> o
  ,nvdla_falcon_clk               //|< i
  ,nvdla_clk_ovr_on               //|> o
  );

//
// NV_NVDLA_partition_o_io.v
//

input  test_mode;
input  direct_reset_;

input  global_clk_ovr_on;
input  tmc2slcg_disable_clock_gating;

input        cacc2csb_resp_dst_valid;  /* data valid */
input [33:0] cacc2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input [1:0] cacc2glb_done_intr_dst_pd;

input        cdma2csb_resp_valid;  /* data valid */
input [33:0] cdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input         cdma_dat2cvif_rd_req_valid;  /* data valid */
output        cdma_dat2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_dat2cvif_rd_req_pd;

input [1:0] cdma_dat2glb_done_intr_pd;

input         cdma_dat2mcif_rd_req_valid;  /* data valid */
output        cdma_dat2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_dat2mcif_rd_req_pd;

input         cdma_wt2cvif_rd_req_valid;  /* data valid */
output        cdma_wt2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_wt2cvif_rd_req_pd;

input [1:0] cdma_wt2glb_done_intr_pd;

input         cdma_wt2mcif_rd_req_valid;  /* data valid */
output        cdma_wt2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] cdma_wt2mcif_rd_req_pd;

input        cmac_a2csb_resp_src_valid;  /* data valid */
input [33:0] cmac_a2csb_resp_src_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input        cmac_b2csb_resp_dst_valid;  /* data valid */
input [33:0] cmac_b2csb_resp_dst_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output        csb2cacc_req_src_pvld;  /* data valid */
input         csb2cacc_req_src_prdy;  /* data return handshake */
output [62:0] csb2cacc_req_src_pd;

output        csb2cdma_req_pvld;  /* data valid */
input         csb2cdma_req_prdy;  /* data return handshake */
output [62:0] csb2cdma_req_pd;

output        csb2cmac_a_req_dst_pvld;  /* data valid */
input         csb2cmac_a_req_dst_prdy;  /* data return handshake */
output [62:0] csb2cmac_a_req_dst_pd;

output        csb2cmac_b_req_src_pvld;  /* data valid */
input         csb2cmac_b_req_src_prdy;  /* data return handshake */
output [62:0] csb2cmac_b_req_src_pd;

output        csb2csc_req_pvld;  /* data valid */
input         csb2csc_req_prdy;  /* data return handshake */
output [62:0] csb2csc_req_pd;

input         csb2nvdla_valid;    /* data valid */
output        csb2nvdla_ready;    /* data return handshake */
input  [15:0] csb2nvdla_addr;
input  [31:0] csb2nvdla_wdat;
input         csb2nvdla_write;
input         csb2nvdla_nposted;

output        csb2sdp_rdma_req_pvld;  /* data valid */
input         csb2sdp_rdma_req_prdy;  /* data return handshake */
output [62:0] csb2sdp_rdma_req_pd;

output        csb2sdp_req_pvld;  /* data valid */
input         csb2sdp_req_prdy;  /* data return handshake */
output [62:0] csb2sdp_req_pd;

input        csc2csb_resp_valid;  /* data valid */
input [33:0] csc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

output         cvif2cdma_dat_rd_rsp_valid;  /* data valid */
input          cvif2cdma_dat_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdma_dat_rd_rsp_pd;

output         cvif2cdma_wt_rd_rsp_valid;  /* data valid */
input          cvif2cdma_wt_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2cdma_wt_rd_rsp_pd;

output        cvif2noc_axi_ar_arvalid;  /* data valid */
input         cvif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] cvif2noc_axi_ar_arid;
output  [3:0] cvif2noc_axi_ar_arlen;
output [63:0] cvif2noc_axi_ar_araddr;

output        cvif2noc_axi_aw_awvalid;  /* data valid */
input         cvif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] cvif2noc_axi_aw_awid;
output  [3:0] cvif2noc_axi_aw_awlen;
output [63:0] cvif2noc_axi_aw_awaddr;

output         cvif2noc_axi_w_wvalid;  /* data valid */
input          cvif2noc_axi_w_wready;  /* data return handshake */
output [511:0] cvif2noc_axi_w_wdata;
output  [63:0] cvif2noc_axi_w_wstrb;
output         cvif2noc_axi_w_wlast;

output         cvif2sdp_b_rd_rsp_valid;  /* data valid */
input          cvif2sdp_b_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_b_rd_rsp_pd;

output         cvif2sdp_e_rd_rsp_valid;  /* data valid */
input          cvif2sdp_e_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_e_rd_rsp_pd;

output         cvif2sdp_n_rd_rsp_valid;  /* data valid */
input          cvif2sdp_n_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_n_rd_rsp_pd;

output         cvif2sdp_rd_rsp_valid;  /* data valid */
input          cvif2sdp_rd_rsp_ready;  /* data return handshake */
output [513:0] cvif2sdp_rd_rsp_pd;

output  cvif2sdp_wr_rsp_complete;

output         mcif2cdma_dat_rd_rsp_valid;  /* data valid */
input          mcif2cdma_dat_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdma_dat_rd_rsp_pd;

output         mcif2cdma_wt_rd_rsp_valid;  /* data valid */
input          mcif2cdma_wt_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2cdma_wt_rd_rsp_pd;

output        mcif2noc_axi_ar_arvalid;  /* data valid */
input         mcif2noc_axi_ar_arready;  /* data return handshake */
output  [7:0] mcif2noc_axi_ar_arid;
output  [3:0] mcif2noc_axi_ar_arlen;
output [63:0] mcif2noc_axi_ar_araddr;

output        mcif2noc_axi_aw_awvalid;  /* data valid */
input         mcif2noc_axi_aw_awready;  /* data return handshake */
output  [7:0] mcif2noc_axi_aw_awid;
output  [3:0] mcif2noc_axi_aw_awlen;
output [63:0] mcif2noc_axi_aw_awaddr;

output         mcif2noc_axi_w_wvalid;  /* data valid */
input          mcif2noc_axi_w_wready;  /* data return handshake */
output [511:0] mcif2noc_axi_w_wdata;
output  [63:0] mcif2noc_axi_w_wstrb;
output         mcif2noc_axi_w_wlast;

output         mcif2sdp_b_rd_rsp_valid;  /* data valid */
input          mcif2sdp_b_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_b_rd_rsp_pd;

output         mcif2sdp_e_rd_rsp_valid;  /* data valid */
input          mcif2sdp_e_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_e_rd_rsp_pd;

output         mcif2sdp_n_rd_rsp_valid;  /* data valid */
input          mcif2sdp_n_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_n_rd_rsp_pd;

output         mcif2sdp_rd_rsp_valid;  /* data valid */
input          mcif2sdp_rd_rsp_ready;  /* data return handshake */
output [513:0] mcif2sdp_rd_rsp_pd;

output  mcif2sdp_wr_rsp_complete;

input        noc2cvif_axi_b_bvalid;  /* data valid */
output       noc2cvif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2cvif_axi_b_bid;

input          noc2cvif_axi_r_rvalid;  /* data valid */
output         noc2cvif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2cvif_axi_r_rid;
input          noc2cvif_axi_r_rlast;
input  [511:0] noc2cvif_axi_r_rdata;

input        noc2mcif_axi_b_bvalid;  /* data valid */
output       noc2mcif_axi_b_bready;  /* data return handshake */
input  [7:0] noc2mcif_axi_b_bid;

input          noc2mcif_axi_r_rvalid;  /* data valid */
output         noc2mcif_axi_r_rready;  /* data return handshake */
input    [7:0] noc2mcif_axi_r_rid;
input          noc2mcif_axi_r_rlast;
input  [511:0] noc2mcif_axi_r_rdata;

output        nvdla2csb_valid;  /* data valid */
output [31:0] nvdla2csb_data;

output  nvdla2csb_wr_complete;

output  core_intr;

input [31:0] pwrbus_ram_pd;

output         sc2mac_dat_a_dst_pvld;     /* data valid */
output [127:0] sc2mac_dat_a_dst_mask;
output   [7:0] sc2mac_dat_a_dst_data0;
output   [7:0] sc2mac_dat_a_dst_data1;
output   [7:0] sc2mac_dat_a_dst_data2;
output   [7:0] sc2mac_dat_a_dst_data3;
output   [7:0] sc2mac_dat_a_dst_data4;
output   [7:0] sc2mac_dat_a_dst_data5;
output   [7:0] sc2mac_dat_a_dst_data6;
output   [7:0] sc2mac_dat_a_dst_data7;
output   [7:0] sc2mac_dat_a_dst_data8;
output   [7:0] sc2mac_dat_a_dst_data9;
output   [7:0] sc2mac_dat_a_dst_data10;
output   [7:0] sc2mac_dat_a_dst_data11;
output   [7:0] sc2mac_dat_a_dst_data12;
output   [7:0] sc2mac_dat_a_dst_data13;
output   [7:0] sc2mac_dat_a_dst_data14;
output   [7:0] sc2mac_dat_a_dst_data15;
output   [7:0] sc2mac_dat_a_dst_data16;
output   [7:0] sc2mac_dat_a_dst_data17;
output   [7:0] sc2mac_dat_a_dst_data18;
output   [7:0] sc2mac_dat_a_dst_data19;
output   [7:0] sc2mac_dat_a_dst_data20;
output   [7:0] sc2mac_dat_a_dst_data21;
output   [7:0] sc2mac_dat_a_dst_data22;
output   [7:0] sc2mac_dat_a_dst_data23;
output   [7:0] sc2mac_dat_a_dst_data24;
output   [7:0] sc2mac_dat_a_dst_data25;
output   [7:0] sc2mac_dat_a_dst_data26;
output   [7:0] sc2mac_dat_a_dst_data27;
output   [7:0] sc2mac_dat_a_dst_data28;
output   [7:0] sc2mac_dat_a_dst_data29;
output   [7:0] sc2mac_dat_a_dst_data30;
output   [7:0] sc2mac_dat_a_dst_data31;
output   [7:0] sc2mac_dat_a_dst_data32;
output   [7:0] sc2mac_dat_a_dst_data33;
output   [7:0] sc2mac_dat_a_dst_data34;
output   [7:0] sc2mac_dat_a_dst_data35;
output   [7:0] sc2mac_dat_a_dst_data36;
output   [7:0] sc2mac_dat_a_dst_data37;
output   [7:0] sc2mac_dat_a_dst_data38;
output   [7:0] sc2mac_dat_a_dst_data39;
output   [7:0] sc2mac_dat_a_dst_data40;
output   [7:0] sc2mac_dat_a_dst_data41;
output   [7:0] sc2mac_dat_a_dst_data42;
output   [7:0] sc2mac_dat_a_dst_data43;
output   [7:0] sc2mac_dat_a_dst_data44;
output   [7:0] sc2mac_dat_a_dst_data45;
output   [7:0] sc2mac_dat_a_dst_data46;
output   [7:0] sc2mac_dat_a_dst_data47;
output   [7:0] sc2mac_dat_a_dst_data48;
output   [7:0] sc2mac_dat_a_dst_data49;
output   [7:0] sc2mac_dat_a_dst_data50;
output   [7:0] sc2mac_dat_a_dst_data51;
output   [7:0] sc2mac_dat_a_dst_data52;
output   [7:0] sc2mac_dat_a_dst_data53;
output   [7:0] sc2mac_dat_a_dst_data54;
output   [7:0] sc2mac_dat_a_dst_data55;
output   [7:0] sc2mac_dat_a_dst_data56;
output   [7:0] sc2mac_dat_a_dst_data57;
output   [7:0] sc2mac_dat_a_dst_data58;
output   [7:0] sc2mac_dat_a_dst_data59;
output   [7:0] sc2mac_dat_a_dst_data60;
output   [7:0] sc2mac_dat_a_dst_data61;
output   [7:0] sc2mac_dat_a_dst_data62;
output   [7:0] sc2mac_dat_a_dst_data63;
output   [7:0] sc2mac_dat_a_dst_data64;
output   [7:0] sc2mac_dat_a_dst_data65;
output   [7:0] sc2mac_dat_a_dst_data66;
output   [7:0] sc2mac_dat_a_dst_data67;
output   [7:0] sc2mac_dat_a_dst_data68;
output   [7:0] sc2mac_dat_a_dst_data69;
output   [7:0] sc2mac_dat_a_dst_data70;
output   [7:0] sc2mac_dat_a_dst_data71;
output   [7:0] sc2mac_dat_a_dst_data72;
output   [7:0] sc2mac_dat_a_dst_data73;
output   [7:0] sc2mac_dat_a_dst_data74;
output   [7:0] sc2mac_dat_a_dst_data75;
output   [7:0] sc2mac_dat_a_dst_data76;
output   [7:0] sc2mac_dat_a_dst_data77;
output   [7:0] sc2mac_dat_a_dst_data78;
output   [7:0] sc2mac_dat_a_dst_data79;
output   [7:0] sc2mac_dat_a_dst_data80;
output   [7:0] sc2mac_dat_a_dst_data81;
output   [7:0] sc2mac_dat_a_dst_data82;
output   [7:0] sc2mac_dat_a_dst_data83;
output   [7:0] sc2mac_dat_a_dst_data84;
output   [7:0] sc2mac_dat_a_dst_data85;
output   [7:0] sc2mac_dat_a_dst_data86;
output   [7:0] sc2mac_dat_a_dst_data87;
output   [7:0] sc2mac_dat_a_dst_data88;
output   [7:0] sc2mac_dat_a_dst_data89;
output   [7:0] sc2mac_dat_a_dst_data90;
output   [7:0] sc2mac_dat_a_dst_data91;
output   [7:0] sc2mac_dat_a_dst_data92;
output   [7:0] sc2mac_dat_a_dst_data93;
output   [7:0] sc2mac_dat_a_dst_data94;
output   [7:0] sc2mac_dat_a_dst_data95;
output   [7:0] sc2mac_dat_a_dst_data96;
output   [7:0] sc2mac_dat_a_dst_data97;
output   [7:0] sc2mac_dat_a_dst_data98;
output   [7:0] sc2mac_dat_a_dst_data99;
output   [7:0] sc2mac_dat_a_dst_data100;
output   [7:0] sc2mac_dat_a_dst_data101;
output   [7:0] sc2mac_dat_a_dst_data102;
output   [7:0] sc2mac_dat_a_dst_data103;
output   [7:0] sc2mac_dat_a_dst_data104;
output   [7:0] sc2mac_dat_a_dst_data105;
output   [7:0] sc2mac_dat_a_dst_data106;
output   [7:0] sc2mac_dat_a_dst_data107;
output   [7:0] sc2mac_dat_a_dst_data108;
output   [7:0] sc2mac_dat_a_dst_data109;
output   [7:0] sc2mac_dat_a_dst_data110;
output   [7:0] sc2mac_dat_a_dst_data111;
output   [7:0] sc2mac_dat_a_dst_data112;
output   [7:0] sc2mac_dat_a_dst_data113;
output   [7:0] sc2mac_dat_a_dst_data114;
output   [7:0] sc2mac_dat_a_dst_data115;
output   [7:0] sc2mac_dat_a_dst_data116;
output   [7:0] sc2mac_dat_a_dst_data117;
output   [7:0] sc2mac_dat_a_dst_data118;
output   [7:0] sc2mac_dat_a_dst_data119;
output   [7:0] sc2mac_dat_a_dst_data120;
output   [7:0] sc2mac_dat_a_dst_data121;
output   [7:0] sc2mac_dat_a_dst_data122;
output   [7:0] sc2mac_dat_a_dst_data123;
output   [7:0] sc2mac_dat_a_dst_data124;
output   [7:0] sc2mac_dat_a_dst_data125;
output   [7:0] sc2mac_dat_a_dst_data126;
output   [7:0] sc2mac_dat_a_dst_data127;
output   [8:0] sc2mac_dat_a_dst_pd;

input         sc2mac_dat_a_src_pvld;     /* data valid */
input [127:0] sc2mac_dat_a_src_mask;
input   [7:0] sc2mac_dat_a_src_data0;
input   [7:0] sc2mac_dat_a_src_data1;
input   [7:0] sc2mac_dat_a_src_data2;
input   [7:0] sc2mac_dat_a_src_data3;
input   [7:0] sc2mac_dat_a_src_data4;
input   [7:0] sc2mac_dat_a_src_data5;
input   [7:0] sc2mac_dat_a_src_data6;
input   [7:0] sc2mac_dat_a_src_data7;
input   [7:0] sc2mac_dat_a_src_data8;
input   [7:0] sc2mac_dat_a_src_data9;
input   [7:0] sc2mac_dat_a_src_data10;
input   [7:0] sc2mac_dat_a_src_data11;
input   [7:0] sc2mac_dat_a_src_data12;
input   [7:0] sc2mac_dat_a_src_data13;
input   [7:0] sc2mac_dat_a_src_data14;
input   [7:0] sc2mac_dat_a_src_data15;
input   [7:0] sc2mac_dat_a_src_data16;
input   [7:0] sc2mac_dat_a_src_data17;
input   [7:0] sc2mac_dat_a_src_data18;
input   [7:0] sc2mac_dat_a_src_data19;
input   [7:0] sc2mac_dat_a_src_data20;
input   [7:0] sc2mac_dat_a_src_data21;
input   [7:0] sc2mac_dat_a_src_data22;
input   [7:0] sc2mac_dat_a_src_data23;
input   [7:0] sc2mac_dat_a_src_data24;
input   [7:0] sc2mac_dat_a_src_data25;
input   [7:0] sc2mac_dat_a_src_data26;
input   [7:0] sc2mac_dat_a_src_data27;
input   [7:0] sc2mac_dat_a_src_data28;
input   [7:0] sc2mac_dat_a_src_data29;
input   [7:0] sc2mac_dat_a_src_data30;
input   [7:0] sc2mac_dat_a_src_data31;
input   [7:0] sc2mac_dat_a_src_data32;
input   [7:0] sc2mac_dat_a_src_data33;
input   [7:0] sc2mac_dat_a_src_data34;
input   [7:0] sc2mac_dat_a_src_data35;
input   [7:0] sc2mac_dat_a_src_data36;
input   [7:0] sc2mac_dat_a_src_data37;
input   [7:0] sc2mac_dat_a_src_data38;
input   [7:0] sc2mac_dat_a_src_data39;
input   [7:0] sc2mac_dat_a_src_data40;
input   [7:0] sc2mac_dat_a_src_data41;
input   [7:0] sc2mac_dat_a_src_data42;
input   [7:0] sc2mac_dat_a_src_data43;
input   [7:0] sc2mac_dat_a_src_data44;
input   [7:0] sc2mac_dat_a_src_data45;
input   [7:0] sc2mac_dat_a_src_data46;
input   [7:0] sc2mac_dat_a_src_data47;
input   [7:0] sc2mac_dat_a_src_data48;
input   [7:0] sc2mac_dat_a_src_data49;
input   [7:0] sc2mac_dat_a_src_data50;
input   [7:0] sc2mac_dat_a_src_data51;
input   [7:0] sc2mac_dat_a_src_data52;
input   [7:0] sc2mac_dat_a_src_data53;
input   [7:0] sc2mac_dat_a_src_data54;
input   [7:0] sc2mac_dat_a_src_data55;
input   [7:0] sc2mac_dat_a_src_data56;
input   [7:0] sc2mac_dat_a_src_data57;
input   [7:0] sc2mac_dat_a_src_data58;
input   [7:0] sc2mac_dat_a_src_data59;
input   [7:0] sc2mac_dat_a_src_data60;
input   [7:0] sc2mac_dat_a_src_data61;
input   [7:0] sc2mac_dat_a_src_data62;
input   [7:0] sc2mac_dat_a_src_data63;
input   [7:0] sc2mac_dat_a_src_data64;
input   [7:0] sc2mac_dat_a_src_data65;
input   [7:0] sc2mac_dat_a_src_data66;
input   [7:0] sc2mac_dat_a_src_data67;
input   [7:0] sc2mac_dat_a_src_data68;
input   [7:0] sc2mac_dat_a_src_data69;
input   [7:0] sc2mac_dat_a_src_data70;
input   [7:0] sc2mac_dat_a_src_data71;
input   [7:0] sc2mac_dat_a_src_data72;
input   [7:0] sc2mac_dat_a_src_data73;
input   [7:0] sc2mac_dat_a_src_data74;
input   [7:0] sc2mac_dat_a_src_data75;
input   [7:0] sc2mac_dat_a_src_data76;
input   [7:0] sc2mac_dat_a_src_data77;
input   [7:0] sc2mac_dat_a_src_data78;
input   [7:0] sc2mac_dat_a_src_data79;
input   [7:0] sc2mac_dat_a_src_data80;
input   [7:0] sc2mac_dat_a_src_data81;
input   [7:0] sc2mac_dat_a_src_data82;
input   [7:0] sc2mac_dat_a_src_data83;
input   [7:0] sc2mac_dat_a_src_data84;
input   [7:0] sc2mac_dat_a_src_data85;
input   [7:0] sc2mac_dat_a_src_data86;
input   [7:0] sc2mac_dat_a_src_data87;
input   [7:0] sc2mac_dat_a_src_data88;
input   [7:0] sc2mac_dat_a_src_data89;
input   [7:0] sc2mac_dat_a_src_data90;
input   [7:0] sc2mac_dat_a_src_data91;
input   [7:0] sc2mac_dat_a_src_data92;
input   [7:0] sc2mac_dat_a_src_data93;
input   [7:0] sc2mac_dat_a_src_data94;
input   [7:0] sc2mac_dat_a_src_data95;
input   [7:0] sc2mac_dat_a_src_data96;
input   [7:0] sc2mac_dat_a_src_data97;
input   [7:0] sc2mac_dat_a_src_data98;
input   [7:0] sc2mac_dat_a_src_data99;
input   [7:0] sc2mac_dat_a_src_data100;
input   [7:0] sc2mac_dat_a_src_data101;
input   [7:0] sc2mac_dat_a_src_data102;
input   [7:0] sc2mac_dat_a_src_data103;
input   [7:0] sc2mac_dat_a_src_data104;
input   [7:0] sc2mac_dat_a_src_data105;
input   [7:0] sc2mac_dat_a_src_data106;
input   [7:0] sc2mac_dat_a_src_data107;
input   [7:0] sc2mac_dat_a_src_data108;
input   [7:0] sc2mac_dat_a_src_data109;
input   [7:0] sc2mac_dat_a_src_data110;
input   [7:0] sc2mac_dat_a_src_data111;
input   [7:0] sc2mac_dat_a_src_data112;
input   [7:0] sc2mac_dat_a_src_data113;
input   [7:0] sc2mac_dat_a_src_data114;
input   [7:0] sc2mac_dat_a_src_data115;
input   [7:0] sc2mac_dat_a_src_data116;
input   [7:0] sc2mac_dat_a_src_data117;
input   [7:0] sc2mac_dat_a_src_data118;
input   [7:0] sc2mac_dat_a_src_data119;
input   [7:0] sc2mac_dat_a_src_data120;
input   [7:0] sc2mac_dat_a_src_data121;
input   [7:0] sc2mac_dat_a_src_data122;
input   [7:0] sc2mac_dat_a_src_data123;
input   [7:0] sc2mac_dat_a_src_data124;
input   [7:0] sc2mac_dat_a_src_data125;
input   [7:0] sc2mac_dat_a_src_data126;
input   [7:0] sc2mac_dat_a_src_data127;
input   [8:0] sc2mac_dat_a_src_pd;

output         sc2mac_wt_a_dst_pvld;     /* data valid */
output [127:0] sc2mac_wt_a_dst_mask;
output   [7:0] sc2mac_wt_a_dst_data0;
output   [7:0] sc2mac_wt_a_dst_data1;
output   [7:0] sc2mac_wt_a_dst_data2;
output   [7:0] sc2mac_wt_a_dst_data3;
output   [7:0] sc2mac_wt_a_dst_data4;
output   [7:0] sc2mac_wt_a_dst_data5;
output   [7:0] sc2mac_wt_a_dst_data6;
output   [7:0] sc2mac_wt_a_dst_data7;
output   [7:0] sc2mac_wt_a_dst_data8;
output   [7:0] sc2mac_wt_a_dst_data9;
output   [7:0] sc2mac_wt_a_dst_data10;
output   [7:0] sc2mac_wt_a_dst_data11;
output   [7:0] sc2mac_wt_a_dst_data12;
output   [7:0] sc2mac_wt_a_dst_data13;
output   [7:0] sc2mac_wt_a_dst_data14;
output   [7:0] sc2mac_wt_a_dst_data15;
output   [7:0] sc2mac_wt_a_dst_data16;
output   [7:0] sc2mac_wt_a_dst_data17;
output   [7:0] sc2mac_wt_a_dst_data18;
output   [7:0] sc2mac_wt_a_dst_data19;
output   [7:0] sc2mac_wt_a_dst_data20;
output   [7:0] sc2mac_wt_a_dst_data21;
output   [7:0] sc2mac_wt_a_dst_data22;
output   [7:0] sc2mac_wt_a_dst_data23;
output   [7:0] sc2mac_wt_a_dst_data24;
output   [7:0] sc2mac_wt_a_dst_data25;
output   [7:0] sc2mac_wt_a_dst_data26;
output   [7:0] sc2mac_wt_a_dst_data27;
output   [7:0] sc2mac_wt_a_dst_data28;
output   [7:0] sc2mac_wt_a_dst_data29;
output   [7:0] sc2mac_wt_a_dst_data30;
output   [7:0] sc2mac_wt_a_dst_data31;
output   [7:0] sc2mac_wt_a_dst_data32;
output   [7:0] sc2mac_wt_a_dst_data33;
output   [7:0] sc2mac_wt_a_dst_data34;
output   [7:0] sc2mac_wt_a_dst_data35;
output   [7:0] sc2mac_wt_a_dst_data36;
output   [7:0] sc2mac_wt_a_dst_data37;
output   [7:0] sc2mac_wt_a_dst_data38;
output   [7:0] sc2mac_wt_a_dst_data39;
output   [7:0] sc2mac_wt_a_dst_data40;
output   [7:0] sc2mac_wt_a_dst_data41;
output   [7:0] sc2mac_wt_a_dst_data42;
output   [7:0] sc2mac_wt_a_dst_data43;
output   [7:0] sc2mac_wt_a_dst_data44;
output   [7:0] sc2mac_wt_a_dst_data45;
output   [7:0] sc2mac_wt_a_dst_data46;
output   [7:0] sc2mac_wt_a_dst_data47;
output   [7:0] sc2mac_wt_a_dst_data48;
output   [7:0] sc2mac_wt_a_dst_data49;
output   [7:0] sc2mac_wt_a_dst_data50;
output   [7:0] sc2mac_wt_a_dst_data51;
output   [7:0] sc2mac_wt_a_dst_data52;
output   [7:0] sc2mac_wt_a_dst_data53;
output   [7:0] sc2mac_wt_a_dst_data54;
output   [7:0] sc2mac_wt_a_dst_data55;
output   [7:0] sc2mac_wt_a_dst_data56;
output   [7:0] sc2mac_wt_a_dst_data57;
output   [7:0] sc2mac_wt_a_dst_data58;
output   [7:0] sc2mac_wt_a_dst_data59;
output   [7:0] sc2mac_wt_a_dst_data60;
output   [7:0] sc2mac_wt_a_dst_data61;
output   [7:0] sc2mac_wt_a_dst_data62;
output   [7:0] sc2mac_wt_a_dst_data63;
output   [7:0] sc2mac_wt_a_dst_data64;
output   [7:0] sc2mac_wt_a_dst_data65;
output   [7:0] sc2mac_wt_a_dst_data66;
output   [7:0] sc2mac_wt_a_dst_data67;
output   [7:0] sc2mac_wt_a_dst_data68;
output   [7:0] sc2mac_wt_a_dst_data69;
output   [7:0] sc2mac_wt_a_dst_data70;
output   [7:0] sc2mac_wt_a_dst_data71;
output   [7:0] sc2mac_wt_a_dst_data72;
output   [7:0] sc2mac_wt_a_dst_data73;
output   [7:0] sc2mac_wt_a_dst_data74;
output   [7:0] sc2mac_wt_a_dst_data75;
output   [7:0] sc2mac_wt_a_dst_data76;
output   [7:0] sc2mac_wt_a_dst_data77;
output   [7:0] sc2mac_wt_a_dst_data78;
output   [7:0] sc2mac_wt_a_dst_data79;
output   [7:0] sc2mac_wt_a_dst_data80;
output   [7:0] sc2mac_wt_a_dst_data81;
output   [7:0] sc2mac_wt_a_dst_data82;
output   [7:0] sc2mac_wt_a_dst_data83;
output   [7:0] sc2mac_wt_a_dst_data84;
output   [7:0] sc2mac_wt_a_dst_data85;
output   [7:0] sc2mac_wt_a_dst_data86;
output   [7:0] sc2mac_wt_a_dst_data87;
output   [7:0] sc2mac_wt_a_dst_data88;
output   [7:0] sc2mac_wt_a_dst_data89;
output   [7:0] sc2mac_wt_a_dst_data90;
output   [7:0] sc2mac_wt_a_dst_data91;
output   [7:0] sc2mac_wt_a_dst_data92;
output   [7:0] sc2mac_wt_a_dst_data93;
output   [7:0] sc2mac_wt_a_dst_data94;
output   [7:0] sc2mac_wt_a_dst_data95;
output   [7:0] sc2mac_wt_a_dst_data96;
output   [7:0] sc2mac_wt_a_dst_data97;
output   [7:0] sc2mac_wt_a_dst_data98;
output   [7:0] sc2mac_wt_a_dst_data99;
output   [7:0] sc2mac_wt_a_dst_data100;
output   [7:0] sc2mac_wt_a_dst_data101;
output   [7:0] sc2mac_wt_a_dst_data102;
output   [7:0] sc2mac_wt_a_dst_data103;
output   [7:0] sc2mac_wt_a_dst_data104;
output   [7:0] sc2mac_wt_a_dst_data105;
output   [7:0] sc2mac_wt_a_dst_data106;
output   [7:0] sc2mac_wt_a_dst_data107;
output   [7:0] sc2mac_wt_a_dst_data108;
output   [7:0] sc2mac_wt_a_dst_data109;
output   [7:0] sc2mac_wt_a_dst_data110;
output   [7:0] sc2mac_wt_a_dst_data111;
output   [7:0] sc2mac_wt_a_dst_data112;
output   [7:0] sc2mac_wt_a_dst_data113;
output   [7:0] sc2mac_wt_a_dst_data114;
output   [7:0] sc2mac_wt_a_dst_data115;
output   [7:0] sc2mac_wt_a_dst_data116;
output   [7:0] sc2mac_wt_a_dst_data117;
output   [7:0] sc2mac_wt_a_dst_data118;
output   [7:0] sc2mac_wt_a_dst_data119;
output   [7:0] sc2mac_wt_a_dst_data120;
output   [7:0] sc2mac_wt_a_dst_data121;
output   [7:0] sc2mac_wt_a_dst_data122;
output   [7:0] sc2mac_wt_a_dst_data123;
output   [7:0] sc2mac_wt_a_dst_data124;
output   [7:0] sc2mac_wt_a_dst_data125;
output   [7:0] sc2mac_wt_a_dst_data126;
output   [7:0] sc2mac_wt_a_dst_data127;
output   [7:0] sc2mac_wt_a_dst_sel;

input         sc2mac_wt_a_src_pvld;     /* data valid */
input [127:0] sc2mac_wt_a_src_mask;
input   [7:0] sc2mac_wt_a_src_data0;
input   [7:0] sc2mac_wt_a_src_data1;
input   [7:0] sc2mac_wt_a_src_data2;
input   [7:0] sc2mac_wt_a_src_data3;
input   [7:0] sc2mac_wt_a_src_data4;
input   [7:0] sc2mac_wt_a_src_data5;
input   [7:0] sc2mac_wt_a_src_data6;
input   [7:0] sc2mac_wt_a_src_data7;
input   [7:0] sc2mac_wt_a_src_data8;
input   [7:0] sc2mac_wt_a_src_data9;
input   [7:0] sc2mac_wt_a_src_data10;
input   [7:0] sc2mac_wt_a_src_data11;
input   [7:0] sc2mac_wt_a_src_data12;
input   [7:0] sc2mac_wt_a_src_data13;
input   [7:0] sc2mac_wt_a_src_data14;
input   [7:0] sc2mac_wt_a_src_data15;
input   [7:0] sc2mac_wt_a_src_data16;
input   [7:0] sc2mac_wt_a_src_data17;
input   [7:0] sc2mac_wt_a_src_data18;
input   [7:0] sc2mac_wt_a_src_data19;
input   [7:0] sc2mac_wt_a_src_data20;
input   [7:0] sc2mac_wt_a_src_data21;
input   [7:0] sc2mac_wt_a_src_data22;
input   [7:0] sc2mac_wt_a_src_data23;
input   [7:0] sc2mac_wt_a_src_data24;
input   [7:0] sc2mac_wt_a_src_data25;
input   [7:0] sc2mac_wt_a_src_data26;
input   [7:0] sc2mac_wt_a_src_data27;
input   [7:0] sc2mac_wt_a_src_data28;
input   [7:0] sc2mac_wt_a_src_data29;
input   [7:0] sc2mac_wt_a_src_data30;
input   [7:0] sc2mac_wt_a_src_data31;
input   [7:0] sc2mac_wt_a_src_data32;
input   [7:0] sc2mac_wt_a_src_data33;
input   [7:0] sc2mac_wt_a_src_data34;
input   [7:0] sc2mac_wt_a_src_data35;
input   [7:0] sc2mac_wt_a_src_data36;
input   [7:0] sc2mac_wt_a_src_data37;
input   [7:0] sc2mac_wt_a_src_data38;
input   [7:0] sc2mac_wt_a_src_data39;
input   [7:0] sc2mac_wt_a_src_data40;
input   [7:0] sc2mac_wt_a_src_data41;
input   [7:0] sc2mac_wt_a_src_data42;
input   [7:0] sc2mac_wt_a_src_data43;
input   [7:0] sc2mac_wt_a_src_data44;
input   [7:0] sc2mac_wt_a_src_data45;
input   [7:0] sc2mac_wt_a_src_data46;
input   [7:0] sc2mac_wt_a_src_data47;
input   [7:0] sc2mac_wt_a_src_data48;
input   [7:0] sc2mac_wt_a_src_data49;
input   [7:0] sc2mac_wt_a_src_data50;
input   [7:0] sc2mac_wt_a_src_data51;
input   [7:0] sc2mac_wt_a_src_data52;
input   [7:0] sc2mac_wt_a_src_data53;
input   [7:0] sc2mac_wt_a_src_data54;
input   [7:0] sc2mac_wt_a_src_data55;
input   [7:0] sc2mac_wt_a_src_data56;
input   [7:0] sc2mac_wt_a_src_data57;
input   [7:0] sc2mac_wt_a_src_data58;
input   [7:0] sc2mac_wt_a_src_data59;
input   [7:0] sc2mac_wt_a_src_data60;
input   [7:0] sc2mac_wt_a_src_data61;
input   [7:0] sc2mac_wt_a_src_data62;
input   [7:0] sc2mac_wt_a_src_data63;
input   [7:0] sc2mac_wt_a_src_data64;
input   [7:0] sc2mac_wt_a_src_data65;
input   [7:0] sc2mac_wt_a_src_data66;
input   [7:0] sc2mac_wt_a_src_data67;
input   [7:0] sc2mac_wt_a_src_data68;
input   [7:0] sc2mac_wt_a_src_data69;
input   [7:0] sc2mac_wt_a_src_data70;
input   [7:0] sc2mac_wt_a_src_data71;
input   [7:0] sc2mac_wt_a_src_data72;
input   [7:0] sc2mac_wt_a_src_data73;
input   [7:0] sc2mac_wt_a_src_data74;
input   [7:0] sc2mac_wt_a_src_data75;
input   [7:0] sc2mac_wt_a_src_data76;
input   [7:0] sc2mac_wt_a_src_data77;
input   [7:0] sc2mac_wt_a_src_data78;
input   [7:0] sc2mac_wt_a_src_data79;
input   [7:0] sc2mac_wt_a_src_data80;
input   [7:0] sc2mac_wt_a_src_data81;
input   [7:0] sc2mac_wt_a_src_data82;
input   [7:0] sc2mac_wt_a_src_data83;
input   [7:0] sc2mac_wt_a_src_data84;
input   [7:0] sc2mac_wt_a_src_data85;
input   [7:0] sc2mac_wt_a_src_data86;
input   [7:0] sc2mac_wt_a_src_data87;
input   [7:0] sc2mac_wt_a_src_data88;
input   [7:0] sc2mac_wt_a_src_data89;
input   [7:0] sc2mac_wt_a_src_data90;
input   [7:0] sc2mac_wt_a_src_data91;
input   [7:0] sc2mac_wt_a_src_data92;
input   [7:0] sc2mac_wt_a_src_data93;
input   [7:0] sc2mac_wt_a_src_data94;
input   [7:0] sc2mac_wt_a_src_data95;
input   [7:0] sc2mac_wt_a_src_data96;
input   [7:0] sc2mac_wt_a_src_data97;
input   [7:0] sc2mac_wt_a_src_data98;
input   [7:0] sc2mac_wt_a_src_data99;
input   [7:0] sc2mac_wt_a_src_data100;
input   [7:0] sc2mac_wt_a_src_data101;
input   [7:0] sc2mac_wt_a_src_data102;
input   [7:0] sc2mac_wt_a_src_data103;
input   [7:0] sc2mac_wt_a_src_data104;
input   [7:0] sc2mac_wt_a_src_data105;
input   [7:0] sc2mac_wt_a_src_data106;
input   [7:0] sc2mac_wt_a_src_data107;
input   [7:0] sc2mac_wt_a_src_data108;
input   [7:0] sc2mac_wt_a_src_data109;
input   [7:0] sc2mac_wt_a_src_data110;
input   [7:0] sc2mac_wt_a_src_data111;
input   [7:0] sc2mac_wt_a_src_data112;
input   [7:0] sc2mac_wt_a_src_data113;
input   [7:0] sc2mac_wt_a_src_data114;
input   [7:0] sc2mac_wt_a_src_data115;
input   [7:0] sc2mac_wt_a_src_data116;
input   [7:0] sc2mac_wt_a_src_data117;
input   [7:0] sc2mac_wt_a_src_data118;
input   [7:0] sc2mac_wt_a_src_data119;
input   [7:0] sc2mac_wt_a_src_data120;
input   [7:0] sc2mac_wt_a_src_data121;
input   [7:0] sc2mac_wt_a_src_data122;
input   [7:0] sc2mac_wt_a_src_data123;
input   [7:0] sc2mac_wt_a_src_data124;
input   [7:0] sc2mac_wt_a_src_data125;
input   [7:0] sc2mac_wt_a_src_data126;
input   [7:0] sc2mac_wt_a_src_data127;
input   [7:0] sc2mac_wt_a_src_sel;

input        sdp2csb_resp_valid;  /* data valid */
input [33:0] sdp2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input  sdp2cvif_rd_cdt_lat_fifo_pop;

input         sdp2cvif_rd_req_valid;  /* data valid */
output        sdp2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp2cvif_rd_req_pd;

input          sdp2cvif_wr_req_valid;  /* data valid */
output         sdp2cvif_wr_req_ready;  /* data return handshake */
input  [514:0] sdp2cvif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input [1:0] sdp2glb_done_intr_pd;

input  sdp2mcif_rd_cdt_lat_fifo_pop;

input         sdp2mcif_rd_req_valid;  /* data valid */
output        sdp2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp2mcif_rd_req_pd;

input          sdp2mcif_wr_req_valid;  /* data valid */
output         sdp2mcif_wr_req_ready;  /* data return handshake */
input  [514:0] sdp2mcif_wr_req_pd;     /* pkt_id_width=1 pkt_widths=78,514  */

input          sdp2pdp_valid;  /* data valid */
output         sdp2pdp_ready;  /* data return handshake */
input  [255:0] sdp2pdp_pd;

input  sdp_b2cvif_rd_cdt_lat_fifo_pop;

input         sdp_b2cvif_rd_req_valid;  /* data valid */
output        sdp_b2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_b2cvif_rd_req_pd;

input  sdp_b2mcif_rd_cdt_lat_fifo_pop;

input         sdp_b2mcif_rd_req_valid;  /* data valid */
output        sdp_b2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_b2mcif_rd_req_pd;

input  sdp_e2cvif_rd_cdt_lat_fifo_pop;

input         sdp_e2cvif_rd_req_valid;  /* data valid */
output        sdp_e2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_e2cvif_rd_req_pd;

input  sdp_e2mcif_rd_cdt_lat_fifo_pop;

input         sdp_e2mcif_rd_req_valid;  /* data valid */
output        sdp_e2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_e2mcif_rd_req_pd;

input  sdp_n2cvif_rd_cdt_lat_fifo_pop;

input         sdp_n2cvif_rd_req_valid;  /* data valid */
output        sdp_n2cvif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_n2cvif_rd_req_pd;

input  sdp_n2mcif_rd_cdt_lat_fifo_pop;

input         sdp_n2mcif_rd_req_valid;  /* data valid */
output        sdp_n2mcif_rd_req_ready;  /* data return handshake */
input  [78:0] sdp_n2mcif_rd_req_pd;

input        sdp_rdma2csb_resp_valid;  /* data valid */
input [33:0] sdp_rdma2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

//input  Jtag_reg_clk;       
//input  Jtag_reg_reset_;    
//input  la_r_clk;           
//input  larstn;             
input  nvdla_core_clk;     
input  dla_reset_rstn;     
output nvdla_core_rstn;     

//input nvdla_host1x_clk;
input nvdla_falcon_clk;

output nvdla_clk_ovr_on;

//stepheng.
//FIXME
//input  [7:0]  falcon2cvif_streamid;
//input  [7:0]  falcon2mcif_streamid;

wire  [33:0] bdma2csb_resp_pd;
wire         bdma2csb_resp_valid;
wire         bdma2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] bdma2cvif_rd_req_pd;
wire         bdma2cvif_rd_req_ready;
wire         bdma2cvif_rd_req_valid;
wire [514:0] bdma2cvif_wr_req_pd;
wire         bdma2cvif_wr_req_ready;
wire         bdma2cvif_wr_req_valid;
wire   [1:0] bdma2glb_done_intr_pd;
wire         bdma2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] bdma2mcif_rd_req_pd;
wire         bdma2mcif_rd_req_ready;
wire         bdma2mcif_rd_req_valid;
wire [514:0] bdma2mcif_wr_req_pd;
wire         bdma2mcif_wr_req_ready;
wire         bdma2mcif_wr_req_valid;
wire  [33:0] cdp2csb_resp_pd;
wire         cdp2csb_resp_valid;
wire         cdp2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] cdp2cvif_rd_req_pd;
wire         cdp2cvif_rd_req_ready;
wire         cdp2cvif_rd_req_valid;
wire [514:0] cdp2cvif_wr_req_pd;
wire         cdp2cvif_wr_req_ready;
wire         cdp2cvif_wr_req_valid;
wire   [1:0] cdp2glb_done_intr_pd;
wire         cdp2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] cdp2mcif_rd_req_pd;
wire         cdp2mcif_rd_req_ready;
wire         cdp2mcif_rd_req_valid;
wire [514:0] cdp2mcif_wr_req_pd;
wire         cdp2mcif_wr_req_ready;
wire         cdp2mcif_wr_req_valid;
wire  [33:0] cdp_rdma2csb_resp_pd;
wire         cdp_rdma2csb_resp_valid;
wire  [33:0] cmac_a2csb_resp_dst_pd;
wire         cmac_a2csb_resp_dst_valid;
wire  [62:0] csb2bdma_req_pd;
wire         csb2bdma_req_prdy;
wire         csb2bdma_req_pvld;
wire  [62:0] csb2cdp_rdma_req_pd;
wire         csb2cdp_rdma_req_prdy;
wire         csb2cdp_rdma_req_pvld;
wire  [62:0] csb2cdp_req_pd;
wire         csb2cdp_req_prdy;
wire         csb2cdp_req_pvld;
wire  [62:0] csb2cmac_a_req_src_pd;
wire         csb2cmac_a_req_src_prdy;
wire         csb2cmac_a_req_src_pvld;
wire  [62:0] csb2cvif_req_pd;
wire         csb2cvif_req_prdy;
wire         csb2cvif_req_pvld;
wire  [62:0] csb2gec_req_pd;
wire         csb2gec_req_prdy;
wire         csb2gec_req_pvld;
wire  [62:0] csb2glb_req_pd;
wire         csb2glb_req_prdy;
wire         csb2glb_req_pvld;
wire  [62:0] csb2mcif_req_pd;
wire         csb2mcif_req_prdy;
wire         csb2mcif_req_pvld;
wire  [62:0] csb2pdp_rdma_req_pd;
wire         csb2pdp_rdma_req_prdy;
wire         csb2pdp_rdma_req_pvld;
wire  [62:0] csb2pdp_req_pd;
wire         csb2pdp_req_prdy;
wire         csb2pdp_req_pvld;
wire  [62:0] csb2rbk_req_pd;
wire         csb2rbk_req_prdy;
wire         csb2rbk_req_pvld;
wire [513:0] cvif2bdma_rd_rsp_pd;
wire         cvif2bdma_rd_rsp_ready;
wire         cvif2bdma_rd_rsp_valid;
wire         cvif2bdma_wr_rsp_complete;
wire [513:0] cvif2cdp_rd_rsp_pd;
wire         cvif2cdp_rd_rsp_ready;
wire         cvif2cdp_rd_rsp_valid;
wire         cvif2cdp_wr_rsp_complete;
wire  [33:0] cvif2csb_resp_pd;
wire         cvif2csb_resp_valid;
wire [513:0] cvif2pdp_rd_rsp_pd;
wire         cvif2pdp_rd_rsp_ready;
wire         cvif2pdp_rd_rsp_valid;
wire         cvif2pdp_wr_rsp_complete;
wire [513:0] cvif2rbk_rd_rsp_pd;
wire         cvif2rbk_rd_rsp_ready;
wire         cvif2rbk_rd_rsp_valid;
wire         cvif2rbk_wr_rsp_complete;
wire         dla_clk_ovr_on_sync;
wire  [33:0] gec2csb_resp_pd;
wire         gec2csb_resp_valid;
wire  [33:0] glb2csb_resp_pd;
wire         glb2csb_resp_valid;
wire         global_clk_ovr_on_sync;
wire [513:0] mcif2bdma_rd_rsp_pd;
wire         mcif2bdma_rd_rsp_ready;
wire         mcif2bdma_rd_rsp_valid;
wire         mcif2bdma_wr_rsp_complete;
wire [513:0] mcif2cdp_rd_rsp_pd;
wire         mcif2cdp_rd_rsp_ready;
wire         mcif2cdp_rd_rsp_valid;
wire         mcif2cdp_wr_rsp_complete;
wire  [33:0] mcif2csb_resp_pd;
wire         mcif2csb_resp_valid;
wire [513:0] mcif2pdp_rd_rsp_pd;
wire         mcif2pdp_rd_rsp_ready;
wire         mcif2pdp_rd_rsp_valid;
wire         mcif2pdp_wr_rsp_complete;
wire [513:0] mcif2rbk_rd_rsp_pd;
wire         mcif2rbk_rd_rsp_ready;
wire         mcif2rbk_rd_rsp_valid;
wire         mcif2rbk_wr_rsp_complete;
wire         nvdla_falcon_rstn;
wire  [33:0] pdp2csb_resp_pd;
wire         pdp2csb_resp_valid;
wire         pdp2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] pdp2cvif_rd_req_pd;
wire         pdp2cvif_rd_req_ready;
wire         pdp2cvif_rd_req_valid;
wire [514:0] pdp2cvif_wr_req_pd;
wire         pdp2cvif_wr_req_ready;
wire         pdp2cvif_wr_req_valid;
wire   [1:0] pdp2glb_done_intr_pd;
wire         pdp2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] pdp2mcif_rd_req_pd;
wire         pdp2mcif_rd_req_ready;
wire         pdp2mcif_rd_req_valid;
wire [514:0] pdp2mcif_wr_req_pd;
wire         pdp2mcif_wr_req_ready;
wire         pdp2mcif_wr_req_valid;
wire  [33:0] pdp_rdma2csb_resp_pd;
wire         pdp_rdma2csb_resp_valid;
wire  [33:0] rbk2csb_resp_pd;
wire         rbk2csb_resp_valid;
wire         rbk2cvif_rd_cdt_lat_fifo_pop;
wire  [78:0] rbk2cvif_rd_req_pd;
wire         rbk2cvif_rd_req_ready;
wire         rbk2cvif_rd_req_valid;
wire [514:0] rbk2cvif_wr_req_pd;
wire         rbk2cvif_wr_req_ready;
wire         rbk2cvif_wr_req_valid;
wire         rbk2mcif_rd_cdt_lat_fifo_pop;
wire  [78:0] rbk2mcif_rd_req_pd;
wire         rbk2mcif_rd_req_ready;
wire         rbk2mcif_rd_req_valid;
wire [514:0] rbk2mcif_wr_req_pd;
wire         rbk2mcif_wr_req_ready;
wire         rbk2mcif_wr_req_valid;
wire   [1:0] rubik2glb_done_intr_pd;

//FIXME
assign nvdla_clk_ovr_on = 0;
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Reset Syncer for nvdla_core_clk             //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_core_reset u_sync_core_reset (
   .dla_reset_rstn                 (dla_reset_rstn)                 //|< i
  ,.direct_reset_                  (direct_reset_)                  //|< i
  ,.test_mode                      (test_mode)                      //|< i
  ,.synced_rstn                    (nvdla_core_rstn)                //|> o
  ,.core_reset_rstn                (1'b1)                           //|< ?
  ,.nvdla_clk                      (nvdla_core_clk)                 //|< i
  );
    //D &Connect core_reset_rstn  core_reset_rstn;
//FIXME need confirm with Yuanzhi

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Reset Syncer for nvdla_falcon_clk           //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_reset u_sync_falcon_reset (
   .dla_reset_rstn                 (nvdla_core_rstn)                //|< o
  ,.direct_reset_                  (direct_reset_)                  //|< i
  ,.test_mode                      (test_mode)                      //|< i
  ,.synced_rstn                    (nvdla_falcon_rstn)              //|> w
  ,.nvdla_clk                      (nvdla_falcon_clk)               //|< i
  );

//&Instance NV_NVDLA_reset u_sync_host1x_reset;
//    &Connect nvdla_clk      nvdla_host1x_clk;
//    &Connect dla_reset_rstn nvdla_core_rstn;
//    &Connect synced_rstn    nvdla_host1x_rstn;

////////////////////////////////////////////////////////////////////////
// SLCG override
////////////////////////////////////////////////////////////////////////
NV_NVDLA_sync3d u_dla_clk_ovr_on_core_sync (
   .clk                            (nvdla_core_clk)                 //|< i
  ,.sync_i                         (nvdla_clk_ovr_on)               //|< o
  ,.sync_o                         (dla_clk_ovr_on_sync)            //|> w
  );

//&Instance NV_NVDLA_sync3d u_dla_clk_ovr_on_falcon_sync;
//&Connect clk      nvdla_falcon_clk;
//&Connect sync_i   nvdla_clk_ovr_on;
//&Connect sync_o   dla_clk_ovr_on_nvdla_falcon_clk_sync;
//
//&Instance NV_NVDLA_sync3d u_dla_clk_ovr_on_host1x_sync;
//&Connect clk      nvdla_host1x_clk;
//&Connect sync_i   nvdla_clk_ovr_on;
//&Connect sync_o   dla_clk_ovr_on_nvdla_host1x_clk_sync;

NV_NVDLA_sync3d_s u_global_clk_ovr_on_core_sync (
   .clk                            (nvdla_core_clk)                 //|< i
  ,.prst                           (nvdla_core_rstn)                //|< o
  ,.sync_i                         (global_clk_ovr_on)              //|< i
  ,.sync_o                         (global_clk_ovr_on_sync)         //|> w
  );

//&Instance NV_NVDLA_sync3d_s u_global_clk_ovr_on_falcon_sync;
//&Connect clk      nvdla_falcon_clk;
//&Connect prst     nvdla_falcon_rstn;
//&Connect sync_i   global_clk_ovr_on;
//&Connect sync_o   global_clk_ovr_on_nvdla_falcon_clk_sync;
//
//&Instance NV_NVDLA_sync3d_s u_global_clk_ovr_on_host1x_sync;
//&Connect clk      nvdla_host1x_clk;
//&Connect prst     nvdla_host1x_rstn;
//&Connect sync_i   global_clk_ovr_on;
//&Connect sync_o   global_clk_ovr_on_nvdla_host1x_clk_sync;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    CSB master                                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_csb_master u_NV_NVDLA_csb_master (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.nvdla_falcon_clk               (nvdla_falcon_clk)               //|< i
  ,.nvdla_falcon_rstn              (nvdla_falcon_rstn)              //|< w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.csb2nvdla_valid                (csb2nvdla_valid)                //|< i
  ,.csb2nvdla_ready                (csb2nvdla_ready)                //|> o
  ,.csb2nvdla_addr                 (csb2nvdla_addr[15:0])           //|< i
  ,.csb2nvdla_wdat                 (csb2nvdla_wdat[31:0])           //|< i
  ,.csb2nvdla_write                (csb2nvdla_write)                //|< i
  ,.csb2nvdla_nposted              (csb2nvdla_nposted)              //|< i
  ,.nvdla2csb_valid                (nvdla2csb_valid)                //|> o
  ,.nvdla2csb_data                 (nvdla2csb_data[31:0])           //|> o
  ,.nvdla2csb_wr_complete          (nvdla2csb_wr_complete)          //|> o
  ,.csb2glb_req_pvld               (csb2glb_req_pvld)               //|> w
  ,.csb2glb_req_prdy               (csb2glb_req_prdy)               //|< w
  ,.csb2glb_req_pd                 (csb2glb_req_pd[62:0])           //|> w
  ,.glb2csb_resp_valid             (glb2csb_resp_valid)             //|< w
  ,.glb2csb_resp_pd                (glb2csb_resp_pd[33:0])          //|< w
  ,.csb2gec_req_pvld               (csb2gec_req_pvld)               //|> w
  ,.csb2gec_req_prdy               (csb2gec_req_prdy)               //|< w
  ,.csb2gec_req_pd                 (csb2gec_req_pd[62:0])           //|> w
  ,.gec2csb_resp_valid             (gec2csb_resp_valid)             //|< w
  ,.gec2csb_resp_pd                (gec2csb_resp_pd[33:0])          //|< w
  ,.csb2mcif_req_pvld              (csb2mcif_req_pvld)              //|> w
  ,.csb2mcif_req_prdy              (csb2mcif_req_prdy)              //|< w
  ,.csb2mcif_req_pd                (csb2mcif_req_pd[62:0])          //|> w
  ,.mcif2csb_resp_valid            (mcif2csb_resp_valid)            //|< w
  ,.mcif2csb_resp_pd               (mcif2csb_resp_pd[33:0])         //|< w
  ,.csb2cvif_req_pvld              (csb2cvif_req_pvld)              //|> w
  ,.csb2cvif_req_prdy              (csb2cvif_req_prdy)              //|< w
  ,.csb2cvif_req_pd                (csb2cvif_req_pd[62:0])          //|> w
  ,.cvif2csb_resp_valid            (cvif2csb_resp_valid)            //|< w
  ,.cvif2csb_resp_pd               (cvif2csb_resp_pd[33:0])         //|< w
#ifdef NVDLA_BDMA_ENABLE
  ,.csb2bdma_req_pvld              (csb2bdma_req_pvld)              //|> w
  ,.csb2bdma_req_prdy              (csb2bdma_req_prdy)              //|< w
  ,.csb2bdma_req_pd                (csb2bdma_req_pd[62:0])          //|> w
  ,.bdma2csb_resp_valid            (bdma2csb_resp_valid)            //|< w
  ,.bdma2csb_resp_pd               (bdma2csb_resp_pd[33:0])         //|< w
#else
  ,.csb2bdma_req_pvld              (csb2bdma_req_pvld)              //|> w
  ,.csb2bdma_req_prdy              (1'b1                    )       //|< w
  ,.csb2bdma_req_pd                (csb2bdma_req_pd[62:0])          //|> w
  ,.bdma2csb_resp_valid            (1'b0                    )       //|< w
  ,.bdma2csb_resp_pd               (34'd0                   )       //|< w
#endif
  ,.csb2cdma_req_pvld              (csb2cdma_req_pvld)              //|> o
  ,.csb2cdma_req_prdy              (csb2cdma_req_prdy)              //|< i
  ,.csb2cdma_req_pd                (csb2cdma_req_pd[62:0])          //|> o
  ,.cdma2csb_resp_valid            (cdma2csb_resp_valid)            //|< i
  ,.cdma2csb_resp_pd               (cdma2csb_resp_pd[33:0])         //|< i
  ,.csb2csc_req_pvld               (csb2csc_req_pvld)               //|> o
  ,.csb2csc_req_prdy               (csb2csc_req_prdy)               //|< i
  ,.csb2csc_req_pd                 (csb2csc_req_pd[62:0])           //|> o
  ,.csc2csb_resp_valid             (csc2csb_resp_valid)             //|< i
  ,.csc2csb_resp_pd                (csc2csb_resp_pd[33:0])          //|< i
  ,.csb2cmac_a_req_pvld            (csb2cmac_a_req_src_pvld)        //|> w
  ,.csb2cmac_a_req_prdy            (csb2cmac_a_req_src_prdy)        //|< w
  ,.csb2cmac_a_req_pd              (csb2cmac_a_req_src_pd[62:0])    //|> w
  ,.cmac_a2csb_resp_valid          (cmac_a2csb_resp_dst_valid)      //|< w
  ,.cmac_a2csb_resp_pd             (cmac_a2csb_resp_dst_pd[33:0])   //|< w
  ,.csb2cmac_b_req_pvld            (csb2cmac_b_req_src_pvld)        //|> o
  ,.csb2cmac_b_req_prdy            (csb2cmac_b_req_src_prdy)        //|< i
  ,.csb2cmac_b_req_pd              (csb2cmac_b_req_src_pd[62:0])    //|> o
  ,.cmac_b2csb_resp_valid          (cmac_b2csb_resp_dst_valid)      //|< i
  ,.cmac_b2csb_resp_pd             (cmac_b2csb_resp_dst_pd[33:0])   //|< i
  ,.csb2cacc_req_pvld              (csb2cacc_req_src_pvld)          //|> o
  ,.csb2cacc_req_prdy              (csb2cacc_req_src_prdy)          //|< i
  ,.csb2cacc_req_pd                (csb2cacc_req_src_pd[62:0])      //|> o
  ,.cacc2csb_resp_valid            (cacc2csb_resp_dst_valid)        //|< i
  ,.cacc2csb_resp_pd               (cacc2csb_resp_dst_pd[33:0])     //|< i
  ,.csb2sdp_rdma_req_pvld          (csb2sdp_rdma_req_pvld)          //|> o
  ,.csb2sdp_rdma_req_prdy          (csb2sdp_rdma_req_prdy)          //|< i
  ,.csb2sdp_rdma_req_pd            (csb2sdp_rdma_req_pd[62:0])      //|> o
  ,.sdp_rdma2csb_resp_valid        (sdp_rdma2csb_resp_valid)        //|< i
  ,.sdp_rdma2csb_resp_pd           (sdp_rdma2csb_resp_pd[33:0])     //|< i
  ,.csb2sdp_req_pvld               (csb2sdp_req_pvld)               //|> o
  ,.csb2sdp_req_prdy               (csb2sdp_req_prdy)               //|< i
  ,.csb2sdp_req_pd                 (csb2sdp_req_pd[62:0])           //|> o
  ,.sdp2csb_resp_valid             (sdp2csb_resp_valid)             //|< i
  ,.sdp2csb_resp_pd                (sdp2csb_resp_pd[33:0])          //|< i
#ifdef NVDLA_PDP_ENABLE
  ,.csb2pdp_rdma_req_pvld          (csb2pdp_rdma_req_pvld)          //|> w
  ,.csb2pdp_rdma_req_prdy          (csb2pdp_rdma_req_prdy)          //|< w
  ,.csb2pdp_rdma_req_pd            (csb2pdp_rdma_req_pd[62:0])      //|> w
  ,.pdp_rdma2csb_resp_valid        (pdp_rdma2csb_resp_valid)        //|< w
  ,.pdp_rdma2csb_resp_pd           (pdp_rdma2csb_resp_pd[33:0])     //|< w
  ,.csb2pdp_req_pvld               (csb2pdp_req_pvld)               //|> w
  ,.csb2pdp_req_prdy               (csb2pdp_req_prdy)               //|< w
  ,.csb2pdp_req_pd                 (csb2pdp_req_pd[62:0])           //|> w
  ,.pdp2csb_resp_valid             (pdp2csb_resp_valid)             //|< w
  ,.pdp2csb_resp_pd                (pdp2csb_resp_pd[33:0])          //|< w
#else
  ,.csb2pdp_rdma_req_pvld          (csb2pdp_rdma_req_pvld)          //|> w
  ,.csb2pdp_rdma_req_prdy          (1'b1                    )       //|< w
  ,.csb2pdp_rdma_req_pd            (csb2pdp_rdma_req_pd[62:0])      //|> w
  ,.pdp_rdma2csb_resp_valid        (1'b0                    )       //|< w
  ,.pdp_rdma2csb_resp_pd           (34'd0                   )       //|< w
  ,.csb2pdp_req_pvld               (csb2pdp_req_pvld)               //|> w
  ,.csb2pdp_req_prdy               (1'b1                    )       //|< w
  ,.csb2pdp_req_pd                 (csb2pdp_req_pd[62:0])           //|> w
  ,.pdp2csb_resp_valid             (1'b0                    )       //|< w
  ,.pdp2csb_resp_pd                (34'd0                   )       //|< w
#endif
#ifdef NVDLA_CDP_ENABLE
  ,.csb2cdp_rdma_req_pvld          (csb2cdp_rdma_req_pvld)          //|> w
  ,.csb2cdp_rdma_req_prdy          (csb2cdp_rdma_req_prdy)          //|< w
  ,.csb2cdp_rdma_req_pd            (csb2cdp_rdma_req_pd[62:0])      //|> w
  ,.cdp_rdma2csb_resp_valid        (cdp_rdma2csb_resp_valid)        //|< w
  ,.cdp_rdma2csb_resp_pd           (cdp_rdma2csb_resp_pd[33:0])     //|< w
  ,.csb2cdp_req_pvld               (csb2cdp_req_pvld)               //|> w
  ,.csb2cdp_req_prdy               (csb2cdp_req_prdy)               //|< w
  ,.csb2cdp_req_pd                 (csb2cdp_req_pd[62:0])           //|> w
  ,.cdp2csb_resp_valid             (cdp2csb_resp_valid)             //|< w
  ,.cdp2csb_resp_pd                (cdp2csb_resp_pd[33:0])          //|< w
#else
  ,.csb2cdp_rdma_req_pvld          (csb2cdp_rdma_req_pvld)          //|> w
  ,.csb2cdp_rdma_req_prdy          (1'b1                    )       //|< w
  ,.csb2cdp_rdma_req_pd            (csb2cdp_rdma_req_pd[62:0])      //|> w
  ,.cdp_rdma2csb_resp_valid        (1'b0                    )       //|< w
  ,.cdp_rdma2csb_resp_pd           (34'd0                   )       //|< w
  ,.csb2cdp_req_pvld               (csb2cdp_req_pvld)               //|> w
  ,.csb2cdp_req_prdy               (1'b1                    )       //|< w
  ,.csb2cdp_req_pd                 (csb2cdp_req_pd[62:0])           //|> w
  ,.cdp2csb_resp_valid             (1'b0                    )       //|< w
  ,.cdp2csb_resp_pd                (34'd0                   )       //|< w
#endif
#ifdef NVDLA_RUBIK_ENABLE 
  ,.csb2rbk_req_pvld               (csb2rbk_req_pvld)               //|> w
  ,.csb2rbk_req_prdy               (csb2rbk_req_prdy)               //|< w
  ,.csb2rbk_req_pd                 (csb2rbk_req_pd[62:0])           //|> w
  ,.rbk2csb_resp_valid             (rbk2csb_resp_valid)             //|< w
  ,.rbk2csb_resp_pd                (rbk2csb_resp_pd[33:0])          //|< w
#else
  ,.csb2rbk_req_pvld               (csb2rbk_req_pvld)               //|> w
  ,.csb2rbk_req_prdy               (1'b1                    )       //|< w
  ,.csb2rbk_req_pd                 (csb2rbk_req_pd[62:0])           //|> w
  ,.rbk2csb_resp_valid             (1'b0                    )       //|< w
  ,.rbk2csb_resp_pd                (34'd0                   )       //|< w
#endif
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    ASYNC CROSSING INTERFACE                    //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_async;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    AXI Interface to MC                         //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_mcif u_NV_NVDLA_mcif (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2mcif_rd_cdt_lat_fifo_pop  (bdma2mcif_rd_cdt_lat_fifo_pop)  //|< w
  ,.bdma2mcif_rd_req_valid         (bdma2mcif_rd_req_valid)         //|< w
  ,.bdma2mcif_rd_req_ready         (bdma2mcif_rd_req_ready)         //|> w
  ,.bdma2mcif_rd_req_pd            (bdma2mcif_rd_req_pd[78:0])      //|< w
  ,.bdma2mcif_wr_req_valid         (bdma2mcif_wr_req_valid)         //|< w
  ,.bdma2mcif_wr_req_ready         (bdma2mcif_wr_req_ready)         //|> w
  ,.bdma2mcif_wr_req_pd            (bdma2mcif_wr_req_pd[514:0])     //|< w
  ,.mcif2bdma_rd_rsp_valid         (mcif2bdma_rd_rsp_valid)         //|> w
  ,.mcif2bdma_rd_rsp_ready         (mcif2bdma_rd_rsp_ready)         //|< w
  ,.mcif2bdma_rd_rsp_pd            (mcif2bdma_rd_rsp_pd[513:0])     //|> w
  ,.mcif2bdma_wr_rsp_complete      (mcif2bdma_wr_rsp_complete)      //|> w
#else
  ,.bdma2mcif_rd_cdt_lat_fifo_pop  (1'b0                    )       //|< w
  ,.bdma2mcif_rd_req_valid         (1'b0                    )       //|< w
  ,.bdma2mcif_rd_req_ready         (bdma2mcif_rd_req_ready)         //|> w
  ,.bdma2mcif_rd_req_pd            (79'd0                   )       //|< w
  ,.bdma2mcif_wr_req_valid         (1'b0                    )       //|< w
  ,.bdma2mcif_wr_req_ready         (bdma2mcif_wr_req_ready)         //|> w
  ,.bdma2mcif_wr_req_pd            (515'd0                  )       //|< w
  ,.mcif2bdma_rd_rsp_valid         (mcif2bdma_rd_rsp_valid)         //|> w
  ,.mcif2bdma_rd_rsp_ready         (1'b1                    )       //|< w
  ,.mcif2bdma_rd_rsp_pd            (mcif2bdma_rd_rsp_pd[513:0])     //|> w
  ,.mcif2bdma_wr_rsp_complete      (mcif2bdma_wr_rsp_complete)      //|> w
#endif
  ,.cdma_dat2mcif_rd_req_valid     (cdma_dat2mcif_rd_req_valid)     //|< i
  ,.cdma_dat2mcif_rd_req_ready     (cdma_dat2mcif_rd_req_ready)     //|> o
  ,.cdma_dat2mcif_rd_req_pd        (cdma_dat2mcif_rd_req_pd[78:0])  //|< i
  ,.cdma_wt2mcif_rd_req_valid      (cdma_wt2mcif_rd_req_valid)      //|< i
  ,.cdma_wt2mcif_rd_req_ready      (cdma_wt2mcif_rd_req_ready)      //|> o
  ,.cdma_wt2mcif_rd_req_pd         (cdma_wt2mcif_rd_req_pd[78:0])   //|< i
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2mcif_rd_cdt_lat_fifo_pop   (cdp2mcif_rd_cdt_lat_fifo_pop)   //|< w
  ,.cdp2mcif_rd_req_valid          (cdp2mcif_rd_req_valid)          //|< w
  ,.cdp2mcif_rd_req_ready          (cdp2mcif_rd_req_ready)          //|> w
  ,.cdp2mcif_rd_req_pd             (cdp2mcif_rd_req_pd[78:0])       //|< w
  ,.cdp2mcif_wr_req_valid          (cdp2mcif_wr_req_valid)          //|< w
  ,.cdp2mcif_wr_req_ready          (cdp2mcif_wr_req_ready)          //|> w
  ,.cdp2mcif_wr_req_pd             (cdp2mcif_wr_req_pd[514:0])      //|< w
  ,.mcif2cdp_rd_rsp_valid          (mcif2cdp_rd_rsp_valid)          //|> w
  ,.mcif2cdp_rd_rsp_ready          (mcif2cdp_rd_rsp_ready)          //|< w
  ,.mcif2cdp_rd_rsp_pd             (mcif2cdp_rd_rsp_pd[513:0])      //|> w
  ,.mcif2cdp_wr_rsp_complete       (mcif2cdp_wr_rsp_complete)       //|> w
#else
  ,.cdp2mcif_rd_cdt_lat_fifo_pop   (1'b0                    )       //|< w
  ,.cdp2mcif_rd_req_valid          (1'b0                    )       //|< w
  ,.cdp2mcif_rd_req_ready          (cdp2mcif_rd_req_ready)          //|> w
  ,.cdp2mcif_rd_req_pd             (79'd0                   )       //|< w
  ,.cdp2mcif_wr_req_valid          (1'b0                    )       //|< w
  ,.cdp2mcif_wr_req_ready          (cdp2mcif_wr_req_ready)          //|> w
  ,.cdp2mcif_wr_req_pd             (515'd0                  )       //|< w
  ,.mcif2cdp_rd_rsp_valid          (mcif2cdp_rd_rsp_valid)          //|> w
  ,.mcif2cdp_rd_rsp_ready          (1'b1                    )       //|< w
  ,.mcif2cdp_rd_rsp_pd             (mcif2cdp_rd_rsp_pd[513:0])      //|> w
  ,.mcif2cdp_wr_rsp_complete       (mcif2cdp_wr_rsp_complete)       //|> w
#endif
  ,.csb2mcif_req_pvld              (csb2mcif_req_pvld)              //|< w
  ,.csb2mcif_req_prdy              (csb2mcif_req_prdy)              //|> w
  ,.csb2mcif_req_pd                (csb2mcif_req_pd[62:0])          //|< w
  ,.mcif2cdma_dat_rd_rsp_valid     (mcif2cdma_dat_rd_rsp_valid)     //|> o
  ,.mcif2cdma_dat_rd_rsp_ready     (mcif2cdma_dat_rd_rsp_ready)     //|< i
  ,.mcif2cdma_dat_rd_rsp_pd        (mcif2cdma_dat_rd_rsp_pd[513:0]) //|> o
  ,.mcif2cdma_wt_rd_rsp_valid      (mcif2cdma_wt_rd_rsp_valid)      //|> o
  ,.mcif2cdma_wt_rd_rsp_ready      (mcif2cdma_wt_rd_rsp_ready)      //|< i
  ,.mcif2cdma_wt_rd_rsp_pd         (mcif2cdma_wt_rd_rsp_pd[513:0])  //|> o
  ,.mcif2csb_resp_valid            (mcif2csb_resp_valid)            //|> w
  ,.mcif2csb_resp_pd               (mcif2csb_resp_pd[33:0])         //|> w
  ,.mcif2noc_axi_ar_arvalid        (mcif2noc_axi_ar_arvalid)        //|> o
  ,.mcif2noc_axi_ar_arready        (mcif2noc_axi_ar_arready)        //|< i
  ,.mcif2noc_axi_ar_arid           (mcif2noc_axi_ar_arid[7:0])      //|> o
  ,.mcif2noc_axi_ar_arlen          (mcif2noc_axi_ar_arlen[3:0])     //|> o
  ,.mcif2noc_axi_ar_araddr         (mcif2noc_axi_ar_araddr[63:0])   //|> o
  ,.mcif2noc_axi_aw_awvalid        (mcif2noc_axi_aw_awvalid)        //|> o
  ,.mcif2noc_axi_aw_awready        (mcif2noc_axi_aw_awready)        //|< i
  ,.mcif2noc_axi_aw_awid           (mcif2noc_axi_aw_awid[7:0])      //|> o
  ,.mcif2noc_axi_aw_awlen          (mcif2noc_axi_aw_awlen[3:0])     //|> o
  ,.mcif2noc_axi_aw_awaddr         (mcif2noc_axi_aw_awaddr[63:0])   //|> o
  ,.mcif2noc_axi_w_wvalid          (mcif2noc_axi_w_wvalid)          //|> o
  ,.mcif2noc_axi_w_wready          (mcif2noc_axi_w_wready)          //|< i
  ,.mcif2noc_axi_w_wdata           (mcif2noc_axi_w_wdata[511:0])    //|> o
  ,.mcif2noc_axi_w_wstrb           (mcif2noc_axi_w_wstrb[63:0])     //|> o
  ,.mcif2noc_axi_w_wlast           (mcif2noc_axi_w_wlast)           //|> o
#ifdef NVDLA_PDP_ENABLE
  ,.mcif2pdp_rd_rsp_valid          (mcif2pdp_rd_rsp_valid)          //|> w
  ,.mcif2pdp_rd_rsp_ready          (mcif2pdp_rd_rsp_ready)          //|< w
  ,.mcif2pdp_rd_rsp_pd             (mcif2pdp_rd_rsp_pd[513:0])      //|> w
  ,.mcif2pdp_wr_rsp_complete       (mcif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2mcif_rd_cdt_lat_fifo_pop   (pdp2mcif_rd_cdt_lat_fifo_pop)   //|< w
  ,.pdp2mcif_rd_req_valid          (pdp2mcif_rd_req_valid)          //|< w
  ,.pdp2mcif_rd_req_ready          (pdp2mcif_rd_req_ready)          //|> w
  ,.pdp2mcif_rd_req_pd             (pdp2mcif_rd_req_pd[78:0])       //|< w
  ,.pdp2mcif_wr_req_valid          (pdp2mcif_wr_req_valid)          //|< w
  ,.pdp2mcif_wr_req_ready          (pdp2mcif_wr_req_ready)          //|> w
  ,.pdp2mcif_wr_req_pd             (pdp2mcif_wr_req_pd[514:0])      //|< w
#else
  ,.mcif2pdp_rd_rsp_valid          (mcif2pdp_rd_rsp_valid)          //|> w
  ,.mcif2pdp_rd_rsp_ready          (1'b1                    )       //|< w
  ,.mcif2pdp_rd_rsp_pd             (mcif2pdp_rd_rsp_pd[513:0])      //|> w
  ,.mcif2pdp_wr_rsp_complete       (mcif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2mcif_rd_cdt_lat_fifo_pop   (1'b0                    )       //|< w
  ,.pdp2mcif_rd_req_valid          (1'b0                    )       //|< w
  ,.pdp2mcif_rd_req_ready          (pdp2mcif_rd_req_ready)          //|> w
  ,.pdp2mcif_rd_req_pd             (79'd0                   )       //|< w
  ,.pdp2mcif_wr_req_valid          (1'b0                    )       //|< w
  ,.pdp2mcif_wr_req_ready          (pdp2mcif_wr_req_ready)          //|> w
  ,.pdp2mcif_wr_req_pd             (515'd0                  )       //|< w
#endif
  ,.mcif2sdp_b_rd_rsp_valid        (mcif2sdp_b_rd_rsp_valid)        //|> o
  ,.mcif2sdp_b_rd_rsp_ready        (mcif2sdp_b_rd_rsp_ready)        //|< i
  ,.mcif2sdp_b_rd_rsp_pd           (mcif2sdp_b_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_e_rd_rsp_valid        (mcif2sdp_e_rd_rsp_valid)        //|> o
  ,.mcif2sdp_e_rd_rsp_ready        (mcif2sdp_e_rd_rsp_ready)        //|< i
  ,.mcif2sdp_e_rd_rsp_pd           (mcif2sdp_e_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_n_rd_rsp_valid        (mcif2sdp_n_rd_rsp_valid)        //|> o
  ,.mcif2sdp_n_rd_rsp_ready        (mcif2sdp_n_rd_rsp_ready)        //|< i
  ,.mcif2sdp_n_rd_rsp_pd           (mcif2sdp_n_rd_rsp_pd[513:0])    //|> o
  ,.mcif2sdp_rd_rsp_valid          (mcif2sdp_rd_rsp_valid)          //|> o
  ,.mcif2sdp_rd_rsp_ready          (mcif2sdp_rd_rsp_ready)          //|< i
  ,.mcif2sdp_rd_rsp_pd             (mcif2sdp_rd_rsp_pd[513:0])      //|> o
  ,.mcif2sdp_wr_rsp_complete       (mcif2sdp_wr_rsp_complete)       //|> o
  ,.noc2mcif_axi_b_bvalid          (noc2mcif_axi_b_bvalid)          //|< i
  ,.noc2mcif_axi_b_bready          (noc2mcif_axi_b_bready)          //|> o
  ,.noc2mcif_axi_b_bid             (noc2mcif_axi_b_bid[7:0])        //|< i
  ,.noc2mcif_axi_r_rvalid          (noc2mcif_axi_r_rvalid)          //|< i
  ,.noc2mcif_axi_r_rready          (noc2mcif_axi_r_rready)          //|> o
  ,.noc2mcif_axi_r_rid             (noc2mcif_axi_r_rid[7:0])        //|< i
  ,.noc2mcif_axi_r_rlast           (noc2mcif_axi_r_rlast)           //|< i
  ,.noc2mcif_axi_r_rdata           (noc2mcif_axi_r_rdata[511:0])    //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rbk2mcif_rd_cdt_lat_fifo_pop   (rbk2mcif_rd_cdt_lat_fifo_pop)   //|< w
  ,.rbk2mcif_rd_req_valid          (rbk2mcif_rd_req_valid)          //|< w
  ,.rbk2mcif_rd_req_ready          (rbk2mcif_rd_req_ready)          //|> w
  ,.rbk2mcif_rd_req_pd             (rbk2mcif_rd_req_pd[78:0])       //|< w
  ,.rbk2mcif_wr_req_valid          (rbk2mcif_wr_req_valid)          //|< w
  ,.rbk2mcif_wr_req_ready          (rbk2mcif_wr_req_ready)          //|> w
  ,.rbk2mcif_wr_req_pd             (rbk2mcif_wr_req_pd[514:0])      //|< w
  ,.mcif2rbk_rd_rsp_valid          (mcif2rbk_rd_rsp_valid)          //|> w
  ,.mcif2rbk_rd_rsp_ready          (mcif2rbk_rd_rsp_ready)          //|< w
  ,.mcif2rbk_rd_rsp_pd             (mcif2rbk_rd_rsp_pd[513:0])      //|> w
  ,.mcif2rbk_wr_rsp_complete       (mcif2rbk_wr_rsp_complete)       //|> w
#else
  ,.rbk2mcif_rd_cdt_lat_fifo_pop   (1'b0                    )       //|< w
  ,.rbk2mcif_rd_req_valid          (1'b0                    )       //|< w
  ,.rbk2mcif_rd_req_ready          (rbk2mcif_rd_req_ready)          //|> w
  ,.rbk2mcif_rd_req_pd             (79'd0                   )       //|< w
  ,.rbk2mcif_wr_req_valid          (1'b0                    )       //|< w
  ,.rbk2mcif_wr_req_ready          (rbk2mcif_wr_req_ready)          //|> w
  ,.rbk2mcif_wr_req_pd             (515'd0                  )       //|< w
  ,.mcif2rbk_rd_rsp_valid          (mcif2rbk_rd_rsp_valid)          //|> w
  ,.mcif2rbk_rd_rsp_ready          (1'b1                    )       //|< w
  ,.mcif2rbk_rd_rsp_pd             (mcif2rbk_rd_rsp_pd[513:0])      //|> w
  ,.mcif2rbk_wr_rsp_complete       (mcif2rbk_wr_rsp_complete)       //|> w
#endif
  ,.sdp2mcif_rd_cdt_lat_fifo_pop   (sdp2mcif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2mcif_rd_req_valid          (sdp2mcif_rd_req_valid)          //|< i
  ,.sdp2mcif_rd_req_ready          (sdp2mcif_rd_req_ready)          //|> o
  ,.sdp2mcif_rd_req_pd             (sdp2mcif_rd_req_pd[78:0])       //|< i
  ,.sdp2mcif_wr_req_valid          (sdp2mcif_wr_req_valid)          //|< i
  ,.sdp2mcif_wr_req_ready          (sdp2mcif_wr_req_ready)          //|> o
  ,.sdp2mcif_wr_req_pd             (sdp2mcif_wr_req_pd[514:0])      //|< i
  ,.sdp_b2mcif_rd_cdt_lat_fifo_pop (sdp_b2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2mcif_rd_req_valid        (sdp_b2mcif_rd_req_valid)        //|< i
  ,.sdp_b2mcif_rd_req_ready        (sdp_b2mcif_rd_req_ready)        //|> o
  ,.sdp_b2mcif_rd_req_pd           (sdp_b2mcif_rd_req_pd[78:0])     //|< i
  ,.sdp_e2mcif_rd_cdt_lat_fifo_pop (sdp_e2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2mcif_rd_req_valid        (sdp_e2mcif_rd_req_valid)        //|< i
  ,.sdp_e2mcif_rd_req_ready        (sdp_e2mcif_rd_req_ready)        //|> o
  ,.sdp_e2mcif_rd_req_pd           (sdp_e2mcif_rd_req_pd[78:0])     //|< i
  ,.sdp_n2mcif_rd_cdt_lat_fifo_pop (sdp_n2mcif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2mcif_rd_req_valid        (sdp_n2mcif_rd_req_valid)        //|< i
  ,.sdp_n2mcif_rd_req_ready        (sdp_n2mcif_rd_req_ready)        //|> o
  ,.sdp_n2mcif_rd_req_pd           (sdp_n2mcif_rd_req_pd[78:0])     //|< i
  );
    //&Connect s/sdp2(mc|cv)if_rd_(req|cdt)/sdp2${1}if_rd_${2}_dst/;
    //&Connect s/(mc|cv)if2sdp_rd_(rsp)/${1}if2sdp_rd_${2}_src/;
    //&Connect s/sdp_b2(mc|cv)if_rd_(req|cdt)/sdp_b2${1}if_rd_${2}_dst/;
    //&Connect s/(mc|cv)if2sdp_b_rd_(rsp)/${1}if2sdp_b_rd_${2}_src/;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    AXI Interface to CVSRAM                     //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_cvif u_NV_NVDLA_cvif (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2cvif_rd_cdt_lat_fifo_pop  (bdma2cvif_rd_cdt_lat_fifo_pop)  //|< w
  ,.bdma2cvif_rd_req_valid         (bdma2cvif_rd_req_valid)         //|< w
  ,.bdma2cvif_rd_req_ready         (bdma2cvif_rd_req_ready)         //|> w
  ,.bdma2cvif_rd_req_pd            (bdma2cvif_rd_req_pd[78:0])      //|< w
  ,.bdma2cvif_wr_req_valid         (bdma2cvif_wr_req_valid)         //|< w
  ,.bdma2cvif_wr_req_ready         (bdma2cvif_wr_req_ready)         //|> w
  ,.bdma2cvif_wr_req_pd            (bdma2cvif_wr_req_pd[514:0])     //|< w
  ,.cvif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|> w
  ,.cvif2bdma_rd_rsp_ready         (cvif2bdma_rd_rsp_ready)         //|< w
  ,.cvif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd[513:0])     //|> w
  ,.cvif2bdma_wr_rsp_complete      (cvif2bdma_wr_rsp_complete)      //|> w
#else
  ,.bdma2cvif_rd_cdt_lat_fifo_pop  (1'b0                    )       //|< w
  ,.bdma2cvif_rd_req_valid         (1'b0                    )       //|< w
  ,.bdma2cvif_rd_req_ready         (bdma2cvif_rd_req_ready)         //|> w
  ,.bdma2cvif_rd_req_pd            (79'd0                   )       //|< w
  ,.bdma2cvif_wr_req_valid         (1'b0                    )       //|< w
  ,.bdma2cvif_wr_req_ready         (bdma2cvif_wr_req_ready)         //|> w
  ,.bdma2cvif_wr_req_pd            (515'd0                  )       //|< w
  ,.cvif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|> w
  ,.cvif2bdma_rd_rsp_ready         (1'b1                    )       //|< w
  ,.cvif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd[513:0])     //|> w
  ,.cvif2bdma_wr_rsp_complete      (cvif2bdma_wr_rsp_complete)      //|> w
#endif
  ,.cdma_dat2cvif_rd_req_valid     (cdma_dat2cvif_rd_req_valid)     //|< i
  ,.cdma_dat2cvif_rd_req_ready     (cdma_dat2cvif_rd_req_ready)     //|> o
  ,.cdma_dat2cvif_rd_req_pd        (cdma_dat2cvif_rd_req_pd[78:0])  //|< i
  ,.cdma_wt2cvif_rd_req_valid      (cdma_wt2cvif_rd_req_valid)      //|< i
  ,.cdma_wt2cvif_rd_req_ready      (cdma_wt2cvif_rd_req_ready)      //|> o
  ,.cdma_wt2cvif_rd_req_pd         (cdma_wt2cvif_rd_req_pd[78:0])   //|< i
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2cvif_rd_cdt_lat_fifo_pop   (cdp2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.cdp2cvif_rd_req_valid          (cdp2cvif_rd_req_valid)          //|< w
  ,.cdp2cvif_rd_req_ready          (cdp2cvif_rd_req_ready)          //|> w
  ,.cdp2cvif_rd_req_pd             (cdp2cvif_rd_req_pd[78:0])       //|< w
  ,.cdp2cvif_wr_req_valid          (cdp2cvif_wr_req_valid)          //|< w
  ,.cdp2cvif_wr_req_ready          (cdp2cvif_wr_req_ready)          //|> w
  ,.cdp2cvif_wr_req_pd             (cdp2cvif_wr_req_pd[514:0])      //|< w
  ,.cvif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|> w
  ,.cvif2cdp_rd_rsp_ready          (cvif2cdp_rd_rsp_ready)          //|< w
  ,.cvif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd[513:0])      //|> w
  ,.cvif2cdp_wr_rsp_complete       (cvif2cdp_wr_rsp_complete)       //|> w
#else
  ,.cdp2cvif_rd_cdt_lat_fifo_pop   (1'b0                    )       //|< w
  ,.cdp2cvif_rd_req_valid          (1'b0                    )       //|< w
  ,.cdp2cvif_rd_req_ready          (cdp2cvif_rd_req_ready)          //|> w
  ,.cdp2cvif_rd_req_pd             (79'd0                   )       //|< w
  ,.cdp2cvif_wr_req_valid          (1'b0                    )       //|< w
  ,.cdp2cvif_wr_req_ready          (cdp2cvif_wr_req_ready)          //|> w
  ,.cdp2cvif_wr_req_pd             (515'd0                  )       //|< w
  ,.cvif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|> w
  ,.cvif2cdp_rd_rsp_ready          (1'b1                    )       //|< w
  ,.cvif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd[513:0])      //|> w
  ,.cvif2cdp_wr_rsp_complete       (cvif2cdp_wr_rsp_complete)       //|> w
#endif
  ,.csb2cvif_req_pvld              (csb2cvif_req_pvld)              //|< w
  ,.csb2cvif_req_prdy              (csb2cvif_req_prdy)              //|> w
  ,.csb2cvif_req_pd                (csb2cvif_req_pd[62:0])          //|< w
  ,.cvif2cdma_dat_rd_rsp_valid     (cvif2cdma_dat_rd_rsp_valid)     //|> o
  ,.cvif2cdma_dat_rd_rsp_ready     (cvif2cdma_dat_rd_rsp_ready)     //|< i
  ,.cvif2cdma_dat_rd_rsp_pd        (cvif2cdma_dat_rd_rsp_pd[513:0]) //|> o
  ,.cvif2cdma_wt_rd_rsp_valid      (cvif2cdma_wt_rd_rsp_valid)      //|> o
  ,.cvif2cdma_wt_rd_rsp_ready      (cvif2cdma_wt_rd_rsp_ready)      //|< i
  ,.cvif2cdma_wt_rd_rsp_pd         (cvif2cdma_wt_rd_rsp_pd[513:0])  //|> o
  ,.cvif2csb_resp_valid            (cvif2csb_resp_valid)            //|> w
  ,.cvif2csb_resp_pd               (cvif2csb_resp_pd[33:0])         //|> w
  ,.cvif2noc_axi_ar_arvalid        (cvif2noc_axi_ar_arvalid)        //|> o
  ,.cvif2noc_axi_ar_arready        (cvif2noc_axi_ar_arready)        //|< i
  ,.cvif2noc_axi_ar_arid           (cvif2noc_axi_ar_arid[7:0])      //|> o
  ,.cvif2noc_axi_ar_arlen          (cvif2noc_axi_ar_arlen[3:0])     //|> o
  ,.cvif2noc_axi_ar_araddr         (cvif2noc_axi_ar_araddr[63:0])   //|> o
  ,.cvif2noc_axi_aw_awvalid        (cvif2noc_axi_aw_awvalid)        //|> o
  ,.cvif2noc_axi_aw_awready        (cvif2noc_axi_aw_awready)        //|< i
  ,.cvif2noc_axi_aw_awid           (cvif2noc_axi_aw_awid[7:0])      //|> o
  ,.cvif2noc_axi_aw_awlen          (cvif2noc_axi_aw_awlen[3:0])     //|> o
  ,.cvif2noc_axi_aw_awaddr         (cvif2noc_axi_aw_awaddr[63:0])   //|> o
  ,.cvif2noc_axi_w_wvalid          (cvif2noc_axi_w_wvalid)          //|> o
  ,.cvif2noc_axi_w_wready          (cvif2noc_axi_w_wready)          //|< i
  ,.cvif2noc_axi_w_wdata           (cvif2noc_axi_w_wdata[511:0])    //|> o
  ,.cvif2noc_axi_w_wstrb           (cvif2noc_axi_w_wstrb[63:0])     //|> o
  ,.cvif2noc_axi_w_wlast           (cvif2noc_axi_w_wlast)           //|> o
#ifdef NVDLA_PDP_ENABLE
  ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|> w
  ,.cvif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)          //|< w
  ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd[513:0])      //|> w
  ,.cvif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2cvif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.pdp2cvif_rd_req_valid          (pdp2cvif_rd_req_valid)          //|< w
  ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|> w
  ,.pdp2cvif_rd_req_pd             (pdp2cvif_rd_req_pd[78:0])       //|< w
  ,.pdp2cvif_wr_req_valid          (pdp2cvif_wr_req_valid)          //|< w
  ,.pdp2cvif_wr_req_ready          (pdp2cvif_wr_req_ready)          //|> w
  ,.pdp2cvif_wr_req_pd             (pdp2cvif_wr_req_pd[514:0])      //|< w
#else
  ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|> w
  ,.cvif2pdp_rd_rsp_ready          (1'b1                    )       //|< w
  ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd[513:0])      //|> w
  ,.cvif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)       //|> w
  ,.pdp2cvif_rd_cdt_lat_fifo_pop   (1'b0                    )       //|< w
  ,.pdp2cvif_rd_req_valid          (1'b0                    )       //|< w
  ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|> w
  ,.pdp2cvif_rd_req_pd             (79'd0                   )       //|< w
  ,.pdp2cvif_wr_req_valid          (1'b0                    )       //|< w
  ,.pdp2cvif_wr_req_ready          (pdp2cvif_wr_req_ready)          //|> w
  ,.pdp2cvif_wr_req_pd             (515'd0                  )       //|< w
#endif
  ,.cvif2sdp_b_rd_rsp_valid        (cvif2sdp_b_rd_rsp_valid)        //|> o
  ,.cvif2sdp_b_rd_rsp_ready        (cvif2sdp_b_rd_rsp_ready)        //|< i
  ,.cvif2sdp_b_rd_rsp_pd           (cvif2sdp_b_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_e_rd_rsp_valid        (cvif2sdp_e_rd_rsp_valid)        //|> o
  ,.cvif2sdp_e_rd_rsp_ready        (cvif2sdp_e_rd_rsp_ready)        //|< i
  ,.cvif2sdp_e_rd_rsp_pd           (cvif2sdp_e_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_n_rd_rsp_valid        (cvif2sdp_n_rd_rsp_valid)        //|> o
  ,.cvif2sdp_n_rd_rsp_ready        (cvif2sdp_n_rd_rsp_ready)        //|< i
  ,.cvif2sdp_n_rd_rsp_pd           (cvif2sdp_n_rd_rsp_pd[513:0])    //|> o
  ,.cvif2sdp_rd_rsp_valid          (cvif2sdp_rd_rsp_valid)          //|> o
  ,.cvif2sdp_rd_rsp_ready          (cvif2sdp_rd_rsp_ready)          //|< i
  ,.cvif2sdp_rd_rsp_pd             (cvif2sdp_rd_rsp_pd[513:0])      //|> o
  ,.cvif2sdp_wr_rsp_complete       (cvif2sdp_wr_rsp_complete)       //|> o
  ,.noc2cvif_axi_b_bvalid          (noc2cvif_axi_b_bvalid)          //|< i
  ,.noc2cvif_axi_b_bready          (noc2cvif_axi_b_bready)          //|> o
  ,.noc2cvif_axi_b_bid             (noc2cvif_axi_b_bid[7:0])        //|< i
  ,.noc2cvif_axi_r_rvalid          (noc2cvif_axi_r_rvalid)          //|< i
  ,.noc2cvif_axi_r_rready          (noc2cvif_axi_r_rready)          //|> o
  ,.noc2cvif_axi_r_rid             (noc2cvif_axi_r_rid[7:0])        //|< i
  ,.noc2cvif_axi_r_rlast           (noc2cvif_axi_r_rlast)           //|< i
  ,.noc2cvif_axi_r_rdata           (noc2cvif_axi_r_rdata[511:0])    //|< i
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
#ifdef NVDLA_RUBIK_ENABLE 
  ,.rbk2cvif_rd_cdt_lat_fifo_pop   (rbk2cvif_rd_cdt_lat_fifo_pop)   //|< w
  ,.rbk2cvif_rd_req_valid          (rbk2cvif_rd_req_valid)          //|< w
  ,.rbk2cvif_rd_req_ready          (rbk2cvif_rd_req_ready)          //|> w
  ,.rbk2cvif_rd_req_pd             (rbk2cvif_rd_req_pd[78:0])       //|< w
  ,.rbk2cvif_wr_req_valid          (rbk2cvif_wr_req_valid)          //|< w
  ,.rbk2cvif_wr_req_ready          (rbk2cvif_wr_req_ready)          //|> w
  ,.rbk2cvif_wr_req_pd             (rbk2cvif_wr_req_pd[514:0])      //|< w
  ,.cvif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|> w
  ,.cvif2rbk_rd_rsp_ready          (cvif2rbk_rd_rsp_ready)          //|< w
  ,.cvif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd[513:0])      //|> w
  ,.cvif2rbk_wr_rsp_complete       (cvif2rbk_wr_rsp_complete)       //|> w
#else
  ,.rbk2cvif_rd_cdt_lat_fifo_pop   (1'b0                    )       //|< w
  ,.rbk2cvif_rd_req_valid          (1'b0                    )       //|< w
  ,.rbk2cvif_rd_req_ready          (rbk2cvif_rd_req_ready)          //|> w
  ,.rbk2cvif_rd_req_pd             (79'd0                   )       //|< w
  ,.rbk2cvif_wr_req_valid          (1'b0                    )       //|< w
  ,.rbk2cvif_wr_req_ready          (rbk2cvif_wr_req_ready)          //|> w
  ,.rbk2cvif_wr_req_pd             (515'd0                  )       //|< w
  ,.cvif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|> w
  ,.cvif2rbk_rd_rsp_ready          (1'b1                    )       //|< w
  ,.cvif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd[513:0])      //|> w
  ,.cvif2rbk_wr_rsp_complete       (cvif2rbk_wr_rsp_complete)       //|> w
#endif
  ,.sdp2cvif_rd_cdt_lat_fifo_pop   (sdp2cvif_rd_cdt_lat_fifo_pop)   //|< i
  ,.sdp2cvif_rd_req_valid          (sdp2cvif_rd_req_valid)          //|< i
  ,.sdp2cvif_rd_req_ready          (sdp2cvif_rd_req_ready)          //|> o
  ,.sdp2cvif_rd_req_pd             (sdp2cvif_rd_req_pd[78:0])       //|< i
  ,.sdp2cvif_wr_req_valid          (sdp2cvif_wr_req_valid)          //|< i
  ,.sdp2cvif_wr_req_ready          (sdp2cvif_wr_req_ready)          //|> o
  ,.sdp2cvif_wr_req_pd             (sdp2cvif_wr_req_pd[514:0])      //|< i
  ,.sdp_b2cvif_rd_cdt_lat_fifo_pop (sdp_b2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_b2cvif_rd_req_valid        (sdp_b2cvif_rd_req_valid)        //|< i
  ,.sdp_b2cvif_rd_req_ready        (sdp_b2cvif_rd_req_ready)        //|> o
  ,.sdp_b2cvif_rd_req_pd           (sdp_b2cvif_rd_req_pd[78:0])     //|< i
  ,.sdp_e2cvif_rd_cdt_lat_fifo_pop (sdp_e2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_e2cvif_rd_req_valid        (sdp_e2cvif_rd_req_valid)        //|< i
  ,.sdp_e2cvif_rd_req_ready        (sdp_e2cvif_rd_req_ready)        //|> o
  ,.sdp_e2cvif_rd_req_pd           (sdp_e2cvif_rd_req_pd[78:0])     //|< i
  ,.sdp_n2cvif_rd_cdt_lat_fifo_pop (sdp_n2cvif_rd_cdt_lat_fifo_pop) //|< i
  ,.sdp_n2cvif_rd_req_valid        (sdp_n2cvif_rd_req_valid)        //|< i
  ,.sdp_n2cvif_rd_req_ready        (sdp_n2cvif_rd_req_ready)        //|> o
  ,.sdp_n2cvif_rd_req_pd           (sdp_n2cvif_rd_req_pd[78:0])     //|< i
  );
    //&Connect s/sdp2(mc|cv)if_rd_(req|cdt)/sdp2${1}if_rd_${2}_dst/;
    //&Connect s/(mc|cv)if2sdp_rd_(rsp)/${1}if2sdp_rd_${2}_src/;
    //&Connect s/sdp_b2(mc|cv)if_rd_(req|cdt)/sdp_b2${1}if_rd_${2}_dst/;
    //&Connect s/(mc|cv)if2sdp_b_rd_(rsp)/${1}if2sdp_b_rd_${2}_src/;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Bridge DMA                                  //
////////////////////////////////////////////////////////////////////////
#ifdef NVDLA_BDMA_ENABLE
NV_NVDLA_bdma u_NV_NVDLA_bdma (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.bdma2csb_resp_valid            (bdma2csb_resp_valid)            //|> w
  ,.bdma2csb_resp_pd               (bdma2csb_resp_pd[33:0])         //|> w
  ,.bdma2cvif_rd_cdt_lat_fifo_pop  (bdma2cvif_rd_cdt_lat_fifo_pop)  //|> w
  ,.bdma2cvif_rd_req_valid         (bdma2cvif_rd_req_valid)         //|> w
  ,.bdma2cvif_rd_req_ready         (bdma2cvif_rd_req_ready)         //|< w
  ,.bdma2cvif_rd_req_pd            (bdma2cvif_rd_req_pd[78:0])      //|> w
  ,.bdma2cvif_wr_req_valid         (bdma2cvif_wr_req_valid)         //|> w
  ,.bdma2cvif_wr_req_ready         (bdma2cvif_wr_req_ready)         //|< w
  ,.bdma2cvif_wr_req_pd            (bdma2cvif_wr_req_pd[514:0])     //|> w
  ,.bdma2glb_done_intr_pd          (bdma2glb_done_intr_pd[1:0])     //|> w
  ,.bdma2mcif_rd_cdt_lat_fifo_pop  (bdma2mcif_rd_cdt_lat_fifo_pop)  //|> w
  ,.bdma2mcif_rd_req_valid         (bdma2mcif_rd_req_valid)         //|> w
  ,.bdma2mcif_rd_req_ready         (bdma2mcif_rd_req_ready)         //|< w
  ,.bdma2mcif_rd_req_pd            (bdma2mcif_rd_req_pd[78:0])      //|> w
  ,.bdma2mcif_wr_req_valid         (bdma2mcif_wr_req_valid)         //|> w
  ,.bdma2mcif_wr_req_ready         (bdma2mcif_wr_req_ready)         //|< w
  ,.bdma2mcif_wr_req_pd            (bdma2mcif_wr_req_pd[514:0])     //|> w
  ,.csb2bdma_req_pvld              (csb2bdma_req_pvld)              //|< w
  ,.csb2bdma_req_prdy              (csb2bdma_req_prdy)              //|> w
  ,.csb2bdma_req_pd                (csb2bdma_req_pd[62:0])          //|< w
  ,.cvif2bdma_rd_rsp_valid         (cvif2bdma_rd_rsp_valid)         //|< w
  ,.cvif2bdma_rd_rsp_ready         (cvif2bdma_rd_rsp_ready)         //|> w
  ,.cvif2bdma_rd_rsp_pd            (cvif2bdma_rd_rsp_pd[513:0])     //|< w
  ,.cvif2bdma_wr_rsp_complete      (cvif2bdma_wr_rsp_complete)      //|< w
  ,.mcif2bdma_rd_rsp_valid         (mcif2bdma_rd_rsp_valid)         //|< w
  ,.mcif2bdma_rd_rsp_ready         (mcif2bdma_rd_rsp_ready)         //|> w
  ,.mcif2bdma_rd_rsp_pd            (mcif2bdma_rd_rsp_pd[513:0])     //|< w
  ,.mcif2bdma_wr_rsp_complete      (mcif2bdma_wr_rsp_complete)      //|< w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)            //|< w
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)         //|< w
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  //|< i
  );
#else
#endif
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Rubik engine                                //
////////////////////////////////////////////////////////////////////////
#ifdef NVDLA_RUBIK_ENABLE 
NV_NVDLA_rubik u_NV_NVDLA_rubik (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.csb2rbk_req_pvld               (csb2rbk_req_pvld)               //|< w
  ,.csb2rbk_req_prdy               (csb2rbk_req_prdy)               //|> w
  ,.csb2rbk_req_pd                 (csb2rbk_req_pd[62:0])           //|< w
  ,.rbk2csb_resp_valid             (rbk2csb_resp_valid)             //|> w
  ,.rbk2csb_resp_pd                (rbk2csb_resp_pd[33:0])          //|> w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.rbk2mcif_rd_req_valid          (rbk2mcif_rd_req_valid)          //|> w
  ,.rbk2mcif_rd_req_ready          (rbk2mcif_rd_req_ready)          //|< w
  ,.rbk2mcif_rd_req_pd             (rbk2mcif_rd_req_pd[78:0])       //|> w
  ,.rbk2cvif_rd_req_valid          (rbk2cvif_rd_req_valid)          //|> w
  ,.rbk2cvif_rd_req_ready          (rbk2cvif_rd_req_ready)          //|< w
  ,.rbk2cvif_rd_req_pd             (rbk2cvif_rd_req_pd[78:0])       //|> w
  ,.mcif2rbk_rd_rsp_valid          (mcif2rbk_rd_rsp_valid)          //|< w
  ,.mcif2rbk_rd_rsp_ready          (mcif2rbk_rd_rsp_ready)          //|> w
  ,.mcif2rbk_rd_rsp_pd             (mcif2rbk_rd_rsp_pd[513:0])      //|< w
  ,.cvif2rbk_rd_rsp_valid          (cvif2rbk_rd_rsp_valid)          //|< w
  ,.cvif2rbk_rd_rsp_ready          (cvif2rbk_rd_rsp_ready)          //|> w
  ,.cvif2rbk_rd_rsp_pd             (cvif2rbk_rd_rsp_pd[513:0])      //|< w
  ,.rbk2mcif_wr_req_valid          (rbk2mcif_wr_req_valid)          //|> w
  ,.rbk2mcif_wr_req_ready          (rbk2mcif_wr_req_ready)          //|< w
  ,.rbk2mcif_wr_req_pd             (rbk2mcif_wr_req_pd[514:0])      //|> w
  ,.mcif2rbk_wr_rsp_complete       (mcif2rbk_wr_rsp_complete)       //|< w
  ,.rbk2cvif_wr_req_valid          (rbk2cvif_wr_req_valid)          //|> w
  ,.rbk2cvif_wr_req_ready          (rbk2cvif_wr_req_ready)          //|< w
  ,.rbk2cvif_wr_req_pd             (rbk2cvif_wr_req_pd[514:0])      //|> w
  ,.cvif2rbk_wr_rsp_complete       (cvif2rbk_wr_rsp_complete)       //|< w
  ,.rbk2mcif_rd_cdt_lat_fifo_pop   (rbk2mcif_rd_cdt_lat_fifo_pop)   //|> w
  ,.rbk2cvif_rd_cdt_lat_fifo_pop   (rbk2cvif_rd_cdt_lat_fifo_pop)   //|> w
  ,.rubik2glb_done_intr_pd         (rubik2glb_done_intr_pd[1:0])    //|> w
  ,.dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)            //|< w
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)         //|< w
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  //|< i
  );
#else
#endif
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Cross-Channel Data Processor                //
////////////////////////////////////////////////////////////////////////
#ifdef NVDLA_CDP_ENABLE
NV_NVDLA_cdp u_NV_NVDLA_cdp (
   .dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)            //|< w
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)         //|< w
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  //|< i
  ,.nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.cdp2csb_resp_valid             (cdp2csb_resp_valid)             //|> w
  ,.cdp2csb_resp_pd                (cdp2csb_resp_pd[33:0])          //|> w
  ,.cdp2cvif_rd_cdt_lat_fifo_pop   (cdp2cvif_rd_cdt_lat_fifo_pop)   //|> w
  ,.cdp2cvif_rd_req_valid          (cdp2cvif_rd_req_valid)          //|> w
  ,.cdp2cvif_rd_req_ready          (cdp2cvif_rd_req_ready)          //|< w
  ,.cdp2cvif_rd_req_pd             (cdp2cvif_rd_req_pd[78:0])       //|> w
  ,.cdp2cvif_wr_req_valid          (cdp2cvif_wr_req_valid)          //|> w
  ,.cdp2cvif_wr_req_ready          (cdp2cvif_wr_req_ready)          //|< w
  ,.cdp2cvif_wr_req_pd             (cdp2cvif_wr_req_pd[514:0])      //|> w
  ,.cdp2glb_done_intr_pd           (cdp2glb_done_intr_pd[1:0])      //|> w
  ,.cdp2mcif_rd_cdt_lat_fifo_pop   (cdp2mcif_rd_cdt_lat_fifo_pop)   //|> w
  ,.cdp2mcif_rd_req_valid          (cdp2mcif_rd_req_valid)          //|> w
  ,.cdp2mcif_rd_req_ready          (cdp2mcif_rd_req_ready)          //|< w
  ,.cdp2mcif_rd_req_pd             (cdp2mcif_rd_req_pd[78:0])       //|> w
  ,.cdp2mcif_wr_req_valid          (cdp2mcif_wr_req_valid)          //|> w
  ,.cdp2mcif_wr_req_ready          (cdp2mcif_wr_req_ready)          //|< w
  ,.cdp2mcif_wr_req_pd             (cdp2mcif_wr_req_pd[514:0])      //|> w
  ,.cdp_rdma2csb_resp_valid        (cdp_rdma2csb_resp_valid)        //|> w
  ,.cdp_rdma2csb_resp_pd           (cdp_rdma2csb_resp_pd[33:0])     //|> w
  ,.csb2cdp_rdma_req_pvld          (csb2cdp_rdma_req_pvld)          //|< w
  ,.csb2cdp_rdma_req_prdy          (csb2cdp_rdma_req_prdy)          //|> w
  ,.csb2cdp_rdma_req_pd            (csb2cdp_rdma_req_pd[62:0])      //|< w
  ,.csb2cdp_req_pvld               (csb2cdp_req_pvld)               //|< w
  ,.csb2cdp_req_prdy               (csb2cdp_req_prdy)               //|> w
  ,.csb2cdp_req_pd                 (csb2cdp_req_pd[62:0])           //|< w
  ,.cvif2cdp_rd_rsp_valid          (cvif2cdp_rd_rsp_valid)          //|< w
  ,.cvif2cdp_rd_rsp_ready          (cvif2cdp_rd_rsp_ready)          //|> w
  ,.cvif2cdp_rd_rsp_pd             (cvif2cdp_rd_rsp_pd[513:0])      //|< w
  ,.cvif2cdp_wr_rsp_complete       (cvif2cdp_wr_rsp_complete)       //|< w
  ,.mcif2cdp_rd_rsp_valid          (mcif2cdp_rd_rsp_valid)          //|< w
  ,.mcif2cdp_rd_rsp_ready          (mcif2cdp_rd_rsp_ready)          //|> w
  ,.mcif2cdp_rd_rsp_pd             (mcif2cdp_rd_rsp_pd[513:0])      //|< w
  ,.mcif2cdp_wr_rsp_complete       (mcif2cdp_wr_rsp_complete)       //|< w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  );
#else 
#endif
////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Planar Data Processor                       //
////////////////////////////////////////////////////////////////////////
#ifdef NVDLA_PDP_ENABLE
NV_NVDLA_pdp u_NV_NVDLA_pdp (
   .dla_clk_ovr_on_sync            (dla_clk_ovr_on_sync)            //|< w
  ,.global_clk_ovr_on_sync         (global_clk_ovr_on_sync)         //|< w
  ,.tmc2slcg_disable_clock_gating  (tmc2slcg_disable_clock_gating)  //|< i
  ,.nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.csb2pdp_rdma_req_pvld          (csb2pdp_rdma_req_pvld)          //|< w
  ,.csb2pdp_rdma_req_prdy          (csb2pdp_rdma_req_prdy)          //|> w
  ,.csb2pdp_rdma_req_pd            (csb2pdp_rdma_req_pd[62:0])      //|< w
  ,.csb2pdp_req_pvld               (csb2pdp_req_pvld)               //|< w
  ,.csb2pdp_req_prdy               (csb2pdp_req_prdy)               //|> w
  ,.csb2pdp_req_pd                 (csb2pdp_req_pd[62:0])           //|< w
  ,.cvif2pdp_rd_rsp_valid          (cvif2pdp_rd_rsp_valid)          //|< w
  ,.cvif2pdp_rd_rsp_ready          (cvif2pdp_rd_rsp_ready)          //|> w
  ,.cvif2pdp_rd_rsp_pd             (cvif2pdp_rd_rsp_pd[513:0])      //|< w
  ,.cvif2pdp_wr_rsp_complete       (cvif2pdp_wr_rsp_complete)       //|< w
  ,.mcif2pdp_rd_rsp_valid          (mcif2pdp_rd_rsp_valid)          //|< w
  ,.mcif2pdp_rd_rsp_ready          (mcif2pdp_rd_rsp_ready)          //|> w
  ,.mcif2pdp_rd_rsp_pd             (mcif2pdp_rd_rsp_pd[513:0])      //|< w
  ,.mcif2pdp_wr_rsp_complete       (mcif2pdp_wr_rsp_complete)       //|< w
  ,.pdp2csb_resp_valid             (pdp2csb_resp_valid)             //|> w
  ,.pdp2csb_resp_pd                (pdp2csb_resp_pd[33:0])          //|> w
  ,.pdp2cvif_rd_cdt_lat_fifo_pop   (pdp2cvif_rd_cdt_lat_fifo_pop)   //|> w
  ,.pdp2cvif_rd_req_valid          (pdp2cvif_rd_req_valid)          //|> w
  ,.pdp2cvif_rd_req_ready          (pdp2cvif_rd_req_ready)          //|< w
  ,.pdp2cvif_rd_req_pd             (pdp2cvif_rd_req_pd[78:0])       //|> w
  ,.pdp2cvif_wr_req_valid          (pdp2cvif_wr_req_valid)          //|> w
  ,.pdp2cvif_wr_req_ready          (pdp2cvif_wr_req_ready)          //|< w
  ,.pdp2cvif_wr_req_pd             (pdp2cvif_wr_req_pd[514:0])      //|> w
  ,.pdp2glb_done_intr_pd           (pdp2glb_done_intr_pd[1:0])      //|> w
  ,.pdp2mcif_rd_cdt_lat_fifo_pop   (pdp2mcif_rd_cdt_lat_fifo_pop)   //|> w
  ,.pdp2mcif_rd_req_valid          (pdp2mcif_rd_req_valid)          //|> w
  ,.pdp2mcif_rd_req_ready          (pdp2mcif_rd_req_ready)          //|< w
  ,.pdp2mcif_rd_req_pd             (pdp2mcif_rd_req_pd[78:0])       //|> w
  ,.pdp2mcif_wr_req_valid          (pdp2mcif_wr_req_valid)          //|> w
  ,.pdp2mcif_wr_req_ready          (pdp2mcif_wr_req_ready)          //|< w
  ,.pdp2mcif_wr_req_pd             (pdp2mcif_wr_req_pd[514:0])      //|> w
  ,.pdp_rdma2csb_resp_valid        (pdp_rdma2csb_resp_valid)        //|> w
  ,.pdp_rdma2csb_resp_pd           (pdp_rdma2csb_resp_pd[33:0])     //|> w
  ,.pwrbus_ram_pd                  (pwrbus_ram_pd[31:0])            //|< i
  ,.sdp2pdp_valid                  (sdp2pdp_valid)                  //|< i
  ,.sdp2pdp_ready                  (sdp2pdp_ready)                  //|> o
  ,.sdp2pdp_pd                     (sdp2pdp_pd[255:0])              //|< i
  );
#else
assign sdp2pdp_ready = 1'b1;//fixme, need remove interface at final
#endif

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Global Unit                                 //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_glb u_NV_NVDLA_glb (
   .csb2glb_req_pvld               (csb2glb_req_pvld)               //|< w
  ,.csb2glb_req_prdy               (csb2glb_req_prdy)               //|> w
  ,.csb2glb_req_pd                 (csb2glb_req_pd[62:0])           //|< w
  ,.glb2csb_resp_valid             (glb2csb_resp_valid)             //|> w
  ,.glb2csb_resp_pd                (glb2csb_resp_pd[33:0])          //|> w
  ,.csb2gec_req_pvld               (csb2gec_req_pvld)               //|< w
  ,.csb2gec_req_prdy               (csb2gec_req_prdy)               //|> w
  ,.csb2gec_req_pd                 (csb2gec_req_pd[62:0])           //|< w
  ,.gec2csb_resp_valid             (gec2csb_resp_valid)             //|> w
  ,.gec2csb_resp_pd                (gec2csb_resp_pd[33:0])          //|> w
  ,.core_intr                      (core_intr)                      //|> o
  ,.sdp2glb_done_intr_pd           (sdp2glb_done_intr_pd[1:0])      //|< i
#ifdef NVDLA_CDP_ENABLE
  ,.cdp2glb_done_intr_pd           (cdp2glb_done_intr_pd[1:0])      //|< w
#else
  ,.cdp2glb_done_intr_pd           (2'd0                    )       //|< w
#endif
#ifdef NVDLA_PDP_ENABLE
  ,.pdp2glb_done_intr_pd           (pdp2glb_done_intr_pd[1:0])      //|< w
#else
  ,.pdp2glb_done_intr_pd           (2'd0                    )       //|< w
#endif
#ifdef NVDLA_BDMA_ENABLE
  ,.bdma2glb_done_intr_pd          (bdma2glb_done_intr_pd[1:0])     //|< w
#else
  ,.bdma2glb_done_intr_pd          (2'd0                    )       //|< w
#endif
#ifdef NVDLA_RUBIK_ENABLE
  ,.rubik2glb_done_intr_pd         (rubik2glb_done_intr_pd[1:0])    //|< w
#else
  ,.rubik2glb_done_intr_pd         (2'd0                    )       //|< w
#endif
  ,.cdma_wt2glb_done_intr_pd       (cdma_wt2glb_done_intr_pd[1:0])  //|< i
  ,.cdma_dat2glb_done_intr_pd      (cdma_dat2glb_done_intr_pd[1:0]) //|< i
  ,.cacc2glb_done_intr_pd          (cacc2glb_done_intr_dst_pd[1:0]) //|< i
  ,.nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_falcon_clk               (nvdla_falcon_clk)               //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.nvdla_falcon_rstn              (nvdla_falcon_rstn)              //|< w
  ,.test_mode                      (test_mode)                      //|< i
  ,.direct_reset_                  (direct_reset_)                  //|< i
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    FALCON WRAPPER                              //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_falcon_top;
//&Terminate -output /obs/;

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Retiming path csc->cmac_a                   //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csc2cmac_a u_NV_NVDLA_RT_csc2cmac_a (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.sc2mac_wt_src_pvld             (sc2mac_wt_a_src_pvld)           //|< i
  ,.sc2mac_wt_src_mask             (sc2mac_wt_a_src_mask[127:0])    //|< i
  ,.sc2mac_wt_src_data0            (sc2mac_wt_a_src_data0[7:0])     //|< i
  ,.sc2mac_wt_src_data1            (sc2mac_wt_a_src_data1[7:0])     //|< i
  ,.sc2mac_wt_src_data2            (sc2mac_wt_a_src_data2[7:0])     //|< i
  ,.sc2mac_wt_src_data3            (sc2mac_wt_a_src_data3[7:0])     //|< i
  ,.sc2mac_wt_src_data4            (sc2mac_wt_a_src_data4[7:0])     //|< i
  ,.sc2mac_wt_src_data5            (sc2mac_wt_a_src_data5[7:0])     //|< i
  ,.sc2mac_wt_src_data6            (sc2mac_wt_a_src_data6[7:0])     //|< i
  ,.sc2mac_wt_src_data7            (sc2mac_wt_a_src_data7[7:0])     //|< i
  ,.sc2mac_wt_src_data8            (sc2mac_wt_a_src_data8[7:0])     //|< i
  ,.sc2mac_wt_src_data9            (sc2mac_wt_a_src_data9[7:0])     //|< i
  ,.sc2mac_wt_src_data10           (sc2mac_wt_a_src_data10[7:0])    //|< i
  ,.sc2mac_wt_src_data11           (sc2mac_wt_a_src_data11[7:0])    //|< i
  ,.sc2mac_wt_src_data12           (sc2mac_wt_a_src_data12[7:0])    //|< i
  ,.sc2mac_wt_src_data13           (sc2mac_wt_a_src_data13[7:0])    //|< i
  ,.sc2mac_wt_src_data14           (sc2mac_wt_a_src_data14[7:0])    //|< i
  ,.sc2mac_wt_src_data15           (sc2mac_wt_a_src_data15[7:0])    //|< i
  ,.sc2mac_wt_src_data16           (sc2mac_wt_a_src_data16[7:0])    //|< i
  ,.sc2mac_wt_src_data17           (sc2mac_wt_a_src_data17[7:0])    //|< i
  ,.sc2mac_wt_src_data18           (sc2mac_wt_a_src_data18[7:0])    //|< i
  ,.sc2mac_wt_src_data19           (sc2mac_wt_a_src_data19[7:0])    //|< i
  ,.sc2mac_wt_src_data20           (sc2mac_wt_a_src_data20[7:0])    //|< i
  ,.sc2mac_wt_src_data21           (sc2mac_wt_a_src_data21[7:0])    //|< i
  ,.sc2mac_wt_src_data22           (sc2mac_wt_a_src_data22[7:0])    //|< i
  ,.sc2mac_wt_src_data23           (sc2mac_wt_a_src_data23[7:0])    //|< i
  ,.sc2mac_wt_src_data24           (sc2mac_wt_a_src_data24[7:0])    //|< i
  ,.sc2mac_wt_src_data25           (sc2mac_wt_a_src_data25[7:0])    //|< i
  ,.sc2mac_wt_src_data26           (sc2mac_wt_a_src_data26[7:0])    //|< i
  ,.sc2mac_wt_src_data27           (sc2mac_wt_a_src_data27[7:0])    //|< i
  ,.sc2mac_wt_src_data28           (sc2mac_wt_a_src_data28[7:0])    //|< i
  ,.sc2mac_wt_src_data29           (sc2mac_wt_a_src_data29[7:0])    //|< i
  ,.sc2mac_wt_src_data30           (sc2mac_wt_a_src_data30[7:0])    //|< i
  ,.sc2mac_wt_src_data31           (sc2mac_wt_a_src_data31[7:0])    //|< i
  ,.sc2mac_wt_src_data32           (sc2mac_wt_a_src_data32[7:0])    //|< i
  ,.sc2mac_wt_src_data33           (sc2mac_wt_a_src_data33[7:0])    //|< i
  ,.sc2mac_wt_src_data34           (sc2mac_wt_a_src_data34[7:0])    //|< i
  ,.sc2mac_wt_src_data35           (sc2mac_wt_a_src_data35[7:0])    //|< i
  ,.sc2mac_wt_src_data36           (sc2mac_wt_a_src_data36[7:0])    //|< i
  ,.sc2mac_wt_src_data37           (sc2mac_wt_a_src_data37[7:0])    //|< i
  ,.sc2mac_wt_src_data38           (sc2mac_wt_a_src_data38[7:0])    //|< i
  ,.sc2mac_wt_src_data39           (sc2mac_wt_a_src_data39[7:0])    //|< i
  ,.sc2mac_wt_src_data40           (sc2mac_wt_a_src_data40[7:0])    //|< i
  ,.sc2mac_wt_src_data41           (sc2mac_wt_a_src_data41[7:0])    //|< i
  ,.sc2mac_wt_src_data42           (sc2mac_wt_a_src_data42[7:0])    //|< i
  ,.sc2mac_wt_src_data43           (sc2mac_wt_a_src_data43[7:0])    //|< i
  ,.sc2mac_wt_src_data44           (sc2mac_wt_a_src_data44[7:0])    //|< i
  ,.sc2mac_wt_src_data45           (sc2mac_wt_a_src_data45[7:0])    //|< i
  ,.sc2mac_wt_src_data46           (sc2mac_wt_a_src_data46[7:0])    //|< i
  ,.sc2mac_wt_src_data47           (sc2mac_wt_a_src_data47[7:0])    //|< i
  ,.sc2mac_wt_src_data48           (sc2mac_wt_a_src_data48[7:0])    //|< i
  ,.sc2mac_wt_src_data49           (sc2mac_wt_a_src_data49[7:0])    //|< i
  ,.sc2mac_wt_src_data50           (sc2mac_wt_a_src_data50[7:0])    //|< i
  ,.sc2mac_wt_src_data51           (sc2mac_wt_a_src_data51[7:0])    //|< i
  ,.sc2mac_wt_src_data52           (sc2mac_wt_a_src_data52[7:0])    //|< i
  ,.sc2mac_wt_src_data53           (sc2mac_wt_a_src_data53[7:0])    //|< i
  ,.sc2mac_wt_src_data54           (sc2mac_wt_a_src_data54[7:0])    //|< i
  ,.sc2mac_wt_src_data55           (sc2mac_wt_a_src_data55[7:0])    //|< i
  ,.sc2mac_wt_src_data56           (sc2mac_wt_a_src_data56[7:0])    //|< i
  ,.sc2mac_wt_src_data57           (sc2mac_wt_a_src_data57[7:0])    //|< i
  ,.sc2mac_wt_src_data58           (sc2mac_wt_a_src_data58[7:0])    //|< i
  ,.sc2mac_wt_src_data59           (sc2mac_wt_a_src_data59[7:0])    //|< i
  ,.sc2mac_wt_src_data60           (sc2mac_wt_a_src_data60[7:0])    //|< i
  ,.sc2mac_wt_src_data61           (sc2mac_wt_a_src_data61[7:0])    //|< i
  ,.sc2mac_wt_src_data62           (sc2mac_wt_a_src_data62[7:0])    //|< i
  ,.sc2mac_wt_src_data63           (sc2mac_wt_a_src_data63[7:0])    //|< i
  ,.sc2mac_wt_src_data64           (sc2mac_wt_a_src_data64[7:0])    //|< i
  ,.sc2mac_wt_src_data65           (sc2mac_wt_a_src_data65[7:0])    //|< i
  ,.sc2mac_wt_src_data66           (sc2mac_wt_a_src_data66[7:0])    //|< i
  ,.sc2mac_wt_src_data67           (sc2mac_wt_a_src_data67[7:0])    //|< i
  ,.sc2mac_wt_src_data68           (sc2mac_wt_a_src_data68[7:0])    //|< i
  ,.sc2mac_wt_src_data69           (sc2mac_wt_a_src_data69[7:0])    //|< i
  ,.sc2mac_wt_src_data70           (sc2mac_wt_a_src_data70[7:0])    //|< i
  ,.sc2mac_wt_src_data71           (sc2mac_wt_a_src_data71[7:0])    //|< i
  ,.sc2mac_wt_src_data72           (sc2mac_wt_a_src_data72[7:0])    //|< i
  ,.sc2mac_wt_src_data73           (sc2mac_wt_a_src_data73[7:0])    //|< i
  ,.sc2mac_wt_src_data74           (sc2mac_wt_a_src_data74[7:0])    //|< i
  ,.sc2mac_wt_src_data75           (sc2mac_wt_a_src_data75[7:0])    //|< i
  ,.sc2mac_wt_src_data76           (sc2mac_wt_a_src_data76[7:0])    //|< i
  ,.sc2mac_wt_src_data77           (sc2mac_wt_a_src_data77[7:0])    //|< i
  ,.sc2mac_wt_src_data78           (sc2mac_wt_a_src_data78[7:0])    //|< i
  ,.sc2mac_wt_src_data79           (sc2mac_wt_a_src_data79[7:0])    //|< i
  ,.sc2mac_wt_src_data80           (sc2mac_wt_a_src_data80[7:0])    //|< i
  ,.sc2mac_wt_src_data81           (sc2mac_wt_a_src_data81[7:0])    //|< i
  ,.sc2mac_wt_src_data82           (sc2mac_wt_a_src_data82[7:0])    //|< i
  ,.sc2mac_wt_src_data83           (sc2mac_wt_a_src_data83[7:0])    //|< i
  ,.sc2mac_wt_src_data84           (sc2mac_wt_a_src_data84[7:0])    //|< i
  ,.sc2mac_wt_src_data85           (sc2mac_wt_a_src_data85[7:0])    //|< i
  ,.sc2mac_wt_src_data86           (sc2mac_wt_a_src_data86[7:0])    //|< i
  ,.sc2mac_wt_src_data87           (sc2mac_wt_a_src_data87[7:0])    //|< i
  ,.sc2mac_wt_src_data88           (sc2mac_wt_a_src_data88[7:0])    //|< i
  ,.sc2mac_wt_src_data89           (sc2mac_wt_a_src_data89[7:0])    //|< i
  ,.sc2mac_wt_src_data90           (sc2mac_wt_a_src_data90[7:0])    //|< i
  ,.sc2mac_wt_src_data91           (sc2mac_wt_a_src_data91[7:0])    //|< i
  ,.sc2mac_wt_src_data92           (sc2mac_wt_a_src_data92[7:0])    //|< i
  ,.sc2mac_wt_src_data93           (sc2mac_wt_a_src_data93[7:0])    //|< i
  ,.sc2mac_wt_src_data94           (sc2mac_wt_a_src_data94[7:0])    //|< i
  ,.sc2mac_wt_src_data95           (sc2mac_wt_a_src_data95[7:0])    //|< i
  ,.sc2mac_wt_src_data96           (sc2mac_wt_a_src_data96[7:0])    //|< i
  ,.sc2mac_wt_src_data97           (sc2mac_wt_a_src_data97[7:0])    //|< i
  ,.sc2mac_wt_src_data98           (sc2mac_wt_a_src_data98[7:0])    //|< i
  ,.sc2mac_wt_src_data99           (sc2mac_wt_a_src_data99[7:0])    //|< i
  ,.sc2mac_wt_src_data100          (sc2mac_wt_a_src_data100[7:0])   //|< i
  ,.sc2mac_wt_src_data101          (sc2mac_wt_a_src_data101[7:0])   //|< i
  ,.sc2mac_wt_src_data102          (sc2mac_wt_a_src_data102[7:0])   //|< i
  ,.sc2mac_wt_src_data103          (sc2mac_wt_a_src_data103[7:0])   //|< i
  ,.sc2mac_wt_src_data104          (sc2mac_wt_a_src_data104[7:0])   //|< i
  ,.sc2mac_wt_src_data105          (sc2mac_wt_a_src_data105[7:0])   //|< i
  ,.sc2mac_wt_src_data106          (sc2mac_wt_a_src_data106[7:0])   //|< i
  ,.sc2mac_wt_src_data107          (sc2mac_wt_a_src_data107[7:0])   //|< i
  ,.sc2mac_wt_src_data108          (sc2mac_wt_a_src_data108[7:0])   //|< i
  ,.sc2mac_wt_src_data109          (sc2mac_wt_a_src_data109[7:0])   //|< i
  ,.sc2mac_wt_src_data110          (sc2mac_wt_a_src_data110[7:0])   //|< i
  ,.sc2mac_wt_src_data111          (sc2mac_wt_a_src_data111[7:0])   //|< i
  ,.sc2mac_wt_src_data112          (sc2mac_wt_a_src_data112[7:0])   //|< i
  ,.sc2mac_wt_src_data113          (sc2mac_wt_a_src_data113[7:0])   //|< i
  ,.sc2mac_wt_src_data114          (sc2mac_wt_a_src_data114[7:0])   //|< i
  ,.sc2mac_wt_src_data115          (sc2mac_wt_a_src_data115[7:0])   //|< i
  ,.sc2mac_wt_src_data116          (sc2mac_wt_a_src_data116[7:0])   //|< i
  ,.sc2mac_wt_src_data117          (sc2mac_wt_a_src_data117[7:0])   //|< i
  ,.sc2mac_wt_src_data118          (sc2mac_wt_a_src_data118[7:0])   //|< i
  ,.sc2mac_wt_src_data119          (sc2mac_wt_a_src_data119[7:0])   //|< i
  ,.sc2mac_wt_src_data120          (sc2mac_wt_a_src_data120[7:0])   //|< i
  ,.sc2mac_wt_src_data121          (sc2mac_wt_a_src_data121[7:0])   //|< i
  ,.sc2mac_wt_src_data122          (sc2mac_wt_a_src_data122[7:0])   //|< i
  ,.sc2mac_wt_src_data123          (sc2mac_wt_a_src_data123[7:0])   //|< i
  ,.sc2mac_wt_src_data124          (sc2mac_wt_a_src_data124[7:0])   //|< i
  ,.sc2mac_wt_src_data125          (sc2mac_wt_a_src_data125[7:0])   //|< i
  ,.sc2mac_wt_src_data126          (sc2mac_wt_a_src_data126[7:0])   //|< i
  ,.sc2mac_wt_src_data127          (sc2mac_wt_a_src_data127[7:0])   //|< i
  ,.sc2mac_wt_src_sel              (sc2mac_wt_a_src_sel[7:0])       //|< i
  ,.sc2mac_dat_src_pvld            (sc2mac_dat_a_src_pvld)          //|< i
  ,.sc2mac_dat_src_mask            (sc2mac_dat_a_src_mask[127:0])   //|< i
  ,.sc2mac_dat_src_data0           (sc2mac_dat_a_src_data0[7:0])    //|< i
  ,.sc2mac_dat_src_data1           (sc2mac_dat_a_src_data1[7:0])    //|< i
  ,.sc2mac_dat_src_data2           (sc2mac_dat_a_src_data2[7:0])    //|< i
  ,.sc2mac_dat_src_data3           (sc2mac_dat_a_src_data3[7:0])    //|< i
  ,.sc2mac_dat_src_data4           (sc2mac_dat_a_src_data4[7:0])    //|< i
  ,.sc2mac_dat_src_data5           (sc2mac_dat_a_src_data5[7:0])    //|< i
  ,.sc2mac_dat_src_data6           (sc2mac_dat_a_src_data6[7:0])    //|< i
  ,.sc2mac_dat_src_data7           (sc2mac_dat_a_src_data7[7:0])    //|< i
  ,.sc2mac_dat_src_data8           (sc2mac_dat_a_src_data8[7:0])    //|< i
  ,.sc2mac_dat_src_data9           (sc2mac_dat_a_src_data9[7:0])    //|< i
  ,.sc2mac_dat_src_data10          (sc2mac_dat_a_src_data10[7:0])   //|< i
  ,.sc2mac_dat_src_data11          (sc2mac_dat_a_src_data11[7:0])   //|< i
  ,.sc2mac_dat_src_data12          (sc2mac_dat_a_src_data12[7:0])   //|< i
  ,.sc2mac_dat_src_data13          (sc2mac_dat_a_src_data13[7:0])   //|< i
  ,.sc2mac_dat_src_data14          (sc2mac_dat_a_src_data14[7:0])   //|< i
  ,.sc2mac_dat_src_data15          (sc2mac_dat_a_src_data15[7:0])   //|< i
  ,.sc2mac_dat_src_data16          (sc2mac_dat_a_src_data16[7:0])   //|< i
  ,.sc2mac_dat_src_data17          (sc2mac_dat_a_src_data17[7:0])   //|< i
  ,.sc2mac_dat_src_data18          (sc2mac_dat_a_src_data18[7:0])   //|< i
  ,.sc2mac_dat_src_data19          (sc2mac_dat_a_src_data19[7:0])   //|< i
  ,.sc2mac_dat_src_data20          (sc2mac_dat_a_src_data20[7:0])   //|< i
  ,.sc2mac_dat_src_data21          (sc2mac_dat_a_src_data21[7:0])   //|< i
  ,.sc2mac_dat_src_data22          (sc2mac_dat_a_src_data22[7:0])   //|< i
  ,.sc2mac_dat_src_data23          (sc2mac_dat_a_src_data23[7:0])   //|< i
  ,.sc2mac_dat_src_data24          (sc2mac_dat_a_src_data24[7:0])   //|< i
  ,.sc2mac_dat_src_data25          (sc2mac_dat_a_src_data25[7:0])   //|< i
  ,.sc2mac_dat_src_data26          (sc2mac_dat_a_src_data26[7:0])   //|< i
  ,.sc2mac_dat_src_data27          (sc2mac_dat_a_src_data27[7:0])   //|< i
  ,.sc2mac_dat_src_data28          (sc2mac_dat_a_src_data28[7:0])   //|< i
  ,.sc2mac_dat_src_data29          (sc2mac_dat_a_src_data29[7:0])   //|< i
  ,.sc2mac_dat_src_data30          (sc2mac_dat_a_src_data30[7:0])   //|< i
  ,.sc2mac_dat_src_data31          (sc2mac_dat_a_src_data31[7:0])   //|< i
  ,.sc2mac_dat_src_data32          (sc2mac_dat_a_src_data32[7:0])   //|< i
  ,.sc2mac_dat_src_data33          (sc2mac_dat_a_src_data33[7:0])   //|< i
  ,.sc2mac_dat_src_data34          (sc2mac_dat_a_src_data34[7:0])   //|< i
  ,.sc2mac_dat_src_data35          (sc2mac_dat_a_src_data35[7:0])   //|< i
  ,.sc2mac_dat_src_data36          (sc2mac_dat_a_src_data36[7:0])   //|< i
  ,.sc2mac_dat_src_data37          (sc2mac_dat_a_src_data37[7:0])   //|< i
  ,.sc2mac_dat_src_data38          (sc2mac_dat_a_src_data38[7:0])   //|< i
  ,.sc2mac_dat_src_data39          (sc2mac_dat_a_src_data39[7:0])   //|< i
  ,.sc2mac_dat_src_data40          (sc2mac_dat_a_src_data40[7:0])   //|< i
  ,.sc2mac_dat_src_data41          (sc2mac_dat_a_src_data41[7:0])   //|< i
  ,.sc2mac_dat_src_data42          (sc2mac_dat_a_src_data42[7:0])   //|< i
  ,.sc2mac_dat_src_data43          (sc2mac_dat_a_src_data43[7:0])   //|< i
  ,.sc2mac_dat_src_data44          (sc2mac_dat_a_src_data44[7:0])   //|< i
  ,.sc2mac_dat_src_data45          (sc2mac_dat_a_src_data45[7:0])   //|< i
  ,.sc2mac_dat_src_data46          (sc2mac_dat_a_src_data46[7:0])   //|< i
  ,.sc2mac_dat_src_data47          (sc2mac_dat_a_src_data47[7:0])   //|< i
  ,.sc2mac_dat_src_data48          (sc2mac_dat_a_src_data48[7:0])   //|< i
  ,.sc2mac_dat_src_data49          (sc2mac_dat_a_src_data49[7:0])   //|< i
  ,.sc2mac_dat_src_data50          (sc2mac_dat_a_src_data50[7:0])   //|< i
  ,.sc2mac_dat_src_data51          (sc2mac_dat_a_src_data51[7:0])   //|< i
  ,.sc2mac_dat_src_data52          (sc2mac_dat_a_src_data52[7:0])   //|< i
  ,.sc2mac_dat_src_data53          (sc2mac_dat_a_src_data53[7:0])   //|< i
  ,.sc2mac_dat_src_data54          (sc2mac_dat_a_src_data54[7:0])   //|< i
  ,.sc2mac_dat_src_data55          (sc2mac_dat_a_src_data55[7:0])   //|< i
  ,.sc2mac_dat_src_data56          (sc2mac_dat_a_src_data56[7:0])   //|< i
  ,.sc2mac_dat_src_data57          (sc2mac_dat_a_src_data57[7:0])   //|< i
  ,.sc2mac_dat_src_data58          (sc2mac_dat_a_src_data58[7:0])   //|< i
  ,.sc2mac_dat_src_data59          (sc2mac_dat_a_src_data59[7:0])   //|< i
  ,.sc2mac_dat_src_data60          (sc2mac_dat_a_src_data60[7:0])   //|< i
  ,.sc2mac_dat_src_data61          (sc2mac_dat_a_src_data61[7:0])   //|< i
  ,.sc2mac_dat_src_data62          (sc2mac_dat_a_src_data62[7:0])   //|< i
  ,.sc2mac_dat_src_data63          (sc2mac_dat_a_src_data63[7:0])   //|< i
  ,.sc2mac_dat_src_data64          (sc2mac_dat_a_src_data64[7:0])   //|< i
  ,.sc2mac_dat_src_data65          (sc2mac_dat_a_src_data65[7:0])   //|< i
  ,.sc2mac_dat_src_data66          (sc2mac_dat_a_src_data66[7:0])   //|< i
  ,.sc2mac_dat_src_data67          (sc2mac_dat_a_src_data67[7:0])   //|< i
  ,.sc2mac_dat_src_data68          (sc2mac_dat_a_src_data68[7:0])   //|< i
  ,.sc2mac_dat_src_data69          (sc2mac_dat_a_src_data69[7:0])   //|< i
  ,.sc2mac_dat_src_data70          (sc2mac_dat_a_src_data70[7:0])   //|< i
  ,.sc2mac_dat_src_data71          (sc2mac_dat_a_src_data71[7:0])   //|< i
  ,.sc2mac_dat_src_data72          (sc2mac_dat_a_src_data72[7:0])   //|< i
  ,.sc2mac_dat_src_data73          (sc2mac_dat_a_src_data73[7:0])   //|< i
  ,.sc2mac_dat_src_data74          (sc2mac_dat_a_src_data74[7:0])   //|< i
  ,.sc2mac_dat_src_data75          (sc2mac_dat_a_src_data75[7:0])   //|< i
  ,.sc2mac_dat_src_data76          (sc2mac_dat_a_src_data76[7:0])   //|< i
  ,.sc2mac_dat_src_data77          (sc2mac_dat_a_src_data77[7:0])   //|< i
  ,.sc2mac_dat_src_data78          (sc2mac_dat_a_src_data78[7:0])   //|< i
  ,.sc2mac_dat_src_data79          (sc2mac_dat_a_src_data79[7:0])   //|< i
  ,.sc2mac_dat_src_data80          (sc2mac_dat_a_src_data80[7:0])   //|< i
  ,.sc2mac_dat_src_data81          (sc2mac_dat_a_src_data81[7:0])   //|< i
  ,.sc2mac_dat_src_data82          (sc2mac_dat_a_src_data82[7:0])   //|< i
  ,.sc2mac_dat_src_data83          (sc2mac_dat_a_src_data83[7:0])   //|< i
  ,.sc2mac_dat_src_data84          (sc2mac_dat_a_src_data84[7:0])   //|< i
  ,.sc2mac_dat_src_data85          (sc2mac_dat_a_src_data85[7:0])   //|< i
  ,.sc2mac_dat_src_data86          (sc2mac_dat_a_src_data86[7:0])   //|< i
  ,.sc2mac_dat_src_data87          (sc2mac_dat_a_src_data87[7:0])   //|< i
  ,.sc2mac_dat_src_data88          (sc2mac_dat_a_src_data88[7:0])   //|< i
  ,.sc2mac_dat_src_data89          (sc2mac_dat_a_src_data89[7:0])   //|< i
  ,.sc2mac_dat_src_data90          (sc2mac_dat_a_src_data90[7:0])   //|< i
  ,.sc2mac_dat_src_data91          (sc2mac_dat_a_src_data91[7:0])   //|< i
  ,.sc2mac_dat_src_data92          (sc2mac_dat_a_src_data92[7:0])   //|< i
  ,.sc2mac_dat_src_data93          (sc2mac_dat_a_src_data93[7:0])   //|< i
  ,.sc2mac_dat_src_data94          (sc2mac_dat_a_src_data94[7:0])   //|< i
  ,.sc2mac_dat_src_data95          (sc2mac_dat_a_src_data95[7:0])   //|< i
  ,.sc2mac_dat_src_data96          (sc2mac_dat_a_src_data96[7:0])   //|< i
  ,.sc2mac_dat_src_data97          (sc2mac_dat_a_src_data97[7:0])   //|< i
  ,.sc2mac_dat_src_data98          (sc2mac_dat_a_src_data98[7:0])   //|< i
  ,.sc2mac_dat_src_data99          (sc2mac_dat_a_src_data99[7:0])   //|< i
  ,.sc2mac_dat_src_data100         (sc2mac_dat_a_src_data100[7:0])  //|< i
  ,.sc2mac_dat_src_data101         (sc2mac_dat_a_src_data101[7:0])  //|< i
  ,.sc2mac_dat_src_data102         (sc2mac_dat_a_src_data102[7:0])  //|< i
  ,.sc2mac_dat_src_data103         (sc2mac_dat_a_src_data103[7:0])  //|< i
  ,.sc2mac_dat_src_data104         (sc2mac_dat_a_src_data104[7:0])  //|< i
  ,.sc2mac_dat_src_data105         (sc2mac_dat_a_src_data105[7:0])  //|< i
  ,.sc2mac_dat_src_data106         (sc2mac_dat_a_src_data106[7:0])  //|< i
  ,.sc2mac_dat_src_data107         (sc2mac_dat_a_src_data107[7:0])  //|< i
  ,.sc2mac_dat_src_data108         (sc2mac_dat_a_src_data108[7:0])  //|< i
  ,.sc2mac_dat_src_data109         (sc2mac_dat_a_src_data109[7:0])  //|< i
  ,.sc2mac_dat_src_data110         (sc2mac_dat_a_src_data110[7:0])  //|< i
  ,.sc2mac_dat_src_data111         (sc2mac_dat_a_src_data111[7:0])  //|< i
  ,.sc2mac_dat_src_data112         (sc2mac_dat_a_src_data112[7:0])  //|< i
  ,.sc2mac_dat_src_data113         (sc2mac_dat_a_src_data113[7:0])  //|< i
  ,.sc2mac_dat_src_data114         (sc2mac_dat_a_src_data114[7:0])  //|< i
  ,.sc2mac_dat_src_data115         (sc2mac_dat_a_src_data115[7:0])  //|< i
  ,.sc2mac_dat_src_data116         (sc2mac_dat_a_src_data116[7:0])  //|< i
  ,.sc2mac_dat_src_data117         (sc2mac_dat_a_src_data117[7:0])  //|< i
  ,.sc2mac_dat_src_data118         (sc2mac_dat_a_src_data118[7:0])  //|< i
  ,.sc2mac_dat_src_data119         (sc2mac_dat_a_src_data119[7:0])  //|< i
  ,.sc2mac_dat_src_data120         (sc2mac_dat_a_src_data120[7:0])  //|< i
  ,.sc2mac_dat_src_data121         (sc2mac_dat_a_src_data121[7:0])  //|< i
  ,.sc2mac_dat_src_data122         (sc2mac_dat_a_src_data122[7:0])  //|< i
  ,.sc2mac_dat_src_data123         (sc2mac_dat_a_src_data123[7:0])  //|< i
  ,.sc2mac_dat_src_data124         (sc2mac_dat_a_src_data124[7:0])  //|< i
  ,.sc2mac_dat_src_data125         (sc2mac_dat_a_src_data125[7:0])  //|< i
  ,.sc2mac_dat_src_data126         (sc2mac_dat_a_src_data126[7:0])  //|< i
  ,.sc2mac_dat_src_data127         (sc2mac_dat_a_src_data127[7:0])  //|< i
  ,.sc2mac_dat_src_pd              (sc2mac_dat_a_src_pd[8:0])       //|< i
  ,.sc2mac_wt_dst_pvld             (sc2mac_wt_a_dst_pvld)           //|> o
  ,.sc2mac_wt_dst_mask             (sc2mac_wt_a_dst_mask[127:0])    //|> o
  ,.sc2mac_wt_dst_data0            (sc2mac_wt_a_dst_data0[7:0])     //|> o
  ,.sc2mac_wt_dst_data1            (sc2mac_wt_a_dst_data1[7:0])     //|> o
  ,.sc2mac_wt_dst_data2            (sc2mac_wt_a_dst_data2[7:0])     //|> o
  ,.sc2mac_wt_dst_data3            (sc2mac_wt_a_dst_data3[7:0])     //|> o
  ,.sc2mac_wt_dst_data4            (sc2mac_wt_a_dst_data4[7:0])     //|> o
  ,.sc2mac_wt_dst_data5            (sc2mac_wt_a_dst_data5[7:0])     //|> o
  ,.sc2mac_wt_dst_data6            (sc2mac_wt_a_dst_data6[7:0])     //|> o
  ,.sc2mac_wt_dst_data7            (sc2mac_wt_a_dst_data7[7:0])     //|> o
  ,.sc2mac_wt_dst_data8            (sc2mac_wt_a_dst_data8[7:0])     //|> o
  ,.sc2mac_wt_dst_data9            (sc2mac_wt_a_dst_data9[7:0])     //|> o
  ,.sc2mac_wt_dst_data10           (sc2mac_wt_a_dst_data10[7:0])    //|> o
  ,.sc2mac_wt_dst_data11           (sc2mac_wt_a_dst_data11[7:0])    //|> o
  ,.sc2mac_wt_dst_data12           (sc2mac_wt_a_dst_data12[7:0])    //|> o
  ,.sc2mac_wt_dst_data13           (sc2mac_wt_a_dst_data13[7:0])    //|> o
  ,.sc2mac_wt_dst_data14           (sc2mac_wt_a_dst_data14[7:0])    //|> o
  ,.sc2mac_wt_dst_data15           (sc2mac_wt_a_dst_data15[7:0])    //|> o
  ,.sc2mac_wt_dst_data16           (sc2mac_wt_a_dst_data16[7:0])    //|> o
  ,.sc2mac_wt_dst_data17           (sc2mac_wt_a_dst_data17[7:0])    //|> o
  ,.sc2mac_wt_dst_data18           (sc2mac_wt_a_dst_data18[7:0])    //|> o
  ,.sc2mac_wt_dst_data19           (sc2mac_wt_a_dst_data19[7:0])    //|> o
  ,.sc2mac_wt_dst_data20           (sc2mac_wt_a_dst_data20[7:0])    //|> o
  ,.sc2mac_wt_dst_data21           (sc2mac_wt_a_dst_data21[7:0])    //|> o
  ,.sc2mac_wt_dst_data22           (sc2mac_wt_a_dst_data22[7:0])    //|> o
  ,.sc2mac_wt_dst_data23           (sc2mac_wt_a_dst_data23[7:0])    //|> o
  ,.sc2mac_wt_dst_data24           (sc2mac_wt_a_dst_data24[7:0])    //|> o
  ,.sc2mac_wt_dst_data25           (sc2mac_wt_a_dst_data25[7:0])    //|> o
  ,.sc2mac_wt_dst_data26           (sc2mac_wt_a_dst_data26[7:0])    //|> o
  ,.sc2mac_wt_dst_data27           (sc2mac_wt_a_dst_data27[7:0])    //|> o
  ,.sc2mac_wt_dst_data28           (sc2mac_wt_a_dst_data28[7:0])    //|> o
  ,.sc2mac_wt_dst_data29           (sc2mac_wt_a_dst_data29[7:0])    //|> o
  ,.sc2mac_wt_dst_data30           (sc2mac_wt_a_dst_data30[7:0])    //|> o
  ,.sc2mac_wt_dst_data31           (sc2mac_wt_a_dst_data31[7:0])    //|> o
  ,.sc2mac_wt_dst_data32           (sc2mac_wt_a_dst_data32[7:0])    //|> o
  ,.sc2mac_wt_dst_data33           (sc2mac_wt_a_dst_data33[7:0])    //|> o
  ,.sc2mac_wt_dst_data34           (sc2mac_wt_a_dst_data34[7:0])    //|> o
  ,.sc2mac_wt_dst_data35           (sc2mac_wt_a_dst_data35[7:0])    //|> o
  ,.sc2mac_wt_dst_data36           (sc2mac_wt_a_dst_data36[7:0])    //|> o
  ,.sc2mac_wt_dst_data37           (sc2mac_wt_a_dst_data37[7:0])    //|> o
  ,.sc2mac_wt_dst_data38           (sc2mac_wt_a_dst_data38[7:0])    //|> o
  ,.sc2mac_wt_dst_data39           (sc2mac_wt_a_dst_data39[7:0])    //|> o
  ,.sc2mac_wt_dst_data40           (sc2mac_wt_a_dst_data40[7:0])    //|> o
  ,.sc2mac_wt_dst_data41           (sc2mac_wt_a_dst_data41[7:0])    //|> o
  ,.sc2mac_wt_dst_data42           (sc2mac_wt_a_dst_data42[7:0])    //|> o
  ,.sc2mac_wt_dst_data43           (sc2mac_wt_a_dst_data43[7:0])    //|> o
  ,.sc2mac_wt_dst_data44           (sc2mac_wt_a_dst_data44[7:0])    //|> o
  ,.sc2mac_wt_dst_data45           (sc2mac_wt_a_dst_data45[7:0])    //|> o
  ,.sc2mac_wt_dst_data46           (sc2mac_wt_a_dst_data46[7:0])    //|> o
  ,.sc2mac_wt_dst_data47           (sc2mac_wt_a_dst_data47[7:0])    //|> o
  ,.sc2mac_wt_dst_data48           (sc2mac_wt_a_dst_data48[7:0])    //|> o
  ,.sc2mac_wt_dst_data49           (sc2mac_wt_a_dst_data49[7:0])    //|> o
  ,.sc2mac_wt_dst_data50           (sc2mac_wt_a_dst_data50[7:0])    //|> o
  ,.sc2mac_wt_dst_data51           (sc2mac_wt_a_dst_data51[7:0])    //|> o
  ,.sc2mac_wt_dst_data52           (sc2mac_wt_a_dst_data52[7:0])    //|> o
  ,.sc2mac_wt_dst_data53           (sc2mac_wt_a_dst_data53[7:0])    //|> o
  ,.sc2mac_wt_dst_data54           (sc2mac_wt_a_dst_data54[7:0])    //|> o
  ,.sc2mac_wt_dst_data55           (sc2mac_wt_a_dst_data55[7:0])    //|> o
  ,.sc2mac_wt_dst_data56           (sc2mac_wt_a_dst_data56[7:0])    //|> o
  ,.sc2mac_wt_dst_data57           (sc2mac_wt_a_dst_data57[7:0])    //|> o
  ,.sc2mac_wt_dst_data58           (sc2mac_wt_a_dst_data58[7:0])    //|> o
  ,.sc2mac_wt_dst_data59           (sc2mac_wt_a_dst_data59[7:0])    //|> o
  ,.sc2mac_wt_dst_data60           (sc2mac_wt_a_dst_data60[7:0])    //|> o
  ,.sc2mac_wt_dst_data61           (sc2mac_wt_a_dst_data61[7:0])    //|> o
  ,.sc2mac_wt_dst_data62           (sc2mac_wt_a_dst_data62[7:0])    //|> o
  ,.sc2mac_wt_dst_data63           (sc2mac_wt_a_dst_data63[7:0])    //|> o
  ,.sc2mac_wt_dst_data64           (sc2mac_wt_a_dst_data64[7:0])    //|> o
  ,.sc2mac_wt_dst_data65           (sc2mac_wt_a_dst_data65[7:0])    //|> o
  ,.sc2mac_wt_dst_data66           (sc2mac_wt_a_dst_data66[7:0])    //|> o
  ,.sc2mac_wt_dst_data67           (sc2mac_wt_a_dst_data67[7:0])    //|> o
  ,.sc2mac_wt_dst_data68           (sc2mac_wt_a_dst_data68[7:0])    //|> o
  ,.sc2mac_wt_dst_data69           (sc2mac_wt_a_dst_data69[7:0])    //|> o
  ,.sc2mac_wt_dst_data70           (sc2mac_wt_a_dst_data70[7:0])    //|> o
  ,.sc2mac_wt_dst_data71           (sc2mac_wt_a_dst_data71[7:0])    //|> o
  ,.sc2mac_wt_dst_data72           (sc2mac_wt_a_dst_data72[7:0])    //|> o
  ,.sc2mac_wt_dst_data73           (sc2mac_wt_a_dst_data73[7:0])    //|> o
  ,.sc2mac_wt_dst_data74           (sc2mac_wt_a_dst_data74[7:0])    //|> o
  ,.sc2mac_wt_dst_data75           (sc2mac_wt_a_dst_data75[7:0])    //|> o
  ,.sc2mac_wt_dst_data76           (sc2mac_wt_a_dst_data76[7:0])    //|> o
  ,.sc2mac_wt_dst_data77           (sc2mac_wt_a_dst_data77[7:0])    //|> o
  ,.sc2mac_wt_dst_data78           (sc2mac_wt_a_dst_data78[7:0])    //|> o
  ,.sc2mac_wt_dst_data79           (sc2mac_wt_a_dst_data79[7:0])    //|> o
  ,.sc2mac_wt_dst_data80           (sc2mac_wt_a_dst_data80[7:0])    //|> o
  ,.sc2mac_wt_dst_data81           (sc2mac_wt_a_dst_data81[7:0])    //|> o
  ,.sc2mac_wt_dst_data82           (sc2mac_wt_a_dst_data82[7:0])    //|> o
  ,.sc2mac_wt_dst_data83           (sc2mac_wt_a_dst_data83[7:0])    //|> o
  ,.sc2mac_wt_dst_data84           (sc2mac_wt_a_dst_data84[7:0])    //|> o
  ,.sc2mac_wt_dst_data85           (sc2mac_wt_a_dst_data85[7:0])    //|> o
  ,.sc2mac_wt_dst_data86           (sc2mac_wt_a_dst_data86[7:0])    //|> o
  ,.sc2mac_wt_dst_data87           (sc2mac_wt_a_dst_data87[7:0])    //|> o
  ,.sc2mac_wt_dst_data88           (sc2mac_wt_a_dst_data88[7:0])    //|> o
  ,.sc2mac_wt_dst_data89           (sc2mac_wt_a_dst_data89[7:0])    //|> o
  ,.sc2mac_wt_dst_data90           (sc2mac_wt_a_dst_data90[7:0])    //|> o
  ,.sc2mac_wt_dst_data91           (sc2mac_wt_a_dst_data91[7:0])    //|> o
  ,.sc2mac_wt_dst_data92           (sc2mac_wt_a_dst_data92[7:0])    //|> o
  ,.sc2mac_wt_dst_data93           (sc2mac_wt_a_dst_data93[7:0])    //|> o
  ,.sc2mac_wt_dst_data94           (sc2mac_wt_a_dst_data94[7:0])    //|> o
  ,.sc2mac_wt_dst_data95           (sc2mac_wt_a_dst_data95[7:0])    //|> o
  ,.sc2mac_wt_dst_data96           (sc2mac_wt_a_dst_data96[7:0])    //|> o
  ,.sc2mac_wt_dst_data97           (sc2mac_wt_a_dst_data97[7:0])    //|> o
  ,.sc2mac_wt_dst_data98           (sc2mac_wt_a_dst_data98[7:0])    //|> o
  ,.sc2mac_wt_dst_data99           (sc2mac_wt_a_dst_data99[7:0])    //|> o
  ,.sc2mac_wt_dst_data100          (sc2mac_wt_a_dst_data100[7:0])   //|> o
  ,.sc2mac_wt_dst_data101          (sc2mac_wt_a_dst_data101[7:0])   //|> o
  ,.sc2mac_wt_dst_data102          (sc2mac_wt_a_dst_data102[7:0])   //|> o
  ,.sc2mac_wt_dst_data103          (sc2mac_wt_a_dst_data103[7:0])   //|> o
  ,.sc2mac_wt_dst_data104          (sc2mac_wt_a_dst_data104[7:0])   //|> o
  ,.sc2mac_wt_dst_data105          (sc2mac_wt_a_dst_data105[7:0])   //|> o
  ,.sc2mac_wt_dst_data106          (sc2mac_wt_a_dst_data106[7:0])   //|> o
  ,.sc2mac_wt_dst_data107          (sc2mac_wt_a_dst_data107[7:0])   //|> o
  ,.sc2mac_wt_dst_data108          (sc2mac_wt_a_dst_data108[7:0])   //|> o
  ,.sc2mac_wt_dst_data109          (sc2mac_wt_a_dst_data109[7:0])   //|> o
  ,.sc2mac_wt_dst_data110          (sc2mac_wt_a_dst_data110[7:0])   //|> o
  ,.sc2mac_wt_dst_data111          (sc2mac_wt_a_dst_data111[7:0])   //|> o
  ,.sc2mac_wt_dst_data112          (sc2mac_wt_a_dst_data112[7:0])   //|> o
  ,.sc2mac_wt_dst_data113          (sc2mac_wt_a_dst_data113[7:0])   //|> o
  ,.sc2mac_wt_dst_data114          (sc2mac_wt_a_dst_data114[7:0])   //|> o
  ,.sc2mac_wt_dst_data115          (sc2mac_wt_a_dst_data115[7:0])   //|> o
  ,.sc2mac_wt_dst_data116          (sc2mac_wt_a_dst_data116[7:0])   //|> o
  ,.sc2mac_wt_dst_data117          (sc2mac_wt_a_dst_data117[7:0])   //|> o
  ,.sc2mac_wt_dst_data118          (sc2mac_wt_a_dst_data118[7:0])   //|> o
  ,.sc2mac_wt_dst_data119          (sc2mac_wt_a_dst_data119[7:0])   //|> o
  ,.sc2mac_wt_dst_data120          (sc2mac_wt_a_dst_data120[7:0])   //|> o
  ,.sc2mac_wt_dst_data121          (sc2mac_wt_a_dst_data121[7:0])   //|> o
  ,.sc2mac_wt_dst_data122          (sc2mac_wt_a_dst_data122[7:0])   //|> o
  ,.sc2mac_wt_dst_data123          (sc2mac_wt_a_dst_data123[7:0])   //|> o
  ,.sc2mac_wt_dst_data124          (sc2mac_wt_a_dst_data124[7:0])   //|> o
  ,.sc2mac_wt_dst_data125          (sc2mac_wt_a_dst_data125[7:0])   //|> o
  ,.sc2mac_wt_dst_data126          (sc2mac_wt_a_dst_data126[7:0])   //|> o
  ,.sc2mac_wt_dst_data127          (sc2mac_wt_a_dst_data127[7:0])   //|> o
  ,.sc2mac_wt_dst_sel              (sc2mac_wt_a_dst_sel[7:0])       //|> o
  ,.sc2mac_dat_dst_pvld            (sc2mac_dat_a_dst_pvld)          //|> o
  ,.sc2mac_dat_dst_mask            (sc2mac_dat_a_dst_mask[127:0])   //|> o
  ,.sc2mac_dat_dst_data0           (sc2mac_dat_a_dst_data0[7:0])    //|> o
  ,.sc2mac_dat_dst_data1           (sc2mac_dat_a_dst_data1[7:0])    //|> o
  ,.sc2mac_dat_dst_data2           (sc2mac_dat_a_dst_data2[7:0])    //|> o
  ,.sc2mac_dat_dst_data3           (sc2mac_dat_a_dst_data3[7:0])    //|> o
  ,.sc2mac_dat_dst_data4           (sc2mac_dat_a_dst_data4[7:0])    //|> o
  ,.sc2mac_dat_dst_data5           (sc2mac_dat_a_dst_data5[7:0])    //|> o
  ,.sc2mac_dat_dst_data6           (sc2mac_dat_a_dst_data6[7:0])    //|> o
  ,.sc2mac_dat_dst_data7           (sc2mac_dat_a_dst_data7[7:0])    //|> o
  ,.sc2mac_dat_dst_data8           (sc2mac_dat_a_dst_data8[7:0])    //|> o
  ,.sc2mac_dat_dst_data9           (sc2mac_dat_a_dst_data9[7:0])    //|> o
  ,.sc2mac_dat_dst_data10          (sc2mac_dat_a_dst_data10[7:0])   //|> o
  ,.sc2mac_dat_dst_data11          (sc2mac_dat_a_dst_data11[7:0])   //|> o
  ,.sc2mac_dat_dst_data12          (sc2mac_dat_a_dst_data12[7:0])   //|> o
  ,.sc2mac_dat_dst_data13          (sc2mac_dat_a_dst_data13[7:0])   //|> o
  ,.sc2mac_dat_dst_data14          (sc2mac_dat_a_dst_data14[7:0])   //|> o
  ,.sc2mac_dat_dst_data15          (sc2mac_dat_a_dst_data15[7:0])   //|> o
  ,.sc2mac_dat_dst_data16          (sc2mac_dat_a_dst_data16[7:0])   //|> o
  ,.sc2mac_dat_dst_data17          (sc2mac_dat_a_dst_data17[7:0])   //|> o
  ,.sc2mac_dat_dst_data18          (sc2mac_dat_a_dst_data18[7:0])   //|> o
  ,.sc2mac_dat_dst_data19          (sc2mac_dat_a_dst_data19[7:0])   //|> o
  ,.sc2mac_dat_dst_data20          (sc2mac_dat_a_dst_data20[7:0])   //|> o
  ,.sc2mac_dat_dst_data21          (sc2mac_dat_a_dst_data21[7:0])   //|> o
  ,.sc2mac_dat_dst_data22          (sc2mac_dat_a_dst_data22[7:0])   //|> o
  ,.sc2mac_dat_dst_data23          (sc2mac_dat_a_dst_data23[7:0])   //|> o
  ,.sc2mac_dat_dst_data24          (sc2mac_dat_a_dst_data24[7:0])   //|> o
  ,.sc2mac_dat_dst_data25          (sc2mac_dat_a_dst_data25[7:0])   //|> o
  ,.sc2mac_dat_dst_data26          (sc2mac_dat_a_dst_data26[7:0])   //|> o
  ,.sc2mac_dat_dst_data27          (sc2mac_dat_a_dst_data27[7:0])   //|> o
  ,.sc2mac_dat_dst_data28          (sc2mac_dat_a_dst_data28[7:0])   //|> o
  ,.sc2mac_dat_dst_data29          (sc2mac_dat_a_dst_data29[7:0])   //|> o
  ,.sc2mac_dat_dst_data30          (sc2mac_dat_a_dst_data30[7:0])   //|> o
  ,.sc2mac_dat_dst_data31          (sc2mac_dat_a_dst_data31[7:0])   //|> o
  ,.sc2mac_dat_dst_data32          (sc2mac_dat_a_dst_data32[7:0])   //|> o
  ,.sc2mac_dat_dst_data33          (sc2mac_dat_a_dst_data33[7:0])   //|> o
  ,.sc2mac_dat_dst_data34          (sc2mac_dat_a_dst_data34[7:0])   //|> o
  ,.sc2mac_dat_dst_data35          (sc2mac_dat_a_dst_data35[7:0])   //|> o
  ,.sc2mac_dat_dst_data36          (sc2mac_dat_a_dst_data36[7:0])   //|> o
  ,.sc2mac_dat_dst_data37          (sc2mac_dat_a_dst_data37[7:0])   //|> o
  ,.sc2mac_dat_dst_data38          (sc2mac_dat_a_dst_data38[7:0])   //|> o
  ,.sc2mac_dat_dst_data39          (sc2mac_dat_a_dst_data39[7:0])   //|> o
  ,.sc2mac_dat_dst_data40          (sc2mac_dat_a_dst_data40[7:0])   //|> o
  ,.sc2mac_dat_dst_data41          (sc2mac_dat_a_dst_data41[7:0])   //|> o
  ,.sc2mac_dat_dst_data42          (sc2mac_dat_a_dst_data42[7:0])   //|> o
  ,.sc2mac_dat_dst_data43          (sc2mac_dat_a_dst_data43[7:0])   //|> o
  ,.sc2mac_dat_dst_data44          (sc2mac_dat_a_dst_data44[7:0])   //|> o
  ,.sc2mac_dat_dst_data45          (sc2mac_dat_a_dst_data45[7:0])   //|> o
  ,.sc2mac_dat_dst_data46          (sc2mac_dat_a_dst_data46[7:0])   //|> o
  ,.sc2mac_dat_dst_data47          (sc2mac_dat_a_dst_data47[7:0])   //|> o
  ,.sc2mac_dat_dst_data48          (sc2mac_dat_a_dst_data48[7:0])   //|> o
  ,.sc2mac_dat_dst_data49          (sc2mac_dat_a_dst_data49[7:0])   //|> o
  ,.sc2mac_dat_dst_data50          (sc2mac_dat_a_dst_data50[7:0])   //|> o
  ,.sc2mac_dat_dst_data51          (sc2mac_dat_a_dst_data51[7:0])   //|> o
  ,.sc2mac_dat_dst_data52          (sc2mac_dat_a_dst_data52[7:0])   //|> o
  ,.sc2mac_dat_dst_data53          (sc2mac_dat_a_dst_data53[7:0])   //|> o
  ,.sc2mac_dat_dst_data54          (sc2mac_dat_a_dst_data54[7:0])   //|> o
  ,.sc2mac_dat_dst_data55          (sc2mac_dat_a_dst_data55[7:0])   //|> o
  ,.sc2mac_dat_dst_data56          (sc2mac_dat_a_dst_data56[7:0])   //|> o
  ,.sc2mac_dat_dst_data57          (sc2mac_dat_a_dst_data57[7:0])   //|> o
  ,.sc2mac_dat_dst_data58          (sc2mac_dat_a_dst_data58[7:0])   //|> o
  ,.sc2mac_dat_dst_data59          (sc2mac_dat_a_dst_data59[7:0])   //|> o
  ,.sc2mac_dat_dst_data60          (sc2mac_dat_a_dst_data60[7:0])   //|> o
  ,.sc2mac_dat_dst_data61          (sc2mac_dat_a_dst_data61[7:0])   //|> o
  ,.sc2mac_dat_dst_data62          (sc2mac_dat_a_dst_data62[7:0])   //|> o
  ,.sc2mac_dat_dst_data63          (sc2mac_dat_a_dst_data63[7:0])   //|> o
  ,.sc2mac_dat_dst_data64          (sc2mac_dat_a_dst_data64[7:0])   //|> o
  ,.sc2mac_dat_dst_data65          (sc2mac_dat_a_dst_data65[7:0])   //|> o
  ,.sc2mac_dat_dst_data66          (sc2mac_dat_a_dst_data66[7:0])   //|> o
  ,.sc2mac_dat_dst_data67          (sc2mac_dat_a_dst_data67[7:0])   //|> o
  ,.sc2mac_dat_dst_data68          (sc2mac_dat_a_dst_data68[7:0])   //|> o
  ,.sc2mac_dat_dst_data69          (sc2mac_dat_a_dst_data69[7:0])   //|> o
  ,.sc2mac_dat_dst_data70          (sc2mac_dat_a_dst_data70[7:0])   //|> o
  ,.sc2mac_dat_dst_data71          (sc2mac_dat_a_dst_data71[7:0])   //|> o
  ,.sc2mac_dat_dst_data72          (sc2mac_dat_a_dst_data72[7:0])   //|> o
  ,.sc2mac_dat_dst_data73          (sc2mac_dat_a_dst_data73[7:0])   //|> o
  ,.sc2mac_dat_dst_data74          (sc2mac_dat_a_dst_data74[7:0])   //|> o
  ,.sc2mac_dat_dst_data75          (sc2mac_dat_a_dst_data75[7:0])   //|> o
  ,.sc2mac_dat_dst_data76          (sc2mac_dat_a_dst_data76[7:0])   //|> o
  ,.sc2mac_dat_dst_data77          (sc2mac_dat_a_dst_data77[7:0])   //|> o
  ,.sc2mac_dat_dst_data78          (sc2mac_dat_a_dst_data78[7:0])   //|> o
  ,.sc2mac_dat_dst_data79          (sc2mac_dat_a_dst_data79[7:0])   //|> o
  ,.sc2mac_dat_dst_data80          (sc2mac_dat_a_dst_data80[7:0])   //|> o
  ,.sc2mac_dat_dst_data81          (sc2mac_dat_a_dst_data81[7:0])   //|> o
  ,.sc2mac_dat_dst_data82          (sc2mac_dat_a_dst_data82[7:0])   //|> o
  ,.sc2mac_dat_dst_data83          (sc2mac_dat_a_dst_data83[7:0])   //|> o
  ,.sc2mac_dat_dst_data84          (sc2mac_dat_a_dst_data84[7:0])   //|> o
  ,.sc2mac_dat_dst_data85          (sc2mac_dat_a_dst_data85[7:0])   //|> o
  ,.sc2mac_dat_dst_data86          (sc2mac_dat_a_dst_data86[7:0])   //|> o
  ,.sc2mac_dat_dst_data87          (sc2mac_dat_a_dst_data87[7:0])   //|> o
  ,.sc2mac_dat_dst_data88          (sc2mac_dat_a_dst_data88[7:0])   //|> o
  ,.sc2mac_dat_dst_data89          (sc2mac_dat_a_dst_data89[7:0])   //|> o
  ,.sc2mac_dat_dst_data90          (sc2mac_dat_a_dst_data90[7:0])   //|> o
  ,.sc2mac_dat_dst_data91          (sc2mac_dat_a_dst_data91[7:0])   //|> o
  ,.sc2mac_dat_dst_data92          (sc2mac_dat_a_dst_data92[7:0])   //|> o
  ,.sc2mac_dat_dst_data93          (sc2mac_dat_a_dst_data93[7:0])   //|> o
  ,.sc2mac_dat_dst_data94          (sc2mac_dat_a_dst_data94[7:0])   //|> o
  ,.sc2mac_dat_dst_data95          (sc2mac_dat_a_dst_data95[7:0])   //|> o
  ,.sc2mac_dat_dst_data96          (sc2mac_dat_a_dst_data96[7:0])   //|> o
  ,.sc2mac_dat_dst_data97          (sc2mac_dat_a_dst_data97[7:0])   //|> o
  ,.sc2mac_dat_dst_data98          (sc2mac_dat_a_dst_data98[7:0])   //|> o
  ,.sc2mac_dat_dst_data99          (sc2mac_dat_a_dst_data99[7:0])   //|> o
  ,.sc2mac_dat_dst_data100         (sc2mac_dat_a_dst_data100[7:0])  //|> o
  ,.sc2mac_dat_dst_data101         (sc2mac_dat_a_dst_data101[7:0])  //|> o
  ,.sc2mac_dat_dst_data102         (sc2mac_dat_a_dst_data102[7:0])  //|> o
  ,.sc2mac_dat_dst_data103         (sc2mac_dat_a_dst_data103[7:0])  //|> o
  ,.sc2mac_dat_dst_data104         (sc2mac_dat_a_dst_data104[7:0])  //|> o
  ,.sc2mac_dat_dst_data105         (sc2mac_dat_a_dst_data105[7:0])  //|> o
  ,.sc2mac_dat_dst_data106         (sc2mac_dat_a_dst_data106[7:0])  //|> o
  ,.sc2mac_dat_dst_data107         (sc2mac_dat_a_dst_data107[7:0])  //|> o
  ,.sc2mac_dat_dst_data108         (sc2mac_dat_a_dst_data108[7:0])  //|> o
  ,.sc2mac_dat_dst_data109         (sc2mac_dat_a_dst_data109[7:0])  //|> o
  ,.sc2mac_dat_dst_data110         (sc2mac_dat_a_dst_data110[7:0])  //|> o
  ,.sc2mac_dat_dst_data111         (sc2mac_dat_a_dst_data111[7:0])  //|> o
  ,.sc2mac_dat_dst_data112         (sc2mac_dat_a_dst_data112[7:0])  //|> o
  ,.sc2mac_dat_dst_data113         (sc2mac_dat_a_dst_data113[7:0])  //|> o
  ,.sc2mac_dat_dst_data114         (sc2mac_dat_a_dst_data114[7:0])  //|> o
  ,.sc2mac_dat_dst_data115         (sc2mac_dat_a_dst_data115[7:0])  //|> o
  ,.sc2mac_dat_dst_data116         (sc2mac_dat_a_dst_data116[7:0])  //|> o
  ,.sc2mac_dat_dst_data117         (sc2mac_dat_a_dst_data117[7:0])  //|> o
  ,.sc2mac_dat_dst_data118         (sc2mac_dat_a_dst_data118[7:0])  //|> o
  ,.sc2mac_dat_dst_data119         (sc2mac_dat_a_dst_data119[7:0])  //|> o
  ,.sc2mac_dat_dst_data120         (sc2mac_dat_a_dst_data120[7:0])  //|> o
  ,.sc2mac_dat_dst_data121         (sc2mac_dat_a_dst_data121[7:0])  //|> o
  ,.sc2mac_dat_dst_data122         (sc2mac_dat_a_dst_data122[7:0])  //|> o
  ,.sc2mac_dat_dst_data123         (sc2mac_dat_a_dst_data123[7:0])  //|> o
  ,.sc2mac_dat_dst_data124         (sc2mac_dat_a_dst_data124[7:0])  //|> o
  ,.sc2mac_dat_dst_data125         (sc2mac_dat_a_dst_data125[7:0])  //|> o
  ,.sc2mac_dat_dst_data126         (sc2mac_dat_a_dst_data126[7:0])  //|> o
  ,.sc2mac_dat_dst_data127         (sc2mac_dat_a_dst_data127[7:0])  //|> o
  ,.sc2mac_dat_dst_pd              (sc2mac_dat_a_dst_pd[8:0])       //|> o
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    Retiming path csb<->cmac_a                  //
////////////////////////////////////////////////////////////////////////
NV_NVDLA_RT_csb2cmac u_NV_NVDLA_RT_csb2cmac (
   .nvdla_core_clk                 (nvdla_core_clk)                 //|< i
  ,.nvdla_core_rstn                (nvdla_core_rstn)                //|< o
  ,.csb2cmac_req_src_pvld          (csb2cmac_a_req_src_pvld)        //|< w
  ,.csb2cmac_req_src_prdy          (csb2cmac_a_req_src_prdy)        //|> w
  ,.csb2cmac_req_src_pd            (csb2cmac_a_req_src_pd[62:0])    //|< w
  ,.cmac2csb_resp_src_valid        (cmac_a2csb_resp_src_valid)      //|< i
  ,.cmac2csb_resp_src_pd           (cmac_a2csb_resp_src_pd[33:0])   //|< i
  ,.csb2cmac_req_dst_pvld          (csb2cmac_a_req_dst_pvld)        //|> o
  ,.csb2cmac_req_dst_prdy          (csb2cmac_a_req_dst_prdy)        //|< i
  ,.csb2cmac_req_dst_pd            (csb2cmac_a_req_dst_pd[62:0])    //|> o
  ,.cmac2csb_resp_dst_valid        (cmac_a2csb_resp_dst_valid)      //|> w
  ,.cmac2csb_resp_dst_pd           (cmac_a2csb_resp_dst_pd[33:0])   //|> w
  );

////////////////////////////////////////////////////////////////////////
//  NVDLA Partition O:    OBS                                         //
////////////////////////////////////////////////////////////////////////
//&Instance NV_NVDLA_O_obs u_obs;

////////////////////////////////////////////////////////////////////////
//  Dangles/Contenders report                                         //
////////////////////////////////////////////////////////////////////////

//|
//|
//|
//|

endmodule // NV_NVDLA_partition_o


