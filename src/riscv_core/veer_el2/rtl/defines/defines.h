// NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE
// This is an automatically generated file by pateln on Tue Sep 24 15:32:41 PDT 2024
//
// cmd:    veer -target=default --iccm_region=0x4 -set=ret_stack_size=8 -set=btb_enable=1 -set=btb_fullya=0 -set=btb_size=512 -set=bht_size=512 -set=div_bit=4 -set=div_new=1 -set=dccm_enable=1 -set=dccm_num_banks=4 -set=dccm_region=0x5 -set=dccm_offset=0x00000 -set=dccm_size=16 -set=dma_buf_depth=5 -set=fast_interrupt_redirect=1 -set=iccm_enable=0 -set=icache_enable=1 -set=icache_waypack=1 -set=icache_ecc=1 -set=icache_size=16 -set=icache_2banks=1 -set=icache_num_ways=2 -set=icache_bypass_enable=1 -set=icache_num_bypass=2 -set=icache_num_tag_bypass=2 -set=icache_tag_bypass_enable=1 -set=iccm_offset=0x0 -set=iccm_size=128 -set=iccm_num_banks=4 -set=lsu_stbuf_depth=4 -set=lsu_num_nbload=4 -set=load_to_use_plus1=0 -set=pic_2cycle=0 -set=pic_region=0x6 -set=pic_offset=0 -set=pic_size=32 -set=pic_total_int=31 -set=dma_buf_depth=5 -set=timer_legal_en=1 -set=bitmanip_zba=1 -set=bitmanip_zbb=1 -set=bitmanip_zbc=1 -set=bitmanip_zbe=0 -set=bitmanip_zbf=0 -set=bitmanip_zbp=0 -set=bitmanip_zbr=0 -set=bitmanip_zbs=1 -fpga_optimize=0 -snapshot=default 
//
#ifndef RV_DEFINES
#define RV_DEFINES

#define RV_BITMANIP_ZBA 1
#define RV_BITMANIP_ZBB 1
#define RV_BITMANIP_ZBC 1
#define RV_BITMANIP_ZBE 0
#define RV_BITMANIP_ZBF 0
#define RV_BITMANIP_ZBP 0
#define RV_BITMANIP_ZBR 0
#define RV_BITMANIP_ZBS 1
#define RV_DIV_BIT 4
#define RV_DIV_NEW 1
#define RV_DMA_BUF_DEPTH 5
#define RV_FAST_INTERRUPT_REDIRECT 1
#define RV_ICACHE_ONLY 1
#define RV_LSU2DMA 0
#define RV_LSU_NUM_NBLOAD 4
#define RV_LSU_NUM_NBLOAD_WIDTH 2
#define RV_LSU_STBUF_DEPTH 4
#define RV_TIMER_LEGAL_EN 1
#define RV_DCCM_BANK_BITS 2
#define RV_DCCM_BITS 14
#define RV_DCCM_BYTE_WIDTH 4
#define RV_DCCM_DATA_CELL ram_1024x39
#define RV_DCCM_DATA_WIDTH 32
#define RV_DCCM_EADR 0x50003fff
#define RV_DCCM_ECC_WIDTH 7
#define RV_DCCM_ENABLE 1
#define RV_DCCM_FDATA_WIDTH 39
#define RV_DCCM_INDEX_BITS 10
#define RV_DCCM_NUM_BANKS 4
#define RV_DCCM_NUM_BANKS_4 
#define RV_DCCM_OFFSET 0x00000
#define RV_DCCM_REGION 0x5
#define RV_DCCM_RESERVED 0x1400
#define RV_DCCM_ROWS 1024
#define RV_DCCM_SADR 0x50000000
#define RV_DCCM_SIZE 16
#define RV_DCCM_SIZE_16 
#define RV_DCCM_WIDTH_BITS 2
#define RV_LSU_SB_BITS 14
#define RV_ICCM_BANK_BITS 2
#define RV_ICCM_BANK_HI 3
#define RV_ICCM_BANK_INDEX_LO 4
#define RV_ICCM_BITS 17
#define RV_ICCM_DATA_CELL ram_8192x39
#define RV_ICCM_EADR 0x4001ffff
#define RV_ICCM_ECC_WIDTH 7
#define RV_ICCM_INDEX_BITS 13
#define RV_ICCM_NUM_BANKS 4
#define RV_ICCM_NUM_BANKS_4 
#define RV_ICCM_OFFSET 0x0
#define RV_ICCM_REGION 0x4
#define RV_ICCM_RESERVED 0x1000
#define RV_ICCM_ROWS 8192
#define RV_ICCM_SADR 0x40000000
#define RV_ICCM_SIZE 128
#define RV_ICCM_SIZE_128 
#define RV_DEBUG_SB_MEM 0xc0580000
#ifndef RV_EXTERNAL_DATA
#define RV_EXTERNAL_DATA 0xe0580000
#endif
#define RV_EXTERNAL_DATA_1 0xd0000000
#ifndef RV_SERIALIO
#define RV_SERIALIO 0xf0580000
#endif
#define RV_UNUSED_REGION0 0xb0000000
#define RV_UNUSED_REGION1 0xa0000000
#define RV_UNUSED_REGION2 0x90000000
#define RV_UNUSED_REGION3 0x70000000
#define RV_UNUSED_REGION4 0x30000000
#define RV_UNUSED_REGION5 0x20000000
#define RV_UNUSED_REGION6 0x10000000
#define RV_UNUSED_REGION7 0x00000000
#ifndef RV_NMI_VEC
#define RV_NMI_VEC 0x11110000
#endif
#define RV_PIC_BASE_ADDR 0x60000000
#define RV_PIC_BITS 15
#define RV_PIC_INT_WORDS 1
#define RV_PIC_MEIE_COUNT 31
#define RV_PIC_MEIE_MASK 0x1
#define RV_PIC_MEIE_OFFSET 0x2000
#define RV_PIC_MEIGWCLR_COUNT 31
#define RV_PIC_MEIGWCLR_MASK 0x0
#define RV_PIC_MEIGWCLR_OFFSET 0x5000
#define RV_PIC_MEIGWCTRL_COUNT 31
#define RV_PIC_MEIGWCTRL_MASK 0x3
#define RV_PIC_MEIGWCTRL_OFFSET 0x4000
#define RV_PIC_MEIP_COUNT 1
#define RV_PIC_MEIP_MASK 0x0
#define RV_PIC_MEIP_OFFSET 0x1000
#define RV_PIC_MEIPL_COUNT 31
#define RV_PIC_MEIPL_MASK 0xf
#define RV_PIC_MEIPL_OFFSET 0x0000
#define RV_PIC_MEIPT_COUNT 31
#define RV_PIC_MEIPT_MASK 0x0
#define RV_PIC_MEIPT_OFFSET 0x3004
#define RV_PIC_MPICCFG_COUNT 1
#define RV_PIC_MPICCFG_MASK 0x1
#define RV_PIC_MPICCFG_OFFSET 0x3000
#define RV_PIC_OFFSET 0
#define RV_PIC_REGION 0x6
#define RV_PIC_SIZE 32
#define RV_PIC_TOTAL_INT 31
#define RV_PIC_TOTAL_INT_PLUS1 32
#define RV_DATA_ACCESS_ADDR0 0x00000000
#define RV_DATA_ACCESS_ADDR1 0x00000000
#define RV_DATA_ACCESS_ADDR2 0x00000000
#define RV_DATA_ACCESS_ADDR3 0x00000000
#define RV_DATA_ACCESS_ADDR4 0x00000000
#define RV_DATA_ACCESS_ADDR5 0x00000000
#define RV_DATA_ACCESS_ADDR6 0x00000000
#define RV_DATA_ACCESS_ADDR7 0x00000000
#define RV_DATA_ACCESS_ENABLE0 0x0
#define RV_DATA_ACCESS_ENABLE1 0x0
#define RV_DATA_ACCESS_ENABLE2 0x0
#define RV_DATA_ACCESS_ENABLE3 0x0
#define RV_DATA_ACCESS_ENABLE4 0x0
#define RV_DATA_ACCESS_ENABLE5 0x0
#define RV_DATA_ACCESS_ENABLE6 0x0
#define RV_DATA_ACCESS_ENABLE7 0x0
#define RV_DATA_ACCESS_MASK0 0xffffffff
#define RV_DATA_ACCESS_MASK1 0xffffffff
#define RV_DATA_ACCESS_MASK2 0xffffffff
#define RV_DATA_ACCESS_MASK3 0xffffffff
#define RV_DATA_ACCESS_MASK4 0xffffffff
#define RV_DATA_ACCESS_MASK5 0xffffffff
#define RV_DATA_ACCESS_MASK6 0xffffffff
#define RV_DATA_ACCESS_MASK7 0xffffffff
#define RV_INST_ACCESS_ADDR0 0x00000000
#define RV_INST_ACCESS_ADDR1 0x00000000
#define RV_INST_ACCESS_ADDR2 0x00000000
#define RV_INST_ACCESS_ADDR3 0x00000000
#define RV_INST_ACCESS_ADDR4 0x00000000
#define RV_INST_ACCESS_ADDR5 0x00000000
#define RV_INST_ACCESS_ADDR6 0x00000000
#define RV_INST_ACCESS_ADDR7 0x00000000
#define RV_INST_ACCESS_ENABLE0 0x0
#define RV_INST_ACCESS_ENABLE1 0x0
#define RV_INST_ACCESS_ENABLE2 0x0
#define RV_INST_ACCESS_ENABLE3 0x0
#define RV_INST_ACCESS_ENABLE4 0x0
#define RV_INST_ACCESS_ENABLE5 0x0
#define RV_INST_ACCESS_ENABLE6 0x0
#define RV_INST_ACCESS_ENABLE7 0x0
#define RV_INST_ACCESS_MASK0 0xffffffff
#define RV_INST_ACCESS_MASK1 0xffffffff
#define RV_INST_ACCESS_MASK2 0xffffffff
#define RV_INST_ACCESS_MASK3 0xffffffff
#define RV_INST_ACCESS_MASK4 0xffffffff
#define RV_INST_ACCESS_MASK5 0xffffffff
#define RV_INST_ACCESS_MASK6 0xffffffff
#define RV_INST_ACCESS_MASK7 0xffffffff
#define RV_PMP_ENTRIES 16
#ifndef RV_RESET_VEC
#define RV_RESET_VEC 0x80000000
#endif
#define RV_TARGET default
#define CPU_TOP `RV_TOP.veer
#define RV_TOP `TOP.rvtop_wrapper.rvtop
#define SDVT_AHB 0
#define TOP tb_top
#define RV_BUILD_AXI4 1
#define RV_BUILD_AXI_NATIVE 1
#define CLOCK_PERIOD 100
#define RV_EXT_ADDRWIDTH 32
#define RV_EXT_DATAWIDTH 64
#define RV_LDERR_ROLLBACK 1
#define RV_STERR_ROLLBACK 0
#define RV_XLEN 32

#endif // RV_DEFINES
