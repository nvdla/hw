`ifndef _NVDLA_BASE_RESOURCE_SV_
`define _NVDLA_BASE_RESOURCE_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_base_resource
//
// @description: base class of various hardware resources
//-------------------------------------------------------------------------------------

class nvdla_base_resource extends uvm_component;
    string                      inst_name;

    typedef enum { ALIGN_TO_32B                   = 'h0
                 , ALIGN_TO_64B                   = 'h1
                 , ALIGN_TO_128B                  = 'h2
                 , ALIGN_TO_256B                  = 'h3
                 , ALIGN_TO_512B                  = 'h4
                 } addr_alignment_e;

    /* One single resource has at most 5 surfaces */
    rand addr_alignment_e          alignment[5];
    rand int                       align_mask[5];

    constraint c_align_mask {
        solve alignment before align_mask;

        foreach (align_mask[i]) {
            alignment[i] == ALIGN_TO_32B  -> align_mask[i] == 'h1f;
            alignment[i] == ALIGN_TO_64B  -> align_mask[i] == 'h3f;
            alignment[i] == ALIGN_TO_128B -> align_mask[i] == 'h7f;
            alignment[i] == ALIGN_TO_256B -> align_mask[i] == 'hff;
            alignment[i] == ALIGN_TO_512B -> align_mask[i] == 'h1ff;
        }
    }

    /*
        active_cnt: counter of how many times resource is active, e.g. gets called by any scenario
        counter default value is set to `NEVER_BE_ACTIVE( e.g. -1 ), and start counting from 0
    */
    int                         active_cnt = `NEVER_BE_ACTIVE;
    /*
        group_to_use: group ID to be configured.
        variable value is automatically determined by active_cnt value.
    */
    int                         group_to_use;
    /*
        ral: register top
    */
    ral_sys_top                 ral;
    surface_generator           surface_gen;
    /*
        sync_evt_queue: used to store sync_evt passed by scenario.
        Always store latest 3 layers' interrupt sync event name
         0: layer N (current to be executed layer)
        -1: layer N-1
        -2: layer N-2
    */
    string                      sync_evt_queue[-2:0];

    /*
        Method
    */
    extern protected function new(string name="nvdla_base_resource", uvm_component parent);
    extern function void      activate();
    extern virtual function   void set_sync_evt_name(string sync_evt_name);
    extern function string    get_sync_evt_name(int index = 0);
    extern function int       get_active_cnt();
    extern function string    get_resource_name();
    extern function longint unsigned  calc_mem_size(int unsigned n_batch, int unsigned batch_stride,
                                                    int unsigned n_channel, int unsigned element_per_atom,
                                                    int unsigned surface_stride);
    extern function longint unsigned  calc_mem_size_plane(
                                                    int unsigned height, int unsigned line_stride,
                                                    int unsigned size_alignment);
    extern function void    lut_table_load(string file, ref bit [15:0] le_table[65], ref bit [15:0] lo_table[257]);
    /*
        Method for trace generation
    */
    extern function void    sync_wait(int fh,   string resource_id, string sync_id );
    extern function void    sync_notify(int fh, string resource_id, string sync_id );
    extern function void    reg_write(int fh,   string reg_name,    int reg_value );
    extern function void    poll_reg_equal(int fh,   string reg_name,    int reg_value );
    extern function void    intr_notify(int fh, string intr_id,     string sync_id);
    extern function void    mem_reserve(int fh, string mem_domain, longint unsigned base_addr,
                                        int size, string sync_id);
    extern function void    mem_load(int fh, string mem_domain, longint unsigned base_addr,
                                     string file_name, string sync_id);
    extern function void    mem_init_by_pattern(int fh, string mem_domain, longint unsigned base_addr,
                                                int size, string pattern, string sync_id);
    extern function void    mem_init_by_file(int fh, string mem_domain, longint unsigned base_addr,
                                             string file_name, string sync_id);
    extern function void    mem_release(int fh, string mem_domain, longint unsigned base_addr, string sync_id);
    /*
        Phase
    */
    extern function void    connect_phase(uvm_phase phase);
    extern virtual function void set_sim_constraint();

    `uvm_component_utils_begin(nvdla_base_resource)
        `uvm_field_int(active_cnt, UVM_DEFAULT)
    `uvm_component_utils_end
endclass : nvdla_base_resource

function nvdla_base_resource::new(string name="nvdla_base_resource", uvm_component parent);
    super.new(name, parent);
    inst_name   = name;
    surface_gen = surface_generator::type_id::create("surface_generator",this);
endfunction: new

function void nvdla_base_resource::activate();
    active_cnt += 1;
    group_to_use = active_cnt%2;
endfunction: activate

function void nvdla_base_resource::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(ral_sys_top)::get(this,"", "ral", ral)) begin
        `uvm_fatal(inst_name, "Null ral object, please check")
    end
endfunction: connect_phase

function void nvdla_base_resource::reg_write(int fh, string reg_name,int reg_value );
    $fwrite(fh,"reg_write(%s_0,0x%0h);\n",reg_name,reg_value);
endfunction: reg_write

function void nvdla_base_resource::poll_reg_equal(int fh, string reg_name,int reg_value );
    $fwrite(fh,"poll_reg_equal(%s_0,0x%0h);\n",reg_name,reg_value);
endfunction: poll_reg_equal

function void nvdla_base_resource::sync_wait(int fh, string resource_id, string sync_id );
    $fwrite(fh,"sync_wait(%s,%s);\n",resource_id,sync_id);
endfunction: sync_wait

function void nvdla_base_resource::sync_notify(int fh, string resource_id, string sync_id );
    $fwrite(fh,"sync_notify(%s,%s);\n",resource_id,sync_id);
endfunction: sync_notify

function void nvdla_base_resource::intr_notify(int fh, string intr_id, string sync_id);
    $fwrite(fh,"intr_notify(%s,%s);\n",intr_id,sync_id);
endfunction: intr_notify

function void nvdla_base_resource::mem_reserve(int fh, string mem_domain, longint unsigned base_addr,
                                               int size, string sync_id);
    if (sync_id == "")
        $fwrite(fh,"mem_reserve(%s,0x%0h,0x%h);\n", mem_domain, base_addr, size);
    else
        $fwrite(fh,"mem_reserve(%s,0x%0h,0x%0h,%s);\n", mem_domain, base_addr, size, sync_id);
endfunction: mem_reserve

function void nvdla_base_resource::mem_load(int fh, string mem_domain, longint unsigned base_addr,
                                            string file_name, string sync_id);
    if (sync_id == "")
        $fwrite(fh,"mem_load(%s,0x%0h,\"%s\");\n", mem_domain, base_addr, file_name);
    else
        $fwrite(fh,"mem_load(%s,0x%0h,\"%s\",%s);\n", mem_domain, base_addr, file_name, sync_id);
endfunction: mem_load

function void nvdla_base_resource::mem_init_by_pattern(int fh, string mem_domain, longint unsigned base_addr,
                                                       int size, string pattern, string sync_id);
    if (sync_id == "")
        $fwrite(fh,"mem_init(%s,0x%0h,0x%0h,%s);\n", mem_domain, base_addr, size, pattern);
    else
        $fwrite(fh,"mem_init(%s,0x%0h,0x%0h,%s,%s);\n", mem_domain, base_addr, size, pattern, sync_id);
endfunction: mem_init_by_pattern

function void nvdla_base_resource::mem_init_by_file(int fh, string mem_domain, longint unsigned base_addr,
                                                    string file_name, string sync_id);
    if (sync_id == "")
        $fwrite(fh,"mem_init(%s,0x%0h,\"%s\");\n", mem_domain, base_addr, file_name);
    else
        $fwrite(fh,"mem_init(%s,0x%0h,\"%s\",%s);\n", mem_domain, base_addr, file_name, sync_id);
endfunction: mem_init_by_file

function void nvdla_base_resource::mem_release(int fh, string mem_domain, longint unsigned base_addr, string sync_id);
    $fwrite(fh,"mem_release(%s,0x%0h,%s);\n", mem_domain, base_addr, sync_id);
endfunction: mem_release

function void nvdla_base_resource::set_sync_evt_name(string sync_evt_name);
    sync_evt_queue[-2:0] = {sync_evt_queue[-1:0], sync_evt_name};
endfunction: set_sync_evt_name

function string nvdla_base_resource::get_sync_evt_name(int index = 0);
    return sync_evt_queue[index];
endfunction: get_sync_evt_name

function int nvdla_base_resource::get_active_cnt();
    return active_cnt;
endfunction: get_active_cnt

function string nvdla_base_resource::get_resource_name();
    return inst_name.tolower();
endfunction: get_resource_name

function longint unsigned nvdla_base_resource::calc_mem_size(int unsigned n_batch,
                                                             int unsigned batch_stride,
                                                             int unsigned n_channel,
                                                             int unsigned element_per_atom,
                                                             int unsigned surface_stride);
    longint unsigned mem_size;
    int unsigned n_surface;

    n_surface = (n_channel+element_per_atom-1) / element_per_atom;
    mem_size  = (n_batch > 1) ? batch_stride*n_batch
                              : surface_stride*n_surface;
    `uvm_info(inst_name,
        $sformatf("n_batch = %#0x, batch_stride = %#0x, n_channel = %#0x, element_per_atom = %#0x, surface_stride = %#0x, mem_size = %#0x",
        n_batch, batch_stride, n_channel, element_per_atom, surface_stride, mem_size), UVM_NONE)
    return mem_size;
endfunction : calc_mem_size

function longint unsigned nvdla_base_resource::calc_mem_size_plane(int unsigned height,
                                                                   int unsigned line_stride,
                                                                   int unsigned size_alignment);
    longint unsigned mem_size;
    int unsigned line_size;
    line_size = (line_stride + size_alignment - 1)/size_alignment*size_alignment;
    mem_size = line_size * height;
    `uvm_info(inst_name,
        $sformatf("height = %#0x, line_stride = %#0x, size_alignment = %#0x, mem_size = %#0x",
        height, line_stride, size_alignment, mem_size), UVM_NONE)
    return mem_size;
endfunction : calc_mem_size_plane

function void  nvdla_base_resource::lut_table_load( string         file,
                                                    ref bit [15:0] le_table[65],
                                                    ref bit [15:0] lo_table[257]);
    int       file_hdl;
    int       le_idx;
    int       lo_idx;
    int       is_file_end;
    int       code;
    bit [8:0] lut_data;
    string    lut_id;

    `uvm_info(inst_name, $sformatf("LUT load: file: %0s", file), UVM_NONE)
    file_hdl = $fopen(file, "r");
    if(!file_hdl) begin
        `uvm_error(inst_name, $sformatf("LUT table file open failed"))
    end
    while(is_file_end == 0) begin
        code = $fscanf(file_hdl, "%s %d", lut_id, lut_data);
        `uvm_info(inst_name, $sformatf("LUT load line: lut_id:%0s, val:%0d", lut_id, lut_data), UVM_NONE)
        if(!code) begin
            // discard unmatch lines
            string discard;
            void'($fgets(discard,file_hdl));
            continue;
        end
        if(lut_id == "lut_raw_entry:") begin
            le_table[le_idx] = lut_data;
            `uvm_info(inst_name, $sformatf("LUT table load: lut=%0s, data=%0h", lut_id, lut_data), UVM_LOW)
            le_idx++;
        end
        else if(lut_id == "lut_density_entry:") begin
            lo_table[lo_idx] = lut_data;
            `uvm_info(inst_name, $sformatf("LUT table load: lut=%0s, data=%0h", lut_id, lut_data), UVM_LOW)
            lo_idx++;
        end
        is_file_end = $feof(file_hdl);
    end
    $fclose(file_hdl);
    if(le_idx != 65 || lo_idx != 257) begin
        `uvm_error(inst_name, $sformatf("LUT table file data load failed"))
    end
endfunction: lut_table_load

function void nvdla_base_resource::set_sim_constraint();
        `uvm_info(inst_name, $sformatf("set sim constraint knobs"), UVM_MEDIUM)
endfunction: set_sim_constraint

`endif //_NVDLA_BASE_RESOURCE_SV_
