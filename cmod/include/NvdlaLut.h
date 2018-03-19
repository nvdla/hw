// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NvdlaLut.h

#ifndef _NVDLALUT_H_
#define _NVDLALUT_H_

#define RAW_TABLE_INDEX 0
#define DENSITY_TABLE_INDEX 1
#define RAW_TABLE_SIZE 257
#define DENSITY_TABLE_SIZE 65
#define SYM_TYPE_NONE 0
#define SYM_TYPE_AXIS 1
#define SYM_TYPE_POINT 2
class NvdlaLut {
    public:
        // Constructors and deconstructors
        NvdlaLut ();
        NvdlaLut (uint32_t raw_table_size, uint32_t density_table_size);
        ~NvdlaLut ();
        void set_table_index(uint8_t  table_index);
        void set_entry_index(uint32_t entry_index);
        void set_table_content(uint32_t data);
        void set_symmetry_type(uint8_t type);
        void set_symmetry_coor_x(uint16_t coor_x);
        void set_symmetry_coor_y(uint16_t coor_y);
        void set_density_table_win_start(uint8_t win_start);
        void set_density_table_win_width(uint8_t win_width);
        void set_density_table_en(uint8_t enable);
        // void setup_table_content(uint32_t & src_data, uint8_t table_index);
        uint8_t  get_table_index();
        uint32_t get_entry_index();
        uint32_t get_table_content();
        uint8_t  get_symmetry_type();
        uint16_t get_symmetry_coor_x();
        uint16_t get_symmetry_coor_y();
        uint8_t  get_density_table_win_start();
        uint8_t  get_density_table_win_width();
        uint8_t  get_density_table_en();
        uint16_t query(int16_t data_in);
    private:
        void        allocate_memory_for_tables ();
        // Look up tables
        uint8_t     table_index_;
        uint32_t    raw_entry_index_;
        uint32_t    density_entry_index_;
        uint16_t    *raw_table_content_;
        uint32_t    raw_table_size_;
        uint16_t    *density_table_content_;
        uint32_t    density_table_size_;
        uint8_t     symmetry_type_;
        uint16_t    symmetry_coor_x_;
        uint16_t    symmetry_coor_y_;
        uint8_t     density_table_win_start_;
        uint8_t     density_table_win_width_;
        uint8_t     density_table_en_;
};

inline NvdlaLut::NvdlaLut ():
    // Initiates table_size with pre-defined value
    raw_table_size_(RAW_TABLE_SIZE),
    density_table_size_(DENSITY_TABLE_SIZE)
{
    table_index_ = 0;
    raw_entry_index_ = 0;
    density_entry_index_ = 0;
    // allocate memory for tables
    allocate_memory_for_tables();
}

inline NvdlaLut::NvdlaLut (uint32_t raw_table_size, uint32_t density_table_size) {
    raw_table_size_     = raw_table_size;
    density_table_size_ = density_table_size;
    table_index_ = 0;
    raw_entry_index_ = 0;
    density_entry_index_ = 0;
    // allocate memory for tables
    allocate_memory_for_tables();
}

inline NvdlaLut::~NvdlaLut () {
    if (NULL != raw_table_content_)     delete [] raw_table_content_;
    if (NULL != density_table_content_) delete [] density_table_content_;
}

inline void NvdlaLut::allocate_memory_for_tables () {
    raw_table_content_ = new uint16_t [raw_table_size_];
    density_table_content_ = new uint16_t [density_table_size_];
}

inline void NvdlaLut::set_table_index(uint8_t  table_index){
    table_index_ = table_index;
}

inline void NvdlaLut::set_entry_index(uint32_t entry_index){
    if (RAW_TABLE_INDEX == table_index_) {
        raw_entry_index_ = entry_index;
    } else {
        density_entry_index_ = entry_index;
    }
}

inline void NvdlaLut::set_table_content (uint32_t data) {
    if (RAW_TABLE_INDEX == table_index_) {
        if (raw_entry_index_ < raw_table_size_) {
            raw_table_content_[raw_entry_index_] = data;
        }
        raw_entry_index_++;
    } else if (DENSITY_TABLE_INDEX == table_index_) {
        if (density_entry_index_ < density_table_size_) {
            density_table_content_[density_entry_index_] = data;
        }
        density_entry_index_++;
    }
}

inline uint8_t NvdlaLut::get_table_index() {
    return table_index_;
}

inline uint32_t NvdlaLut::get_entry_index() {
    if (RAW_TABLE_INDEX == table_index_) {
        return raw_entry_index_;
    } else {
        return density_entry_index_;
    }
}

inline uint32_t NvdlaLut::get_table_content() {
    if (RAW_TABLE_INDEX == table_index_) {
        if (raw_entry_index_ < raw_table_size_) {
            return raw_table_content_[raw_entry_index_++];
        }
    } else if (DENSITY_TABLE_INDEX == table_index_) {
        if (raw_entry_index_ < density_table_size_) {
            return density_table_content_[raw_entry_index_++];
        }
    }
    // Implies entry index or table index violation
    return 0;
}

inline void     NvdlaLut::set_symmetry_type(uint8_t type){
    symmetry_type_ = type;
}

inline void     NvdlaLut::set_symmetry_coor_x(uint16_t coor_x){
    symmetry_coor_x_ = coor_x;
}

inline void     NvdlaLut::set_symmetry_coor_y(uint16_t coor_y){
    symmetry_coor_y_ = coor_y;
}

inline void     NvdlaLut::set_density_table_win_start(uint8_t win_start){
    density_table_win_start_ = win_start;
}

inline void     NvdlaLut::set_density_table_win_width(uint8_t win_width){
    density_table_win_width_ = win_width;
}

inline void     NvdlaLut::set_density_table_en(uint8_t enable){
    density_table_en_ = enable;
}

inline uint8_t  NvdlaLut::get_symmetry_type(){
    return symmetry_type_;
}

inline uint16_t NvdlaLut::get_symmetry_coor_x(){
    return symmetry_coor_x_;
}

inline uint16_t NvdlaLut::get_symmetry_coor_y(){
    return symmetry_coor_y_;
}

inline uint8_t  NvdlaLut::get_density_table_win_start(){
    return density_table_win_start_;
}

inline uint8_t  NvdlaLut::get_density_table_win_width(){
    return density_table_win_width_;
}

inline uint8_t  NvdlaLut::get_density_table_en(){
    return density_table_en_;
}

inline uint16_t NvdlaLut::query(int16_t data_in) {
    uint32_t idx_0, idx_1;
    uint16_t offset_0, offset_1;
    uint16_t threshold_low, threshold_high; // Density table
    bool is_lut_sym = false;
    uint16_t shift_num;
    uint16_t delta_index;
    uint16_t lut_in;
    int16_t  lut_out_0, lut_out_1;
    int32_t  multi_data;
    int16_t  result;
    threshold_low  = density_table_win_start_;
    threshold_high = density_table_win_start_ + (1 << density_table_win_width_);
    if (SYM_TYPE_NONE != symmetry_type_) {
        is_lut_sym = true;
    }
    lut_in = is_lut_sym ? abs(data_in) : data_in;
    // Query
    if ( (lut_in  < threshold_low) || (lut_in > threshold_high) ) {
        // Query raw table
        idx_0       = is_lut_sym ? lut_in >> 7   : (lut_in >> 8) + 0x80;
        idx_1       = idx_0 + 1;
        offset_0    = is_lut_sym  ? lut_in & 0x7f : lut_in & 0xff;
        offset_1    = (is_lut_sym ? 128 : 256) - offset_0;
        lut_out_0   = raw_table_content_[idx_0];
        lut_out_1   = raw_table_content_[idx_1];
        // Linear interpolation
        multi_data  = lut_out_0 * offset_1 + lut_out_1 * offset_0;
        result      = is_lut_sym ? multi_data >> 7 : multi_data >> 8;
    }
    else{
        // Query density table
        shift_num   = density_table_win_width_ + (is_lut_sym ? 0x1 : 0x2);
        delta_index = lut_in - threshold_low;
        idx_0       = (delta_index >> shift_num) & 0x3f;
        idx_1       = idx_0 + 1;
        offset_0    = delta_index & ( ( 1<<shift_num ) - 0x1 );
        offset_1    = ( 1 << shift_num ) - offset_0;
        lut_out_0   = density_table_content_[idx_0];
        lut_out_1   = density_table_content_[idx_1];
        // Linear interpolation
        multi_data  = lut_out_0 * offset_1 + lut_out_1 * offset_0;
        result      = multi_data >> shift_num;
    }
    if (SYM_TYPE_POINT != symmetry_type_) {
        result = 2*raw_table_content_[0] - result;
    }
    return result;
}

#endif



