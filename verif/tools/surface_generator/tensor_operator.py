import numpy as np
from functools import reduce

class TensorOperator:
    '''
    Tensor Operatior:
        For tensor space allocation and manipulation
    '''
    # Data patterns
    supported_data_type = {'int8', 'int16', 'float16'}
    supported_pattern = {'random', 'index', 'zeros', 'ones'}

    @staticmethod
    def create_tensor_zeros(size_tuple, data_type):
        data = np.zeros(size_tuple, dtype=data_type)
        return data

    @staticmethod
    def create_tensor_ones(size_tuple, data_type):
        data = np.ones(size_tuple, dtype=data_type)
        return data

    @staticmethod
    def create_tensor_random(size_tuple, data_type):
        if np.issubdtype (data_type, np.integer):
            max_value = np.iinfo(data_type).max
            data = np.random.randint(max_value, size=size_tuple, dtype=data_type)
            return data
        else:
            max_value = np.finfo(data_type).max
            data = np.random.random(size_tuple) * max_value
            return data

    @staticmethod
    def create_tensor_index(size_tuple, data_type):
        total_element_number = reduce(lambda x, y: x*y, list(size_tuple))
        #print('total_element_number')
        #print(total_element_number)
        #print('size_tuple')
        #print(size_tuple)
        data = np.arange(total_element_number, dtype=data_type).reshape(size_tuple)
        #print('data')
        #print(data)
        return data

    @staticmethod
    def create_tensor(size_tuple, data_type='int8', pattern='index'):
        assert(pattern.lower() in TensorOperator.supported_pattern)
        assert(data_type in TensorOperator.supported_data_type)
        for dimension_size in size_tuple:
            assert(dimension_size > 0)
        method_name = 'create_tensor_' + pattern.lower()
        method = getattr(TensorOperator, method_name, TensorOperator.create_tensor_zeros)
        print ("Using method %s to create a tensor" % method.__name__)
        return method(size_tuple, np.dtype(data_type))

#    @staticmethod
#    def create_tensor_nchw_atom_index(self):
#        data = np.arange(self.total_element_num, dtype=self.data_type).reshape
#        return data

#    @staticmethod
#    def create_tensor(number, channel, height, width, data_type='int8', pattern='random', order='nchw'):
#        assert(data_type.lower() in cls.supported_data_type)
#        assert(pattern.lower() in cls.__tensor_data_patter__)
#        assert(order.lower() in cls.__tensor_order__)
#        assert(number>0)
#        assert(channel>0)
#        assert(height>0)
#        assert(width>0)
#        dimension_name_value_dict = {'n':number, 'c':channel, 'h':height, 'w':width}
#        size_tuple = (dimension_name_value_dict[order[0]], dimension_name_value_dict[order[1]],
#                      dimension_name_value_dict[order[2]], dimension_name_value_dict[order[3]])
#        method_name = 'create_tensor_' + pattern.lower()
#        method = getattr(self, method_name, self.create_tensor_zeros)
#        print ("Using method %s to create a tensor" % method.__name__)
#        self.tensor.set_data(method(size_tuple, np.dtype(data_type)), order)

    @staticmethod
    def append_c_compensation_to_nchw_tensor(nchw_uncompensated, element_per_atom, pattern='zeros'):
        allowed_pattern = {'zeros'}
        assert (pattern in allowed_pattern)
        (n,c,h,w) = nchw_uncompensated.shape
        if (0 == c%element_per_atom):
            return nchw_uncompensated
        else:
            c_appended = element_per_atom - c%element_per_atom
            tensor_for_compensation = np.zeros((n,c_appended,h,w), nchw_uncompensated.dtype)
            nchw_compensated = np.append(nchw_uncompensated, tensor_for_compensation, 1)
            return nchw_compensated
    
    @staticmethod
    def remove_c_compensation_from_nchw_tensor(nchw_compensated, c):
        (n,c_compensated,h,w) = nchw_compensated.shape
        assert(c <= c_compensated)
        assert(c > 0)
        if (0 == c_compensated):
            return nchw_compensated
        else:
            nchw = nchw_compensated[:,:c,:,:]
            return nchw
    
    @staticmethod
    def convert_tensor_from_nchw_to_nch_wxatom(nchw, element_per_atom):
        assert(4==len(nchw.shape))
        (n,c,h,w) = nchw.shape
        assert(0==c%element_per_atom)
        c_div_element_per_atom = c // element_per_atom
        #print ('nchw')
        #print (nchw)
        # swap W and C, get array in NWHC
        #  axes mapping for nchw {0:number, 1: channel, 2: height, 3: width}
        #  axes mapping for nwhc {0:number, 1: width, 2: height, 3: channel}
        nwhc = np.swapaxes(nchw, 1, 3) 
        #print ('nwhc')
        #print (nwhc)
        # reshape nwhc to nwhc_atom which axes mapping is  {0:number, 1: width, 2: height, 3: c_div_element_per_atom, 4:atom}
        nwhc_atom = nwhc.reshape(n,w,h,c_div_element_per_atom,element_per_atom)
        #print ('nwhc_atom')
        #print (nwhc_atom)
        # swap W and C of nwhc_atom, get array in NCHW_atom which axes mapping is  {0:number, 1: c_div_element_per_atom, 2: height, 3: width, 4:atom}
        nchw_atom = np.swapaxes(nwhc_atom, 1, 3)
        #print('nchw_atom')
        #print(nchw_atom)
        # fused atoms with the w iteration, reshape to ch_atom which axes mapping is {0:number, 1: c_div_element_per_atom, 2: height, 3: atom*w}
        nch_wxatom = nchw_atom.reshape(n,c_div_element_per_atom, h, element_per_atom*w)
        #print ('nch_wxatom')
        #print (nch_wxatom)
        return nch_wxatom

    @staticmethod
    def convert_tensor_from_nch_wxatom_to_nchw(nch_wxatom, element_per_atom):
        assert(4==len(nch_wxatom.shape))
        (n,c_div_element_per_atom,h,w_mul_element_per_atom) = nch_wxatom.shape
        assert(0 == w_mul_element_per_atom % element_per_atom, "w_mul_element_per_atom: %d, element_per_atom: %d" % (w_mul_element_per_atom, element_per_atom))
        w = w_mul_element_per_atom//element_per_atom
        c = c_div_element_per_atom * element_per_atom
        #print ('nch_wxatom')
        #print (nch_wxatom)
        # reshape to nchw_atom which axes mapping is:
        # {0:number, 1: channel_div_element_per_atom, 2: height, 3: width, 4:atom}
        nchw_atom = nch_wxatom.reshape(n,c_div_element_per_atom,h,w,element_per_atom)
        #print ('nchw_atom')
        #print (nchw_atom)
        # swap W and C to get array in NWHC_atom which axes mapping is:
        # {0:number, 1: width, 2: height, 3: channel_div_element_per_atom, 4:atom}
        nwhc_atom = np.swapaxes(nchw_atom, 1, 3)
        #print('nwhc_atom')
        #print(nwhc_atom)
        # reshape to get NWHC which axes mapping is {0:number, 1: width, 2: height, 3: channel}
        nwhc = nwhc_atom.reshape(n, w, h, c)
        #print ('nwhc')
        #print (nwhc)
        # swap W and C to get NCHW which axes mapping is {0:number, 1: channel, 2: height, 3: width}
        nchw = np.swapaxes(nwhc, 1, 3)
        #print('nchw')
        #print(nchw)
        return nchw

    @staticmethod
    def convert_tensor_from_nchw_to_sh_wan(nchw, element_per_atom):
        '''
        nchw (p is n)->wchn->whcn->whs_an->shw_an->sh_wan
        '''
        assert(4==len(nchw.shape))
        (n,c,h,w) = nchw.shape
        assert(0==c%element_per_atom)
        s = c // element_per_atom
        # swap P and , get array in WCHN
        #  axes mapping for nchw {0:number, 1: channel, 2: height, 3: width}
        #  axes mapping for wchn {0:width, 1: channel, 2: height, 3: number}
        wchn = np.swapaxes(nchw, 0, 3) 
        whcn = np.swapaxes(wchn, 1, 2)
        # whsan = whcn.reshape(w, h, s, element_per_atom, n)
        # whs_an = whsan.reshape(w, h, s, element_per_atom*n)
        whs_an = whcn.reshape(w, h, s, element_per_atom*n)
        shw_an = np.swapaxes(whs_an, 0, 2)
        sh_wan = shw_an.reshape(1, s, h, w*element_per_atom*n)  # add more dimension to keep dimension consistency
        #print ('sh_wan', sh_wan)
        return sh_wan

    @staticmethod
    def convert_tensor_from_sh_wan_to_nchw(sh_wan, element_per_atom, n):
        '''
        sh_wan->shw_an->whs_an->whcn->nhcw->nchw
        '''
        assert(4==len(sh_wan.shape))
        (b, s, h, wan) = sh_wan.shape
        assert(wan%n==0)
        assert(wan%element_per_atom==0)
        a = element_per_atom
        c = s*a
        w = wan//a//n
        shw_an = sh_wan.reshape(s, h, w, a*n)
        whs_an = np.swapaxes(shw_an, 0, 2)
        whcn = whs_an.reshape(w,h,c,n)
        nhcw = np.swapaxes(whcn, 0, 3)
        nchw = np.swapaxes(nhcw, 1, 2)
        #print('nchw', nchw)
        return nchw

    @staticmethod
    def convert_nchw_to_nwhc(nchw):
        nwhc = np.swapaxes(nchw, 1, 3)
        return nwhc
    
    @staticmethod
    def convert_nhwc_to_nchw(nhwc):
        ncwh = np.swapaxes(nhwc, 1, 3)
        nchw = np.swapaxes(ncwh, 2, 3)
        return nchw
    
    @staticmethod
    def split_c_last_tensor_by_c_alignment(c_last_tensor, element_per_atom):
        *args, c = c_last_tensor.shape
        c_remained = c % element_per_atom
        c_algined = c - c_remained
        last_axis_index = len(c_last_tensor.shape)-1
        tensor_c_aligned, tensor_c_remained = np.split(c_last_tensor, [c_algined], axis=last_axis_index)
        return (tensor_c_aligned, tensor_c_remained)
    
    @staticmethod
    def convert_nchw_to_gkhwc(nchw, kernel_per_group):
        k, c, h, w = nchw.shape
        g = (k+kernel_per_group-1)//kernel_per_group
        gkchw = nchw.reshape(g, kernel_per_group, c, h, w)
        #print('gkchw')
        #print(gkchw)
        #print(gkchw.shape)
        gkwhc = np.swapaxes(gkchw,2,4)
        gkhwc = np.swapaxes(gkwhc,2,3)
        return gkhwc
    
    @staticmethod
    def convert_gkhwc_to_gm(gkhwc, element_per_atom):
        g, k, h, w, c = gkhwc.shape
        s = (c+element_per_atom-1)//element_per_atom
        gkhwsa = gkhwc.reshape(g, k, w, h, s, element_per_atom)
        #print('gkhwsa')
        #print(gkhwsa)
        #print(gkhwsa.shape)
        gshwka = np.swapaxes(gkhwsa, 1, 4)
        #print('gshwka')
        #print(gshwka)
        #print(gshwka.shape)
        m = s*h*w*k*element_per_atom
        gm = gshwka.reshape(g, m)
        return gm
    
    @staticmethod
    def convert_nchw_to_gm(nchw, kernel_per_group, element_per_atom):
        assert(len(nchw.shape)==4)
        #k,c,h,w = nchw.shape
        #print('convert_nchw_to_gm:nchw')
        #print(nchw)
        #print(nchw.shape)
        gkhwc = TensorOperator.convert_nchw_to_gkhwc(nchw, kernel_per_group)
        #print('convert_nchw_to_gm:gkhwc')
        #print(gkhwc)
        #print(gkhwc.shape)
        gkhwc_aligned, gkhwc_remained = TensorOperator.split_c_last_tensor_by_c_alignment(gkhwc, element_per_atom)
        #print('convert_nchw_to_gm:gkhwc_aligned')
        #print(gkhwc_aligned)
        #print(gkhwc_aligned.shape)
        #print('gkhwc_remained')
        #print(gkhwc_remained)
        #print(gkhwc_remained.shape)
        if (0 == gkhwc_remained.size):
            gm = TensorOperator.convert_gkhwc_to_gm(gkhwc_aligned, element_per_atom)
        else:
            gm_aligned, gm_remained = map(TensorOperator.convert_gkhwc_to_gm, 
                                          (gkhwc_aligned, gkhwc_remained),
                                          (element_per_atom, gkhwc_remained.shape[-1])
                                         )
            #print('gm_aligned')
            #print(gm_aligned)
            #print(gm_aligned.shape)
            #print('gm_remained')
            #print(gm_remained)
            #print(gm_remained.shape)
            gm = np.concatenate((gm_aligned,gm_remained), 1)
        #print('gm')
        #print(gm)
        return gm
    
    @staticmethod
    def convert_nchw_to_weight_memory_surface(nchw, kernel_per_group, element_per_atom):
        assert(len(nchw.shape)==4)
        k, c, h, w = nchw.shape
        k_remained = k % kernel_per_group
        k_algined = k - k_remained
        nchw_aligned, nchw_remained = np.split(nchw, [k_algined], axis=0)
        #print('nchw_aligned')
        #print(nchw_aligned)
        #print(nchw_aligned.shape)
        #print('nchw_remained')
        #print(nchw_remained)
        #print(nchw_remained.shape)
        if 0 == nchw_remained.size:
            gm = TensorOperator.convert_nchw_to_gm(nchw_aligned, kernel_per_group, element_per_atom)
            memory_surface = gm.reshape(gm.size)
        else:
            gm_aligned, gm_remained = map(TensorOperator.convert_nchw_to_gm, 
                                          (nchw_aligned, nchw_remained),
                                          (kernel_per_group, k_remained),
                                          (element_per_atom, element_per_atom)
                                         )
            memory_surface = np.concatenate((gm_aligned.reshape(gm_aligned.size),gm_remained.reshape(gm_remained.size)))
        return memory_surface
    
    @staticmethod
    def convert_memory_surface_to_gm(memory_surface, group_number):
        assert(0==memory_surface.size%group_number)
        m = memory_surface.size // group_number
        gm = memory_surface.reshape(group_number, m)
        return gm
    
    @staticmethod
    def convert_gm_to_gkhwc(gm, kchw_tuple, element_per_atom):
        kernel_per_group, c, h, w = kchw_tuple
        g, m = gm.shape
        assert(0 == c%element_per_atom)
        #assert(0 == kernel_per_group%g)
        s = c//element_per_atom
        #kernel_per_group = k//g
        gshwka = gm.reshape(g, s, h, w, kernel_per_group, element_per_atom)
        #gshwka -> gkhwsa
        gkhwsa = np.swapaxes(gshwka, 1, 4)
        #gkhwsa -> gkhwc
        gkhwc = gkhwsa.reshape(g, kernel_per_group, h, w, c)
        return gkhwc
    
    #   gm -> gm_c_aligned, gm_c_remained
    #       gm -> gkhwc
    #   gkhwc_c_aligned, gkhwc_c_remained -> gkhwc
    #   gkhwc -> nchw
    @staticmethod
    def convert_gm_to_nchw(gm, kchw_tuple, element_per_atom):
        kernel_per_group, c, h, w = kchw_tuple
        g, m = gm.shape
        assert(kernel_per_group*c*h*w == m)
        k = kernel_per_group * g
        c_remained = c % element_per_atom
        c_aligned = c - c_remained
        m_c_aligned = kernel_per_group*c_aligned*h*w
        #m_c_remained = kernel_per_group*c_remained*h*w
#        print('kchw_tuple')
#        print(kchw_tuple)
#        print('m_c_aligned')
#        print(m_c_aligned)
#        print('gm')
#        print(gm)
#        print(gm.shape)
        gm_c_aligned, gm_c_remained = np.split(gm, [m_c_aligned], axis=1)
        if(0 == gm_c_remained.size):
            gkhwc = TensorOperator.convert_gm_to_gkhwc(gm_c_aligned, (kernel_per_group, c_aligned, h, w), element_per_atom)
        else:
            gkhwc_c_aligned, gkhwc_c_remained = map(TensorOperator.convert_gm_to_gkhwc,
                                                    (gm_c_aligned, gm_c_remained),
                                                    ((kernel_per_group, c_aligned, h, w), (kernel_per_group, c_remained, h, w)),
                                                    (element_per_atom, c_remained)
                                                   )
            last_axis_index = len(gkhwc_c_aligned.shape)-1
            gkhwc = np.concatenate((gkhwc_c_aligned, gkhwc_c_remained), axis=last_axis_index)
        #gkhwc -> gkcwh ->gkchw
        gkcwh = np.swapaxes(gkhwc, 2, 4)
        gkchw = np.swapaxes(gkcwh, 3, 4)
        nchw = gkchw.reshape(k, c, h, w)
        return nchw
    
    @staticmethod
    def convert_weight_memory_surface_to_nchw(memory_surface, k, c, h, w, kernel_per_group, element_per_atom):
        # split by K alignment
        assert(k*c*h*w <= memory_surface.size) # memory_surface may contain garbage alignment
        k_remained = k % kernel_per_group
        k_aligned = k - k_remained
        g_aligned = k // kernel_per_group
        g_remained = (k + kernel_per_group -1)//kernel_per_group - g_aligned
        # msf -> msf_k_aligned, msf_k_remained
        element_num_k_aligned = k_aligned*c*h*w
        msf_k_aligned, msf_k_remained = np.split(memory_surface[:k*c*h*w], [element_num_k_aligned])
        if (0 == msf_k_remained.size):
            gm_k_aligned = TensorOperator.convert_memory_surface_to_gm(msf_k_aligned, g_aligned)
            nchw = TensorOperator.convert_gm_to_nchw(gm_k_aligned, (kernel_per_group,c,h,w), element_per_atom)
        else:
            (gm_k_aligned, gm_k_remained) = map(TensorOperator.convert_memory_surface_to_gm, 
                                                  (msf_k_aligned, msf_k_remained),
                                                  (g_aligned, g_remained)
                                             )
    #        print('gm_k_aligned')
    #        print(gm_k_aligned)
    #        print(gm_k_aligned.shape)
    #        print('gm_k_remained')
    #        print(gm_k_remained)
    #        print(gm_k_remained.shape)
            #    msf -> gm
            #    gm -> gm_c_aligned, gm_c_remained
            #        gm -> gshwa -> gkhwc
            #    gkhwc_c_aligned, gkhwc_c_remained -> gkhwc
            #    gkhwc -> nchw
            nchw_k_aligned,nchw_k_remained = map(TensorOperator.convert_gm_to_nchw,
                                                 (gm_k_aligned, gm_k_remained),
                                                 ((kernel_per_group,c,h,w),(k_remained,c,h,w)),
                                                 (element_per_atom, element_per_atom)
                                                )
            # nchw_k_aligned, nchw_k_remained -> nchw
            nchw = np.concatenate((nchw_k_aligned, nchw_k_remained))
        return nchw

    @staticmethod
    def align_array_size(array_unaligned, value, alignment_in_byte):
        assert(alignment_in_byte>0)
        if (array_unaligned.size*array_unaligned.dtype.itemsize)%alignment_in_byte == 0:
            return array_unaligned
        else:
            alignment_in_element = alignment_in_byte//array_unaligned.dtype.itemsize
            return np.lib.pad(array_unaligned,
                    (0, alignment_in_element - array_unaligned.size%alignment_in_element),
                    'constant', constant_values=(value,value)
                    )

    @staticmethod
    def compress_array_by_element(array_uncompressed, element_per_group, alignment_in_byte):
        '''
        Compress a uncompressed tensor by element, returns compressed array, mask array, and array group size
        @Parameter
        @Return value:(array_compressed, array_mask, array_group_size)
        '''
        assert(len(array_uncompressed.shape)!=0)
        assert(array_uncompressed.size>0)
        assert(element_per_group>0)
        assert(alignment_in_byte>0)
        element_byte_size = array_uncompressed.dtype.itemsize
        assert((array_uncompressed.size*element_byte_size)%alignment_in_byte==0)
        alignment_in_element = alignment_in_byte//element_byte_size
        group_num = (array_uncompressed.size + element_per_group - 1)//element_per_group
        array_compressed = array_uncompressed[array_uncompressed!=0]
        array_mask  = np.packbits(np.ma.getmask(np.ma.masked_not_equal(array_uncompressed, 0)))
        array_group_size = np.empty(group_num, dtype='uint32')
        for index, array_group in enumerate(np.split(array_uncompressed, list(range(element_per_group,array_uncompressed.size,element_per_group)))):
            array_group_size[index] = np.count_nonzero(array_group)*element_byte_size
        #print('array_group_size',array_group_size)
        array_compressed = TensorOperator.align_array_size(array_compressed, 0, alignment_in_byte)
        array_mask       = TensorOperator.align_array_size(array_mask, 0, alignment_in_byte)
        # each group size shall be aligned to alignment_in_byte
        for index in range(array_group_size.size-1):
            if array_group_size[index]%alignment_in_byte != 0:
                aligned = alignment_in_byte - array_group_size[index]%alignment_in_byte
                array_group_size[index]   += aligned
                array_group_size[index+1] -= aligned
        if array_group_size.sum()%alignment_in_byte != 0:
            array_group_size[-1] += alignment_in_byte - array_group_size.sum()%alignment_in_byte
        #print('array_group_size',array_group_size)
        return (array_compressed, array_mask, array_group_size)

    @staticmethod
    def decompress_array_by_element(array_compressed, array_mask, array_group_size):
        print(array_compressed, array_mask, array_group_size)
        assert((array_compressed.size*array_compressed.dtype.itemsize) == array_group_size.sum())
        assert(array_compressed.size>0)
        assert(array_mask.size>0)
        assert(array_group_size.size>0)
        array_mask_bit_per_element = np.unpackbits(array_mask)
        compressed_iter = np.nditer(array_compressed)
        array_decompressed = np.zeros(array_mask_bit_per_element.size, dtype=array_compressed.dtype)
        for idx, value in enumerate(array_mask_bit_per_element):
            if value != 0:
                array_decompressed[idx] = compressed_iter.value
                compressed_iter.iternext()
        return array_decompressed

    @staticmethod
    def merge_nchw_tensors_by_dimemsion(tensor_list, dimension_id):
        nchw = np.concatenate(tensor_list, dimension_id)
        return nchw

    @staticmethod
    def split_tensor_nchw_by_dimemsion(tensor, split_boarder_indices, dimension_id):
        tensor_list = np.split(tensor, split_boarder_indices, dimension_id)
        return tensor_list

    @staticmethod
    def adjust_channel_order(tensor, channel_order):
        assert(len(channel_order) == len(set(channel_order)), "Channel order is %s" % str(channel_order))
        dimension_channel_axis_id = 1
        tensor_adjusted = tensor[:,channel_order,:,:]
        ## explanation code
        #channel_number = tensor.shape[dimension_channel_axis_id]
        #tensor_list = np.split(tensor, channel_number, dimension_channel_axis_id)
        #tensor_adjusted = np.concatenate(list(tensor_item for order_item,tensor_item in sorted(zip(channel_order, tensor_list)) ), dimension_channel_axis_id)
        return tensor_adjusted

    @staticmethod
    def print_tensor(name, data):
        print ("==== Tensor Data of %s begin ====" % name)
        print (data)
        print ("==== Tensor Data of %s end ====" % name)

if __name__ == "__main__":
    nchw_2_4_3_2 = TensorOperator.create_tensor((2, 4, 3, 2))
    TensorOperator.print_tensor('nchw_2_4_3_2', nchw_2_4_3_2)
    kchw_kpg_ac_5_3_3_3_2_2 = TensorOperator.create_tensor((5, 3, 3, 3), data_type='int16')
    msf_5_3_3_3_2_2= TensorOperator.convert_nchw_to_weight_memory_surface(kchw_kpg_ac_5_3_3_3_2_2, 2, 2)
    TensorOperator.print_tensor('kchw_kpg_ac_5_3_3_3_2_2', kchw_kpg_ac_5_3_3_3_2_2)
    TensorOperator.print_tensor('msf_5_3_3_3_2_2', msf_5_3_3_3_2_2)
    kchw_kpg_ac_5_3_3_3_2_2_converted = TensorOperator.convert_weight_memory_surface_to_nchw(msf_5_3_3_3_2_2, 5, 3, 3, 3, 2, 2)
    TensorOperator.print_tensor('kchw_kpg_ac_5_3_3_3_2_2_converted', kchw_kpg_ac_5_3_3_3_2_2_converted)
    #kchw_kpg_ac_5_4_3_3_2_2 = TensorOperator.create_tensor((5, 4, 3, 3), data_type='int16')
    #msf_5_4_3_3_2_2= TensorOperator.convert_nchw_to_weight_memory_surface(kchw_kpg_ac_5_4_3_3_2_2, 2, 2)
    #TensorOperator.print_tensor('msf_5_4_3_3_2_2', msf_5_4_3_3_2_2)
