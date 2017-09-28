// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_csc.v

module NV_NVDLA_csc (
   accu2sc_credit_size           //|< i
  ,accu2sc_credit_vld            //|< i
  ,cdma2sc_dat_entries           //|< i
  ,cdma2sc_dat_pending_ack       //|< i
  ,cdma2sc_dat_slices            //|< i
  ,cdma2sc_dat_updt              //|< i
  ,cdma2sc_wmb_entries           //|< i
  ,cdma2sc_wt_entries            //|< i
  ,cdma2sc_wt_kernels            //|< i
  ,cdma2sc_wt_pending_ack        //|< i
  ,cdma2sc_wt_updt               //|< i
  ,csb2csc_req_pd                //|< i
  ,csb2csc_req_pvld              //|< i
  ,dla_clk_ovr_on_sync           //|< i
  ,global_clk_ovr_on_sync        //|< i
  ,nvdla_core_clk                //|< i
  ,nvdla_core_rstn               //|< i
  ,pwrbus_ram_pd                 //|< i
  ,sc2buf_dat_rd_data            //|< i
  ,sc2buf_dat_rd_valid           //|< i
  ,sc2buf_wmb_rd_data            //|< i
  ,sc2buf_wmb_rd_valid           //|< i
  ,sc2buf_wt_rd_data             //|< i
  ,sc2buf_wt_rd_valid            //|< i
  ,tmc2slcg_disable_clock_gating //|< i
  ,csb2csc_req_prdy              //|> o
  ,csc2csb_resp_pd               //|> o
  ,csc2csb_resp_valid            //|> o
  ,sc2buf_dat_rd_addr            //|> o
  ,sc2buf_dat_rd_en              //|> o
  ,sc2buf_wmb_rd_addr            //|> o
  ,sc2buf_wmb_rd_en              //|> o
  ,sc2buf_wt_rd_addr             //|> o
  ,sc2buf_wt_rd_en               //|> o
  ,sc2cdma_dat_entries           //|> o
  ,sc2cdma_dat_pending_req       //|> o
  ,sc2cdma_dat_slices            //|> o
  ,sc2cdma_dat_updt              //|> o
  ,sc2cdma_wmb_entries           //|> o
  ,sc2cdma_wt_entries            //|> o
  ,sc2cdma_wt_kernels            //|> o
  ,sc2cdma_wt_pending_req        //|> o
  ,sc2cdma_wt_updt               //|> o
  ,sc2mac_dat_a_data0            //|> o
  ,sc2mac_dat_a_data1            //|> o
  ,sc2mac_dat_a_data10           //|> o
  ,sc2mac_dat_a_data100          //|> o
  ,sc2mac_dat_a_data101          //|> o
  ,sc2mac_dat_a_data102          //|> o
  ,sc2mac_dat_a_data103          //|> o
  ,sc2mac_dat_a_data104          //|> o
  ,sc2mac_dat_a_data105          //|> o
  ,sc2mac_dat_a_data106          //|> o
  ,sc2mac_dat_a_data107          //|> o
  ,sc2mac_dat_a_data108          //|> o
  ,sc2mac_dat_a_data109          //|> o
  ,sc2mac_dat_a_data11           //|> o
  ,sc2mac_dat_a_data110          //|> o
  ,sc2mac_dat_a_data111          //|> o
  ,sc2mac_dat_a_data112          //|> o
  ,sc2mac_dat_a_data113          //|> o
  ,sc2mac_dat_a_data114          //|> o
  ,sc2mac_dat_a_data115          //|> o
  ,sc2mac_dat_a_data116          //|> o
  ,sc2mac_dat_a_data117          //|> o
  ,sc2mac_dat_a_data118          //|> o
  ,sc2mac_dat_a_data119          //|> o
  ,sc2mac_dat_a_data12           //|> o
  ,sc2mac_dat_a_data120          //|> o
  ,sc2mac_dat_a_data121          //|> o
  ,sc2mac_dat_a_data122          //|> o
  ,sc2mac_dat_a_data123          //|> o
  ,sc2mac_dat_a_data124          //|> o
  ,sc2mac_dat_a_data125          //|> o
  ,sc2mac_dat_a_data126          //|> o
  ,sc2mac_dat_a_data127          //|> o
  ,sc2mac_dat_a_data13           //|> o
  ,sc2mac_dat_a_data14           //|> o
  ,sc2mac_dat_a_data15           //|> o
  ,sc2mac_dat_a_data16           //|> o
  ,sc2mac_dat_a_data17           //|> o
  ,sc2mac_dat_a_data18           //|> o
  ,sc2mac_dat_a_data19           //|> o
  ,sc2mac_dat_a_data2            //|> o
  ,sc2mac_dat_a_data20           //|> o
  ,sc2mac_dat_a_data21           //|> o
  ,sc2mac_dat_a_data22           //|> o
  ,sc2mac_dat_a_data23           //|> o
  ,sc2mac_dat_a_data24           //|> o
  ,sc2mac_dat_a_data25           //|> o
  ,sc2mac_dat_a_data26           //|> o
  ,sc2mac_dat_a_data27           //|> o
  ,sc2mac_dat_a_data28           //|> o
  ,sc2mac_dat_a_data29           //|> o
  ,sc2mac_dat_a_data3            //|> o
  ,sc2mac_dat_a_data30           //|> o
  ,sc2mac_dat_a_data31           //|> o
  ,sc2mac_dat_a_data32           //|> o
  ,sc2mac_dat_a_data33           //|> o
  ,sc2mac_dat_a_data34           //|> o
  ,sc2mac_dat_a_data35           //|> o
  ,sc2mac_dat_a_data36           //|> o
  ,sc2mac_dat_a_data37           //|> o
  ,sc2mac_dat_a_data38           //|> o
  ,sc2mac_dat_a_data39           //|> o
  ,sc2mac_dat_a_data4            //|> o
  ,sc2mac_dat_a_data40           //|> o
  ,sc2mac_dat_a_data41           //|> o
  ,sc2mac_dat_a_data42           //|> o
  ,sc2mac_dat_a_data43           //|> o
  ,sc2mac_dat_a_data44           //|> o
  ,sc2mac_dat_a_data45           //|> o
  ,sc2mac_dat_a_data46           //|> o
  ,sc2mac_dat_a_data47           //|> o
  ,sc2mac_dat_a_data48           //|> o
  ,sc2mac_dat_a_data49           //|> o
  ,sc2mac_dat_a_data5            //|> o
  ,sc2mac_dat_a_data50           //|> o
  ,sc2mac_dat_a_data51           //|> o
  ,sc2mac_dat_a_data52           //|> o
  ,sc2mac_dat_a_data53           //|> o
  ,sc2mac_dat_a_data54           //|> o
  ,sc2mac_dat_a_data55           //|> o
  ,sc2mac_dat_a_data56           //|> o
  ,sc2mac_dat_a_data57           //|> o
  ,sc2mac_dat_a_data58           //|> o
  ,sc2mac_dat_a_data59           //|> o
  ,sc2mac_dat_a_data6            //|> o
  ,sc2mac_dat_a_data60           //|> o
  ,sc2mac_dat_a_data61           //|> o
  ,sc2mac_dat_a_data62           //|> o
  ,sc2mac_dat_a_data63           //|> o
  ,sc2mac_dat_a_data64           //|> o
  ,sc2mac_dat_a_data65           //|> o
  ,sc2mac_dat_a_data66           //|> o
  ,sc2mac_dat_a_data67           //|> o
  ,sc2mac_dat_a_data68           //|> o
  ,sc2mac_dat_a_data69           //|> o
  ,sc2mac_dat_a_data7            //|> o
  ,sc2mac_dat_a_data70           //|> o
  ,sc2mac_dat_a_data71           //|> o
  ,sc2mac_dat_a_data72           //|> o
  ,sc2mac_dat_a_data73           //|> o
  ,sc2mac_dat_a_data74           //|> o
  ,sc2mac_dat_a_data75           //|> o
  ,sc2mac_dat_a_data76           //|> o
  ,sc2mac_dat_a_data77           //|> o
  ,sc2mac_dat_a_data78           //|> o
  ,sc2mac_dat_a_data79           //|> o
  ,sc2mac_dat_a_data8            //|> o
  ,sc2mac_dat_a_data80           //|> o
  ,sc2mac_dat_a_data81           //|> o
  ,sc2mac_dat_a_data82           //|> o
  ,sc2mac_dat_a_data83           //|> o
  ,sc2mac_dat_a_data84           //|> o
  ,sc2mac_dat_a_data85           //|> o
  ,sc2mac_dat_a_data86           //|> o
  ,sc2mac_dat_a_data87           //|> o
  ,sc2mac_dat_a_data88           //|> o
  ,sc2mac_dat_a_data89           //|> o
  ,sc2mac_dat_a_data9            //|> o
  ,sc2mac_dat_a_data90           //|> o
  ,sc2mac_dat_a_data91           //|> o
  ,sc2mac_dat_a_data92           //|> o
  ,sc2mac_dat_a_data93           //|> o
  ,sc2mac_dat_a_data94           //|> o
  ,sc2mac_dat_a_data95           //|> o
  ,sc2mac_dat_a_data96           //|> o
  ,sc2mac_dat_a_data97           //|> o
  ,sc2mac_dat_a_data98           //|> o
  ,sc2mac_dat_a_data99           //|> o
  ,sc2mac_dat_a_mask             //|> o
  ,sc2mac_dat_a_pd               //|> o
  ,sc2mac_dat_a_pvld             //|> o
  ,sc2mac_dat_b_data0            //|> o
  ,sc2mac_dat_b_data1            //|> o
  ,sc2mac_dat_b_data10           //|> o
  ,sc2mac_dat_b_data100          //|> o
  ,sc2mac_dat_b_data101          //|> o
  ,sc2mac_dat_b_data102          //|> o
  ,sc2mac_dat_b_data103          //|> o
  ,sc2mac_dat_b_data104          //|> o
  ,sc2mac_dat_b_data105          //|> o
  ,sc2mac_dat_b_data106          //|> o
  ,sc2mac_dat_b_data107          //|> o
  ,sc2mac_dat_b_data108          //|> o
  ,sc2mac_dat_b_data109          //|> o
  ,sc2mac_dat_b_data11           //|> o
  ,sc2mac_dat_b_data110          //|> o
  ,sc2mac_dat_b_data111          //|> o
  ,sc2mac_dat_b_data112          //|> o
  ,sc2mac_dat_b_data113          //|> o
  ,sc2mac_dat_b_data114          //|> o
  ,sc2mac_dat_b_data115          //|> o
  ,sc2mac_dat_b_data116          //|> o
  ,sc2mac_dat_b_data117          //|> o
  ,sc2mac_dat_b_data118          //|> o
  ,sc2mac_dat_b_data119          //|> o
  ,sc2mac_dat_b_data12           //|> o
  ,sc2mac_dat_b_data120          //|> o
  ,sc2mac_dat_b_data121          //|> o
  ,sc2mac_dat_b_data122          //|> o
  ,sc2mac_dat_b_data123          //|> o
  ,sc2mac_dat_b_data124          //|> o
  ,sc2mac_dat_b_data125          //|> o
  ,sc2mac_dat_b_data126          //|> o
  ,sc2mac_dat_b_data127          //|> o
  ,sc2mac_dat_b_data13           //|> o
  ,sc2mac_dat_b_data14           //|> o
  ,sc2mac_dat_b_data15           //|> o
  ,sc2mac_dat_b_data16           //|> o
  ,sc2mac_dat_b_data17           //|> o
  ,sc2mac_dat_b_data18           //|> o
  ,sc2mac_dat_b_data19           //|> o
  ,sc2mac_dat_b_data2            //|> o
  ,sc2mac_dat_b_data20           //|> o
  ,sc2mac_dat_b_data21           //|> o
  ,sc2mac_dat_b_data22           //|> o
  ,sc2mac_dat_b_data23           //|> o
  ,sc2mac_dat_b_data24           //|> o
  ,sc2mac_dat_b_data25           //|> o
  ,sc2mac_dat_b_data26           //|> o
  ,sc2mac_dat_b_data27           //|> o
  ,sc2mac_dat_b_data28           //|> o
  ,sc2mac_dat_b_data29           //|> o
  ,sc2mac_dat_b_data3            //|> o
  ,sc2mac_dat_b_data30           //|> o
  ,sc2mac_dat_b_data31           //|> o
  ,sc2mac_dat_b_data32           //|> o
  ,sc2mac_dat_b_data33           //|> o
  ,sc2mac_dat_b_data34           //|> o
  ,sc2mac_dat_b_data35           //|> o
  ,sc2mac_dat_b_data36           //|> o
  ,sc2mac_dat_b_data37           //|> o
  ,sc2mac_dat_b_data38           //|> o
  ,sc2mac_dat_b_data39           //|> o
  ,sc2mac_dat_b_data4            //|> o
  ,sc2mac_dat_b_data40           //|> o
  ,sc2mac_dat_b_data41           //|> o
  ,sc2mac_dat_b_data42           //|> o
  ,sc2mac_dat_b_data43           //|> o
  ,sc2mac_dat_b_data44           //|> o
  ,sc2mac_dat_b_data45           //|> o
  ,sc2mac_dat_b_data46           //|> o
  ,sc2mac_dat_b_data47           //|> o
  ,sc2mac_dat_b_data48           //|> o
  ,sc2mac_dat_b_data49           //|> o
  ,sc2mac_dat_b_data5            //|> o
  ,sc2mac_dat_b_data50           //|> o
  ,sc2mac_dat_b_data51           //|> o
  ,sc2mac_dat_b_data52           //|> o
  ,sc2mac_dat_b_data53           //|> o
  ,sc2mac_dat_b_data54           //|> o
  ,sc2mac_dat_b_data55           //|> o
  ,sc2mac_dat_b_data56           //|> o
  ,sc2mac_dat_b_data57           //|> o
  ,sc2mac_dat_b_data58           //|> o
  ,sc2mac_dat_b_data59           //|> o
  ,sc2mac_dat_b_data6            //|> o
  ,sc2mac_dat_b_data60           //|> o
  ,sc2mac_dat_b_data61           //|> o
  ,sc2mac_dat_b_data62           //|> o
  ,sc2mac_dat_b_data63           //|> o
  ,sc2mac_dat_b_data64           //|> o
  ,sc2mac_dat_b_data65           //|> o
  ,sc2mac_dat_b_data66           //|> o
  ,sc2mac_dat_b_data67           //|> o
  ,sc2mac_dat_b_data68           //|> o
  ,sc2mac_dat_b_data69           //|> o
  ,sc2mac_dat_b_data7            //|> o
  ,sc2mac_dat_b_data70           //|> o
  ,sc2mac_dat_b_data71           //|> o
  ,sc2mac_dat_b_data72           //|> o
  ,sc2mac_dat_b_data73           //|> o
  ,sc2mac_dat_b_data74           //|> o
  ,sc2mac_dat_b_data75           //|> o
  ,sc2mac_dat_b_data76           //|> o
  ,sc2mac_dat_b_data77           //|> o
  ,sc2mac_dat_b_data78           //|> o
  ,sc2mac_dat_b_data79           //|> o
  ,sc2mac_dat_b_data8            //|> o
  ,sc2mac_dat_b_data80           //|> o
  ,sc2mac_dat_b_data81           //|> o
  ,sc2mac_dat_b_data82           //|> o
  ,sc2mac_dat_b_data83           //|> o
  ,sc2mac_dat_b_data84           //|> o
  ,sc2mac_dat_b_data85           //|> o
  ,sc2mac_dat_b_data86           //|> o
  ,sc2mac_dat_b_data87           //|> o
  ,sc2mac_dat_b_data88           //|> o
  ,sc2mac_dat_b_data89           //|> o
  ,sc2mac_dat_b_data9            //|> o
  ,sc2mac_dat_b_data90           //|> o
  ,sc2mac_dat_b_data91           //|> o
  ,sc2mac_dat_b_data92           //|> o
  ,sc2mac_dat_b_data93           //|> o
  ,sc2mac_dat_b_data94           //|> o
  ,sc2mac_dat_b_data95           //|> o
  ,sc2mac_dat_b_data96           //|> o
  ,sc2mac_dat_b_data97           //|> o
  ,sc2mac_dat_b_data98           //|> o
  ,sc2mac_dat_b_data99           //|> o
  ,sc2mac_dat_b_mask             //|> o
  ,sc2mac_dat_b_pd               //|> o
  ,sc2mac_dat_b_pvld             //|> o
  ,sc2mac_wt_a_data0             //|> o
  ,sc2mac_wt_a_data1             //|> o
  ,sc2mac_wt_a_data10            //|> o
  ,sc2mac_wt_a_data100           //|> o
  ,sc2mac_wt_a_data101           //|> o
  ,sc2mac_wt_a_data102           //|> o
  ,sc2mac_wt_a_data103           //|> o
  ,sc2mac_wt_a_data104           //|> o
  ,sc2mac_wt_a_data105           //|> o
  ,sc2mac_wt_a_data106           //|> o
  ,sc2mac_wt_a_data107           //|> o
  ,sc2mac_wt_a_data108           //|> o
  ,sc2mac_wt_a_data109           //|> o
  ,sc2mac_wt_a_data11            //|> o
  ,sc2mac_wt_a_data110           //|> o
  ,sc2mac_wt_a_data111           //|> o
  ,sc2mac_wt_a_data112           //|> o
  ,sc2mac_wt_a_data113           //|> o
  ,sc2mac_wt_a_data114           //|> o
  ,sc2mac_wt_a_data115           //|> o
  ,sc2mac_wt_a_data116           //|> o
  ,sc2mac_wt_a_data117           //|> o
  ,sc2mac_wt_a_data118           //|> o
  ,sc2mac_wt_a_data119           //|> o
  ,sc2mac_wt_a_data12            //|> o
  ,sc2mac_wt_a_data120           //|> o
  ,sc2mac_wt_a_data121           //|> o
  ,sc2mac_wt_a_data122           //|> o
  ,sc2mac_wt_a_data123           //|> o
  ,sc2mac_wt_a_data124           //|> o
  ,sc2mac_wt_a_data125           //|> o
  ,sc2mac_wt_a_data126           //|> o
  ,sc2mac_wt_a_data127           //|> o
  ,sc2mac_wt_a_data13            //|> o
  ,sc2mac_wt_a_data14            //|> o
  ,sc2mac_wt_a_data15            //|> o
  ,sc2mac_wt_a_data16            //|> o
  ,sc2mac_wt_a_data17            //|> o
  ,sc2mac_wt_a_data18            //|> o
  ,sc2mac_wt_a_data19            //|> o
  ,sc2mac_wt_a_data2             //|> o
  ,sc2mac_wt_a_data20            //|> o
  ,sc2mac_wt_a_data21            //|> o
  ,sc2mac_wt_a_data22            //|> o
  ,sc2mac_wt_a_data23            //|> o
  ,sc2mac_wt_a_data24            //|> o
  ,sc2mac_wt_a_data25            //|> o
  ,sc2mac_wt_a_data26            //|> o
  ,sc2mac_wt_a_data27            //|> o
  ,sc2mac_wt_a_data28            //|> o
  ,sc2mac_wt_a_data29            //|> o
  ,sc2mac_wt_a_data3             //|> o
  ,sc2mac_wt_a_data30            //|> o
  ,sc2mac_wt_a_data31            //|> o
  ,sc2mac_wt_a_data32            //|> o
  ,sc2mac_wt_a_data33            //|> o
  ,sc2mac_wt_a_data34            //|> o
  ,sc2mac_wt_a_data35            //|> o
  ,sc2mac_wt_a_data36            //|> o
  ,sc2mac_wt_a_data37            //|> o
  ,sc2mac_wt_a_data38            //|> o
  ,sc2mac_wt_a_data39            //|> o
  ,sc2mac_wt_a_data4             //|> o
  ,sc2mac_wt_a_data40            //|> o
  ,sc2mac_wt_a_data41            //|> o
  ,sc2mac_wt_a_data42            //|> o
  ,sc2mac_wt_a_data43            //|> o
  ,sc2mac_wt_a_data44            //|> o
  ,sc2mac_wt_a_data45            //|> o
  ,sc2mac_wt_a_data46            //|> o
  ,sc2mac_wt_a_data47            //|> o
  ,sc2mac_wt_a_data48            //|> o
  ,sc2mac_wt_a_data49            //|> o
  ,sc2mac_wt_a_data5             //|> o
  ,sc2mac_wt_a_data50            //|> o
  ,sc2mac_wt_a_data51            //|> o
  ,sc2mac_wt_a_data52            //|> o
  ,sc2mac_wt_a_data53            //|> o
  ,sc2mac_wt_a_data54            //|> o
  ,sc2mac_wt_a_data55            //|> o
  ,sc2mac_wt_a_data56            //|> o
  ,sc2mac_wt_a_data57            //|> o
  ,sc2mac_wt_a_data58            //|> o
  ,sc2mac_wt_a_data59            //|> o
  ,sc2mac_wt_a_data6             //|> o
  ,sc2mac_wt_a_data60            //|> o
  ,sc2mac_wt_a_data61            //|> o
  ,sc2mac_wt_a_data62            //|> o
  ,sc2mac_wt_a_data63            //|> o
  ,sc2mac_wt_a_data64            //|> o
  ,sc2mac_wt_a_data65            //|> o
  ,sc2mac_wt_a_data66            //|> o
  ,sc2mac_wt_a_data67            //|> o
  ,sc2mac_wt_a_data68            //|> o
  ,sc2mac_wt_a_data69            //|> o
  ,sc2mac_wt_a_data7             //|> o
  ,sc2mac_wt_a_data70            //|> o
  ,sc2mac_wt_a_data71            //|> o
  ,sc2mac_wt_a_data72            //|> o
  ,sc2mac_wt_a_data73            //|> o
  ,sc2mac_wt_a_data74            //|> o
  ,sc2mac_wt_a_data75            //|> o
  ,sc2mac_wt_a_data76            //|> o
  ,sc2mac_wt_a_data77            //|> o
  ,sc2mac_wt_a_data78            //|> o
  ,sc2mac_wt_a_data79            //|> o
  ,sc2mac_wt_a_data8             //|> o
  ,sc2mac_wt_a_data80            //|> o
  ,sc2mac_wt_a_data81            //|> o
  ,sc2mac_wt_a_data82            //|> o
  ,sc2mac_wt_a_data83            //|> o
  ,sc2mac_wt_a_data84            //|> o
  ,sc2mac_wt_a_data85            //|> o
  ,sc2mac_wt_a_data86            //|> o
  ,sc2mac_wt_a_data87            //|> o
  ,sc2mac_wt_a_data88            //|> o
  ,sc2mac_wt_a_data89            //|> o
  ,sc2mac_wt_a_data9             //|> o
  ,sc2mac_wt_a_data90            //|> o
  ,sc2mac_wt_a_data91            //|> o
  ,sc2mac_wt_a_data92            //|> o
  ,sc2mac_wt_a_data93            //|> o
  ,sc2mac_wt_a_data94            //|> o
  ,sc2mac_wt_a_data95            //|> o
  ,sc2mac_wt_a_data96            //|> o
  ,sc2mac_wt_a_data97            //|> o
  ,sc2mac_wt_a_data98            //|> o
  ,sc2mac_wt_a_data99            //|> o
  ,sc2mac_wt_a_mask              //|> o
  ,sc2mac_wt_a_pvld              //|> o
  ,sc2mac_wt_a_sel               //|> o
  ,sc2mac_wt_b_data0             //|> o
  ,sc2mac_wt_b_data1             //|> o
  ,sc2mac_wt_b_data10            //|> o
  ,sc2mac_wt_b_data100           //|> o
  ,sc2mac_wt_b_data101           //|> o
  ,sc2mac_wt_b_data102           //|> o
  ,sc2mac_wt_b_data103           //|> o
  ,sc2mac_wt_b_data104           //|> o
  ,sc2mac_wt_b_data105           //|> o
  ,sc2mac_wt_b_data106           //|> o
  ,sc2mac_wt_b_data107           //|> o
  ,sc2mac_wt_b_data108           //|> o
  ,sc2mac_wt_b_data109           //|> o
  ,sc2mac_wt_b_data11            //|> o
  ,sc2mac_wt_b_data110           //|> o
  ,sc2mac_wt_b_data111           //|> o
  ,sc2mac_wt_b_data112           //|> o
  ,sc2mac_wt_b_data113           //|> o
  ,sc2mac_wt_b_data114           //|> o
  ,sc2mac_wt_b_data115           //|> o
  ,sc2mac_wt_b_data116           //|> o
  ,sc2mac_wt_b_data117           //|> o
  ,sc2mac_wt_b_data118           //|> o
  ,sc2mac_wt_b_data119           //|> o
  ,sc2mac_wt_b_data12            //|> o
  ,sc2mac_wt_b_data120           //|> o
  ,sc2mac_wt_b_data121           //|> o
  ,sc2mac_wt_b_data122           //|> o
  ,sc2mac_wt_b_data123           //|> o
  ,sc2mac_wt_b_data124           //|> o
  ,sc2mac_wt_b_data125           //|> o
  ,sc2mac_wt_b_data126           //|> o
  ,sc2mac_wt_b_data127           //|> o
  ,sc2mac_wt_b_data13            //|> o
  ,sc2mac_wt_b_data14            //|> o
  ,sc2mac_wt_b_data15            //|> o
  ,sc2mac_wt_b_data16            //|> o
  ,sc2mac_wt_b_data17            //|> o
  ,sc2mac_wt_b_data18            //|> o
  ,sc2mac_wt_b_data19            //|> o
  ,sc2mac_wt_b_data2             //|> o
  ,sc2mac_wt_b_data20            //|> o
  ,sc2mac_wt_b_data21            //|> o
  ,sc2mac_wt_b_data22            //|> o
  ,sc2mac_wt_b_data23            //|> o
  ,sc2mac_wt_b_data24            //|> o
  ,sc2mac_wt_b_data25            //|> o
  ,sc2mac_wt_b_data26            //|> o
  ,sc2mac_wt_b_data27            //|> o
  ,sc2mac_wt_b_data28            //|> o
  ,sc2mac_wt_b_data29            //|> o
  ,sc2mac_wt_b_data3             //|> o
  ,sc2mac_wt_b_data30            //|> o
  ,sc2mac_wt_b_data31            //|> o
  ,sc2mac_wt_b_data32            //|> o
  ,sc2mac_wt_b_data33            //|> o
  ,sc2mac_wt_b_data34            //|> o
  ,sc2mac_wt_b_data35            //|> o
  ,sc2mac_wt_b_data36            //|> o
  ,sc2mac_wt_b_data37            //|> o
  ,sc2mac_wt_b_data38            //|> o
  ,sc2mac_wt_b_data39            //|> o
  ,sc2mac_wt_b_data4             //|> o
  ,sc2mac_wt_b_data40            //|> o
  ,sc2mac_wt_b_data41            //|> o
  ,sc2mac_wt_b_data42            //|> o
  ,sc2mac_wt_b_data43            //|> o
  ,sc2mac_wt_b_data44            //|> o
  ,sc2mac_wt_b_data45            //|> o
  ,sc2mac_wt_b_data46            //|> o
  ,sc2mac_wt_b_data47            //|> o
  ,sc2mac_wt_b_data48            //|> o
  ,sc2mac_wt_b_data49            //|> o
  ,sc2mac_wt_b_data5             //|> o
  ,sc2mac_wt_b_data50            //|> o
  ,sc2mac_wt_b_data51            //|> o
  ,sc2mac_wt_b_data52            //|> o
  ,sc2mac_wt_b_data53            //|> o
  ,sc2mac_wt_b_data54            //|> o
  ,sc2mac_wt_b_data55            //|> o
  ,sc2mac_wt_b_data56            //|> o
  ,sc2mac_wt_b_data57            //|> o
  ,sc2mac_wt_b_data58            //|> o
  ,sc2mac_wt_b_data59            //|> o
  ,sc2mac_wt_b_data6             //|> o
  ,sc2mac_wt_b_data60            //|> o
  ,sc2mac_wt_b_data61            //|> o
  ,sc2mac_wt_b_data62            //|> o
  ,sc2mac_wt_b_data63            //|> o
  ,sc2mac_wt_b_data64            //|> o
  ,sc2mac_wt_b_data65            //|> o
  ,sc2mac_wt_b_data66            //|> o
  ,sc2mac_wt_b_data67            //|> o
  ,sc2mac_wt_b_data68            //|> o
  ,sc2mac_wt_b_data69            //|> o
  ,sc2mac_wt_b_data7             //|> o
  ,sc2mac_wt_b_data70            //|> o
  ,sc2mac_wt_b_data71            //|> o
  ,sc2mac_wt_b_data72            //|> o
  ,sc2mac_wt_b_data73            //|> o
  ,sc2mac_wt_b_data74            //|> o
  ,sc2mac_wt_b_data75            //|> o
  ,sc2mac_wt_b_data76            //|> o
  ,sc2mac_wt_b_data77            //|> o
  ,sc2mac_wt_b_data78            //|> o
  ,sc2mac_wt_b_data79            //|> o
  ,sc2mac_wt_b_data8             //|> o
  ,sc2mac_wt_b_data80            //|> o
  ,sc2mac_wt_b_data81            //|> o
  ,sc2mac_wt_b_data82            //|> o
  ,sc2mac_wt_b_data83            //|> o
  ,sc2mac_wt_b_data84            //|> o
  ,sc2mac_wt_b_data85            //|> o
  ,sc2mac_wt_b_data86            //|> o
  ,sc2mac_wt_b_data87            //|> o
  ,sc2mac_wt_b_data88            //|> o
  ,sc2mac_wt_b_data89            //|> o
  ,sc2mac_wt_b_data9             //|> o
  ,sc2mac_wt_b_data90            //|> o
  ,sc2mac_wt_b_data91            //|> o
  ,sc2mac_wt_b_data92            //|> o
  ,sc2mac_wt_b_data93            //|> o
  ,sc2mac_wt_b_data94            //|> o
  ,sc2mac_wt_b_data95            //|> o
  ,sc2mac_wt_b_data96            //|> o
  ,sc2mac_wt_b_data97            //|> o
  ,sc2mac_wt_b_data98            //|> o
  ,sc2mac_wt_b_data99            //|> o
  ,sc2mac_wt_b_mask              //|> o
  ,sc2mac_wt_b_pvld              //|> o
  ,sc2mac_wt_b_sel               //|> o
  );

//
// NV_NVDLA_csc_ports.v
//
input  nvdla_core_clk;   /* sc2cdma_dat_pending, sc2cdma_wt_pending, accu2sc_credit, cdma2sc_dat_pending, cdma2sc_wt_pending, csb2csc_req, csc2csb_resp, dat_up_cdma2sc, dat_up_sc2cdma, sc2buf_dat_rd_nvdla_ram_addr_ADDR_WIDTH_12_BE_1, sc2buf_dat_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1, sc2buf_wmb_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, sc2buf_wmb_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1, sc2buf_wt_rd_nvdla_ram_addr_ADDR_WIDTH_12_BE_1, sc2buf_wt_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1, sc2mac_dat_a, sc2mac_dat_b, sc2mac_wt_a, sc2mac_wt_b, wt_up_cdma2sc, wt_up_sc2cdma */
input  nvdla_core_rstn;  /* sc2cdma_dat_pending, sc2cdma_wt_pending, accu2sc_credit, cdma2sc_dat_pending, cdma2sc_wt_pending, csb2csc_req, csc2csb_resp, dat_up_cdma2sc, dat_up_sc2cdma, sc2buf_dat_rd_nvdla_ram_addr_ADDR_WIDTH_12_BE_1, sc2buf_dat_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1, sc2buf_wmb_rd_nvdla_ram_addr_ADDR_WIDTH_8_BE_1, sc2buf_wmb_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1, sc2buf_wt_rd_nvdla_ram_addr_ADDR_WIDTH_12_BE_1, sc2buf_wt_rd_nvdla_ram_data_valid_DATA_WIDTH_1024_ECC_SIZE_1, sc2mac_dat_a, sc2mac_dat_b, sc2mac_wt_a, sc2mac_wt_b, wt_up_cdma2sc, wt_up_sc2cdma */

output  sc2cdma_dat_pending_req;

output  sc2cdma_wt_pending_req;

input       accu2sc_credit_vld;   /* data valid */
input [2:0] accu2sc_credit_size;

input  cdma2sc_dat_pending_ack;

input  cdma2sc_wt_pending_ack;

input         csb2csc_req_pvld;  /* data valid */
output        csb2csc_req_prdy;  /* data return handshake */
input  [62:0] csb2csc_req_pd;

output        csc2csb_resp_valid;  /* data valid */
output [33:0] csc2csb_resp_pd;     /* pkt_id_width=1 pkt_widths=33,33  */

input        cdma2sc_dat_updt;     /* data valid */
input [11:0] cdma2sc_dat_entries;
input [11:0] cdma2sc_dat_slices;

output        sc2cdma_dat_updt;     /* data valid */
output [11:0] sc2cdma_dat_entries;
output [11:0] sc2cdma_dat_slices;

input [31:0] pwrbus_ram_pd;

output        sc2buf_dat_rd_en;    /* data valid */
output [11:0] sc2buf_dat_rd_addr;

input          sc2buf_dat_rd_valid;  /* data valid */
input [1023:0] sc2buf_dat_rd_data;

output       sc2buf_wmb_rd_en;    /* data valid */
output [7:0] sc2buf_wmb_rd_addr;

input          sc2buf_wmb_rd_valid;  /* data valid */
input [1023:0] sc2buf_wmb_rd_data;

output        sc2buf_wt_rd_en;    /* data valid */
output [11:0] sc2buf_wt_rd_addr;

input          sc2buf_wt_rd_valid;  /* data valid */
input [1023:0] sc2buf_wt_rd_data;

output         sc2mac_dat_a_pvld;     /* data valid */
output [127:0] sc2mac_dat_a_mask;
output   [7:0] sc2mac_dat_a_data0;
output   [7:0] sc2mac_dat_a_data1;
output   [7:0] sc2mac_dat_a_data2;
output   [7:0] sc2mac_dat_a_data3;
output   [7:0] sc2mac_dat_a_data4;
output   [7:0] sc2mac_dat_a_data5;
output   [7:0] sc2mac_dat_a_data6;
output   [7:0] sc2mac_dat_a_data7;
output   [7:0] sc2mac_dat_a_data8;
output   [7:0] sc2mac_dat_a_data9;
output   [7:0] sc2mac_dat_a_data10;
output   [7:0] sc2mac_dat_a_data11;
output   [7:0] sc2mac_dat_a_data12;
output   [7:0] sc2mac_dat_a_data13;
output   [7:0] sc2mac_dat_a_data14;
output   [7:0] sc2mac_dat_a_data15;
output   [7:0] sc2mac_dat_a_data16;
output   [7:0] sc2mac_dat_a_data17;
output   [7:0] sc2mac_dat_a_data18;
output   [7:0] sc2mac_dat_a_data19;
output   [7:0] sc2mac_dat_a_data20;
output   [7:0] sc2mac_dat_a_data21;
output   [7:0] sc2mac_dat_a_data22;
output   [7:0] sc2mac_dat_a_data23;
output   [7:0] sc2mac_dat_a_data24;
output   [7:0] sc2mac_dat_a_data25;
output   [7:0] sc2mac_dat_a_data26;
output   [7:0] sc2mac_dat_a_data27;
output   [7:0] sc2mac_dat_a_data28;
output   [7:0] sc2mac_dat_a_data29;
output   [7:0] sc2mac_dat_a_data30;
output   [7:0] sc2mac_dat_a_data31;
output   [7:0] sc2mac_dat_a_data32;
output   [7:0] sc2mac_dat_a_data33;
output   [7:0] sc2mac_dat_a_data34;
output   [7:0] sc2mac_dat_a_data35;
output   [7:0] sc2mac_dat_a_data36;
output   [7:0] sc2mac_dat_a_data37;
output   [7:0] sc2mac_dat_a_data38;
output   [7:0] sc2mac_dat_a_data39;
output   [7:0] sc2mac_dat_a_data40;
output   [7:0] sc2mac_dat_a_data41;
output   [7:0] sc2mac_dat_a_data42;
output   [7:0] sc2mac_dat_a_data43;
output   [7:0] sc2mac_dat_a_data44;
output   [7:0] sc2mac_dat_a_data45;
output   [7:0] sc2mac_dat_a_data46;
output   [7:0] sc2mac_dat_a_data47;
output   [7:0] sc2mac_dat_a_data48;
output   [7:0] sc2mac_dat_a_data49;
output   [7:0] sc2mac_dat_a_data50;
output   [7:0] sc2mac_dat_a_data51;
output   [7:0] sc2mac_dat_a_data52;
output   [7:0] sc2mac_dat_a_data53;
output   [7:0] sc2mac_dat_a_data54;
output   [7:0] sc2mac_dat_a_data55;
output   [7:0] sc2mac_dat_a_data56;
output   [7:0] sc2mac_dat_a_data57;
output   [7:0] sc2mac_dat_a_data58;
output   [7:0] sc2mac_dat_a_data59;
output   [7:0] sc2mac_dat_a_data60;
output   [7:0] sc2mac_dat_a_data61;
output   [7:0] sc2mac_dat_a_data62;
output   [7:0] sc2mac_dat_a_data63;
output   [7:0] sc2mac_dat_a_data64;
output   [7:0] sc2mac_dat_a_data65;
output   [7:0] sc2mac_dat_a_data66;
output   [7:0] sc2mac_dat_a_data67;
output   [7:0] sc2mac_dat_a_data68;
output   [7:0] sc2mac_dat_a_data69;
output   [7:0] sc2mac_dat_a_data70;
output   [7:0] sc2mac_dat_a_data71;
output   [7:0] sc2mac_dat_a_data72;
output   [7:0] sc2mac_dat_a_data73;
output   [7:0] sc2mac_dat_a_data74;
output   [7:0] sc2mac_dat_a_data75;
output   [7:0] sc2mac_dat_a_data76;
output   [7:0] sc2mac_dat_a_data77;
output   [7:0] sc2mac_dat_a_data78;
output   [7:0] sc2mac_dat_a_data79;
output   [7:0] sc2mac_dat_a_data80;
output   [7:0] sc2mac_dat_a_data81;
output   [7:0] sc2mac_dat_a_data82;
output   [7:0] sc2mac_dat_a_data83;
output   [7:0] sc2mac_dat_a_data84;
output   [7:0] sc2mac_dat_a_data85;
output   [7:0] sc2mac_dat_a_data86;
output   [7:0] sc2mac_dat_a_data87;
output   [7:0] sc2mac_dat_a_data88;
output   [7:0] sc2mac_dat_a_data89;
output   [7:0] sc2mac_dat_a_data90;
output   [7:0] sc2mac_dat_a_data91;
output   [7:0] sc2mac_dat_a_data92;
output   [7:0] sc2mac_dat_a_data93;
output   [7:0] sc2mac_dat_a_data94;
output   [7:0] sc2mac_dat_a_data95;
output   [7:0] sc2mac_dat_a_data96;
output   [7:0] sc2mac_dat_a_data97;
output   [7:0] sc2mac_dat_a_data98;
output   [7:0] sc2mac_dat_a_data99;
output   [7:0] sc2mac_dat_a_data100;
output   [7:0] sc2mac_dat_a_data101;
output   [7:0] sc2mac_dat_a_data102;
output   [7:0] sc2mac_dat_a_data103;
output   [7:0] sc2mac_dat_a_data104;
output   [7:0] sc2mac_dat_a_data105;
output   [7:0] sc2mac_dat_a_data106;
output   [7:0] sc2mac_dat_a_data107;
output   [7:0] sc2mac_dat_a_data108;
output   [7:0] sc2mac_dat_a_data109;
output   [7:0] sc2mac_dat_a_data110;
output   [7:0] sc2mac_dat_a_data111;
output   [7:0] sc2mac_dat_a_data112;
output   [7:0] sc2mac_dat_a_data113;
output   [7:0] sc2mac_dat_a_data114;
output   [7:0] sc2mac_dat_a_data115;
output   [7:0] sc2mac_dat_a_data116;
output   [7:0] sc2mac_dat_a_data117;
output   [7:0] sc2mac_dat_a_data118;
output   [7:0] sc2mac_dat_a_data119;
output   [7:0] sc2mac_dat_a_data120;
output   [7:0] sc2mac_dat_a_data121;
output   [7:0] sc2mac_dat_a_data122;
output   [7:0] sc2mac_dat_a_data123;
output   [7:0] sc2mac_dat_a_data124;
output   [7:0] sc2mac_dat_a_data125;
output   [7:0] sc2mac_dat_a_data126;
output   [7:0] sc2mac_dat_a_data127;
output   [8:0] sc2mac_dat_a_pd;

output         sc2mac_dat_b_pvld;     /* data valid */
output [127:0] sc2mac_dat_b_mask;
output   [7:0] sc2mac_dat_b_data0;
output   [7:0] sc2mac_dat_b_data1;
output   [7:0] sc2mac_dat_b_data2;
output   [7:0] sc2mac_dat_b_data3;
output   [7:0] sc2mac_dat_b_data4;
output   [7:0] sc2mac_dat_b_data5;
output   [7:0] sc2mac_dat_b_data6;
output   [7:0] sc2mac_dat_b_data7;
output   [7:0] sc2mac_dat_b_data8;
output   [7:0] sc2mac_dat_b_data9;
output   [7:0] sc2mac_dat_b_data10;
output   [7:0] sc2mac_dat_b_data11;
output   [7:0] sc2mac_dat_b_data12;
output   [7:0] sc2mac_dat_b_data13;
output   [7:0] sc2mac_dat_b_data14;
output   [7:0] sc2mac_dat_b_data15;
output   [7:0] sc2mac_dat_b_data16;
output   [7:0] sc2mac_dat_b_data17;
output   [7:0] sc2mac_dat_b_data18;
output   [7:0] sc2mac_dat_b_data19;
output   [7:0] sc2mac_dat_b_data20;
output   [7:0] sc2mac_dat_b_data21;
output   [7:0] sc2mac_dat_b_data22;
output   [7:0] sc2mac_dat_b_data23;
output   [7:0] sc2mac_dat_b_data24;
output   [7:0] sc2mac_dat_b_data25;
output   [7:0] sc2mac_dat_b_data26;
output   [7:0] sc2mac_dat_b_data27;
output   [7:0] sc2mac_dat_b_data28;
output   [7:0] sc2mac_dat_b_data29;
output   [7:0] sc2mac_dat_b_data30;
output   [7:0] sc2mac_dat_b_data31;
output   [7:0] sc2mac_dat_b_data32;
output   [7:0] sc2mac_dat_b_data33;
output   [7:0] sc2mac_dat_b_data34;
output   [7:0] sc2mac_dat_b_data35;
output   [7:0] sc2mac_dat_b_data36;
output   [7:0] sc2mac_dat_b_data37;
output   [7:0] sc2mac_dat_b_data38;
output   [7:0] sc2mac_dat_b_data39;
output   [7:0] sc2mac_dat_b_data40;
output   [7:0] sc2mac_dat_b_data41;
output   [7:0] sc2mac_dat_b_data42;
output   [7:0] sc2mac_dat_b_data43;
output   [7:0] sc2mac_dat_b_data44;
output   [7:0] sc2mac_dat_b_data45;
output   [7:0] sc2mac_dat_b_data46;
output   [7:0] sc2mac_dat_b_data47;
output   [7:0] sc2mac_dat_b_data48;
output   [7:0] sc2mac_dat_b_data49;
output   [7:0] sc2mac_dat_b_data50;
output   [7:0] sc2mac_dat_b_data51;
output   [7:0] sc2mac_dat_b_data52;
output   [7:0] sc2mac_dat_b_data53;
output   [7:0] sc2mac_dat_b_data54;
output   [7:0] sc2mac_dat_b_data55;
output   [7:0] sc2mac_dat_b_data56;
output   [7:0] sc2mac_dat_b_data57;
output   [7:0] sc2mac_dat_b_data58;
output   [7:0] sc2mac_dat_b_data59;
output   [7:0] sc2mac_dat_b_data60;
output   [7:0] sc2mac_dat_b_data61;
output   [7:0] sc2mac_dat_b_data62;
output   [7:0] sc2mac_dat_b_data63;
output   [7:0] sc2mac_dat_b_data64;
output   [7:0] sc2mac_dat_b_data65;
output   [7:0] sc2mac_dat_b_data66;
output   [7:0] sc2mac_dat_b_data67;
output   [7:0] sc2mac_dat_b_data68;
output   [7:0] sc2mac_dat_b_data69;
output   [7:0] sc2mac_dat_b_data70;
output   [7:0] sc2mac_dat_b_data71;
output   [7:0] sc2mac_dat_b_data72;
output   [7:0] sc2mac_dat_b_data73;
output   [7:0] sc2mac_dat_b_data74;
output   [7:0] sc2mac_dat_b_data75;
output   [7:0] sc2mac_dat_b_data76;
output   [7:0] sc2mac_dat_b_data77;
output   [7:0] sc2mac_dat_b_data78;
output   [7:0] sc2mac_dat_b_data79;
output   [7:0] sc2mac_dat_b_data80;
output   [7:0] sc2mac_dat_b_data81;
output   [7:0] sc2mac_dat_b_data82;
output   [7:0] sc2mac_dat_b_data83;
output   [7:0] sc2mac_dat_b_data84;
output   [7:0] sc2mac_dat_b_data85;
output   [7:0] sc2mac_dat_b_data86;
output   [7:0] sc2mac_dat_b_data87;
output   [7:0] sc2mac_dat_b_data88;
output   [7:0] sc2mac_dat_b_data89;
output   [7:0] sc2mac_dat_b_data90;
output   [7:0] sc2mac_dat_b_data91;
output   [7:0] sc2mac_dat_b_data92;
output   [7:0] sc2mac_dat_b_data93;
output   [7:0] sc2mac_dat_b_data94;
output   [7:0] sc2mac_dat_b_data95;
output   [7:0] sc2mac_dat_b_data96;
output   [7:0] sc2mac_dat_b_data97;
output   [7:0] sc2mac_dat_b_data98;
output   [7:0] sc2mac_dat_b_data99;
output   [7:0] sc2mac_dat_b_data100;
output   [7:0] sc2mac_dat_b_data101;
output   [7:0] sc2mac_dat_b_data102;
output   [7:0] sc2mac_dat_b_data103;
output   [7:0] sc2mac_dat_b_data104;
output   [7:0] sc2mac_dat_b_data105;
output   [7:0] sc2mac_dat_b_data106;
output   [7:0] sc2mac_dat_b_data107;
output   [7:0] sc2mac_dat_b_data108;
output   [7:0] sc2mac_dat_b_data109;
output   [7:0] sc2mac_dat_b_data110;
output   [7:0] sc2mac_dat_b_data111;
output   [7:0] sc2mac_dat_b_data112;
output   [7:0] sc2mac_dat_b_data113;
output   [7:0] sc2mac_dat_b_data114;
output   [7:0] sc2mac_dat_b_data115;
output   [7:0] sc2mac_dat_b_data116;
output   [7:0] sc2mac_dat_b_data117;
output   [7:0] sc2mac_dat_b_data118;
output   [7:0] sc2mac_dat_b_data119;
output   [7:0] sc2mac_dat_b_data120;
output   [7:0] sc2mac_dat_b_data121;
output   [7:0] sc2mac_dat_b_data122;
output   [7:0] sc2mac_dat_b_data123;
output   [7:0] sc2mac_dat_b_data124;
output   [7:0] sc2mac_dat_b_data125;
output   [7:0] sc2mac_dat_b_data126;
output   [7:0] sc2mac_dat_b_data127;
output   [8:0] sc2mac_dat_b_pd;

output         sc2mac_wt_a_pvld;     /* data valid */
output [127:0] sc2mac_wt_a_mask;
output   [7:0] sc2mac_wt_a_data0;
output   [7:0] sc2mac_wt_a_data1;
output   [7:0] sc2mac_wt_a_data2;
output   [7:0] sc2mac_wt_a_data3;
output   [7:0] sc2mac_wt_a_data4;
output   [7:0] sc2mac_wt_a_data5;
output   [7:0] sc2mac_wt_a_data6;
output   [7:0] sc2mac_wt_a_data7;
output   [7:0] sc2mac_wt_a_data8;
output   [7:0] sc2mac_wt_a_data9;
output   [7:0] sc2mac_wt_a_data10;
output   [7:0] sc2mac_wt_a_data11;
output   [7:0] sc2mac_wt_a_data12;
output   [7:0] sc2mac_wt_a_data13;
output   [7:0] sc2mac_wt_a_data14;
output   [7:0] sc2mac_wt_a_data15;
output   [7:0] sc2mac_wt_a_data16;
output   [7:0] sc2mac_wt_a_data17;
output   [7:0] sc2mac_wt_a_data18;
output   [7:0] sc2mac_wt_a_data19;
output   [7:0] sc2mac_wt_a_data20;
output   [7:0] sc2mac_wt_a_data21;
output   [7:0] sc2mac_wt_a_data22;
output   [7:0] sc2mac_wt_a_data23;
output   [7:0] sc2mac_wt_a_data24;
output   [7:0] sc2mac_wt_a_data25;
output   [7:0] sc2mac_wt_a_data26;
output   [7:0] sc2mac_wt_a_data27;
output   [7:0] sc2mac_wt_a_data28;
output   [7:0] sc2mac_wt_a_data29;
output   [7:0] sc2mac_wt_a_data30;
output   [7:0] sc2mac_wt_a_data31;
output   [7:0] sc2mac_wt_a_data32;
output   [7:0] sc2mac_wt_a_data33;
output   [7:0] sc2mac_wt_a_data34;
output   [7:0] sc2mac_wt_a_data35;
output   [7:0] sc2mac_wt_a_data36;
output   [7:0] sc2mac_wt_a_data37;
output   [7:0] sc2mac_wt_a_data38;
output   [7:0] sc2mac_wt_a_data39;
output   [7:0] sc2mac_wt_a_data40;
output   [7:0] sc2mac_wt_a_data41;
output   [7:0] sc2mac_wt_a_data42;
output   [7:0] sc2mac_wt_a_data43;
output   [7:0] sc2mac_wt_a_data44;
output   [7:0] sc2mac_wt_a_data45;
output   [7:0] sc2mac_wt_a_data46;
output   [7:0] sc2mac_wt_a_data47;
output   [7:0] sc2mac_wt_a_data48;
output   [7:0] sc2mac_wt_a_data49;
output   [7:0] sc2mac_wt_a_data50;
output   [7:0] sc2mac_wt_a_data51;
output   [7:0] sc2mac_wt_a_data52;
output   [7:0] sc2mac_wt_a_data53;
output   [7:0] sc2mac_wt_a_data54;
output   [7:0] sc2mac_wt_a_data55;
output   [7:0] sc2mac_wt_a_data56;
output   [7:0] sc2mac_wt_a_data57;
output   [7:0] sc2mac_wt_a_data58;
output   [7:0] sc2mac_wt_a_data59;
output   [7:0] sc2mac_wt_a_data60;
output   [7:0] sc2mac_wt_a_data61;
output   [7:0] sc2mac_wt_a_data62;
output   [7:0] sc2mac_wt_a_data63;
output   [7:0] sc2mac_wt_a_data64;
output   [7:0] sc2mac_wt_a_data65;
output   [7:0] sc2mac_wt_a_data66;
output   [7:0] sc2mac_wt_a_data67;
output   [7:0] sc2mac_wt_a_data68;
output   [7:0] sc2mac_wt_a_data69;
output   [7:0] sc2mac_wt_a_data70;
output   [7:0] sc2mac_wt_a_data71;
output   [7:0] sc2mac_wt_a_data72;
output   [7:0] sc2mac_wt_a_data73;
output   [7:0] sc2mac_wt_a_data74;
output   [7:0] sc2mac_wt_a_data75;
output   [7:0] sc2mac_wt_a_data76;
output   [7:0] sc2mac_wt_a_data77;
output   [7:0] sc2mac_wt_a_data78;
output   [7:0] sc2mac_wt_a_data79;
output   [7:0] sc2mac_wt_a_data80;
output   [7:0] sc2mac_wt_a_data81;
output   [7:0] sc2mac_wt_a_data82;
output   [7:0] sc2mac_wt_a_data83;
output   [7:0] sc2mac_wt_a_data84;
output   [7:0] sc2mac_wt_a_data85;
output   [7:0] sc2mac_wt_a_data86;
output   [7:0] sc2mac_wt_a_data87;
output   [7:0] sc2mac_wt_a_data88;
output   [7:0] sc2mac_wt_a_data89;
output   [7:0] sc2mac_wt_a_data90;
output   [7:0] sc2mac_wt_a_data91;
output   [7:0] sc2mac_wt_a_data92;
output   [7:0] sc2mac_wt_a_data93;
output   [7:0] sc2mac_wt_a_data94;
output   [7:0] sc2mac_wt_a_data95;
output   [7:0] sc2mac_wt_a_data96;
output   [7:0] sc2mac_wt_a_data97;
output   [7:0] sc2mac_wt_a_data98;
output   [7:0] sc2mac_wt_a_data99;
output   [7:0] sc2mac_wt_a_data100;
output   [7:0] sc2mac_wt_a_data101;
output   [7:0] sc2mac_wt_a_data102;
output   [7:0] sc2mac_wt_a_data103;
output   [7:0] sc2mac_wt_a_data104;
output   [7:0] sc2mac_wt_a_data105;
output   [7:0] sc2mac_wt_a_data106;
output   [7:0] sc2mac_wt_a_data107;
output   [7:0] sc2mac_wt_a_data108;
output   [7:0] sc2mac_wt_a_data109;
output   [7:0] sc2mac_wt_a_data110;
output   [7:0] sc2mac_wt_a_data111;
output   [7:0] sc2mac_wt_a_data112;
output   [7:0] sc2mac_wt_a_data113;
output   [7:0] sc2mac_wt_a_data114;
output   [7:0] sc2mac_wt_a_data115;
output   [7:0] sc2mac_wt_a_data116;
output   [7:0] sc2mac_wt_a_data117;
output   [7:0] sc2mac_wt_a_data118;
output   [7:0] sc2mac_wt_a_data119;
output   [7:0] sc2mac_wt_a_data120;
output   [7:0] sc2mac_wt_a_data121;
output   [7:0] sc2mac_wt_a_data122;
output   [7:0] sc2mac_wt_a_data123;
output   [7:0] sc2mac_wt_a_data124;
output   [7:0] sc2mac_wt_a_data125;
output   [7:0] sc2mac_wt_a_data126;
output   [7:0] sc2mac_wt_a_data127;
output   [7:0] sc2mac_wt_a_sel;

output         sc2mac_wt_b_pvld;     /* data valid */
output [127:0] sc2mac_wt_b_mask;
output   [7:0] sc2mac_wt_b_data0;
output   [7:0] sc2mac_wt_b_data1;
output   [7:0] sc2mac_wt_b_data2;
output   [7:0] sc2mac_wt_b_data3;
output   [7:0] sc2mac_wt_b_data4;
output   [7:0] sc2mac_wt_b_data5;
output   [7:0] sc2mac_wt_b_data6;
output   [7:0] sc2mac_wt_b_data7;
output   [7:0] sc2mac_wt_b_data8;
output   [7:0] sc2mac_wt_b_data9;
output   [7:0] sc2mac_wt_b_data10;
output   [7:0] sc2mac_wt_b_data11;
output   [7:0] sc2mac_wt_b_data12;
output   [7:0] sc2mac_wt_b_data13;
output   [7:0] sc2mac_wt_b_data14;
output   [7:0] sc2mac_wt_b_data15;
output   [7:0] sc2mac_wt_b_data16;
output   [7:0] sc2mac_wt_b_data17;
output   [7:0] sc2mac_wt_b_data18;
output   [7:0] sc2mac_wt_b_data19;
output   [7:0] sc2mac_wt_b_data20;
output   [7:0] sc2mac_wt_b_data21;
output   [7:0] sc2mac_wt_b_data22;
output   [7:0] sc2mac_wt_b_data23;
output   [7:0] sc2mac_wt_b_data24;
output   [7:0] sc2mac_wt_b_data25;
output   [7:0] sc2mac_wt_b_data26;
output   [7:0] sc2mac_wt_b_data27;
output   [7:0] sc2mac_wt_b_data28;
output   [7:0] sc2mac_wt_b_data29;
output   [7:0] sc2mac_wt_b_data30;
output   [7:0] sc2mac_wt_b_data31;
output   [7:0] sc2mac_wt_b_data32;
output   [7:0] sc2mac_wt_b_data33;
output   [7:0] sc2mac_wt_b_data34;
output   [7:0] sc2mac_wt_b_data35;
output   [7:0] sc2mac_wt_b_data36;
output   [7:0] sc2mac_wt_b_data37;
output   [7:0] sc2mac_wt_b_data38;
output   [7:0] sc2mac_wt_b_data39;
output   [7:0] sc2mac_wt_b_data40;
output   [7:0] sc2mac_wt_b_data41;
output   [7:0] sc2mac_wt_b_data42;
output   [7:0] sc2mac_wt_b_data43;
output   [7:0] sc2mac_wt_b_data44;
output   [7:0] sc2mac_wt_b_data45;
output   [7:0] sc2mac_wt_b_data46;
output   [7:0] sc2mac_wt_b_data47;
output   [7:0] sc2mac_wt_b_data48;
output   [7:0] sc2mac_wt_b_data49;
output   [7:0] sc2mac_wt_b_data50;
output   [7:0] sc2mac_wt_b_data51;
output   [7:0] sc2mac_wt_b_data52;
output   [7:0] sc2mac_wt_b_data53;
output   [7:0] sc2mac_wt_b_data54;
output   [7:0] sc2mac_wt_b_data55;
output   [7:0] sc2mac_wt_b_data56;
output   [7:0] sc2mac_wt_b_data57;
output   [7:0] sc2mac_wt_b_data58;
output   [7:0] sc2mac_wt_b_data59;
output   [7:0] sc2mac_wt_b_data60;
output   [7:0] sc2mac_wt_b_data61;
output   [7:0] sc2mac_wt_b_data62;
output   [7:0] sc2mac_wt_b_data63;
output   [7:0] sc2mac_wt_b_data64;
output   [7:0] sc2mac_wt_b_data65;
output   [7:0] sc2mac_wt_b_data66;
output   [7:0] sc2mac_wt_b_data67;
output   [7:0] sc2mac_wt_b_data68;
output   [7:0] sc2mac_wt_b_data69;
output   [7:0] sc2mac_wt_b_data70;
output   [7:0] sc2mac_wt_b_data71;
output   [7:0] sc2mac_wt_b_data72;
output   [7:0] sc2mac_wt_b_data73;
output   [7:0] sc2mac_wt_b_data74;
output   [7:0] sc2mac_wt_b_data75;
output   [7:0] sc2mac_wt_b_data76;
output   [7:0] sc2mac_wt_b_data77;
output   [7:0] sc2mac_wt_b_data78;
output   [7:0] sc2mac_wt_b_data79;
output   [7:0] sc2mac_wt_b_data80;
output   [7:0] sc2mac_wt_b_data81;
output   [7:0] sc2mac_wt_b_data82;
output   [7:0] sc2mac_wt_b_data83;
output   [7:0] sc2mac_wt_b_data84;
output   [7:0] sc2mac_wt_b_data85;
output   [7:0] sc2mac_wt_b_data86;
output   [7:0] sc2mac_wt_b_data87;
output   [7:0] sc2mac_wt_b_data88;
output   [7:0] sc2mac_wt_b_data89;
output   [7:0] sc2mac_wt_b_data90;
output   [7:0] sc2mac_wt_b_data91;
output   [7:0] sc2mac_wt_b_data92;
output   [7:0] sc2mac_wt_b_data93;
output   [7:0] sc2mac_wt_b_data94;
output   [7:0] sc2mac_wt_b_data95;
output   [7:0] sc2mac_wt_b_data96;
output   [7:0] sc2mac_wt_b_data97;
output   [7:0] sc2mac_wt_b_data98;
output   [7:0] sc2mac_wt_b_data99;
output   [7:0] sc2mac_wt_b_data100;
output   [7:0] sc2mac_wt_b_data101;
output   [7:0] sc2mac_wt_b_data102;
output   [7:0] sc2mac_wt_b_data103;
output   [7:0] sc2mac_wt_b_data104;
output   [7:0] sc2mac_wt_b_data105;
output   [7:0] sc2mac_wt_b_data106;
output   [7:0] sc2mac_wt_b_data107;
output   [7:0] sc2mac_wt_b_data108;
output   [7:0] sc2mac_wt_b_data109;
output   [7:0] sc2mac_wt_b_data110;
output   [7:0] sc2mac_wt_b_data111;
output   [7:0] sc2mac_wt_b_data112;
output   [7:0] sc2mac_wt_b_data113;
output   [7:0] sc2mac_wt_b_data114;
output   [7:0] sc2mac_wt_b_data115;
output   [7:0] sc2mac_wt_b_data116;
output   [7:0] sc2mac_wt_b_data117;
output   [7:0] sc2mac_wt_b_data118;
output   [7:0] sc2mac_wt_b_data119;
output   [7:0] sc2mac_wt_b_data120;
output   [7:0] sc2mac_wt_b_data121;
output   [7:0] sc2mac_wt_b_data122;
output   [7:0] sc2mac_wt_b_data123;
output   [7:0] sc2mac_wt_b_data124;
output   [7:0] sc2mac_wt_b_data125;
output   [7:0] sc2mac_wt_b_data126;
output   [7:0] sc2mac_wt_b_data127;
output   [7:0] sc2mac_wt_b_sel;

input        cdma2sc_wt_updt;      /* data valid */
input [13:0] cdma2sc_wt_kernels;
input [11:0] cdma2sc_wt_entries;
input  [8:0] cdma2sc_wmb_entries;

output        sc2cdma_wt_updt;      /* data valid */
output [13:0] sc2cdma_wt_kernels;
output [11:0] sc2cdma_wt_entries;
output  [8:0] sc2cdma_wmb_entries;

input   dla_clk_ovr_on_sync;
input   global_clk_ovr_on_sync;
input   tmc2slcg_disable_clock_gating;

wire        dp2reg_done;
wire        nvdla_op_gated_clk_0;
wire        nvdla_op_gated_clk_1;
wire        nvdla_op_gated_clk_2;
wire        nvdla_wg_gated_clk;
wire [20:0] reg2dp_atomics;
wire  [4:0] reg2dp_batches;
wire  [0:0] reg2dp_conv_mode;
wire  [2:0] reg2dp_conv_x_stride_ext;
wire  [2:0] reg2dp_conv_y_stride_ext;
wire [31:0] reg2dp_cya;
wire  [3:0] reg2dp_data_bank;
wire  [0:0] reg2dp_data_reuse;
wire [12:0] reg2dp_datain_channel_ext;
wire  [0:0] reg2dp_datain_format;
wire [12:0] reg2dp_datain_height_ext;
wire [12:0] reg2dp_datain_width_ext;
wire [12:0] reg2dp_dataout_channel;
wire [12:0] reg2dp_dataout_height;
wire [12:0] reg2dp_dataout_width;
wire [11:0] reg2dp_entries;
wire  [1:0] reg2dp_in_precision;
wire  [0:0] reg2dp_op_en;
wire  [4:0] reg2dp_pad_left;
wire  [4:0] reg2dp_pad_top;
wire [15:0] reg2dp_pad_value;
wire  [1:0] reg2dp_pra_truncate;
wire  [1:0] reg2dp_proc_precision;
wire [11:0] reg2dp_rls_slices;
wire  [0:0] reg2dp_skip_data_rls;
wire  [0:0] reg2dp_skip_weight_rls;
wire  [3:0] reg2dp_weight_bank;
wire [24:0] reg2dp_weight_bytes;
wire [12:0] reg2dp_weight_channel_ext;
wire  [0:0] reg2dp_weight_format;
wire  [4:0] reg2dp_weight_height_ext;
wire [12:0] reg2dp_weight_kernel;
wire  [0:0] reg2dp_weight_reuse;
wire  [4:0] reg2dp_weight_width_ext;
wire [20:0] reg2dp_wmb_bytes;
wire  [4:0] reg2dp_x_dilation_ext;
wire  [4:0] reg2dp_y_dilation_ext;
wire  [1:0] reg2dp_y_extension;
wire  [1:0] sc_state;
wire [30:0] sg2dl_pd;
wire        sg2dl_pvld;
wire        sg2dl_reuse_rls;
wire [17:0] sg2wl_pd;
wire        sg2wl_pvld;
wire        sg2wl_reuse_rls;
wire  [3:0] slcg_op_en;
wire        slcg_wg_en;


//==========================================================
// Regfile
//==========================================================
NV_NVDLA_CSC_regfile u_regfile (
   .nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.csb2csc_req_pd                (csb2csc_req_pd[62:0])            //|< i
  ,.csb2csc_req_pvld              (csb2csc_req_pvld)                //|< i
  ,.dp2reg_done                   (dp2reg_done)                     //|< w
  ,.csb2csc_req_prdy              (csb2csc_req_prdy)                //|> o
  ,.csc2csb_resp_pd               (csc2csb_resp_pd[33:0])           //|> o
  ,.csc2csb_resp_valid            (csc2csb_resp_valid)              //|> o
  ,.reg2dp_atomics                (reg2dp_atomics[20:0])            //|> w
  ,.reg2dp_batches                (reg2dp_batches[4:0])             //|> w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode)                //|> w
  ,.reg2dp_conv_x_stride_ext      (reg2dp_conv_x_stride_ext[2:0])   //|> w
  ,.reg2dp_conv_y_stride_ext      (reg2dp_conv_y_stride_ext[2:0])   //|> w
  ,.reg2dp_cya                    (reg2dp_cya[31:0])                //|> w *
  ,.reg2dp_data_bank              (reg2dp_data_bank[3:0])           //|> w
  ,.reg2dp_data_reuse             (reg2dp_data_reuse)               //|> w
  ,.reg2dp_datain_channel_ext     (reg2dp_datain_channel_ext[12:0]) //|> w
  ,.reg2dp_datain_format          (reg2dp_datain_format)            //|> w
  ,.reg2dp_datain_height_ext      (reg2dp_datain_height_ext[12:0])  //|> w
  ,.reg2dp_datain_width_ext       (reg2dp_datain_width_ext[12:0])   //|> w
  ,.reg2dp_dataout_channel        (reg2dp_dataout_channel[12:0])    //|> w *
  ,.reg2dp_dataout_height         (reg2dp_dataout_height[12:0])     //|> w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])      //|> w
  ,.reg2dp_entries                (reg2dp_entries[11:0])            //|> w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])        //|> w
  ,.reg2dp_op_en                  (reg2dp_op_en)                    //|> w
  ,.reg2dp_pad_left               (reg2dp_pad_left[4:0])            //|> w
  ,.reg2dp_pad_top                (reg2dp_pad_top[4:0])             //|> w
  ,.reg2dp_pad_value              (reg2dp_pad_value[15:0])          //|> w
  ,.reg2dp_pra_truncate           (reg2dp_pra_truncate[1:0])        //|> w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|> w
  ,.reg2dp_rls_slices             (reg2dp_rls_slices[11:0])         //|> w
  ,.reg2dp_skip_data_rls          (reg2dp_skip_data_rls)            //|> w
  ,.reg2dp_skip_weight_rls        (reg2dp_skip_weight_rls)          //|> w
  ,.reg2dp_weight_bank            (reg2dp_weight_bank[3:0])         //|> w
  ,.reg2dp_weight_bytes           (reg2dp_weight_bytes[24:0])       //|> w
  ,.reg2dp_weight_channel_ext     (reg2dp_weight_channel_ext[12:0]) //|> w
  ,.reg2dp_weight_format          (reg2dp_weight_format)            //|> w
  ,.reg2dp_weight_height_ext      (reg2dp_weight_height_ext[4:0])   //|> w
  ,.reg2dp_weight_kernel          (reg2dp_weight_kernel[12:0])      //|> w
  ,.reg2dp_weight_reuse           (reg2dp_weight_reuse)             //|> w
  ,.reg2dp_weight_width_ext       (reg2dp_weight_width_ext[4:0])    //|> w
  ,.reg2dp_wmb_bytes              (reg2dp_wmb_bytes[20:0])          //|> w
  ,.reg2dp_x_dilation_ext         (reg2dp_x_dilation_ext[4:0])      //|> w
  ,.reg2dp_y_dilation_ext         (reg2dp_y_dilation_ext[4:0])      //|> w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|> w
  ,.slcg_op_en                    (slcg_op_en[3:0])                 //|> w
  );

//==========================================================
// Sequence generator
//==========================================================
NV_NVDLA_CSC_sg u_sg (
   .nvdla_core_clk                (nvdla_op_gated_clk_0)            //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.pwrbus_ram_pd                 (pwrbus_ram_pd[31:0])             //|< i
  ,.dp2reg_done                   (dp2reg_done)                     //|> w
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)                //|< i
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[11:0])       //|< i
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[11:0])        //|< i
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)                 //|< i
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels[13:0])        //|< i
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries[11:0])        //|< i
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries[8:0])        //|< i
  ,.sg2dl_pvld                    (sg2dl_pvld)                      //|> w
  ,.sg2dl_pd                      (sg2dl_pd[30:0])                  //|> w
  ,.sg2wl_pvld                    (sg2wl_pvld)                      //|> w
  ,.sg2wl_pd                      (sg2wl_pd[17:0])                  //|> w
  ,.accu2sc_credit_vld            (accu2sc_credit_vld)              //|< i
  ,.accu2sc_credit_size           (accu2sc_credit_size[2:0])        //|< i
  ,.sc_state                      (sc_state[1:0])                   //|> w
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)         //|> o
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)          //|> o
  ,.cdma2sc_dat_pending_ack       (cdma2sc_dat_pending_ack)         //|< i
  ,.cdma2sc_wt_pending_ack        (cdma2sc_wt_pending_ack)          //|< i
  ,.sg2dl_reuse_rls               (sg2dl_reuse_rls)                 //|> w
  ,.sg2wl_reuse_rls               (sg2wl_reuse_rls)                 //|> w
  ,.nvdla_core_ng_clk             (nvdla_core_clk)                  //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode[0])             //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|< w
  ,.reg2dp_data_reuse             (reg2dp_data_reuse[0])            //|< w
  ,.reg2dp_skip_data_rls          (reg2dp_skip_data_rls[0])         //|< w
  ,.reg2dp_weight_reuse           (reg2dp_weight_reuse[0])          //|< w
  ,.reg2dp_skip_weight_rls        (reg2dp_skip_weight_rls[0])       //|< w
  ,.reg2dp_batches                (reg2dp_batches[4:0])             //|< w
  ,.reg2dp_datain_format          (reg2dp_datain_format[0])         //|< w
  ,.reg2dp_datain_height_ext      (reg2dp_datain_height_ext[12:0])  //|< w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|< w
  ,.reg2dp_weight_width_ext       (reg2dp_weight_width_ext[4:0])    //|< w
  ,.reg2dp_weight_height_ext      (reg2dp_weight_height_ext[4:0])   //|< w
  ,.reg2dp_weight_channel_ext     (reg2dp_weight_channel_ext[12:0]) //|< w
  ,.reg2dp_weight_kernel          (reg2dp_weight_kernel[12:0])      //|< w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])      //|< w
  ,.reg2dp_dataout_height         (reg2dp_dataout_height[12:0])     //|< w
  ,.reg2dp_data_bank              (reg2dp_data_bank[3:0])           //|< w
  ,.reg2dp_weight_bank            (reg2dp_weight_bank[3:0])         //|< w
  ,.reg2dp_atomics                (reg2dp_atomics[20:0])            //|< w
  ,.reg2dp_rls_slices             (reg2dp_rls_slices[11:0])         //|< w
  );

//==========================================================
// Weight loader
//==========================================================
NV_NVDLA_CSC_wl u_wl (
   .nvdla_core_clk                (nvdla_op_gated_clk_1)            //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.sg2wl_pvld                    (sg2wl_pvld)                      //|< w
  ,.sg2wl_pd                      (sg2wl_pd[17:0])                  //|< w
  ,.sc_state                      (sc_state[1:0])                   //|< w
  ,.sg2wl_reuse_rls               (sg2wl_reuse_rls)                 //|< w
  ,.sc2cdma_wt_pending_req        (sc2cdma_wt_pending_req)          //|< o
  ,.cdma2sc_wt_updt               (cdma2sc_wt_updt)                 //|< i
  ,.cdma2sc_wt_kernels            (cdma2sc_wt_kernels[13:0])        //|< i
  ,.cdma2sc_wt_entries            (cdma2sc_wt_entries[11:0])        //|< i
  ,.cdma2sc_wmb_entries           (cdma2sc_wmb_entries[8:0])        //|< i
  ,.sc2cdma_wt_updt               (sc2cdma_wt_updt)                 //|> o
  ,.sc2cdma_wt_kernels            (sc2cdma_wt_kernels[13:0])        //|> o
  ,.sc2cdma_wt_entries            (sc2cdma_wt_entries[11:0])        //|> o
  ,.sc2cdma_wmb_entries           (sc2cdma_wmb_entries[8:0])        //|> o
  ,.sc2buf_wt_rd_en               (sc2buf_wt_rd_en)                 //|> o
  ,.sc2buf_wt_rd_addr             (sc2buf_wt_rd_addr[11:0])         //|> o
  ,.sc2buf_wt_rd_valid            (sc2buf_wt_rd_valid)              //|< i
  ,.sc2buf_wt_rd_data             (sc2buf_wt_rd_data[1023:0])       //|< i
  ,.sc2buf_wmb_rd_en              (sc2buf_wmb_rd_en)                //|> o
  ,.sc2buf_wmb_rd_addr            (sc2buf_wmb_rd_addr[7:0])         //|> o
  ,.sc2buf_wmb_rd_valid           (sc2buf_wmb_rd_valid)             //|< i
  ,.sc2buf_wmb_rd_data            (sc2buf_wmb_rd_data[1023:0])      //|< i
  ,.sc2mac_wt_a_pvld              (sc2mac_wt_a_pvld)                //|> o
  ,.sc2mac_wt_a_mask              (sc2mac_wt_a_mask[127:0])         //|> o
  ,.sc2mac_wt_a_data0             (sc2mac_wt_a_data0[7:0])          //|> o
  ,.sc2mac_wt_a_data1             (sc2mac_wt_a_data1[7:0])          //|> o
  ,.sc2mac_wt_a_data2             (sc2mac_wt_a_data2[7:0])          //|> o
  ,.sc2mac_wt_a_data3             (sc2mac_wt_a_data3[7:0])          //|> o
  ,.sc2mac_wt_a_data4             (sc2mac_wt_a_data4[7:0])          //|> o
  ,.sc2mac_wt_a_data5             (sc2mac_wt_a_data5[7:0])          //|> o
  ,.sc2mac_wt_a_data6             (sc2mac_wt_a_data6[7:0])          //|> o
  ,.sc2mac_wt_a_data7             (sc2mac_wt_a_data7[7:0])          //|> o
  ,.sc2mac_wt_a_data8             (sc2mac_wt_a_data8[7:0])          //|> o
  ,.sc2mac_wt_a_data9             (sc2mac_wt_a_data9[7:0])          //|> o
  ,.sc2mac_wt_a_data10            (sc2mac_wt_a_data10[7:0])         //|> o
  ,.sc2mac_wt_a_data11            (sc2mac_wt_a_data11[7:0])         //|> o
  ,.sc2mac_wt_a_data12            (sc2mac_wt_a_data12[7:0])         //|> o
  ,.sc2mac_wt_a_data13            (sc2mac_wt_a_data13[7:0])         //|> o
  ,.sc2mac_wt_a_data14            (sc2mac_wt_a_data14[7:0])         //|> o
  ,.sc2mac_wt_a_data15            (sc2mac_wt_a_data15[7:0])         //|> o
  ,.sc2mac_wt_a_data16            (sc2mac_wt_a_data16[7:0])         //|> o
  ,.sc2mac_wt_a_data17            (sc2mac_wt_a_data17[7:0])         //|> o
  ,.sc2mac_wt_a_data18            (sc2mac_wt_a_data18[7:0])         //|> o
  ,.sc2mac_wt_a_data19            (sc2mac_wt_a_data19[7:0])         //|> o
  ,.sc2mac_wt_a_data20            (sc2mac_wt_a_data20[7:0])         //|> o
  ,.sc2mac_wt_a_data21            (sc2mac_wt_a_data21[7:0])         //|> o
  ,.sc2mac_wt_a_data22            (sc2mac_wt_a_data22[7:0])         //|> o
  ,.sc2mac_wt_a_data23            (sc2mac_wt_a_data23[7:0])         //|> o
  ,.sc2mac_wt_a_data24            (sc2mac_wt_a_data24[7:0])         //|> o
  ,.sc2mac_wt_a_data25            (sc2mac_wt_a_data25[7:0])         //|> o
  ,.sc2mac_wt_a_data26            (sc2mac_wt_a_data26[7:0])         //|> o
  ,.sc2mac_wt_a_data27            (sc2mac_wt_a_data27[7:0])         //|> o
  ,.sc2mac_wt_a_data28            (sc2mac_wt_a_data28[7:0])         //|> o
  ,.sc2mac_wt_a_data29            (sc2mac_wt_a_data29[7:0])         //|> o
  ,.sc2mac_wt_a_data30            (sc2mac_wt_a_data30[7:0])         //|> o
  ,.sc2mac_wt_a_data31            (sc2mac_wt_a_data31[7:0])         //|> o
  ,.sc2mac_wt_a_data32            (sc2mac_wt_a_data32[7:0])         //|> o
  ,.sc2mac_wt_a_data33            (sc2mac_wt_a_data33[7:0])         //|> o
  ,.sc2mac_wt_a_data34            (sc2mac_wt_a_data34[7:0])         //|> o
  ,.sc2mac_wt_a_data35            (sc2mac_wt_a_data35[7:0])         //|> o
  ,.sc2mac_wt_a_data36            (sc2mac_wt_a_data36[7:0])         //|> o
  ,.sc2mac_wt_a_data37            (sc2mac_wt_a_data37[7:0])         //|> o
  ,.sc2mac_wt_a_data38            (sc2mac_wt_a_data38[7:0])         //|> o
  ,.sc2mac_wt_a_data39            (sc2mac_wt_a_data39[7:0])         //|> o
  ,.sc2mac_wt_a_data40            (sc2mac_wt_a_data40[7:0])         //|> o
  ,.sc2mac_wt_a_data41            (sc2mac_wt_a_data41[7:0])         //|> o
  ,.sc2mac_wt_a_data42            (sc2mac_wt_a_data42[7:0])         //|> o
  ,.sc2mac_wt_a_data43            (sc2mac_wt_a_data43[7:0])         //|> o
  ,.sc2mac_wt_a_data44            (sc2mac_wt_a_data44[7:0])         //|> o
  ,.sc2mac_wt_a_data45            (sc2mac_wt_a_data45[7:0])         //|> o
  ,.sc2mac_wt_a_data46            (sc2mac_wt_a_data46[7:0])         //|> o
  ,.sc2mac_wt_a_data47            (sc2mac_wt_a_data47[7:0])         //|> o
  ,.sc2mac_wt_a_data48            (sc2mac_wt_a_data48[7:0])         //|> o
  ,.sc2mac_wt_a_data49            (sc2mac_wt_a_data49[7:0])         //|> o
  ,.sc2mac_wt_a_data50            (sc2mac_wt_a_data50[7:0])         //|> o
  ,.sc2mac_wt_a_data51            (sc2mac_wt_a_data51[7:0])         //|> o
  ,.sc2mac_wt_a_data52            (sc2mac_wt_a_data52[7:0])         //|> o
  ,.sc2mac_wt_a_data53            (sc2mac_wt_a_data53[7:0])         //|> o
  ,.sc2mac_wt_a_data54            (sc2mac_wt_a_data54[7:0])         //|> o
  ,.sc2mac_wt_a_data55            (sc2mac_wt_a_data55[7:0])         //|> o
  ,.sc2mac_wt_a_data56            (sc2mac_wt_a_data56[7:0])         //|> o
  ,.sc2mac_wt_a_data57            (sc2mac_wt_a_data57[7:0])         //|> o
  ,.sc2mac_wt_a_data58            (sc2mac_wt_a_data58[7:0])         //|> o
  ,.sc2mac_wt_a_data59            (sc2mac_wt_a_data59[7:0])         //|> o
  ,.sc2mac_wt_a_data60            (sc2mac_wt_a_data60[7:0])         //|> o
  ,.sc2mac_wt_a_data61            (sc2mac_wt_a_data61[7:0])         //|> o
  ,.sc2mac_wt_a_data62            (sc2mac_wt_a_data62[7:0])         //|> o
  ,.sc2mac_wt_a_data63            (sc2mac_wt_a_data63[7:0])         //|> o
  ,.sc2mac_wt_a_data64            (sc2mac_wt_a_data64[7:0])         //|> o
  ,.sc2mac_wt_a_data65            (sc2mac_wt_a_data65[7:0])         //|> o
  ,.sc2mac_wt_a_data66            (sc2mac_wt_a_data66[7:0])         //|> o
  ,.sc2mac_wt_a_data67            (sc2mac_wt_a_data67[7:0])         //|> o
  ,.sc2mac_wt_a_data68            (sc2mac_wt_a_data68[7:0])         //|> o
  ,.sc2mac_wt_a_data69            (sc2mac_wt_a_data69[7:0])         //|> o
  ,.sc2mac_wt_a_data70            (sc2mac_wt_a_data70[7:0])         //|> o
  ,.sc2mac_wt_a_data71            (sc2mac_wt_a_data71[7:0])         //|> o
  ,.sc2mac_wt_a_data72            (sc2mac_wt_a_data72[7:0])         //|> o
  ,.sc2mac_wt_a_data73            (sc2mac_wt_a_data73[7:0])         //|> o
  ,.sc2mac_wt_a_data74            (sc2mac_wt_a_data74[7:0])         //|> o
  ,.sc2mac_wt_a_data75            (sc2mac_wt_a_data75[7:0])         //|> o
  ,.sc2mac_wt_a_data76            (sc2mac_wt_a_data76[7:0])         //|> o
  ,.sc2mac_wt_a_data77            (sc2mac_wt_a_data77[7:0])         //|> o
  ,.sc2mac_wt_a_data78            (sc2mac_wt_a_data78[7:0])         //|> o
  ,.sc2mac_wt_a_data79            (sc2mac_wt_a_data79[7:0])         //|> o
  ,.sc2mac_wt_a_data80            (sc2mac_wt_a_data80[7:0])         //|> o
  ,.sc2mac_wt_a_data81            (sc2mac_wt_a_data81[7:0])         //|> o
  ,.sc2mac_wt_a_data82            (sc2mac_wt_a_data82[7:0])         //|> o
  ,.sc2mac_wt_a_data83            (sc2mac_wt_a_data83[7:0])         //|> o
  ,.sc2mac_wt_a_data84            (sc2mac_wt_a_data84[7:0])         //|> o
  ,.sc2mac_wt_a_data85            (sc2mac_wt_a_data85[7:0])         //|> o
  ,.sc2mac_wt_a_data86            (sc2mac_wt_a_data86[7:0])         //|> o
  ,.sc2mac_wt_a_data87            (sc2mac_wt_a_data87[7:0])         //|> o
  ,.sc2mac_wt_a_data88            (sc2mac_wt_a_data88[7:0])         //|> o
  ,.sc2mac_wt_a_data89            (sc2mac_wt_a_data89[7:0])         //|> o
  ,.sc2mac_wt_a_data90            (sc2mac_wt_a_data90[7:0])         //|> o
  ,.sc2mac_wt_a_data91            (sc2mac_wt_a_data91[7:0])         //|> o
  ,.sc2mac_wt_a_data92            (sc2mac_wt_a_data92[7:0])         //|> o
  ,.sc2mac_wt_a_data93            (sc2mac_wt_a_data93[7:0])         //|> o
  ,.sc2mac_wt_a_data94            (sc2mac_wt_a_data94[7:0])         //|> o
  ,.sc2mac_wt_a_data95            (sc2mac_wt_a_data95[7:0])         //|> o
  ,.sc2mac_wt_a_data96            (sc2mac_wt_a_data96[7:0])         //|> o
  ,.sc2mac_wt_a_data97            (sc2mac_wt_a_data97[7:0])         //|> o
  ,.sc2mac_wt_a_data98            (sc2mac_wt_a_data98[7:0])         //|> o
  ,.sc2mac_wt_a_data99            (sc2mac_wt_a_data99[7:0])         //|> o
  ,.sc2mac_wt_a_data100           (sc2mac_wt_a_data100[7:0])        //|> o
  ,.sc2mac_wt_a_data101           (sc2mac_wt_a_data101[7:0])        //|> o
  ,.sc2mac_wt_a_data102           (sc2mac_wt_a_data102[7:0])        //|> o
  ,.sc2mac_wt_a_data103           (sc2mac_wt_a_data103[7:0])        //|> o
  ,.sc2mac_wt_a_data104           (sc2mac_wt_a_data104[7:0])        //|> o
  ,.sc2mac_wt_a_data105           (sc2mac_wt_a_data105[7:0])        //|> o
  ,.sc2mac_wt_a_data106           (sc2mac_wt_a_data106[7:0])        //|> o
  ,.sc2mac_wt_a_data107           (sc2mac_wt_a_data107[7:0])        //|> o
  ,.sc2mac_wt_a_data108           (sc2mac_wt_a_data108[7:0])        //|> o
  ,.sc2mac_wt_a_data109           (sc2mac_wt_a_data109[7:0])        //|> o
  ,.sc2mac_wt_a_data110           (sc2mac_wt_a_data110[7:0])        //|> o
  ,.sc2mac_wt_a_data111           (sc2mac_wt_a_data111[7:0])        //|> o
  ,.sc2mac_wt_a_data112           (sc2mac_wt_a_data112[7:0])        //|> o
  ,.sc2mac_wt_a_data113           (sc2mac_wt_a_data113[7:0])        //|> o
  ,.sc2mac_wt_a_data114           (sc2mac_wt_a_data114[7:0])        //|> o
  ,.sc2mac_wt_a_data115           (sc2mac_wt_a_data115[7:0])        //|> o
  ,.sc2mac_wt_a_data116           (sc2mac_wt_a_data116[7:0])        //|> o
  ,.sc2mac_wt_a_data117           (sc2mac_wt_a_data117[7:0])        //|> o
  ,.sc2mac_wt_a_data118           (sc2mac_wt_a_data118[7:0])        //|> o
  ,.sc2mac_wt_a_data119           (sc2mac_wt_a_data119[7:0])        //|> o
  ,.sc2mac_wt_a_data120           (sc2mac_wt_a_data120[7:0])        //|> o
  ,.sc2mac_wt_a_data121           (sc2mac_wt_a_data121[7:0])        //|> o
  ,.sc2mac_wt_a_data122           (sc2mac_wt_a_data122[7:0])        //|> o
  ,.sc2mac_wt_a_data123           (sc2mac_wt_a_data123[7:0])        //|> o
  ,.sc2mac_wt_a_data124           (sc2mac_wt_a_data124[7:0])        //|> o
  ,.sc2mac_wt_a_data125           (sc2mac_wt_a_data125[7:0])        //|> o
  ,.sc2mac_wt_a_data126           (sc2mac_wt_a_data126[7:0])        //|> o
  ,.sc2mac_wt_a_data127           (sc2mac_wt_a_data127[7:0])        //|> o
  ,.sc2mac_wt_a_sel               (sc2mac_wt_a_sel[7:0])            //|> o
  ,.sc2mac_wt_b_pvld              (sc2mac_wt_b_pvld)                //|> o
  ,.sc2mac_wt_b_mask              (sc2mac_wt_b_mask[127:0])         //|> o
  ,.sc2mac_wt_b_data0             (sc2mac_wt_b_data0[7:0])          //|> o
  ,.sc2mac_wt_b_data1             (sc2mac_wt_b_data1[7:0])          //|> o
  ,.sc2mac_wt_b_data2             (sc2mac_wt_b_data2[7:0])          //|> o
  ,.sc2mac_wt_b_data3             (sc2mac_wt_b_data3[7:0])          //|> o
  ,.sc2mac_wt_b_data4             (sc2mac_wt_b_data4[7:0])          //|> o
  ,.sc2mac_wt_b_data5             (sc2mac_wt_b_data5[7:0])          //|> o
  ,.sc2mac_wt_b_data6             (sc2mac_wt_b_data6[7:0])          //|> o
  ,.sc2mac_wt_b_data7             (sc2mac_wt_b_data7[7:0])          //|> o
  ,.sc2mac_wt_b_data8             (sc2mac_wt_b_data8[7:0])          //|> o
  ,.sc2mac_wt_b_data9             (sc2mac_wt_b_data9[7:0])          //|> o
  ,.sc2mac_wt_b_data10            (sc2mac_wt_b_data10[7:0])         //|> o
  ,.sc2mac_wt_b_data11            (sc2mac_wt_b_data11[7:0])         //|> o
  ,.sc2mac_wt_b_data12            (sc2mac_wt_b_data12[7:0])         //|> o
  ,.sc2mac_wt_b_data13            (sc2mac_wt_b_data13[7:0])         //|> o
  ,.sc2mac_wt_b_data14            (sc2mac_wt_b_data14[7:0])         //|> o
  ,.sc2mac_wt_b_data15            (sc2mac_wt_b_data15[7:0])         //|> o
  ,.sc2mac_wt_b_data16            (sc2mac_wt_b_data16[7:0])         //|> o
  ,.sc2mac_wt_b_data17            (sc2mac_wt_b_data17[7:0])         //|> o
  ,.sc2mac_wt_b_data18            (sc2mac_wt_b_data18[7:0])         //|> o
  ,.sc2mac_wt_b_data19            (sc2mac_wt_b_data19[7:0])         //|> o
  ,.sc2mac_wt_b_data20            (sc2mac_wt_b_data20[7:0])         //|> o
  ,.sc2mac_wt_b_data21            (sc2mac_wt_b_data21[7:0])         //|> o
  ,.sc2mac_wt_b_data22            (sc2mac_wt_b_data22[7:0])         //|> o
  ,.sc2mac_wt_b_data23            (sc2mac_wt_b_data23[7:0])         //|> o
  ,.sc2mac_wt_b_data24            (sc2mac_wt_b_data24[7:0])         //|> o
  ,.sc2mac_wt_b_data25            (sc2mac_wt_b_data25[7:0])         //|> o
  ,.sc2mac_wt_b_data26            (sc2mac_wt_b_data26[7:0])         //|> o
  ,.sc2mac_wt_b_data27            (sc2mac_wt_b_data27[7:0])         //|> o
  ,.sc2mac_wt_b_data28            (sc2mac_wt_b_data28[7:0])         //|> o
  ,.sc2mac_wt_b_data29            (sc2mac_wt_b_data29[7:0])         //|> o
  ,.sc2mac_wt_b_data30            (sc2mac_wt_b_data30[7:0])         //|> o
  ,.sc2mac_wt_b_data31            (sc2mac_wt_b_data31[7:0])         //|> o
  ,.sc2mac_wt_b_data32            (sc2mac_wt_b_data32[7:0])         //|> o
  ,.sc2mac_wt_b_data33            (sc2mac_wt_b_data33[7:0])         //|> o
  ,.sc2mac_wt_b_data34            (sc2mac_wt_b_data34[7:0])         //|> o
  ,.sc2mac_wt_b_data35            (sc2mac_wt_b_data35[7:0])         //|> o
  ,.sc2mac_wt_b_data36            (sc2mac_wt_b_data36[7:0])         //|> o
  ,.sc2mac_wt_b_data37            (sc2mac_wt_b_data37[7:0])         //|> o
  ,.sc2mac_wt_b_data38            (sc2mac_wt_b_data38[7:0])         //|> o
  ,.sc2mac_wt_b_data39            (sc2mac_wt_b_data39[7:0])         //|> o
  ,.sc2mac_wt_b_data40            (sc2mac_wt_b_data40[7:0])         //|> o
  ,.sc2mac_wt_b_data41            (sc2mac_wt_b_data41[7:0])         //|> o
  ,.sc2mac_wt_b_data42            (sc2mac_wt_b_data42[7:0])         //|> o
  ,.sc2mac_wt_b_data43            (sc2mac_wt_b_data43[7:0])         //|> o
  ,.sc2mac_wt_b_data44            (sc2mac_wt_b_data44[7:0])         //|> o
  ,.sc2mac_wt_b_data45            (sc2mac_wt_b_data45[7:0])         //|> o
  ,.sc2mac_wt_b_data46            (sc2mac_wt_b_data46[7:0])         //|> o
  ,.sc2mac_wt_b_data47            (sc2mac_wt_b_data47[7:0])         //|> o
  ,.sc2mac_wt_b_data48            (sc2mac_wt_b_data48[7:0])         //|> o
  ,.sc2mac_wt_b_data49            (sc2mac_wt_b_data49[7:0])         //|> o
  ,.sc2mac_wt_b_data50            (sc2mac_wt_b_data50[7:0])         //|> o
  ,.sc2mac_wt_b_data51            (sc2mac_wt_b_data51[7:0])         //|> o
  ,.sc2mac_wt_b_data52            (sc2mac_wt_b_data52[7:0])         //|> o
  ,.sc2mac_wt_b_data53            (sc2mac_wt_b_data53[7:0])         //|> o
  ,.sc2mac_wt_b_data54            (sc2mac_wt_b_data54[7:0])         //|> o
  ,.sc2mac_wt_b_data55            (sc2mac_wt_b_data55[7:0])         //|> o
  ,.sc2mac_wt_b_data56            (sc2mac_wt_b_data56[7:0])         //|> o
  ,.sc2mac_wt_b_data57            (sc2mac_wt_b_data57[7:0])         //|> o
  ,.sc2mac_wt_b_data58            (sc2mac_wt_b_data58[7:0])         //|> o
  ,.sc2mac_wt_b_data59            (sc2mac_wt_b_data59[7:0])         //|> o
  ,.sc2mac_wt_b_data60            (sc2mac_wt_b_data60[7:0])         //|> o
  ,.sc2mac_wt_b_data61            (sc2mac_wt_b_data61[7:0])         //|> o
  ,.sc2mac_wt_b_data62            (sc2mac_wt_b_data62[7:0])         //|> o
  ,.sc2mac_wt_b_data63            (sc2mac_wt_b_data63[7:0])         //|> o
  ,.sc2mac_wt_b_data64            (sc2mac_wt_b_data64[7:0])         //|> o
  ,.sc2mac_wt_b_data65            (sc2mac_wt_b_data65[7:0])         //|> o
  ,.sc2mac_wt_b_data66            (sc2mac_wt_b_data66[7:0])         //|> o
  ,.sc2mac_wt_b_data67            (sc2mac_wt_b_data67[7:0])         //|> o
  ,.sc2mac_wt_b_data68            (sc2mac_wt_b_data68[7:0])         //|> o
  ,.sc2mac_wt_b_data69            (sc2mac_wt_b_data69[7:0])         //|> o
  ,.sc2mac_wt_b_data70            (sc2mac_wt_b_data70[7:0])         //|> o
  ,.sc2mac_wt_b_data71            (sc2mac_wt_b_data71[7:0])         //|> o
  ,.sc2mac_wt_b_data72            (sc2mac_wt_b_data72[7:0])         //|> o
  ,.sc2mac_wt_b_data73            (sc2mac_wt_b_data73[7:0])         //|> o
  ,.sc2mac_wt_b_data74            (sc2mac_wt_b_data74[7:0])         //|> o
  ,.sc2mac_wt_b_data75            (sc2mac_wt_b_data75[7:0])         //|> o
  ,.sc2mac_wt_b_data76            (sc2mac_wt_b_data76[7:0])         //|> o
  ,.sc2mac_wt_b_data77            (sc2mac_wt_b_data77[7:0])         //|> o
  ,.sc2mac_wt_b_data78            (sc2mac_wt_b_data78[7:0])         //|> o
  ,.sc2mac_wt_b_data79            (sc2mac_wt_b_data79[7:0])         //|> o
  ,.sc2mac_wt_b_data80            (sc2mac_wt_b_data80[7:0])         //|> o
  ,.sc2mac_wt_b_data81            (sc2mac_wt_b_data81[7:0])         //|> o
  ,.sc2mac_wt_b_data82            (sc2mac_wt_b_data82[7:0])         //|> o
  ,.sc2mac_wt_b_data83            (sc2mac_wt_b_data83[7:0])         //|> o
  ,.sc2mac_wt_b_data84            (sc2mac_wt_b_data84[7:0])         //|> o
  ,.sc2mac_wt_b_data85            (sc2mac_wt_b_data85[7:0])         //|> o
  ,.sc2mac_wt_b_data86            (sc2mac_wt_b_data86[7:0])         //|> o
  ,.sc2mac_wt_b_data87            (sc2mac_wt_b_data87[7:0])         //|> o
  ,.sc2mac_wt_b_data88            (sc2mac_wt_b_data88[7:0])         //|> o
  ,.sc2mac_wt_b_data89            (sc2mac_wt_b_data89[7:0])         //|> o
  ,.sc2mac_wt_b_data90            (sc2mac_wt_b_data90[7:0])         //|> o
  ,.sc2mac_wt_b_data91            (sc2mac_wt_b_data91[7:0])         //|> o
  ,.sc2mac_wt_b_data92            (sc2mac_wt_b_data92[7:0])         //|> o
  ,.sc2mac_wt_b_data93            (sc2mac_wt_b_data93[7:0])         //|> o
  ,.sc2mac_wt_b_data94            (sc2mac_wt_b_data94[7:0])         //|> o
  ,.sc2mac_wt_b_data95            (sc2mac_wt_b_data95[7:0])         //|> o
  ,.sc2mac_wt_b_data96            (sc2mac_wt_b_data96[7:0])         //|> o
  ,.sc2mac_wt_b_data97            (sc2mac_wt_b_data97[7:0])         //|> o
  ,.sc2mac_wt_b_data98            (sc2mac_wt_b_data98[7:0])         //|> o
  ,.sc2mac_wt_b_data99            (sc2mac_wt_b_data99[7:0])         //|> o
  ,.sc2mac_wt_b_data100           (sc2mac_wt_b_data100[7:0])        //|> o
  ,.sc2mac_wt_b_data101           (sc2mac_wt_b_data101[7:0])        //|> o
  ,.sc2mac_wt_b_data102           (sc2mac_wt_b_data102[7:0])        //|> o
  ,.sc2mac_wt_b_data103           (sc2mac_wt_b_data103[7:0])        //|> o
  ,.sc2mac_wt_b_data104           (sc2mac_wt_b_data104[7:0])        //|> o
  ,.sc2mac_wt_b_data105           (sc2mac_wt_b_data105[7:0])        //|> o
  ,.sc2mac_wt_b_data106           (sc2mac_wt_b_data106[7:0])        //|> o
  ,.sc2mac_wt_b_data107           (sc2mac_wt_b_data107[7:0])        //|> o
  ,.sc2mac_wt_b_data108           (sc2mac_wt_b_data108[7:0])        //|> o
  ,.sc2mac_wt_b_data109           (sc2mac_wt_b_data109[7:0])        //|> o
  ,.sc2mac_wt_b_data110           (sc2mac_wt_b_data110[7:0])        //|> o
  ,.sc2mac_wt_b_data111           (sc2mac_wt_b_data111[7:0])        //|> o
  ,.sc2mac_wt_b_data112           (sc2mac_wt_b_data112[7:0])        //|> o
  ,.sc2mac_wt_b_data113           (sc2mac_wt_b_data113[7:0])        //|> o
  ,.sc2mac_wt_b_data114           (sc2mac_wt_b_data114[7:0])        //|> o
  ,.sc2mac_wt_b_data115           (sc2mac_wt_b_data115[7:0])        //|> o
  ,.sc2mac_wt_b_data116           (sc2mac_wt_b_data116[7:0])        //|> o
  ,.sc2mac_wt_b_data117           (sc2mac_wt_b_data117[7:0])        //|> o
  ,.sc2mac_wt_b_data118           (sc2mac_wt_b_data118[7:0])        //|> o
  ,.sc2mac_wt_b_data119           (sc2mac_wt_b_data119[7:0])        //|> o
  ,.sc2mac_wt_b_data120           (sc2mac_wt_b_data120[7:0])        //|> o
  ,.sc2mac_wt_b_data121           (sc2mac_wt_b_data121[7:0])        //|> o
  ,.sc2mac_wt_b_data122           (sc2mac_wt_b_data122[7:0])        //|> o
  ,.sc2mac_wt_b_data123           (sc2mac_wt_b_data123[7:0])        //|> o
  ,.sc2mac_wt_b_data124           (sc2mac_wt_b_data124[7:0])        //|> o
  ,.sc2mac_wt_b_data125           (sc2mac_wt_b_data125[7:0])        //|> o
  ,.sc2mac_wt_b_data126           (sc2mac_wt_b_data126[7:0])        //|> o
  ,.sc2mac_wt_b_data127           (sc2mac_wt_b_data127[7:0])        //|> o
  ,.sc2mac_wt_b_sel               (sc2mac_wt_b_sel[7:0])            //|> o
  ,.nvdla_core_ng_clk             (nvdla_core_clk)                  //|< i
  ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
  ,.reg2dp_in_precision           (reg2dp_in_precision[1:0])        //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|< w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|< w
  ,.reg2dp_weight_reuse           (reg2dp_weight_reuse[0])          //|< w
  ,.reg2dp_skip_weight_rls        (reg2dp_skip_weight_rls[0])       //|< w
  ,.reg2dp_weight_format          (reg2dp_weight_format[0])         //|< w
  ,.reg2dp_weight_bytes           (reg2dp_weight_bytes[24:0])       //|< w
  ,.reg2dp_wmb_bytes              (reg2dp_wmb_bytes[20:0])          //|< w
  ,.reg2dp_data_bank              (reg2dp_data_bank[3:0])           //|< w
  ,.reg2dp_weight_bank            (reg2dp_weight_bank[3:0])         //|< w
  );

//==========================================================
// Data loader
//==========================================================
NV_NVDLA_CSC_dl u_dl (
   .nvdla_core_clk                (nvdla_op_gated_clk_2)            //|< w
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.sg2dl_pvld                    (sg2dl_pvld)                      //|< w
  ,.sg2dl_pd                      (sg2dl_pd[30:0])                  //|< w
  ,.sc_state                      (sc_state[1:0])                   //|< w
  ,.sg2dl_reuse_rls               (sg2dl_reuse_rls)                 //|< w
  ,.sc2cdma_dat_pending_req       (sc2cdma_dat_pending_req)         //|< o
  ,.cdma2sc_dat_updt              (cdma2sc_dat_updt)                //|< i
  ,.cdma2sc_dat_entries           (cdma2sc_dat_entries[11:0])       //|< i
  ,.cdma2sc_dat_slices            (cdma2sc_dat_slices[11:0])        //|< i
  ,.sc2cdma_dat_updt              (sc2cdma_dat_updt)                //|> o
  ,.sc2cdma_dat_entries           (sc2cdma_dat_entries[11:0])       //|> o
  ,.sc2cdma_dat_slices            (sc2cdma_dat_slices[11:0])        //|> o
  ,.sc2buf_dat_rd_en              (sc2buf_dat_rd_en)                //|> o
  ,.sc2buf_dat_rd_addr            (sc2buf_dat_rd_addr[11:0])        //|> o
  ,.sc2buf_dat_rd_valid           (sc2buf_dat_rd_valid)             //|< i
  ,.sc2buf_dat_rd_data            (sc2buf_dat_rd_data[1023:0])      //|< i
  ,.sc2mac_dat_a_pvld             (sc2mac_dat_a_pvld)               //|> o
  ,.sc2mac_dat_a_mask             (sc2mac_dat_a_mask[127:0])        //|> o
  ,.sc2mac_dat_a_data0            (sc2mac_dat_a_data0[7:0])         //|> o
  ,.sc2mac_dat_a_data1            (sc2mac_dat_a_data1[7:0])         //|> o
  ,.sc2mac_dat_a_data2            (sc2mac_dat_a_data2[7:0])         //|> o
  ,.sc2mac_dat_a_data3            (sc2mac_dat_a_data3[7:0])         //|> o
  ,.sc2mac_dat_a_data4            (sc2mac_dat_a_data4[7:0])         //|> o
  ,.sc2mac_dat_a_data5            (sc2mac_dat_a_data5[7:0])         //|> o
  ,.sc2mac_dat_a_data6            (sc2mac_dat_a_data6[7:0])         //|> o
  ,.sc2mac_dat_a_data7            (sc2mac_dat_a_data7[7:0])         //|> o
  ,.sc2mac_dat_a_data8            (sc2mac_dat_a_data8[7:0])         //|> o
  ,.sc2mac_dat_a_data9            (sc2mac_dat_a_data9[7:0])         //|> o
  ,.sc2mac_dat_a_data10           (sc2mac_dat_a_data10[7:0])        //|> o
  ,.sc2mac_dat_a_data11           (sc2mac_dat_a_data11[7:0])        //|> o
  ,.sc2mac_dat_a_data12           (sc2mac_dat_a_data12[7:0])        //|> o
  ,.sc2mac_dat_a_data13           (sc2mac_dat_a_data13[7:0])        //|> o
  ,.sc2mac_dat_a_data14           (sc2mac_dat_a_data14[7:0])        //|> o
  ,.sc2mac_dat_a_data15           (sc2mac_dat_a_data15[7:0])        //|> o
  ,.sc2mac_dat_a_data16           (sc2mac_dat_a_data16[7:0])        //|> o
  ,.sc2mac_dat_a_data17           (sc2mac_dat_a_data17[7:0])        //|> o
  ,.sc2mac_dat_a_data18           (sc2mac_dat_a_data18[7:0])        //|> o
  ,.sc2mac_dat_a_data19           (sc2mac_dat_a_data19[7:0])        //|> o
  ,.sc2mac_dat_a_data20           (sc2mac_dat_a_data20[7:0])        //|> o
  ,.sc2mac_dat_a_data21           (sc2mac_dat_a_data21[7:0])        //|> o
  ,.sc2mac_dat_a_data22           (sc2mac_dat_a_data22[7:0])        //|> o
  ,.sc2mac_dat_a_data23           (sc2mac_dat_a_data23[7:0])        //|> o
  ,.sc2mac_dat_a_data24           (sc2mac_dat_a_data24[7:0])        //|> o
  ,.sc2mac_dat_a_data25           (sc2mac_dat_a_data25[7:0])        //|> o
  ,.sc2mac_dat_a_data26           (sc2mac_dat_a_data26[7:0])        //|> o
  ,.sc2mac_dat_a_data27           (sc2mac_dat_a_data27[7:0])        //|> o
  ,.sc2mac_dat_a_data28           (sc2mac_dat_a_data28[7:0])        //|> o
  ,.sc2mac_dat_a_data29           (sc2mac_dat_a_data29[7:0])        //|> o
  ,.sc2mac_dat_a_data30           (sc2mac_dat_a_data30[7:0])        //|> o
  ,.sc2mac_dat_a_data31           (sc2mac_dat_a_data31[7:0])        //|> o
  ,.sc2mac_dat_a_data32           (sc2mac_dat_a_data32[7:0])        //|> o
  ,.sc2mac_dat_a_data33           (sc2mac_dat_a_data33[7:0])        //|> o
  ,.sc2mac_dat_a_data34           (sc2mac_dat_a_data34[7:0])        //|> o
  ,.sc2mac_dat_a_data35           (sc2mac_dat_a_data35[7:0])        //|> o
  ,.sc2mac_dat_a_data36           (sc2mac_dat_a_data36[7:0])        //|> o
  ,.sc2mac_dat_a_data37           (sc2mac_dat_a_data37[7:0])        //|> o
  ,.sc2mac_dat_a_data38           (sc2mac_dat_a_data38[7:0])        //|> o
  ,.sc2mac_dat_a_data39           (sc2mac_dat_a_data39[7:0])        //|> o
  ,.sc2mac_dat_a_data40           (sc2mac_dat_a_data40[7:0])        //|> o
  ,.sc2mac_dat_a_data41           (sc2mac_dat_a_data41[7:0])        //|> o
  ,.sc2mac_dat_a_data42           (sc2mac_dat_a_data42[7:0])        //|> o
  ,.sc2mac_dat_a_data43           (sc2mac_dat_a_data43[7:0])        //|> o
  ,.sc2mac_dat_a_data44           (sc2mac_dat_a_data44[7:0])        //|> o
  ,.sc2mac_dat_a_data45           (sc2mac_dat_a_data45[7:0])        //|> o
  ,.sc2mac_dat_a_data46           (sc2mac_dat_a_data46[7:0])        //|> o
  ,.sc2mac_dat_a_data47           (sc2mac_dat_a_data47[7:0])        //|> o
  ,.sc2mac_dat_a_data48           (sc2mac_dat_a_data48[7:0])        //|> o
  ,.sc2mac_dat_a_data49           (sc2mac_dat_a_data49[7:0])        //|> o
  ,.sc2mac_dat_a_data50           (sc2mac_dat_a_data50[7:0])        //|> o
  ,.sc2mac_dat_a_data51           (sc2mac_dat_a_data51[7:0])        //|> o
  ,.sc2mac_dat_a_data52           (sc2mac_dat_a_data52[7:0])        //|> o
  ,.sc2mac_dat_a_data53           (sc2mac_dat_a_data53[7:0])        //|> o
  ,.sc2mac_dat_a_data54           (sc2mac_dat_a_data54[7:0])        //|> o
  ,.sc2mac_dat_a_data55           (sc2mac_dat_a_data55[7:0])        //|> o
  ,.sc2mac_dat_a_data56           (sc2mac_dat_a_data56[7:0])        //|> o
  ,.sc2mac_dat_a_data57           (sc2mac_dat_a_data57[7:0])        //|> o
  ,.sc2mac_dat_a_data58           (sc2mac_dat_a_data58[7:0])        //|> o
  ,.sc2mac_dat_a_data59           (sc2mac_dat_a_data59[7:0])        //|> o
  ,.sc2mac_dat_a_data60           (sc2mac_dat_a_data60[7:0])        //|> o
  ,.sc2mac_dat_a_data61           (sc2mac_dat_a_data61[7:0])        //|> o
  ,.sc2mac_dat_a_data62           (sc2mac_dat_a_data62[7:0])        //|> o
  ,.sc2mac_dat_a_data63           (sc2mac_dat_a_data63[7:0])        //|> o
  ,.sc2mac_dat_a_data64           (sc2mac_dat_a_data64[7:0])        //|> o
  ,.sc2mac_dat_a_data65           (sc2mac_dat_a_data65[7:0])        //|> o
  ,.sc2mac_dat_a_data66           (sc2mac_dat_a_data66[7:0])        //|> o
  ,.sc2mac_dat_a_data67           (sc2mac_dat_a_data67[7:0])        //|> o
  ,.sc2mac_dat_a_data68           (sc2mac_dat_a_data68[7:0])        //|> o
  ,.sc2mac_dat_a_data69           (sc2mac_dat_a_data69[7:0])        //|> o
  ,.sc2mac_dat_a_data70           (sc2mac_dat_a_data70[7:0])        //|> o
  ,.sc2mac_dat_a_data71           (sc2mac_dat_a_data71[7:0])        //|> o
  ,.sc2mac_dat_a_data72           (sc2mac_dat_a_data72[7:0])        //|> o
  ,.sc2mac_dat_a_data73           (sc2mac_dat_a_data73[7:0])        //|> o
  ,.sc2mac_dat_a_data74           (sc2mac_dat_a_data74[7:0])        //|> o
  ,.sc2mac_dat_a_data75           (sc2mac_dat_a_data75[7:0])        //|> o
  ,.sc2mac_dat_a_data76           (sc2mac_dat_a_data76[7:0])        //|> o
  ,.sc2mac_dat_a_data77           (sc2mac_dat_a_data77[7:0])        //|> o
  ,.sc2mac_dat_a_data78           (sc2mac_dat_a_data78[7:0])        //|> o
  ,.sc2mac_dat_a_data79           (sc2mac_dat_a_data79[7:0])        //|> o
  ,.sc2mac_dat_a_data80           (sc2mac_dat_a_data80[7:0])        //|> o
  ,.sc2mac_dat_a_data81           (sc2mac_dat_a_data81[7:0])        //|> o
  ,.sc2mac_dat_a_data82           (sc2mac_dat_a_data82[7:0])        //|> o
  ,.sc2mac_dat_a_data83           (sc2mac_dat_a_data83[7:0])        //|> o
  ,.sc2mac_dat_a_data84           (sc2mac_dat_a_data84[7:0])        //|> o
  ,.sc2mac_dat_a_data85           (sc2mac_dat_a_data85[7:0])        //|> o
  ,.sc2mac_dat_a_data86           (sc2mac_dat_a_data86[7:0])        //|> o
  ,.sc2mac_dat_a_data87           (sc2mac_dat_a_data87[7:0])        //|> o
  ,.sc2mac_dat_a_data88           (sc2mac_dat_a_data88[7:0])        //|> o
  ,.sc2mac_dat_a_data89           (sc2mac_dat_a_data89[7:0])        //|> o
  ,.sc2mac_dat_a_data90           (sc2mac_dat_a_data90[7:0])        //|> o
  ,.sc2mac_dat_a_data91           (sc2mac_dat_a_data91[7:0])        //|> o
  ,.sc2mac_dat_a_data92           (sc2mac_dat_a_data92[7:0])        //|> o
  ,.sc2mac_dat_a_data93           (sc2mac_dat_a_data93[7:0])        //|> o
  ,.sc2mac_dat_a_data94           (sc2mac_dat_a_data94[7:0])        //|> o
  ,.sc2mac_dat_a_data95           (sc2mac_dat_a_data95[7:0])        //|> o
  ,.sc2mac_dat_a_data96           (sc2mac_dat_a_data96[7:0])        //|> o
  ,.sc2mac_dat_a_data97           (sc2mac_dat_a_data97[7:0])        //|> o
  ,.sc2mac_dat_a_data98           (sc2mac_dat_a_data98[7:0])        //|> o
  ,.sc2mac_dat_a_data99           (sc2mac_dat_a_data99[7:0])        //|> o
  ,.sc2mac_dat_a_data100          (sc2mac_dat_a_data100[7:0])       //|> o
  ,.sc2mac_dat_a_data101          (sc2mac_dat_a_data101[7:0])       //|> o
  ,.sc2mac_dat_a_data102          (sc2mac_dat_a_data102[7:0])       //|> o
  ,.sc2mac_dat_a_data103          (sc2mac_dat_a_data103[7:0])       //|> o
  ,.sc2mac_dat_a_data104          (sc2mac_dat_a_data104[7:0])       //|> o
  ,.sc2mac_dat_a_data105          (sc2mac_dat_a_data105[7:0])       //|> o
  ,.sc2mac_dat_a_data106          (sc2mac_dat_a_data106[7:0])       //|> o
  ,.sc2mac_dat_a_data107          (sc2mac_dat_a_data107[7:0])       //|> o
  ,.sc2mac_dat_a_data108          (sc2mac_dat_a_data108[7:0])       //|> o
  ,.sc2mac_dat_a_data109          (sc2mac_dat_a_data109[7:0])       //|> o
  ,.sc2mac_dat_a_data110          (sc2mac_dat_a_data110[7:0])       //|> o
  ,.sc2mac_dat_a_data111          (sc2mac_dat_a_data111[7:0])       //|> o
  ,.sc2mac_dat_a_data112          (sc2mac_dat_a_data112[7:0])       //|> o
  ,.sc2mac_dat_a_data113          (sc2mac_dat_a_data113[7:0])       //|> o
  ,.sc2mac_dat_a_data114          (sc2mac_dat_a_data114[7:0])       //|> o
  ,.sc2mac_dat_a_data115          (sc2mac_dat_a_data115[7:0])       //|> o
  ,.sc2mac_dat_a_data116          (sc2mac_dat_a_data116[7:0])       //|> o
  ,.sc2mac_dat_a_data117          (sc2mac_dat_a_data117[7:0])       //|> o
  ,.sc2mac_dat_a_data118          (sc2mac_dat_a_data118[7:0])       //|> o
  ,.sc2mac_dat_a_data119          (sc2mac_dat_a_data119[7:0])       //|> o
  ,.sc2mac_dat_a_data120          (sc2mac_dat_a_data120[7:0])       //|> o
  ,.sc2mac_dat_a_data121          (sc2mac_dat_a_data121[7:0])       //|> o
  ,.sc2mac_dat_a_data122          (sc2mac_dat_a_data122[7:0])       //|> o
  ,.sc2mac_dat_a_data123          (sc2mac_dat_a_data123[7:0])       //|> o
  ,.sc2mac_dat_a_data124          (sc2mac_dat_a_data124[7:0])       //|> o
  ,.sc2mac_dat_a_data125          (sc2mac_dat_a_data125[7:0])       //|> o
  ,.sc2mac_dat_a_data126          (sc2mac_dat_a_data126[7:0])       //|> o
  ,.sc2mac_dat_a_data127          (sc2mac_dat_a_data127[7:0])       //|> o
  ,.sc2mac_dat_a_pd               (sc2mac_dat_a_pd[8:0])            //|> o
  ,.sc2mac_dat_b_pvld             (sc2mac_dat_b_pvld)               //|> o
  ,.sc2mac_dat_b_mask             (sc2mac_dat_b_mask[127:0])        //|> o
  ,.sc2mac_dat_b_data0            (sc2mac_dat_b_data0[7:0])         //|> o
  ,.sc2mac_dat_b_data1            (sc2mac_dat_b_data1[7:0])         //|> o
  ,.sc2mac_dat_b_data2            (sc2mac_dat_b_data2[7:0])         //|> o
  ,.sc2mac_dat_b_data3            (sc2mac_dat_b_data3[7:0])         //|> o
  ,.sc2mac_dat_b_data4            (sc2mac_dat_b_data4[7:0])         //|> o
  ,.sc2mac_dat_b_data5            (sc2mac_dat_b_data5[7:0])         //|> o
  ,.sc2mac_dat_b_data6            (sc2mac_dat_b_data6[7:0])         //|> o
  ,.sc2mac_dat_b_data7            (sc2mac_dat_b_data7[7:0])         //|> o
  ,.sc2mac_dat_b_data8            (sc2mac_dat_b_data8[7:0])         //|> o
  ,.sc2mac_dat_b_data9            (sc2mac_dat_b_data9[7:0])         //|> o
  ,.sc2mac_dat_b_data10           (sc2mac_dat_b_data10[7:0])        //|> o
  ,.sc2mac_dat_b_data11           (sc2mac_dat_b_data11[7:0])        //|> o
  ,.sc2mac_dat_b_data12           (sc2mac_dat_b_data12[7:0])        //|> o
  ,.sc2mac_dat_b_data13           (sc2mac_dat_b_data13[7:0])        //|> o
  ,.sc2mac_dat_b_data14           (sc2mac_dat_b_data14[7:0])        //|> o
  ,.sc2mac_dat_b_data15           (sc2mac_dat_b_data15[7:0])        //|> o
  ,.sc2mac_dat_b_data16           (sc2mac_dat_b_data16[7:0])        //|> o
  ,.sc2mac_dat_b_data17           (sc2mac_dat_b_data17[7:0])        //|> o
  ,.sc2mac_dat_b_data18           (sc2mac_dat_b_data18[7:0])        //|> o
  ,.sc2mac_dat_b_data19           (sc2mac_dat_b_data19[7:0])        //|> o
  ,.sc2mac_dat_b_data20           (sc2mac_dat_b_data20[7:0])        //|> o
  ,.sc2mac_dat_b_data21           (sc2mac_dat_b_data21[7:0])        //|> o
  ,.sc2mac_dat_b_data22           (sc2mac_dat_b_data22[7:0])        //|> o
  ,.sc2mac_dat_b_data23           (sc2mac_dat_b_data23[7:0])        //|> o
  ,.sc2mac_dat_b_data24           (sc2mac_dat_b_data24[7:0])        //|> o
  ,.sc2mac_dat_b_data25           (sc2mac_dat_b_data25[7:0])        //|> o
  ,.sc2mac_dat_b_data26           (sc2mac_dat_b_data26[7:0])        //|> o
  ,.sc2mac_dat_b_data27           (sc2mac_dat_b_data27[7:0])        //|> o
  ,.sc2mac_dat_b_data28           (sc2mac_dat_b_data28[7:0])        //|> o
  ,.sc2mac_dat_b_data29           (sc2mac_dat_b_data29[7:0])        //|> o
  ,.sc2mac_dat_b_data30           (sc2mac_dat_b_data30[7:0])        //|> o
  ,.sc2mac_dat_b_data31           (sc2mac_dat_b_data31[7:0])        //|> o
  ,.sc2mac_dat_b_data32           (sc2mac_dat_b_data32[7:0])        //|> o
  ,.sc2mac_dat_b_data33           (sc2mac_dat_b_data33[7:0])        //|> o
  ,.sc2mac_dat_b_data34           (sc2mac_dat_b_data34[7:0])        //|> o
  ,.sc2mac_dat_b_data35           (sc2mac_dat_b_data35[7:0])        //|> o
  ,.sc2mac_dat_b_data36           (sc2mac_dat_b_data36[7:0])        //|> o
  ,.sc2mac_dat_b_data37           (sc2mac_dat_b_data37[7:0])        //|> o
  ,.sc2mac_dat_b_data38           (sc2mac_dat_b_data38[7:0])        //|> o
  ,.sc2mac_dat_b_data39           (sc2mac_dat_b_data39[7:0])        //|> o
  ,.sc2mac_dat_b_data40           (sc2mac_dat_b_data40[7:0])        //|> o
  ,.sc2mac_dat_b_data41           (sc2mac_dat_b_data41[7:0])        //|> o
  ,.sc2mac_dat_b_data42           (sc2mac_dat_b_data42[7:0])        //|> o
  ,.sc2mac_dat_b_data43           (sc2mac_dat_b_data43[7:0])        //|> o
  ,.sc2mac_dat_b_data44           (sc2mac_dat_b_data44[7:0])        //|> o
  ,.sc2mac_dat_b_data45           (sc2mac_dat_b_data45[7:0])        //|> o
  ,.sc2mac_dat_b_data46           (sc2mac_dat_b_data46[7:0])        //|> o
  ,.sc2mac_dat_b_data47           (sc2mac_dat_b_data47[7:0])        //|> o
  ,.sc2mac_dat_b_data48           (sc2mac_dat_b_data48[7:0])        //|> o
  ,.sc2mac_dat_b_data49           (sc2mac_dat_b_data49[7:0])        //|> o
  ,.sc2mac_dat_b_data50           (sc2mac_dat_b_data50[7:0])        //|> o
  ,.sc2mac_dat_b_data51           (sc2mac_dat_b_data51[7:0])        //|> o
  ,.sc2mac_dat_b_data52           (sc2mac_dat_b_data52[7:0])        //|> o
  ,.sc2mac_dat_b_data53           (sc2mac_dat_b_data53[7:0])        //|> o
  ,.sc2mac_dat_b_data54           (sc2mac_dat_b_data54[7:0])        //|> o
  ,.sc2mac_dat_b_data55           (sc2mac_dat_b_data55[7:0])        //|> o
  ,.sc2mac_dat_b_data56           (sc2mac_dat_b_data56[7:0])        //|> o
  ,.sc2mac_dat_b_data57           (sc2mac_dat_b_data57[7:0])        //|> o
  ,.sc2mac_dat_b_data58           (sc2mac_dat_b_data58[7:0])        //|> o
  ,.sc2mac_dat_b_data59           (sc2mac_dat_b_data59[7:0])        //|> o
  ,.sc2mac_dat_b_data60           (sc2mac_dat_b_data60[7:0])        //|> o
  ,.sc2mac_dat_b_data61           (sc2mac_dat_b_data61[7:0])        //|> o
  ,.sc2mac_dat_b_data62           (sc2mac_dat_b_data62[7:0])        //|> o
  ,.sc2mac_dat_b_data63           (sc2mac_dat_b_data63[7:0])        //|> o
  ,.sc2mac_dat_b_data64           (sc2mac_dat_b_data64[7:0])        //|> o
  ,.sc2mac_dat_b_data65           (sc2mac_dat_b_data65[7:0])        //|> o
  ,.sc2mac_dat_b_data66           (sc2mac_dat_b_data66[7:0])        //|> o
  ,.sc2mac_dat_b_data67           (sc2mac_dat_b_data67[7:0])        //|> o
  ,.sc2mac_dat_b_data68           (sc2mac_dat_b_data68[7:0])        //|> o
  ,.sc2mac_dat_b_data69           (sc2mac_dat_b_data69[7:0])        //|> o
  ,.sc2mac_dat_b_data70           (sc2mac_dat_b_data70[7:0])        //|> o
  ,.sc2mac_dat_b_data71           (sc2mac_dat_b_data71[7:0])        //|> o
  ,.sc2mac_dat_b_data72           (sc2mac_dat_b_data72[7:0])        //|> o
  ,.sc2mac_dat_b_data73           (sc2mac_dat_b_data73[7:0])        //|> o
  ,.sc2mac_dat_b_data74           (sc2mac_dat_b_data74[7:0])        //|> o
  ,.sc2mac_dat_b_data75           (sc2mac_dat_b_data75[7:0])        //|> o
  ,.sc2mac_dat_b_data76           (sc2mac_dat_b_data76[7:0])        //|> o
  ,.sc2mac_dat_b_data77           (sc2mac_dat_b_data77[7:0])        //|> o
  ,.sc2mac_dat_b_data78           (sc2mac_dat_b_data78[7:0])        //|> o
  ,.sc2mac_dat_b_data79           (sc2mac_dat_b_data79[7:0])        //|> o
  ,.sc2mac_dat_b_data80           (sc2mac_dat_b_data80[7:0])        //|> o
  ,.sc2mac_dat_b_data81           (sc2mac_dat_b_data81[7:0])        //|> o
  ,.sc2mac_dat_b_data82           (sc2mac_dat_b_data82[7:0])        //|> o
  ,.sc2mac_dat_b_data83           (sc2mac_dat_b_data83[7:0])        //|> o
  ,.sc2mac_dat_b_data84           (sc2mac_dat_b_data84[7:0])        //|> o
  ,.sc2mac_dat_b_data85           (sc2mac_dat_b_data85[7:0])        //|> o
  ,.sc2mac_dat_b_data86           (sc2mac_dat_b_data86[7:0])        //|> o
  ,.sc2mac_dat_b_data87           (sc2mac_dat_b_data87[7:0])        //|> o
  ,.sc2mac_dat_b_data88           (sc2mac_dat_b_data88[7:0])        //|> o
  ,.sc2mac_dat_b_data89           (sc2mac_dat_b_data89[7:0])        //|> o
  ,.sc2mac_dat_b_data90           (sc2mac_dat_b_data90[7:0])        //|> o
  ,.sc2mac_dat_b_data91           (sc2mac_dat_b_data91[7:0])        //|> o
  ,.sc2mac_dat_b_data92           (sc2mac_dat_b_data92[7:0])        //|> o
  ,.sc2mac_dat_b_data93           (sc2mac_dat_b_data93[7:0])        //|> o
  ,.sc2mac_dat_b_data94           (sc2mac_dat_b_data94[7:0])        //|> o
  ,.sc2mac_dat_b_data95           (sc2mac_dat_b_data95[7:0])        //|> o
  ,.sc2mac_dat_b_data96           (sc2mac_dat_b_data96[7:0])        //|> o
  ,.sc2mac_dat_b_data97           (sc2mac_dat_b_data97[7:0])        //|> o
  ,.sc2mac_dat_b_data98           (sc2mac_dat_b_data98[7:0])        //|> o
  ,.sc2mac_dat_b_data99           (sc2mac_dat_b_data99[7:0])        //|> o
  ,.sc2mac_dat_b_data100          (sc2mac_dat_b_data100[7:0])       //|> o
  ,.sc2mac_dat_b_data101          (sc2mac_dat_b_data101[7:0])       //|> o
  ,.sc2mac_dat_b_data102          (sc2mac_dat_b_data102[7:0])       //|> o
  ,.sc2mac_dat_b_data103          (sc2mac_dat_b_data103[7:0])       //|> o
  ,.sc2mac_dat_b_data104          (sc2mac_dat_b_data104[7:0])       //|> o
  ,.sc2mac_dat_b_data105          (sc2mac_dat_b_data105[7:0])       //|> o
  ,.sc2mac_dat_b_data106          (sc2mac_dat_b_data106[7:0])       //|> o
  ,.sc2mac_dat_b_data107          (sc2mac_dat_b_data107[7:0])       //|> o
  ,.sc2mac_dat_b_data108          (sc2mac_dat_b_data108[7:0])       //|> o
  ,.sc2mac_dat_b_data109          (sc2mac_dat_b_data109[7:0])       //|> o
  ,.sc2mac_dat_b_data110          (sc2mac_dat_b_data110[7:0])       //|> o
  ,.sc2mac_dat_b_data111          (sc2mac_dat_b_data111[7:0])       //|> o
  ,.sc2mac_dat_b_data112          (sc2mac_dat_b_data112[7:0])       //|> o
  ,.sc2mac_dat_b_data113          (sc2mac_dat_b_data113[7:0])       //|> o
  ,.sc2mac_dat_b_data114          (sc2mac_dat_b_data114[7:0])       //|> o
  ,.sc2mac_dat_b_data115          (sc2mac_dat_b_data115[7:0])       //|> o
  ,.sc2mac_dat_b_data116          (sc2mac_dat_b_data116[7:0])       //|> o
  ,.sc2mac_dat_b_data117          (sc2mac_dat_b_data117[7:0])       //|> o
  ,.sc2mac_dat_b_data118          (sc2mac_dat_b_data118[7:0])       //|> o
  ,.sc2mac_dat_b_data119          (sc2mac_dat_b_data119[7:0])       //|> o
  ,.sc2mac_dat_b_data120          (sc2mac_dat_b_data120[7:0])       //|> o
  ,.sc2mac_dat_b_data121          (sc2mac_dat_b_data121[7:0])       //|> o
  ,.sc2mac_dat_b_data122          (sc2mac_dat_b_data122[7:0])       //|> o
  ,.sc2mac_dat_b_data123          (sc2mac_dat_b_data123[7:0])       //|> o
  ,.sc2mac_dat_b_data124          (sc2mac_dat_b_data124[7:0])       //|> o
  ,.sc2mac_dat_b_data125          (sc2mac_dat_b_data125[7:0])       //|> o
  ,.sc2mac_dat_b_data126          (sc2mac_dat_b_data126[7:0])       //|> o
  ,.sc2mac_dat_b_data127          (sc2mac_dat_b_data127[7:0])       //|> o
  ,.sc2mac_dat_b_pd               (sc2mac_dat_b_pd[8:0])            //|> o
  ,.nvdla_core_ng_clk             (nvdla_core_clk)                  //|< i
  ,.nvdla_wg_clk                  (nvdla_wg_gated_clk)              //|< w
  ,.reg2dp_op_en                  (reg2dp_op_en[0])                 //|< w
  ,.reg2dp_conv_mode              (reg2dp_conv_mode[0])             //|< w
  ,.reg2dp_batches                (reg2dp_batches[4:0])             //|< w
  ,.reg2dp_proc_precision         (reg2dp_proc_precision[1:0])      //|< w
  ,.reg2dp_datain_format          (reg2dp_datain_format[0])         //|< w
  ,.reg2dp_skip_data_rls          (reg2dp_skip_data_rls[0])         //|< w
  ,.reg2dp_datain_channel_ext     (reg2dp_datain_channel_ext[12:0]) //|< w
  ,.reg2dp_datain_height_ext      (reg2dp_datain_height_ext[12:0])  //|< w
  ,.reg2dp_datain_width_ext       (reg2dp_datain_width_ext[12:0])   //|< w
  ,.reg2dp_y_extension            (reg2dp_y_extension[1:0])         //|< w
  ,.reg2dp_weight_channel_ext     (reg2dp_weight_channel_ext[12:0]) //|< w
  ,.reg2dp_entries                (reg2dp_entries[11:0])            //|< w
  ,.reg2dp_dataout_width          (reg2dp_dataout_width[12:0])      //|< w
  ,.reg2dp_rls_slices             (reg2dp_rls_slices[11:0])         //|< w
  ,.reg2dp_conv_x_stride_ext      (reg2dp_conv_x_stride_ext[2:0])   //|< w
  ,.reg2dp_conv_y_stride_ext      (reg2dp_conv_y_stride_ext[2:0])   //|< w
  ,.reg2dp_x_dilation_ext         (reg2dp_x_dilation_ext[4:0])      //|< w
  ,.reg2dp_y_dilation_ext         (reg2dp_y_dilation_ext[4:0])      //|< w
  ,.reg2dp_pad_left               (reg2dp_pad_left[4:0])            //|< w
  ,.reg2dp_pad_top                (reg2dp_pad_top[4:0])             //|< w
  ,.reg2dp_pad_value              (reg2dp_pad_value[15:0])          //|< w
  ,.reg2dp_data_bank              (reg2dp_data_bank[3:0])           //|< w
  ,.reg2dp_pra_truncate           (reg2dp_pra_truncate[1:0])        //|< w
  ,.slcg_wg_en                    (slcg_wg_en)                      //|> w
  );

//==========================================================
// SLCG groups
//==========================================================

NV_NVDLA_CSC_slcg u_slcg_op_0 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[0])                   //|< w
  ,.slcg_en_src_1                 (1'b1)                            //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_0)            //|> w
  );


NV_NVDLA_CSC_slcg u_slcg_op_1 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[1])                   //|< w
  ,.slcg_en_src_1                 (1'b1)                            //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_1)            //|> w
  );


NV_NVDLA_CSC_slcg u_slcg_op_2 (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[2])                   //|< w
  ,.slcg_en_src_1                 (1'b1)                            //|< ?
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_op_gated_clk_2)            //|> w
  );


NV_NVDLA_CSC_slcg u_slcg_wg (
   .dla_clk_ovr_on_sync           (dla_clk_ovr_on_sync)             //|< i
  ,.global_clk_ovr_on_sync        (global_clk_ovr_on_sync)          //|< i
  ,.nvdla_core_clk                (nvdla_core_clk)                  //|< i
  ,.nvdla_core_rstn               (nvdla_core_rstn)                 //|< i
  ,.slcg_en_src_0                 (slcg_op_en[3])                   //|< w
  ,.slcg_en_src_1                 (slcg_wg_en)                      //|< w
  ,.tmc2slcg_disable_clock_gating (tmc2slcg_disable_clock_gating)   //|< i
  ,.nvdla_core_gated_clk          (nvdla_wg_gated_clk)              //|> w
  );

// //==========================================================
// // OBS connection
// //==========================================================
// assign obs_bus_csc_slcg_op_en = slcg_op_en;
// assign obs_bus_csc_slcg_wg_en = slcg_wg_en;

////////////////////////////////////////////////////////////////////////
//  dangle not connected signals                                      //
////////////////////////////////////////////////////////////////////////



`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML 
// spyglass disable_block STARC-2.10.3.2a 
// spyglass disable_block STARC05-2.1.3.1 
// spyglass disable_block STARC-2.1.4.6 
// spyglass disable_block W116 
// spyglass disable_block W154 
// spyglass disable_block W239 
// spyglass disable_block W362 
// spyglass disable_block WRN_58 
// spyglass disable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
  // VCS coverage off 
  nv_assert_never #(0,0,"Config error! input kernel size and output data channel are not match!")      zzz_assert_never_1x (nvdla_core_clk, `ASSERT_RESET, (reg2dp_op_en & (reg2dp_dataout_channel != reg2dp_weight_kernel))); // spyglass disable W504 SelfDeterminedExpr-ML 
  // VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML 
// spyglass enable_block STARC-2.10.3.2a 
// spyglass enable_block STARC05-2.1.3.1 
// spyglass enable_block STARC-2.1.4.6 
// spyglass enable_block W116 
// spyglass enable_block W154 
// spyglass enable_block W239 
// spyglass enable_block W362 
// spyglass enable_block WRN_58 
// spyglass enable_block WRN_61 
`endif // SPYGLASS_ASSERT_ON

endmodule // NV_NVDLA_csc


