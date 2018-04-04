`ifndef _NVDLA_RESOURCE_DEFINE_SV_
`define _NVDLA_RESOURCE_DEFINE_SV_

`define NEVER_BE_ACTIVE                 -1
`define ADDRMAP_NVDLA_PIO_INSTANCE_PATH ""

parameter NVDLA_CBUF_ENTRY_BYTE_WIDTH = (`NVDLA_CBUF_ENTRY_WIDTH/8);

// Import FP function DPI
import "DPI-C" function chandle new_FP16();
import "DPI-C" function chandle new_FP17();
import "DPI-C" function chandle new_FP32();
import "DPI-C" function void set_FP16(chandle input_a, input  bit [15:0] value);
import "DPI-C" function void get_FP16(chandle input_a, output bit [15:0] value);
import "DPI-C" function void set_FP17(chandle input_a, input  bit [16:0] value);
import "DPI-C" function void get_FP17(chandle input_a, output bit [16:0] value);
import "DPI-C" function void set_FP32(chandle input_a, input  bit [31:0] value);
import "DPI-C" function void get_FP32(chandle input_a, output bit [31:0] value);
import "DPI-C" function void Fp16To17_ref(chandle input_a, chandle result_a);
import "DPI-C" function void FpMul_FP17_ref(chandle input_a, chandle input_b, chandle result_a);
import "DPI-C" function void FpAdd_FP32_ref(chandle input_a, chandle input_b, chandle result_a);
import "DPI-C" function void FpIntToFloat_ref(input bit [15:0] input_a, chandle result_a);

// Weight distribute macros for constriant
`define weight_dist_32bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [32'h0:32'hFF]:/w0, [32'h100:32'hFFFF]:/w1, [32'h1_0000:32'hFFFE_FFFF]:/w2, [32'hFFFF_0000:32'hFFFF_FEFF]:/w3, [32'hFFFF_FF00:32'hFFFF_FFFF]:/w4};

`define weight_dist_27bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [27'h0:27'hFF]:/w0, [27'h100:27'hFFFF]:/w1, [27'h1_0000:27'h7FE_FFFF]:/w2, [27'h7FF_0000:27'h7FF_FEFF]:/w3, [27'h7FF_FF00:27'h7FF_FFFF]:/w4};

`define weight_dist_25bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [25'h0:25'hFF]:/w0, [25'h100:25'hFFFF]:/w1, [25'h1_0000:25'h1FE_FFFF]:/w2, [25'h1FF_0000:25'h1FF_FEFF]:/w3, [25'h1FF_FF00:25'h1FF_FFFF]:/w4};

`define weight_dist_21bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [21'h0:21'hFF]:/w0, [21'h100:21'hFFFF]:/w1, [21'h1_0000:21'h1E_FFFF]:/w2, [21'h1F_0000:21'h1F_FEFF]:/w3, [21'h1F_FF00:21'h1F_FFFF]:/w4};

`define weight_dist_19bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [19'h0:19'hFF]:/w0, [19'h100:19'hFFFF]:/w1, [19'h1_0000:19'h6_FFFF]:/w2, [19'h7_0000:19'h7_FEFF]:/w3, [19'h7_FF00:19'h7_FFFF]:/w4};

`define weight_dist_18bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [18'h0:18'hFF]:/w0, [18'h100:18'hFFFF]:/w1, [18'h1_0000:18'h2_FFFF]:/w2, [18'h3_0000:18'h3_FEFF]:/w3, [18'h3_FF00:18'h3_FFFF]:/w4};

`define weight_dist_17bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [17'h0:17'hFF]:/w0, [17'h100:17'hFFF]:/w1, [17'h1000:17'h1_EFFF]:/w2, [17'h1_F000:17'h1_FEFF]:/w3, [17'h1_FF00:17'h1_FFFF]:/w4};

`define weight_dist_16bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [16'h0:16'hFF]:/w0, [16'h100:16'hFFF]:/w1, [16'h1000:16'hEFFF]:/w2, [16'hF000:16'hFEFF]:/w3, [16'hFF00:16'hFFFF]:/w4};

`define weight_dist_14bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [14'h0:14'hF]:/w0, [14'h10:14'hFF]:/w1, [14'h100:14'h1EFF]:/w2, [14'h1F00:14'h1FEF]:/w3, [14'h1FF0:14'h1FFF]:/w4};

`define weight_dist_13bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [13'h0:13'hF]:/w0, [13'h10:13'hFF]:/w1, [13'h100:13'h1EFF]:/w2, [13'h1F00:13'h1FEF]:/w3, [13'h1FF0:13'h1FFF]:/w4};

`define weight_dist_12bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [12'h0:12'hF]:/w0, [12'h10:12'hFF]:/w1, [12'h100:12'hEFF]:/w2, [12'hF00:12'hFEF]:/w3, [12'hFF0:12'hFFF]:/w4};

`define weight_dist_10bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [10'h0:10'hF]:/w0, [10'h10:10'hFF]:/w1, [10'h100:10'h2FF]:/w2, [10'h300:10'h37F]:/w3, [10'h380:10'h3FF]:/w4};

`define weight_dist_8bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [8'h0:8'hF]:/w0, [8'h10:8'h3F]:/w1, [8'h40:8'hBF]:/w2, [8'hC0:8'hEF]:/w3, [8'hF0:8'hFF]:/w4};

`define weight_dist_6bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [6'h0:6'h7]:/w0, [6'h8:6'hF]:/w1, [6'h10:6'h2F]:/w2, [6'h30:6'h37]:/w3, [6'h38:6'h3F]:/w4};

`define weight_dist_5bit(data, w0=5, w1=25, w2=40, w3=25, w4=5) \
    data dist { [5'h0:5'h3]:/w0, [5'h4:5'hB]:/w1, [5'hC:5'h13]:/w2, [5'h14:5'h1B]:/w3, [5'h1C:5'h1F]:/w4};

`endif //_NVDLA_RESOURCE_DEFINE_SV_
