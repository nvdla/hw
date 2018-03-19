`ifndef _SURFACE_GENERATOR_SV_
`define _SURFACE_GENERATOR_SV_

//-------------------------------------------------------------------------------------
//
// CLASS: nvdla_tg_surface_generator
//
// @description: class for memory surface generation
//-------------------------------------------------------------------------------------


class surface_generator extends uvm_component;

    string      inst_name;
    
    string      memory_surface_generator_path  = "surface_generator.py";
    function new(string name, uvm_component parent);
        super.new(name, parent);
        this.inst_name = name;
    endfunction : new

    `uvm_component_utils_begin(surface_generator)
        `uvm_field_string   (memory_surface_generator_path, UVM_ALL_ON)
    `uvm_component_utils_end

    extern function void generate_memory_surface_feature(surface_feature_config feature_config);
    extern function void generate_memory_surface_weight(surface_weight_config weight_config);
    extern function void generate_memory_surface_image_pitch(surface_image_pitch_config image_config);

endclass : surface_generator

function void surface_generator::generate_memory_surface_feature(surface_feature_config feature_config);
    string cmd = $sformatf("%s feature --seed %d --width %d --height %d --channel %d --batch %d --component %d --atomic_memory %d --line_stride %d --surface_stride %d --batch_stride %d --data_type %s --pattern %s --file_name %s", memory_surface_generator_path, $urandom(),
        feature_config.width, feature_config.height,feature_config.channel, feature_config.batch,
        feature_config.component_per_element,
        feature_config.atomic_memory,
        feature_config.line_stride, feature_config.surface_stride, feature_config.batch_stride,
        feature_config.precision.name().tolower(),
        feature_config.pattern,
        // feature_config.none_zero_rate=10000,
        // feature_config.fp_enabled=0, feature_config.fp_nan_enabled=1, feature_config.fp_inf_enabled=1,
        // feature_config.batch_cubes_are_the_same=1,
        feature_config.name
        );
    `uvm_info(inst_name, $sformatf("Feature generation command is %s", cmd), UVM_MEDIUM)
	if ($system(cmd)) begin
        `uvm_fatal(inst_name, $sformatf("Fail to generate memory feature surface, command is %s", cmd))
	end
endfunction : generate_memory_surface_feature

function void surface_generator::generate_memory_surface_weight(surface_weight_config weight_config);
    // width, height, channel, kernel_number, atomic_channel, atomic_kernel, data_type, alignment_in_byte, pattern, is_compressed, file_name
    string cmd = $sformatf("%s weight --seed %d --width %d --height %d --channel %d --kernel %d --atomic_channel %d --atomic_kernel %d --data_type %s --alignment_in_byte %d --pattern %s --is_compressed %s --file_name %s", memory_surface_generator_path, $urandom(),
        weight_config.width, weight_config.height,weight_config.channel, weight_config.kernel,
        weight_config.atomic_channel,
        weight_config.atomic_kernel,
        weight_config.precision.name().tolower(),
        weight_config.cbuf_entry_byte_size,
        weight_config.pattern,
        (1==weight_config.comp_en)?"True":"False",
        weight_config.comp_en?{weight_config.weight_name,",",weight_config.weight_mask_name,",",weight_config.weight_group_size_name}:weight_config.weight_name
        // weight_config.none_zero_rate;
        // weight_config.fp_enabled=0; weight_config.fp_nan_enabled=0; weight_config.fp_inf_enabled=1;
        );
    `uvm_info(inst_name, $sformatf("Weight generation command is %s", cmd), UVM_MEDIUM)
	if ($system(cmd)) begin
        `uvm_fatal(inst_name, $sformatf("Fail to generate memory weight surface, command is %s", cmd))
	end
endfunction : generate_memory_surface_weight

function void surface_generator::generate_memory_surface_image_pitch(surface_image_pitch_config image_config);
    string cmd = $sformatf("%0s image_pitch --seed %0d --width %0d --height %0d --channel %0d --atomic_memory %0d --line_stride %0d,%0d --offset_x %0d --pixel_format_name %0s --data_type %0s --pattern %0s --file_name %0s", memory_surface_generator_path, $urandom(),
        image_config.width, image_config.height,image_config.channel,
        image_config.atomic_memory,
        image_config.line_stride_0, image_config.line_stride_1,
        image_config.offset_x,
        image_config.pixel_format_name,
        image_config.precision.name().tolower(),
        image_config.pattern,
        // image_config.none_zero_rate=10000,
        // image_config.fp_enabled=0, image_config.fp_nan_enabled=1, image_config.fp_inf_enabled=1,
        image_config.name
        );
    `uvm_info(inst_name, $sformatf("Image pitch generation command is %s", cmd), UVM_MEDIUM)
	if ($system(cmd)) begin
        `uvm_fatal(inst_name, $sformatf("Fail to generate memory image pitch surface, command is %s", cmd))
	end
endfunction : generate_memory_surface_image_pitch

`endif //_SURFACE_GENERATOR_SV_
