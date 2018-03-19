`ifndef _SURFACE_GENERATOR_PKG_SV_
`define _SURFACE_GENERATOR_PKG_SV_


//-------------------------------------------------------------------------------------
//
// PACKAGE: nvdla_resources_pkg
//
//-------------------------------------------------------------------------------------
package surface_generator_pkg;
    import uvm_pkg::*;

    typedef enum { INT8=0, INT16=1, FLOAT16=2 } precision_e;

    typedef struct {    string name; 
                        int unsigned width=1; int unsigned height=1;int unsigned channel=1; int unsigned batch=1;
                        int unsigned line_stride; int unsigned surface_stride; int unsigned batch_stride;
                        int unsigned atomic_memory=8; int unsigned component_per_element=1;
                        precision_e precision=INT8;
                        string pattern="random";
                        int unsigned none_zero_rate=100;
                        int unsigned fp_nan_enabled=1; int unsigned fp_inf_enabled=1;
    } surface_feature_config;

    typedef struct {    string weight_name; string weight_mask_name; string weight_group_size_name;
                        int unsigned width;int unsigned height;int unsigned channel;int unsigned kernel;
                        int unsigned atomic_channel=8;
                        int unsigned atomic_kernel=8;
                        int unsigned cbuf_entry_byte_size=8;
                        precision_e precision=INT8;
                        string pattern="random";
                        int unsigned comp_en;
                        int unsigned none_zero_rate;
                        int unsigned fp_enabled=0; int unsigned fp_nan_enabled=0; int unsigned fp_inf_enabled=1;
    } surface_weight_config;

    typedef struct {    string name; 
                        int unsigned width=1; int unsigned height=1;int unsigned channel=1;
                        int unsigned line_stride_0; int unsigned line_stride_1;
                        int unsigned atomic_memory=8; int unsigned offset_x=0;
                        precision_e precision=INT8;
                        string pixel_format_name="T_A8R8G8B8";
                        string pattern="random";
                        int unsigned none_zero_rate=100;
                        int unsigned fp_nan_enabled=1; int unsigned fp_inf_enabled=1;
    } surface_image_pitch_config;

    `include "surface_generator.sv"

endpackage : surface_generator_pkg

`endif // _SURFACE_GENERATOR_PKG_SV_
