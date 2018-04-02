from tensor_operator import TensorOperator
import re
import numpy as np

class MemorySurface:
    __format__ = {'FeatureMap','weight','image'}
    #__data_type__ = {'int8', 'int16', 'float16'}
    def __init__(self, name):
        self.name = name
        self.seed = 0
        self.pattern = None
        self.memory_surface_data = None
        self.tensor_nchw = None
        self.max_byte_per_line = 16

    def set_seed(self):
        np.random.seed(self.seed)

    def print_info(self):
        print("===== Information of %s with pattern %s, begin =====" % (self.name, self.pattern))
        print("----- surface data shape of %s, begin ----" % self.name)
        print(self.memory_surface_data.shape)
        print("----- surface data shape of %s, end  -----" % self.name)
        print("----- surface data of %s, begin ----" % self.name)
        print(self.memory_surface_data)
        print("----- surface data of %s, end  -----" % self.name)
        print("----- tensor data of %s, begin -----" % self.name)
        print(self.tensor_nchw)
        print("----- tensor data of %s, end   -----" % self.name)
        print("===== Information of %s with pattern %s, end =======" % (self.name, self.pattern))

    def save_tensor_to_file(self):
        #TODO, need arch to confirm the file format
        pass
    
    def write_line_to_file(self, file_handler, offset, content):
        # convert to hex bytes
        content_str = content.tobytes().hex()
        line_offset = offset
        line_byte_list = []
        line_byte_count = 0
        for byte in map(''.join, zip(*[iter(content_str)]*2)):
            byte_str = '0x'+byte
            line_byte_list.append(byte_str)
            line_byte_count += 1
            if (line_byte_count == self.max_byte_per_line):
                file_handler.write("{offset:0x%x, size:%d, payload:%s},\n" % (line_offset, self.max_byte_per_line, ' '.join(line_byte_list)))
                line_byte_count = 0
                line_byte_list = []
                line_offset += self.max_byte_per_line
        # content byte size is not aligned with max_byte_per_line, write the last line to file
        if (0 != line_byte_count):
            file_handler.write("{offset:0x%x, size:%d, payload:%s},\n" % (line_offset, len(line_byte_list), ' '.join(line_byte_list)))

class MemorySurfaceFeatureMap(MemorySurface):
    # TODO, need to implement pattern supported_pattern = {nhwc_index'}
    supported_pattern = {'nchw_index', 'nsh_wxatom_index', 'shwan_index', 'random', 'ones', 'zeros'}
    def __init__(self, name):
        super().__init__(name)
        self.width = 0
        self.height = 0
        self.channel = 0
        self.batch = 0
        self.component = 0
        self.atomic_memory = 0   # ATOMIC_MEMORY
        self.line_stride = 0
        self.surface_stride = 0
        self.surface_number = 0
        self.batch_stride = 0
        self.data_type = 0
        self.pattern = ''
        self.file_name = ''

    def set_configs(self, config):
        try:
            seed, width, height, channel, component, batch, atomic_memory, line_stride, surface_stride, batch_stride, data_type, pattern, file_name = config
        except ValueError:
            raise Exception('Error in feature memory surface creation', '''
Required parameter for feature map surface are:
    seed, width, height, channel, component, batch, atomic_memory, line_stride, surface_stride, batch_stride, data_type, pattern, file_name
''')
        assert(width > 0)
        assert(height > 0)
        assert(channel > 0)
        assert(batch > 0)
        assert(component > 0)
        assert(not((batch>1) and (component>1)))
        assert(atomic_memory > 0)
        assert(line_stride >= width*atomic_memory)
        assert(surface_stride >= height*line_stride)
        # TODO assert(batch_stride > surface_stride)
        assert(data_type in TensorOperator.supported_data_type)
        assert(pattern in self.supported_pattern)
        self.seed, self.width, self.height, self.channel, self.component, self.batch, self.atomic_memory, self.line_stride, self.surface_stride, self.batch_stride, self.data_type, self.pattern, self.file_name = config
        self.surface_number = (channel + atomic_memory - 1)//atomic_memory
        self.set_seed()

    def convert_tensor_nchw_to_memory_surface(self, memory_surface_shape='nsh_wxatom'):
        nchw_compensated = TensorOperator.append_c_compensation_to_nchw_tensor(self.tensor_nchw, self.atomic_memory)
        if 'nsh_wxatom' == memory_surface_shape:
            self.memory_surface_data = TensorOperator.convert_tensor_from_nchw_to_nch_wxatom(nchw_compensated, self.atomic_memory)
        elif 'sh_wan' == memory_surface_shape:
            self.memory_surface_data = TensorOperator.convert_tensor_from_nchw_to_sh_wan(nchw_compensated, self.atomic_memory)

    def convert_memory_surface_to_tensor_nchw(self, memory_surface_shape='nsh_wxatom'):
        if 'nsh_wxatom' == memory_surface_shape:
            nchw_compensated = TensorOperator.convert_tensor_from_nch_wxatom_to_nchw(self.memory_surface_data, self.atomic_memory)
        elif 'sh_wan' == memory_surface_shape:
            nchw_compensated = TensorOperator.convert_tensor_from_sh_wan_to_nchw(self.memory_surface_data, self.atomic_memory, self.component)
        self.tensor_nchw = TensorOperator.remove_c_compensation_from_nchw_tensor(nchw_compensated, self.channel)

    # config = (width, height, channel, batch, atomic_memory, line_stride, surface_stride, batch_stride, data_type, pattern)
    def generate_memory_surface(self, *config):
        print(config)
        self.set_configs(config)
        if (1 == self.component):
            if self.pattern in ['nchw_index']:
                self.tensor_nchw = TensorOperator.create_tensor((self.batch, self.channel, self.height, self.width), self.data_type, 'index')
                #print('self.tensor_nchw')
                #print(self.tensor_nchw)
                self.convert_tensor_nchw_to_memory_surface()
            elif self.pattern in ['random', 'ones', 'zeros']:
                self.tensor_nchw = TensorOperator.create_tensor((self.batch, self.channel, self.height, self.width), self.data_type, self.pattern)
                self.convert_tensor_nchw_to_memory_surface()
            elif self.pattern in ['nch_wxatom_index']:
                self.memory_surface_data = TensorOperator.create_tensor((self.batch, self.surface_number, self.height, self.width*self.atomic_memory), self.data_type, 'index')
                #print('self.memory_surface_data')
                #print(self.memory_surface_data)
                self.convert_memory_surface_to_tensor_nchw()
            else:
                raise Exception('MemorySurfaceFeatureMap::generate_memory_surface','Not supported pattern:%s' % self.pattern)
        else:
            ## multi component, single batch
            if self.pattern in ['nchw_index']:
                self.tensor_nchw = TensorOperator.create_tensor((self.component, self.channel, self.height, self.width), self.data_type, 'index')
                #print('self.tensor_nchw',self.tensor_nchw)
                self.convert_tensor_nchw_to_memory_surface('sh_wan')
            elif self.pattern in ['random', 'ones', 'zeros']:
                self.tensor_nchw = TensorOperator.create_tensor((self.component, self.channel, self.height, self.width), self.data_type, self.pattern)
                #print('self.tensor_nchw',self.tensor_nchw)
                self.convert_tensor_nchw_to_memory_surface('sh_wan')
            elif self.pattern in ['shwan_index']:
                self.memory_surface_data = TensorOperator.create_tensor((1, self.surface_number, self.height, self.component*self.width*self.atomic_memory), self.data_type, 'index')
                #print('self.memory_surface_data', self.memory_surface_data)
                self.convert_memory_surface_to_tensor_nchw('sh_wan')
            else:
                raise Exception('MemorySurfaceFeatureMap::generate_memory_surface','Not supported pattern:%s' % self.pattern)

    def dump_memory_surface_to_file(self):
        print('MemorySurfaceFeatureMap::dump_memory_surface_to_file')
        #element_number = self.memory_surface_data.size
        #element_size = self.memory_surface_data.dtype.itemsize
        # MSF, batch surface line
        #print('self.memory_surface_data', self.memory_surface_data)
        with open (self.file_name, 'w') as f:
            f.write('{\n')
            offset = 0
            for batch_index in range(self.batch):
                for surface_index in range(self.surface_number):
                    for line_index in range(self.height):
                        offset = batch_index*self.batch_stride + surface_index*self.surface_stride + line_index*self.line_stride
                        #print('offset:', offset)
                        #print('batch_index:', batch_index)
                        #print('surface_index:', surface_index)
                        #print('line_index:', line_index)
                        self.write_line_to_file(f, offset, self.memory_surface_data[batch_index, surface_index, line_index])
            f.write('}\n')

class MemorySurfaceWeight(MemorySurface):
    supported_pattern = {'nchw_index', 'nhwc_index', 'random', 'ones', 'zeros', 'gshwp_index'}
    def __init__(self, name):
        super().__init__(name)
        self.width = 0
        self.height = 0
        self.channel = 0
        self.kernel_number = 0
        self.element_per_atom = 0   # ATOMIC_CHANNEL
        self.kernel_per_group = 0
        self.data_type = 0
        self.pattern = ''
        self.group_number = 0
        self.is_compressed = False
        self.weight_compressed = None
        self.weight_mask = None
        self.weight_group_size = None
        self.debug_decompressed = None

    def set_configs(self, config):
        try:
            #self.width, self.height, self.channel, self.kernel_number, self.element_per_atom, self.kernel_per_group, self.data_type, self.pattern = config
            seed, width, height, channel, kernel_number, element_per_atom, kernel_per_group, data_type, alignment_in_byte, pattern, is_compressed, file_name = config
        except ValueError:
            raise Exception('Error in weight memory surface creation', '''
Required parameter for weight map surface are:
    width, height, channel, kernel_number, data_type, pattern
''')
        assert(width > 0)
        assert(height > 0)
        assert(channel > 0)
        assert(kernel_number > 0)
        assert(element_per_atom > 0)
        assert(kernel_per_group>0)
        assert(data_type in TensorOperator.supported_data_type)
        assert(pattern in self.supported_pattern)
        assert(len(file_name)>0)
        assert( ((is_compressed == True) and (type(file_name) in [list,tuple]) and (len(file_name)==3)) or ((is_compressed == False) and (type(file_name) is str)) )
        #assert()
        self.seed, self.width, self.height, self.channel, self.kernel_number, self.element_per_atom, self.kernel_per_group, self.data_type, self.alignment_in_byte, self.pattern, self.is_compressed, self.file_name = config
        self.group_number = (self.kernel_number+self.kernel_per_group-1)//self.kernel_per_group
        self.set_seed()

    def convert_tensor_nchw_to_memory_surface(self):
        self.memory_surface_data = TensorOperator.align_array_size(TensorOperator.convert_nchw_to_weight_memory_surface(self.tensor_nchw, self.element_per_atom, self.kernel_per_group), 0, self.alignment_in_byte)

    def convert_memory_surface_to_tensor_nchw(self):
        self.tensor_nchw = TensorOperator.convert_weight_memory_surface_to_nchw(self.memory_surface_data,
                                                                                self.kernel_number, self.channel, self.height, self.width,
                                                                                self.kernel_per_group, self.element_per_atom)

    def generate_memory_surface(self, *config):
        self.set_configs(config)
        if self.pattern in ['nchw_index']:
            self.tensor_nchw = TensorOperator.create_tensor((self.kernel_number, self.channel, self.height, self.width), self.data_type, 'index')
            self.convert_tensor_nchw_to_memory_surface()
        elif self.pattern in ['nhwc_index']:
            self.tensor_nchw = TensorOperator.create_tensor((self.kernel_number, self.height, self.width, self.channel), self.data_type, 'index')
            self.tensor_nchw = TensorOperator.convert_nhwc_to_nchw(self.tensor_nchw)
            self.convert_tensor_nchw_to_memory_surface()
        elif self.pattern in ['ones','zeros', 'random']:
            self.tensor_nchw = TensorOperator.create_tensor((self.kernel_number, self.channel, self.height, self.width), self.data_type, self.pattern)
            self.convert_tensor_nchw_to_memory_surface()
        elif self.pattern in ['gshwp_index']:
            self.memory_surface_data = TensorOperator.align_array_size(TensorOperator.create_tensor((self.kernel_number*self.channel*self.height*self.width,), self.data_type, 'index'), 0, self.alignment_in_byte)
            self.convert_memory_surface_to_tensor_nchw()
        if self.is_compressed:
            element_per_group = self.width*self.height*self.channel*self.kernel_per_group
            self.weight_compressed, self.weight_mask, self.weight_group_size = TensorOperator.compress_array_by_element(
                    self.memory_surface_data, element_per_group, self.element_per_atom
                )
            self.debug_decompressed = TensorOperator.decompress_array_by_element(self.weight_compressed, self.weight_mask, self.weight_group_size)

    def print_info(self):
        print("===== Information of %s with pattern %s, begin =====" % (self.name, self.pattern))
        if self.is_compressed:
            print("----- surface data of %s, begin ----" % self.name)
            print(self.memory_surface_data)
            print("----- surface data of %s, end  -----" % self.name)
            print("----- compressed weight data of %s, begin ----" % self.name)
            print(self.weight_compressed)
            print("----- compressed weight data of %s, end  -----" % self.name)
            print("----- compressed weight data of %s, begin ----" % self.name)
            print(self.weight_mask)
            print("----- compressed weight data of %s, end  -----" % self.name)
            print("----- compressed weight data of %s, begin ----" % self.name)
            print(self.weight_group_size)
            print("----- compressed weight data of %s, end  -----" % self.name)
            print("----- debug decompressed weight data of %s, begin ----" % self.name)
            print(self.debug_decompressed)
            print("----- debug decompressed weight data of %s, end  -----" % self.name)
        else:
            print("----- surface data of %s, begin ----" % self.name)
            print(self.memory_surface_data)
            print("----- surface data of %s, end  -----" % self.name)
        print("----- tensor data of %s, begin -----" % self.name)
        print(self.tensor_nchw)
        print("----- tensor data of %s, end   -----" % self.name)
        print("===== Information of %s with pattern %s, end =======" % (self.name, self.pattern))

    def dump_memory_surface_to_file(self):
        print('MemorySurfaceWeight::dump_memory_surface_to_file')
        #element_number = self.memory_surface_data.size
        #element_size = self.memory_surface_data.dtype.itemsize
        # MSF, batch surface line
        if self.is_compressed:
            with open (self.file_name[0], 'w') as f:
                f.write('{\n')
                self.write_line_to_file(f, 0, self.weight_compressed)
                f.write('}\n')
            with open (self.file_name[1], 'w') as f:
                f.write('{\n')
                self.write_line_to_file(f, 0, self.weight_mask)
                f.write('}\n')
            with open (self.file_name[2], 'w') as f:
                f.write('{\n')
                self.write_line_to_file(f, 0, self.weight_group_size)
                f.write('}\n')
        else:
            with open (self.file_name, 'w') as f:
                f.write('{\n')
                self.write_line_to_file(f, 0, self.memory_surface_data)
                f.write('}\n')

class MemorySurfaceImagePitch(MemorySurface):
    supported_pattern = {'nchw_index', 'nsh_wxatom_index', 'random', 'ones', 'zeros'}

    def reset(self):
        self.width = 0
        self.height = 0
        self.channel = 0
        self.atomic_memory = 0   # ATOMIC_MEMORY
        self.line_stride = []
        self.offset_x = 0
        self.pixel_format_name = ''
        self.plane_number = 0
        self.data_type = None
        self.pattern = ''
        self.file_name = []
        self.channel_name_list = []
        self.channel_per_plane = []
        self.pad_num_line_start = []
        self.pad_num_line_end = []
        # memory surface data size may not be same, cannot use numpy array for memory_surface_data
        self.memory_surface_data = []

    def __init__(self, name):
        super().__init__(name)
        self.reset()

    def set_configs(self, config):
        self.reset()
        try:
            seed, width, height, channel, atomic_memory, line_stride, offset_x, pixel_format_name, data_type, pattern, file_name = config
        except ValueError:
            raise Exception('Error in feature memory surface creation', '''
Required parameter for feature map surface are:
    seed, width, height, channel, atomic_memory, line_stride, offset_x, pixel_format_name, data_type, pattern, file_name
''')
        assert(width > 0)
        assert(height > 0)
        assert(channel > 0)
        # assert(pixel_format_name in self.supported_pixel_format)
        #assert(data_type in TensorOperator.supported_data_type)
        assert(pattern in self.supported_pattern)
        self.seed, self.width, self.height, self.channel, self.atomic_memory, line_stride, self.offset_x, self.pixel_format_name, self.data_type, self.pattern, file_name = config
        self.file_name   = file_name.split(',')
        self.line_stride = list(int(x, 0) for x in line_stride.split(','))
        #assert(len(self.file_name) == len(self.line_stride)) # file number and line_stride shall be the same as surface number
        self.extract_surface_setting()
        self.set_seed()

    def extract_surface_setting (self):
        # Pixel format name examples:
        #   T_B8G8R8X8
        #   T_A2R10G10B10
        #   T_Y8___U8V8_N444
        pixel_format_name       = self.pixel_format_name.replace('T_','').replace('_N444','')
        if '_F' in pixel_format_name:
            assert('float16' == self.data_type)
        plane_separator_anchor  = re.compile(r'___')
        hdr_anchor              = re.compile(r'(^A2)|(A2$)')
        channel_anchor        = re.compile(r'(?P<channel_name>[A-Z])(?P<bit_width>\d+)')
        is_reverse  = False
        is_hdr      = False
        is_a2_msb   = False
        plane_name_list = pixel_format_name.split('___')
        self.plane_number = len(plane_name_list)
        element_byte_size = np.dtype(self.data_type).itemsize
        for plane_name in plane_name_list:
            # a plane could be: R8G8B8A8, Y8, U8V8
            result = hdr_anchor.search(plane_name)
            if result:
                is_hdr      = True
                is_a2_msb   = (0 == plane_name.index('A2'))
            # 'R8G8B8A8' -> [('R', '8'), ('G', '8'), ('B', '8'), ('A', '8')]
            channel_list = channel_anchor.findall(plane_name)
            channel_name_tuple, channel_bit_width_tuple = zip(*channel_list)
            self.channel_name_list.extend(channel_name_tuple)
            channel_per_plane = len(channel_list)
            element_alignment = self.atomic_memory//(element_byte_size*channel_per_plane)
            #print('MemorySurfaceImagePitch::element_alignment', element_alignment, sep='\n')
            self.channel_per_plane.append(channel_per_plane)
            pad_num_line_start = self.offset_x % element_alignment
            self.pad_num_line_start.append(pad_num_line_start)
            self.pad_num_line_end.append( (pad_num_line_start + self.width + element_alignment -1 )//element_alignment * element_alignment - (pad_num_line_start + self.width) )
        #print('MemorySurfaceImagePitch::pad_num_line_start', self.pad_num_line_start, sep='\n')
        #print('MemorySurfaceImagePitch::pad_num_line_end', self.pad_num_line_end, sep='\n')

    def convert_memory_surface_to_tensor_nchw(self):
        # Remove pad zeros in line start and line end which is come from offset_x and atomic_m alignment
        for plane_idx in range(self.plane_number):
            self.memory_surface_data[plane_idx] = self.memory_surface_data[plane_idx][:,:,:, self.pad_num_line_start[plane_idx]:-pad_num_line_end[plane_idx]]
        tensor_list = []
        # convert plane memory to plane tensor
        for plane_idx in range(self.plane_number):
            tensor_list.append(TensorOperator.convert_tensor_from_nch_wxatom_to_nchw(self.memory_surface_data[plane_idx], self.channel_per_plane[plane_idx]))
        # merge plane tensors on dimemsion channel
        self.tensor_nchw = TensorOperator.merge_nchw_tensors_by_dimemsion(tensor_list, 1)
        # Adjust order to ['R','G','B','Y','U','V','X','A']
        channel_order = []
        for channel in ['R','G','B','Y','U','V','X','A']:
            if channel in self.channel_name_list:
                channel_order.append(self.channel_name_list.index(channel))
        self.tensor_nchw = TensorOperator.adjust_channel_order(TensorOperator.tensor_nchw, channel_order)

    def convert_tensor_nchw_to_memory_surface(self):
        # Adjust order from ['R','G','B','Y','U','V','X','A'] to pixel format
        channel_name_new_list = []
        channel_order = []
        tensor_channel_name_list = []
        for channel in self.channel_name_list:
            if channel in ['R','G','B','Y','U','V','X','A']:
                tensor_channel_name_list.append(channel)
        for channel in self.channel_name_list:
            if channel in tensor_channel_name_list:
                channel_order.append(tensor_channel_name_list.index(channel))
        self.tensor_nchw = TensorOperator.adjust_channel_order(self.tensor_nchw, channel_order)
        # split tensor to plane tensor on dimension channel
        dimension_channel_axis_id = 1
        boarder_channel_idx = [self.channel_per_plane[0]]
        tensor_list = TensorOperator.split_tensor_nchw_by_dimemsion(self.tensor_nchw, boarder_channel_idx, dimension_channel_axis_id)
        # convert plane tensor to plane memory
        for plane_idx in range(self.plane_number):
            self.memory_surface_data.append(TensorOperator.convert_tensor_from_nchw_to_nch_wxatom(tensor_list[plane_idx], self.channel_per_plane[plane_idx]))
        # apply offset_x and atomic_m alignment, pad zeros in line start and line end
        for plane_idx in range(self.plane_number):
            self.memory_surface_data[plane_idx] = np.pad(self.memory_surface_data[plane_idx], ((0,0), (0,0), (0,0), (self.pad_num_line_start[plane_idx]*self.channel_per_plane[plane_idx], self.pad_num_line_end[plane_idx]*self.channel_per_plane[plane_idx])), 'constant')


    def generate_memory_surface(self, *config):
        print(config)
        self.set_configs(config)
        supported_pattern = {'nchw_index', 'nsh_wxatom_index', 'random', 'ones', 'zeros'}
        if self.pattern in ['nchw_index']:
            self.tensor_nchw = TensorOperator.create_tensor((1, self.channel, self.height, self.width), self.data_type, 'index')
            self.convert_tensor_nchw_to_memory_surface()
        elif self.pattern in ['random', 'ones', 'zeros']:
            self.tensor_nchw = TensorOperator.create_tensor((1, self.channel, self.height, self.width), self.data_type, self.pattern)
            self.convert_tensor_nchw_to_memory_surface()
        elif self.pattern in ['nsh_wxatom_index']:
            for plane_idx in range(self.plane_number):
                self.memory_surface_data.append( TensorOperator.create_tensor((1, 1, self.height, (self.width + self.pad_num_line_start[plane_idx] + pad_num_line_end[plane_idx])*self.channel_per_plane[plane_idx]), self.data_type, 'index') )
            #print('self.memory_surface_data')
            #print(self.memory_surface_data)
            self.convert_memory_surface_to_tensor_nchw()
        else:
            raise Exception('MemorySurfaceImagePitch::generate_memory_surface','Not supported pattern:%s' % self.pattern)

    def dump_memory_surface_to_file(self):
        print('MemorySurfaceImagePitch::dump_memory_surface_to_file')
        #print('self.memory_surface_data', self.memory_surface_data)
        for plane_index in range(self.plane_number):
            with open (self.file_name[plane_index], 'w') as f:
                f.write('{\n')
                offset = 0
                for line_index in range(self.height):
                    offset = line_index*self.line_stride[plane_index]
                    self.write_line_to_file(f, offset, self.memory_surface_data[plane_index][0, 0, line_index])
                f.write('}\n')

    def print_info(self):
        print("===== Information of %s with pattern %s, begin =====" % (self.name, self.pattern))
        print("----- surface data shape of %s, begin ----" % self.name)
        for plane_idx in range(self.plane_number):
            print(self.memory_surface_data[plane_idx].shape)
        print("----- surface data shape of %s, end  -----" % self.name)
        print("----- surface data of %s, begin ----" % self.name)
        for plane_idx in range(self.plane_number):
            print(self.memory_surface_data[plane_idx])
        print("----- surface data of %s, end  -----" % self.name)
        print("----- tensor data of %s, begin -----" % self.name)
        print(self.tensor_nchw)
        print("----- tensor data of %s, end   -----" % self.name)
        print("===== Information of %s with pattern %s, end =======" % (self.name, self.pattern))

class MemorySurfaceFactory():
    @classmethod
    def creat(cls, format):
        format_class_name = 'MemorySurface'+format
        return globals()[format_class_name]

if __name__ == "__main__":
    #msf = MemorySurfaceFactory.creat('FeatureMap')('AA')
    ##msf = MSFM('AA')
    #msf.generate_memory_surface(0, 2, 3, 4, 1, 1, 8, 16, 48, 48, 'int8', 'ones', 'AA_ones.dat')
    #msf.print_info()
    #msf.generate_memory_surface(0, 2, 3, 4, 1, 1, 8, 16, 48, 48, 'int8', 'zeros', 'AA_zeros.dat')
    #msf.print_info()
    #msf.generate_memory_surface(0, 2, 3, 4, 1, 1, 8, 16, 48, 48, 'int8', 'random', 'AA_random.dat')
    #msf.print_info()
    #msf.generate_memory_surface(0, 2, 3, 4, 1, 1, 8, 16, 48, 48, 'int8', 'nchw_index', 'AA_nchw_index.dat')
    #msf.print_info()
    #msf.generate_memory_surface(0, 2, 3, 4, 1, 1, 8, 16, 48, 48, 'int8', 'nch_wxatom_index', 'AA_nch_wxatom_index.dat')
    #msf.print_info()
    #msf.generate_memory_surface(0, 2, 3, 4, 1, 2, 8, 16, 48, 48, 'int8', 'shwan_index', 'AA_shwan_index.dat')
    #msf.print_info()
    #msf.dump_memory_surface_to_file()
    #msf.generate_memory_surface(0, 1, 1, 1, 1, 2, 8, 32, 32, 32, 'int16', 'nchw_index', 'AA_nchw_index_int16.dat')
    #msf.print_info()
    #msf.dump_memory_surface_to_file()
    #raise

    #msw = MemorySurfaceFactory.creat('Weight')('BB')
    ##width, height, channel, kernel_number, element_per_atom, kernel_per_group, data_type, pattern
    #msw.generate_memory_surface(0, 3, 3, 3, 5, 2, 2, 'int8', 8, 'nchw_index', False, 'weight_nchw_index.dat')
    #msw.print_info()
    #msw.dump_memory_surface_to_file()
    #
    #msw.generate_memory_surface(0, 3, 3, 3, 5, 2, 2, 'int16', 8, 'gshwp_index', False, 'weight_gshwp_index.dat')
    #msw.print_info()
    #msw.dump_memory_surface_to_file()
    #
    #msw.generate_memory_surface(0, 3, 3, 4, 4, 2, 2, 'int16', 8, 'nhwc_index', False, 'weight_nhwc_index_int16.dat')
    #msw.print_info()
    #msw.dump_memory_surface_to_file()
    #
    #msw.generate_memory_surface(0, 3, 3, 4, 4, 2, 2, 'int8', 8, 'gshwp_index', False, 'weight_gshwp_index_int8_aligned.dat')
    #msw.print_info()
    #msw.dump_memory_surface_to_file()

    #msw.generate_memory_surface(0, 3, 3, 4, 4, 2, 2, 'int8', 16, 'gshwp_index', True, ('weight_gshwp_index_int8_aligned_cmp.dat', 'weight_gshwp_index_int8_aligned_wmb.dat', 'weight_gshwp_index_int8_aligned_wgs.dat', ))
    #msw.print_info()
    #msw.dump_memory_surface_to_file()

    #msw.generate_memory_surface(0, 3, 3, 3, 5, 2, 2, 'int16', 16, 'gshwp_index', True, ('weight_gshwp_index_cmp.dat', 'weight_gshwp_index_wmb.dat', 'weight_gshwp_index_wgs.dat', ))
    #msw.print_info()
    #msw.dump_memory_surface_to_file()

    msp = MemorySurfaceFactory.creat('ImagePitch')('CC')
    #seed, width, height, channel, atomic_memory, line_stride, offset_x, pixel_format_name, data_type, pattern, file_name
    msp.generate_memory_surface(0, 3, 3, 4, 8, '32', 0, 'T_A8R8G8B8', 'int8', 'nchw_index', 'pitchlinear_l0.dat')
    msp.print_info()
    msp.dump_memory_surface_to_file()
    msp.generate_memory_surface(1, 3, 3, 4, 8, '32', 1, 'T_A8R8G8B8', 'int8', 'nchw_index', 'pitchlinear_l1.dat')
    msp.print_info()
    msp.dump_memory_surface_to_file()
    msp.generate_memory_surface(1, 3, 3, 3, 8, '32,32', 3, 'T_Y8___U8V8_N444', 'int8', 'nchw_index', 'pitchlinear_l3_0.dat,pitchlinear_l3_1.dat')
    msp.print_info()
    msp.dump_memory_surface_to_file()
    msp.generate_memory_surface(1, 3, 3, 3, 8, '32,32', 7, 'T_Y8___U8V8_N444', 'int8', 'nchw_index', 'pitchlinear_l7_0.dat,pitchlinear_l7_1.dat')
    msp.print_info()
    msp.dump_memory_surface_to_file()
