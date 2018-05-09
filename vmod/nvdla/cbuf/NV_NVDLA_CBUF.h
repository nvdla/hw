// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: NV_NVDLA_CBUF.h
#define CBUF_BANK_NUMBER            NVDLA_CBUF_BANK_NUMBER
#define CBUF_BANK_DEPTH             NVDLA_CBUF_BANK_DEPTH
#define CBUF_ENTRY_WIDTH            NVDLA_CBUF_ENTRY_WIDTH
#define CBUF_ENTRY_BYTE             CBUF_ENTRY_WIDTH/8
#define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH 
#define CBUF_BANK_DEPTH_BITS        NVDLA_CBUF_BANK_DEPTH_LOG2  //log2(bank_depth), how many bits need to give an address in BANK
#define CBUF_RD_DATA_SHIFT_WIDTH    NVDLA_CBUF_WIDTH_MUL2_LOG2  //log2(ram_width*2),width of data shift
#define CBUF_ADDR_WIDTH             NVDLA_CBUF_DEPTH_LOG2       //log2(bank_depth*bank_num)for both read and write
#define CBUF_RD_PORT_WIDTH          CBUF_ENTRY_WIDTH
#define CBUF_WR_PORT_NUMBER         2   //how many write ports.
#define CSC_IMAGE_MAX_STRIDE_BYTE   32  //=stride_max*channel_max*BPE, stride could be config max to 8, image channel to 4.         

#if (NVDLA_CC_ATOMC_DIV_ATOMK==1) & (CBUF_ENTRY_BYTE >=CSC_IMAGE_MAX_STRIDE_BYTE)
    #define CBUF_BANK_RAM_CASE          0
    `define CBUF_BANK_RAM_CASE0
    `define CBUF_NO_SUPPORT_READ_JUMPING
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==1) & (CBUF_ENTRY_BYTE < CSC_IMAGE_MAX_STRIDE_BYTE)
    #define CBUF_BANK_RAM_CASE          1
    `define CBUF_BANK_RAM_CASE1
    `define CBUF_SUPPORT_READ_JUMPING
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==2) & (CBUF_ENTRY_BYTE >=CSC_IMAGE_MAX_STRIDE_BYTE)
    #define CBUF_BANK_RAM_CASE          2
    `define CBUF_BANK_RAM_CASE2
    `define CBUF_NO_SUPPORT_READ_JUMPING
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==2) & (CBUF_ENTRY_BYTE <CSC_IMAGE_MAX_STRIDE_BYTE)
    #define CBUF_BANK_RAM_CASE          3
    `define CBUF_BANK_RAM_CASE3
    `define CBUF_SUPPORT_READ_JUMPING
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==4) & (CBUF_ENTRY_BYTE >=CSC_IMAGE_MAX_STRIDE_BYTE)
    #define CBUF_BANK_RAM_CASE          4
    `define CBUF_BANK_RAM_CASE4
    `define CBUF_NO_SUPPORT_READ_JUMPING
#elif (NVDLA_CC_ATOMC_DIV_ATOMK==4) & (CBUF_ENTRY_BYTE <CSC_IMAGE_MAX_STRIDE_BYTE)
    #define CBUF_BANK_RAM_CASE          5
    `define CBUF_BANK_RAM_CASE5
    `define CBUF_SUPPORT_READ_JUMPING
#endif


//ram case could be 0/1/2/3/4/5  0:1ram/bank; 1:1*2ram/bank; 2:2*1ram/bank; 3:2*2ram/bank  4:4*1ram/bank  5:4*2ram/bank
#if (CBUF_BANK_RAM_CASE==0)
    #define CBUF_RAM_PER_BANK           1   
    #define CBUF_WR_BANK_SEL_WIDTH      1
    #define CBUF_RAM_WIDTH              NVDLA_CBUF_ENTRY_WIDTH  
    #define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH 
    #define CBUF_RAM_DEPTH_BITS         CBUF_BANK_DEPTH_BITS
#elif (CBUF_BANK_RAM_CASE==1)
    #define CBUF_RAM_PER_BANK           2   
    #define CBUF_WR_BANK_SEL_WIDTH      1
    #define CBUF_RAM_WIDTH              NVDLA_CBUF_ENTRY_WIDTH
    #define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH/2 
    #define CBUF_RAM_DEPTH_BITS         CBUF_BANK_DEPTH_BITS-1
#elif (CBUF_BANK_RAM_CASE==2)
    #define CBUF_RAM_PER_BANK           2   
    #define CBUF_WR_BANK_SEL_WIDTH      2
    #define CBUF_RAM_WIDTH              NVDLA_CBUF_ENTRY_WIDTH/2
    #define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH 
    #define CBUF_RAM_DEPTH_BITS         CBUF_BANK_DEPTH_BITS
#elif (CBUF_BANK_RAM_CASE==3)
    #define CBUF_RAM_PER_BANK           4   
    #define CBUF_WR_BANK_SEL_WIDTH      2
    #define CBUF_RAM_WIDTH              NVDLA_CBUF_ENTRY_WIDTH/2
    #define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH/2 
    #define CBUF_RAM_DEPTH_BITS         CBUF_BANK_DEPTH_BITS-1
#elif (CBUF_BANK_RAM_CASE==4)
    #define CBUF_RAM_PER_BANK           4   
    #define CBUF_WR_BANK_SEL_WIDTH      4
    #define CBUF_RAM_WIDTH              NVDLA_CBUF_ENTRY_WIDTH/4
    #define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH 
    #define CBUF_RAM_DEPTH_BITS         CBUF_BANK_DEPTH_BITS
#elif (CBUF_BANK_RAM_CASE==5)
    #define CBUF_RAM_PER_BANK           8   
    #define CBUF_WR_BANK_SEL_WIDTH      4
    #define CBUF_RAM_WIDTH              NVDLA_CBUF_ENTRY_WIDTH/4
    #define CBUF_RAM_DEPTH              NVDLA_CBUF_BANK_DEPTH/2 
    #define CBUF_RAM_DEPTH_BITS         CBUF_BANK_DEPTH_BITS-1
#endif

#define CBUF_WR_PORT_WIDTH          CBUF_RAM_WIDTH 

#if (CBUF_BANK_NUMBER==2)
    #if (CBUF_BANK_DEPTH==512)
        #define CBUF_BANK_SLICE             "9:9"  
    #elif (CBUF_BANK_DEPTH==256)
        #define CBUF_BANK_SLICE             "8:8"  
    #elif (CBUF_BANK_DEPTH==128)
        #define CBUF_BANK_SLICE             "7:7"  
    #elif (CBUF_BANK_DEPTH==64)
        #define CBUF_BANK_SLICE             "6:6"  
    #endif
#elif (CBUF_BANK_NUMBER==4)
    #if (CBUF_BANK_DEPTH==512)
        #define CBUF_BANK_SLICE             "10:9"  
    #elif (CBUF_BANK_DEPTH==256)
        #define CBUF_BANK_SLICE             "9:8"  
    #elif (CBUF_BANK_DEPTH==128)
        #define CBUF_BANK_SLICE             "8:7"  
    #elif (CBUF_BANK_DEPTH==64)
        #define CBUF_BANK_SLICE             "7:6"  
    #endif
#elif (CBUF_BANK_NUMBER==8)
    #if (CBUF_BANK_DEPTH==512)
        #define CBUF_BANK_SLICE             "11:9"  
    #elif (CBUF_BANK_DEPTH==256)
        #define CBUF_BANK_SLICE             "10:8"  
    #elif (CBUF_BANK_DEPTH==128)
        #define CBUF_BANK_SLICE             "9:7"  
    #elif (CBUF_BANK_DEPTH==64)
        #define CBUF_BANK_SLICE             "8:6"  
    #endif
#elif (CBUF_BANK_NUMBER==16)
    #if (CBUF_BANK_DEPTH==512)
        #define CBUF_BANK_SLICE             "12:9"  
    #elif (CBUF_BANK_DEPTH==256)
        #define CBUF_BANK_SLICE             "11:8"  
    #elif (CBUF_BANK_DEPTH==128)
        #define CBUF_BANK_SLICE             "10:7"  
    #elif (CBUF_BANK_DEPTH==64)
        #define CBUF_BANK_SLICE             "9:6"  
    #endif
#elif (CBUF_BANK_NUMBER==32)
    #if (CBUF_BANK_DEPTH==512)
        #define CBUF_BANK_SLICE             "13:9"  
    #elif (CBUF_BANK_DEPTH==256)
        #define CBUF_BANK_SLICE             "12:8"  
    #elif (CBUF_BANK_DEPTH==128)
        #define CBUF_BANK_SLICE             "11:7"  
    #elif (CBUF_BANK_DEPTH==64)
        #define CBUF_BANK_SLICE             "10:6"  
    #endif
#endif

#ifdef NVDLA_WEIGHT_COMPRESSION_ENABLE
    `define CBUF_WEIGHT_COMPRESSED    //whether need read WMB
#endif

`define CDMA2CBUF_DEBUG_PRINT  //open debug print
