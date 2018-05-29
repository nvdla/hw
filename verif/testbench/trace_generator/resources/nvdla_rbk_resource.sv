`ifndef _NVDLA_RBK_RESOURCE_SV_
`define _NVDLA_RBK_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_rbk_resource
//
// @description: various hardware resources of rbk sub module
//-------------------------------------------------------------------------------------

class nvdla_rbk_resource extends nvdla_base_resource;

    // enum define
    //:| import spec2constrain
    //:| global spec2cons
    //:| spec2cons = spec2constrain.Spec2Cons()
    //:| spec2cons.enum_gen(['NVDLA_RBK'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    typedef enum{ rubik_mode_CONTRACT              = 'h0
                 ,rubik_mode_SPLIT                 = 'h1
                 ,rubik_mode_MERGE                 = 'h2
                } rubik_mode_t;
    typedef enum{ in_precision_INT8                = 'h0
                 ,in_precision_INT16               = 'h1
                 ,in_precision_FP16                = 'h2
                } in_precision_t;
    typedef enum{ datain_ram_type_CVIF             = 'h0
                 ,datain_ram_type_MCIF             = 'h1
                } datain_ram_type_t;
    typedef enum{ dataout_ram_type_CVIF            = 'h0
                 ,dataout_ram_type_MCIF            = 'h1
                } dataout_ram_type_t;
    //:) epython: generated_end (DO NOT EDIT ABOVE)
    
    // field variables
    //:| spec2cons.state_gen(['NVDLA_RBK'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    rand rubik_mode_t               rubik_mode;
    rand in_precision_t             in_precision;
    rand datain_ram_type_t          datain_ram_type;
    rand bit [12:0]                 datain_width;
    rand bit [12:0]                 datain_height;
    rand bit [12:0]                 datain_channel;
    rand bit [31:0]                 dain_addr_high;
    rand bit [26:0]                 dain_addr_low;
    rand bit [26:0]                 dain_line_stride;
    rand bit [26:0]                 dain_surf_stride;
    rand bit [26:0]                 dain_planar_stride;
    rand dataout_ram_type_t         dataout_ram_type;
    rand bit [12:0]                 dataout_channel;
    rand bit [31:0]                 daout_addr_high;
    rand bit [26:0]                 daout_addr_low;
    rand bit [26:0]                 daout_line_stride;
    rand bit [26:0]                 contract_stride_0;
    rand bit [26:0]                 contract_stride_1;
    rand bit [26:0]                 daout_surf_stride;
    rand bit [26:0]                 daout_planar_stride;
    rand bit [4:0]                  deconv_x_stride;
    rand bit [4:0]                  deconv_y_stride;
    rand bit [0:0]                  perf_en;
    //:) epython: generated_end (DO NOT EDIT ABOVE)

    `uvm_component_utils_begin(nvdla_rbk_resource)
        //:| spec2cons.macro_gen(['NVDLA_RBK'])
        //:) epython: generated_beg (DO NOT EDIT BELOW)
        `uvm_field_enum(rubik_mode_t,             rubik_mode,          UVM_ALL_ON)
        `uvm_field_enum(in_precision_t,           in_precision,        UVM_ALL_ON)
        `uvm_field_enum(datain_ram_type_t,        datain_ram_type,     UVM_ALL_ON)
        `uvm_field_int(datain_width,                                   UVM_ALL_ON)
        `uvm_field_int(datain_height,                                  UVM_ALL_ON)
        `uvm_field_int(datain_channel,                                 UVM_ALL_ON)
        `uvm_field_int(dain_addr_high,                                 UVM_ALL_ON)
        `uvm_field_int(dain_addr_low,                                  UVM_ALL_ON)
        `uvm_field_int(dain_line_stride,                               UVM_ALL_ON)
        `uvm_field_int(dain_surf_stride,                               UVM_ALL_ON)
        `uvm_field_int(dain_planar_stride,                             UVM_ALL_ON)
        `uvm_field_enum(dataout_ram_type_t,       dataout_ram_type,    UVM_ALL_ON)
        `uvm_field_int(dataout_channel,                                UVM_ALL_ON)
        `uvm_field_int(daout_addr_high,                                UVM_ALL_ON)
        `uvm_field_int(daout_addr_low,                                 UVM_ALL_ON)
        `uvm_field_int(daout_line_stride,                              UVM_ALL_ON)
        `uvm_field_int(contract_stride_0,                              UVM_ALL_ON)
        `uvm_field_int(contract_stride_1,                              UVM_ALL_ON)
        `uvm_field_int(daout_surf_stride,                              UVM_ALL_ON)
        `uvm_field_int(daout_planar_stride,                            UVM_ALL_ON)
        `uvm_field_int(deconv_x_stride,                                UVM_ALL_ON)
        `uvm_field_int(deconv_y_stride,                                UVM_ALL_ON)
        `uvm_field_int(perf_en,                                        UVM_ALL_ON)
        //:) epython: generated_end (DO NOT EDIT ABOVE)
    `uvm_component_utils_end

    /*
        Methods
    */
    extern function         new(string name="nvdla_rbk_resource", uvm_component parent);
    extern function void    trace_dump(int fh);
    extern function void    set_register();
    extern function void    post_randomize();

    /*
        constraints: 
            * ias_constraint: mandatory constraints from architecture requirement
            * sim_constraint: optional constraints for simulation only
    */
    // ias constraint
    extern constraint c_ias_channel_size;
    extern constraint c_ias_stride_size;    
    // sim constraint
    extern constraint c_sim_datain_dist;
    extern constraint c_sim_cube_size_small;    

endclass : nvdla_rbk_resource

function nvdla_rbk_resource::new(string name="nvdla_rbk_resource", uvm_component parent);
    super.new(name, parent);
    `uvm_info(inst_name, $sformatf("Initialize resource %s ... ",inst_name),UVM_LOW);
endfunction: new

function void nvdla_rbk_resource::trace_dump(int fh);
    if(fh==null) begin
        `uvm_fatal(inst_name, "Null handle of trace file ...")
    end
    `uvm_info(inst_name, "Start trace dumping ...", UVM_HIGH)
    // if both groups have been used, resource must wait for the group released
    if (get_active_cnt() > 1) begin
        sync_wait(fh,inst_name,sync_evt_queue[-2]);
    end
    
    reg_write(fh,{inst_name.toupper(),".S_POINTER"},group_to_use);
    
    begin
        uvm_reg        reg_q[$];
        uvm_reg_data_t val;
        uvm_status_e   status;
        
        ral.nvdla.NVDLA_RBK.get_registers(reg_q);
        reg_q.shuffle();
        foreach(reg_q[i]) begin
            if(reg_q[i].get_rights() != "RW") begin
                continue;
            end
            case(reg_q[i].get_name())
                "D_OP_ENABLE",
                "S_POINTER": ;
                default: reg_write(fh,{inst_name.toupper(),".",reg_q[i].get_name()},int'(reg_q[i].get()));
            endcase
        end
    end
    ral.nvdla.NVDLA_RBK.D_OP_ENABLE.set(1);
    reg_write(fh,{inst_name.toupper(),".D_OP_ENABLE"},1);
    intr_notify(fh,{"RUBIK_",$sformatf("%0d",group_to_use)}, sync_evt_queue[0]);
    `uvm_info(inst_name, "Finish trace dumping ...", UVM_HIGH)
endfunction : trace_dump

constraint nvdla_rbk_resource::c_ias_channel_size {
    //bug 200260831
    if (rubik_mode == rubik_mode_CONTRACT) {
	    ((dataout_channel+1)*(deconv_x_stride+1)*(deconv_y_stride+1)) == (datain_channel+1);
	} else {
	    dataout_channel == datain_channel;
	}

    if (rubik_mode == rubik_mode_CONTRACT) {
        ((datain_channel+1)*((in_precision == in_precision_INT8)?1:2) % (32*(deconv_x_stride+1)*(deconv_y_stride+1))) == 0;
    }
}

constraint nvdla_rbk_resource::c_ias_stride_size {        
    if (rubik_mode == rubik_mode_MERGE) {
        (dain_line_stride*32 - (datain_width+1)*((in_precision == in_precision_INT8)?1:2)) >= 0; 
        (dain_line_stride*32 - (datain_width+1)*((in_precision == in_precision_INT8)?1:2)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5}; 
        dain_line_stride % 2 == 0;
    } else { 
        (dain_line_stride*32 - (datain_width+1)*32) >= 0; 
        (dain_line_stride*32 - (datain_width+1)*32) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5}; 
    }
    
    if (rubik_mode == rubik_mode_CONTRACT || rubik_mode == rubik_mode_SPLIT) {
        (dain_surf_stride - dain_line_stride*(datain_height+1)) >= 0;
        (dain_surf_stride - dain_line_stride*(datain_height+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    }

	if (rubik_mode == rubik_mode_CONTRACT) {
	    contract_stride_0 == (dain_surf_stride*(datain_channel+1)*((in_precision==in_precision_INT8)?1:2)/((deconv_x_stride+1)*(deconv_y_stride+1)*32));
	}

    if (rubik_mode == rubik_mode_MERGE) {
        (dain_planar_stride - dain_line_stride*(datain_height+1)) >= 0;
        (dain_planar_stride - dain_line_stride*(datain_height+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
        dain_planar_stride % 2 == 0;
    }

    /*
     CONTRACT MODE:
     dataout_width   = datain_width * deconv_x_stride
     dataout_height  = datain_height * deconv_y_stride
     dataout_channel = datain_channel / (deconv_x_stride * deconv_y_stride)
     bug 200270306:
     deconv_x_stride * datain_width <= 8192
     */
    if (rubik_mode == rubik_mode_CONTRACT) {
        (daout_line_stride*32 - (datain_width+1)*(deconv_x_stride+1)*32) >= 0; 
        (daout_line_stride*32 - (datain_width+1)*(deconv_x_stride+1)*32) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5}; 
        //bug 200270306:
        ((deconv_x_stride+1)*(datain_width+1)) <= 8192;
    }
    else if (rubik_mode == rubik_mode_MERGE) {
        (daout_line_stride*32 - (datain_width+1)*32) >= 0; 
        (daout_line_stride*32 - (datain_width+1)*32) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5}; 
    }
    else {
        (daout_line_stride*32 - (datain_width+1)*((in_precision == in_precision_INT8)?1:2)) >= 0; 
        (daout_line_stride*32 - (datain_width+1)*((in_precision == in_precision_INT8)?1:2)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5}; 
        daout_line_stride % 2 == 0;
    }

    if (rubik_mode == rubik_mode_CONTRACT) {
        (daout_surf_stride - daout_line_stride*(datain_height+1)*(deconv_y_stride+1)) >= 0;
        (daout_surf_stride - daout_line_stride*(datain_height+1)*(deconv_y_stride+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    }
    else if (rubik_mode == rubik_mode_MERGE) {
        (daout_surf_stride - daout_line_stride*(datain_height+1)) >= 0;
        (daout_surf_stride - daout_line_stride*(datain_height+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
    }

    if (rubik_mode == rubik_mode_SPLIT) {
        (daout_planar_stride - daout_line_stride*(datain_height+1)) >= 0;
        (daout_planar_stride - daout_line_stride*(datain_height+1)) dist { 0:=30, ['h1:'hF]:=45, ['h10:'h7F]:=20, ['h80:'hFF]:=5};
        daout_planar_stride % 2 == 0;
    }

	if (rubik_mode != rubik_mode_CONTRACT) {
	    deconv_x_stride == 0;
	    deconv_y_stride == 0;
	}

    contract_stride_1 == (daout_line_stride*(deconv_y_stride+1)); 
};

constraint nvdla_rbk_resource::c_sim_datain_dist {
    datain_width   dist { ['h0:'h100]:=256,['h101:'h1efe]:=1,['h1eff:'h1fff]:=256 };
    datain_height  dist { ['h0:'h100]:=256,['h101:'h1efe]:=1,['h1eff:'h1fff]:=256 };
    datain_channel dist { ['h0:'h100]:=256,['h101:'h1efe]:=1,['h1eff:'h1fff]:=256 };
    (datain_width+1)*(datain_height+1)*(datain_channel+1) <= 64'h10000;    
}

constraint nvdla_rbk_resource::c_sim_cube_size_small {
    datain_width   inside {[0:'h0F]};
    datain_height  inside {[0:'h0F]};
    datain_channel inside {[0:'h3F]};
    ((datain_width+1)*(datain_height+1)*(datain_channel+1)) <= 64'h4000;
}

function void nvdla_rbk_resource::post_randomize();
endfunction : post_randomize

function void nvdla_rbk_resource::set_register();
    //:| spec2cons.ral_set(['NVDLA_RBK'])
    //:) epython: generated_beg (DO NOT EDIT BELOW)
    ral.nvdla.NVDLA_RBK.D_MISC_CFG.RUBIK_MODE.set(                                     rubik_mode);
    ral.nvdla.NVDLA_RBK.D_MISC_CFG.IN_PRECISION.set(                                   in_precision);
    ral.nvdla.NVDLA_RBK.D_DAIN_RAM_TYPE.DATAIN_RAM_TYPE.set(                           datain_ram_type);
    ral.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_WIDTH.set(                              datain_width);
    ral.nvdla.NVDLA_RBK.D_DATAIN_SIZE_0.DATAIN_HEIGHT.set(                             datain_height);
    ral.nvdla.NVDLA_RBK.D_DATAIN_SIZE_1.DATAIN_CHANNEL.set(                            datain_channel);
    ral.nvdla.NVDLA_RBK.D_DAIN_ADDR_HIGH.DAIN_ADDR_HIGH.set(                           dain_addr_high);
    ral.nvdla.NVDLA_RBK.D_DAIN_ADDR_LOW.DAIN_ADDR_LOW.set(                             dain_addr_low);
    ral.nvdla.NVDLA_RBK.D_DAIN_LINE_STRIDE.DAIN_LINE_STRIDE.set(                       dain_line_stride);
    ral.nvdla.NVDLA_RBK.D_DAIN_SURF_STRIDE.DAIN_SURF_STRIDE.set(                       dain_surf_stride);
    ral.nvdla.NVDLA_RBK.D_DAIN_PLANAR_STRIDE.DAIN_PLANAR_STRIDE.set(                   dain_planar_stride);
    ral.nvdla.NVDLA_RBK.D_DAOUT_RAM_TYPE.DATAOUT_RAM_TYPE.set(                         dataout_ram_type);
    ral.nvdla.NVDLA_RBK.D_DATAOUT_SIZE_1.DATAOUT_CHANNEL.set(                          dataout_channel);
    ral.nvdla.NVDLA_RBK.D_DAOUT_ADDR_HIGH.DAOUT_ADDR_HIGH.set(                         daout_addr_high);
    ral.nvdla.NVDLA_RBK.D_DAOUT_ADDR_LOW.DAOUT_ADDR_LOW.set(                           daout_addr_low);
    ral.nvdla.NVDLA_RBK.D_DAOUT_LINE_STRIDE.DAOUT_LINE_STRIDE.set(                     daout_line_stride);
    ral.nvdla.NVDLA_RBK.D_CONTRACT_STRIDE_0.CONTRACT_STRIDE_0.set(                     contract_stride_0);
    ral.nvdla.NVDLA_RBK.D_CONTRACT_STRIDE_1.CONTRACT_STRIDE_1.set(                     contract_stride_1);
    ral.nvdla.NVDLA_RBK.D_DAOUT_SURF_STRIDE.DAOUT_SURF_STRIDE.set(                     daout_surf_stride);
    ral.nvdla.NVDLA_RBK.D_DAOUT_PLANAR_STRIDE.DAOUT_PLANAR_STRIDE.set(                 daout_planar_stride);
    ral.nvdla.NVDLA_RBK.D_DECONV_STRIDE.DECONV_X_STRIDE.set(                           deconv_x_stride);
    ral.nvdla.NVDLA_RBK.D_DECONV_STRIDE.DECONV_Y_STRIDE.set(                           deconv_y_stride);
    ral.nvdla.NVDLA_RBK.D_PERF_ENABLE.PERF_EN.set(                                     perf_en);
    //:) epython: generated_end (DO NOT EDIT ABOVE)
endfunction : set_register

`endif //_NVDLA_RBK_RESOURCE_SV_
