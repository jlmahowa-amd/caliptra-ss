// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
`define DRAM(bk) caliptra_ss_top.mcu_top_i.dccm_loop[bk].ram.ram_core
`define MCU_RV_LSU_BUS_TAG_local 1
`default_nettype none

`include "common_defines.sv"
`include "config_defines.svh"
`include "caliptra_reg_defines.svh"
`include "caliptra_macros.svh"

`include "config_defines_mcu.svh"

module caliptra_ss_top_fpga (
    input bit core_clk,
    // Caliptra AXI Interface
    input  wire [31:0] S_AXI_CALIPTRA_AWADDR,
    input  wire [1:0] S_AXI_CALIPTRA_AWBURST,
    input  wire [2:0] S_AXI_CALIPTRA_AWSIZE,
    input  wire [7:0] S_AXI_CALIPTRA_AWLEN,
    input  wire [31:0] S_AXI_CALIPTRA_AWUSER,
    input  wire [15:0] S_AXI_CALIPTRA_AWID,
    input  wire S_AXI_CALIPTRA_AWLOCK,
    input  wire S_AXI_CALIPTRA_AWVALID,
    output wire S_AXI_CALIPTRA_AWREADY,
    // W
    input  wire [31:0] S_AXI_CALIPTRA_WDATA,
    input  wire [3:0] S_AXI_CALIPTRA_WSTRB,
    input  wire S_AXI_CALIPTRA_WVALID,
    output wire S_AXI_CALIPTRA_WREADY,
    input  wire S_AXI_CALIPTRA_WLAST,
    // B
    output wire [1:0] S_AXI_CALIPTRA_BRESP,
    output reg  [15:0] S_AXI_CALIPTRA_BID,
    output wire S_AXI_CALIPTRA_BVALID,
    input  wire S_AXI_CALIPTRA_BREADY,
    // AR
    input  wire [31:0] S_AXI_CALIPTRA_ARADDR,
    input  wire [1:0] S_AXI_CALIPTRA_ARBURST,
    input  wire [2:0] S_AXI_CALIPTRA_ARSIZE,
    input  wire [7:0] S_AXI_CALIPTRA_ARLEN,
    input  wire [31:0] S_AXI_CALIPTRA_ARUSER,
    input  wire [15:0] S_AXI_CALIPTRA_ARID,
    input  wire S_AXI_CALIPTRA_ARLOCK,
    input  wire S_AXI_CALIPTRA_ARVALID,
    output wire S_AXI_CALIPTRA_ARREADY,
    // R
    output wire [31:0] S_AXI_CALIPTRA_RDATA,
    output wire [3:0] S_AXI_CALIPTRA_RRESP,
    output reg  [15:0] S_AXI_CALIPTRA_RID,
    output wire S_AXI_CALIPTRA_RLAST,
    output wire S_AXI_CALIPTRA_RVALID,
    input  wire S_AXI_CALIPTRA_RREADY
);
//import axi_pkg::*;
//import soc_ifc_pkg::*;

// TODO: What is this for?
    `ifndef VERILATOR
        bit          [31:0]         mem_signature_begin = 32'd0; // TODO:
        bit          [31:0]         mem_signature_end   = 32'd0;
        bit          [31:0]         mem_mailbox         = 32'hD0580000;
    `endif
        logic                       rst_l;
        logic                       porst_l;
        logic [mcu_pt.PIC_TOTAL_INT:1]  ext_int;
        logic                       nmi_int;
        logic                       timer_int;
        logic                       soft_int;

        logic        [31:0]         reset_vector;
        logic        [31:0]         nmi_vector;
        logic        [31:1]         jtag_id;
// TODO: Are these used?
        logic        [31:0]         ic_haddr        ;
        logic        [2:0]          ic_hburst       ;
        logic                       ic_hmastlock    ;
        logic        [3:0]          ic_hprot        ;
        logic        [2:0]          ic_hsize        ;
        logic        [1:0]          ic_htrans       ;
        logic                       ic_hwrite       ;
        logic        [63:0]         ic_hrdata       ;
        logic                       ic_hready       ;
        logic                       ic_hresp        ;

        logic        [31:0]         lsu_haddr       ;
        logic        [2:0]          lsu_hburst      ;
        logic                       lsu_hmastlock   ;
        logic        [3:0]          lsu_hprot       ;
        logic        [2:0]          lsu_hsize       ;
        logic        [1:0]          lsu_htrans      ;
        logic                       lsu_hwrite      ;
        logic        [63:0]         lsu_hrdata      ;
        logic        [63:0]         lsu_hwdata      ;
        logic                       lsu_hready      ;
        logic                       lsu_hresp        ;

        logic        [31:0]         sb_haddr        ;
        logic        [2:0]          sb_hburst       ;
        logic                       sb_hmastlock    ;
        logic        [3:0]          sb_hprot        ;
        logic        [2:0]          sb_hsize        ;
        logic        [1:0]          sb_htrans       ;
        logic                       sb_hwrite       ;

        logic        [63:0]         sb_hrdata       ;
        logic        [63:0]         sb_hwdata       ;
        logic                       sb_hready       ;
        logic                       sb_hresp        ;

        logic        [31:0]         trace_rv_i_insn_ip;
        logic        [31:0]         trace_rv_i_address_ip;
        logic                       trace_rv_i_valid_ip;
        logic                       trace_rv_i_exception_ip;
        logic        [4:0]          trace_rv_i_ecause_ip;
        logic                       trace_rv_i_interrupt_ip;
        logic        [31:0]         trace_rv_i_tval_ip;

        logic                       o_debug_mode_status;


        logic                       jtag_tdo;
        logic                       o_cpu_halt_ack;
        logic                       o_cpu_halt_status;
        logic                       o_cpu_run_ack;


        logic        [63:0]         dma_hrdata       ;
        logic        [63:0]         dma_hwdata       ;
        logic                       dma_hready       ;
        logic                       dma_hresp        ;

        logic                       mpc_debug_halt_req;
        logic                       mpc_debug_run_req;
        logic                       mpc_reset_run_req;
        logic                       mpc_debug_halt_ack;
        logic                       mpc_debug_run_ack;
        logic                       debug_brkpt_status;


        wire                        dma_hready_out;
        int                         commit_count;

        logic                       wb_valid;
        logic [4:0]                 wb_dest;
        logic [31:0]                wb_data;

        logic                       wb_csr_valid;
        logic [11:0]                wb_csr_dest;
        logic [31:0]                wb_csr_data;

    `ifdef MCU_RV_BUILD_AXI4
       //-------------------------- LSU AXI signals--------------------------
       // AXI Write Channels
        wire                        lsu_axi_awvalid;
        wire                        lsu_axi_awready;
        wire [`MCU_RV_LSU_BUS_TAG-1:0]  lsu_axi_awid;
        wire [31:0]                 lsu_axi_awaddr;
        wire [3:0]                  lsu_axi_awregion;
        wire [7:0]                  lsu_axi_awlen;
        wire [2:0]                  lsu_axi_awsize;
        wire [1:0]                  lsu_axi_awburst;
        wire                        lsu_axi_awlock;
        wire [3:0]                  lsu_axi_awcache;
        wire [2:0]                  lsu_axi_awprot;
        wire [3:0]                  lsu_axi_awqos;

        wire                        lsu_axi_wvalid;
        wire                        lsu_axi_wready;
        wire [63:0]                 lsu_axi_wdata;
        wire [7:0]                  lsu_axi_wstrb;
        wire                        lsu_axi_wlast;

        wire                        lsu_axi_bvalid;
        wire                        lsu_axi_bready;
        wire [1:0]                  lsu_axi_bresp;
        wire [`MCU_RV_LSU_BUS_TAG-1:0]  lsu_axi_bid;

        // AXI Read Channels
        wire                        lsu_axi_arvalid;
        wire                        lsu_axi_arready;
        wire [`MCU_RV_LSU_BUS_TAG-1:0]  lsu_axi_arid;
        wire [31:0]                 lsu_axi_araddr;
        wire [3:0]                  lsu_axi_arregion;
        wire [7:0]                  lsu_axi_arlen;
        wire [2:0]                  lsu_axi_arsize;
        wire [1:0]                  lsu_axi_arburst;
        wire                        lsu_axi_arlock;
        wire [3:0]                  lsu_axi_arcache;
        wire [2:0]                  lsu_axi_arprot;
        wire [3:0]                  lsu_axi_arqos;

        wire                        lsu_axi_rvalid;
        wire                        lsu_axi_rready;
        wire [`MCU_RV_LSU_BUS_TAG-1:0]  lsu_axi_rid;
        wire [63:0]                 lsu_axi_rdata;
        wire [1:0]                  lsu_axi_rresp;
        wire                        lsu_axi_rlast;

        //-------------------------- IFU AXI signals--------------------------
        // AXI Write Channels
        wire                        ifu_axi_awvalid;
        wire                        ifu_axi_awready;
        wire [`MCU_RV_IFU_BUS_TAG-1:0]  ifu_axi_awid;
        wire [31:0]                 ifu_axi_awaddr;
        wire [3:0]                  ifu_axi_awregion;
        wire [7:0]                  ifu_axi_awlen;
        wire [2:0]                  ifu_axi_awsize;
        wire [1:0]                  ifu_axi_awburst;
        wire                        ifu_axi_awlock;
        wire [3:0]                  ifu_axi_awcache;
        wire [2:0]                  ifu_axi_awprot;
        wire [3:0]                  ifu_axi_awqos;

        wire                        ifu_axi_wvalid;
        wire                        ifu_axi_wready;
        wire [63:0]                 ifu_axi_wdata;
        wire [7:0]                  ifu_axi_wstrb;
        wire                        ifu_axi_wlast;

        wire                        ifu_axi_bvalid;
        wire                        ifu_axi_bready;
        wire [1:0]                  ifu_axi_bresp;
        wire [`MCU_RV_IFU_BUS_TAG-1:0]  ifu_axi_bid;

        // AXI Read Channels
        wire                        ifu_axi_arvalid;
        wire                        ifu_axi_arready;
        wire [`MCU_RV_IFU_BUS_TAG-1:0]  ifu_axi_arid;
        wire [31:0]                 ifu_axi_araddr;
        wire [3:0]                  ifu_axi_arregion;
        wire [7:0]                  ifu_axi_arlen;
        wire [2:0]                  ifu_axi_arsize;
        wire [1:0]                  ifu_axi_arburst;
        wire                        ifu_axi_arlock;
        wire [3:0]                  ifu_axi_arcache;
        wire [2:0]                  ifu_axi_arprot;
        wire [3:0]                  ifu_axi_arqos;

        wire                        ifu_axi_rvalid;
        wire                        ifu_axi_rready;
        wire [`MCU_RV_IFU_BUS_TAG-1:0]  ifu_axi_rid;
        wire [63:0]                 ifu_axi_rdata;
        wire [1:0]                  ifu_axi_rresp;
        wire                        ifu_axi_rlast;

        //-------------------------- SB AXI signals--------------------------
        // AXI Write Channels
        wire                        sb_axi_awvalid;
        wire                        sb_axi_awready;
        wire [`MCU_RV_SB_BUS_TAG-1:0]   sb_axi_awid;
        wire [31:0]                 sb_axi_awaddr;
        wire [3:0]                  sb_axi_awregion;
        wire [7:0]                  sb_axi_awlen;
        wire [2:0]                  sb_axi_awsize;
        wire [1:0]                  sb_axi_awburst;
        wire                        sb_axi_awlock;
        wire [3:0]                  sb_axi_awcache;
        wire [2:0]                  sb_axi_awprot;
        wire [3:0]                  sb_axi_awqos;

        wire                        sb_axi_wvalid;
        wire                        sb_axi_wready;
        wire [63:0]                 sb_axi_wdata;
        wire [7:0]                  sb_axi_wstrb;
        wire                        sb_axi_wlast;

        wire                        sb_axi_bvalid;
        wire                        sb_axi_bready;
        wire [1:0]                  sb_axi_bresp;
        wire [`MCU_RV_SB_BUS_TAG-1:0]   sb_axi_bid;

        // AXI Read Channels
        wire                        sb_axi_arvalid;
        wire                        sb_axi_arready;
        wire [`MCU_RV_SB_BUS_TAG-1:0]   sb_axi_arid;
        wire [31:0]                 sb_axi_araddr;
        wire [3:0]                  sb_axi_arregion;
        wire [7:0]                  sb_axi_arlen;
        wire [2:0]                  sb_axi_arsize;
        wire [1:0]                  sb_axi_arburst;
        wire                        sb_axi_arlock;
        wire [3:0]                  sb_axi_arcache;
        wire [2:0]                  sb_axi_arprot;
        wire [3:0]                  sb_axi_arqos;

        wire                        sb_axi_rvalid;
        wire                        sb_axi_rready;
        wire [`MCU_RV_SB_BUS_TAG-1:0]   sb_axi_rid;
        wire [63:0]                 sb_axi_rdata;
        wire [1:0]                  sb_axi_rresp;
        wire                        sb_axi_rlast;

       //-------------------------- DMA AXI signals--------------------------
       // AXI Write Channels
        wire                        dma_axi_awvalid;
        wire                        dma_axi_awready;
        wire [`MCU_RV_DMA_BUS_TAG-1:0]  dma_axi_awid;
        wire [31:0]                 dma_axi_awaddr;
        wire [2:0]                  dma_axi_awsize;
        wire [2:0]                  dma_axi_awprot;
        wire [7:0]                  dma_axi_awlen;
        wire [1:0]                  dma_axi_awburst;


        wire                        dma_axi_wvalid;
        wire                        dma_axi_wready;
        wire [63:0]                 dma_axi_wdata;
        wire [7:0]                  dma_axi_wstrb;
        wire                        dma_axi_wlast;

        wire                        dma_axi_bvalid;
        wire                        dma_axi_bready;
        wire [1:0]                  dma_axi_bresp;
        wire [`MCU_RV_DMA_BUS_TAG-1:0]  dma_axi_bid;

        // AXI Read Channels
        wire                        dma_axi_arvalid;
        wire                        dma_axi_arready;
        wire [`MCU_RV_DMA_BUS_TAG-1:0]  dma_axi_arid;
        wire [31:0]                 dma_axi_araddr;
        wire [2:0]                  dma_axi_arsize;
        wire [2:0]                  dma_axi_arprot;
        wire [7:0]                  dma_axi_arlen;
        wire [1:0]                  dma_axi_arburst;

        wire                        dma_axi_rvalid;
        wire                        dma_axi_rready;
        wire [`MCU_RV_DMA_BUS_TAG-1:0]  dma_axi_rid;
        wire [63:0]                 dma_axi_rdata;
        wire [1:0]                  dma_axi_rresp;
        wire                        dma_axi_rlast;

        wire                        lmem_axi_arvalid;
        wire                        lmem_axi_arready;

        wire                        lmem_axi_rvalid;
        wire [`MCU_RV_LSU_BUS_TAG-1:0]  lmem_axi_rid;
        wire [1:0]                  lmem_axi_rresp;
        wire [63:0]                 lmem_axi_rdata;
        wire                        lmem_axi_rlast;
        wire                        lmem_axi_rready;

        wire                        lmem_axi_awvalid;
        wire                        lmem_axi_awready;

        wire                        lmem_axi_wvalid;
        wire                        lmem_axi_wready;

        wire [1:0]                  lmem_axi_bresp;
        wire                        lmem_axi_bvalid;
        wire [`MCU_RV_LSU_BUS_TAG-1:0]  lmem_axi_bid;
        wire                        lmem_axi_bready;

    `endif
        mcu_el2_mem_if                  mcu_el2_mem_export ();
        // el2_mem_if                  caliptra_el2_mem_export (); // TODO: Never used

        logic [mcu_pt.ICCM_NUM_BANKS-1:0][                   38:0] iccm_bank_wr_fdata;
        logic [mcu_pt.ICCM_NUM_BANKS-1:0][                   38:0] iccm_bank_fdout;
        logic [mcu_pt.DCCM_NUM_BANKS-1:0][mcu_pt.DCCM_FDATA_WIDTH-1:0] dccm_wr_fdata_bank;
        logic [mcu_pt.DCCM_NUM_BANKS-1:0][mcu_pt.DCCM_FDATA_WIDTH-1:0] dccm_bank_fdout;



        //=================== BEGIN CALIPTRA_TOP_TB ========================

        logic                       cptra_pwrgood;
        logic                       cptra_rst_b;
        logic                       BootFSM_BrkPoint;
        logic                       scan_mode;

        logic [`CLP_OBF_KEY_DWORDS-1:0][31:0]          cptra_obf_key;
        
        logic [0:`CLP_OBF_UDS_DWORDS-1][31:0]          cptra_uds_rand;
        logic [0:`CLP_OBF_FE_DWORDS-1][31:0]           cptra_fe_rand;
        logic [0:`CLP_OBF_KEY_DWORDS-1][31:0]          cptra_obf_key_tb;

        //jtag interface
        logic                      cptra_jtag_tck;    // JTAG clk
        logic                      cptra_jtag_tms;    // JTAG TMS
        logic                      cptra_jtag_tdi;    // JTAG tdi
        logic                      cptra_jtag_trst_n; // JTAG Reset
        logic                      cptra_jtag_tdo;    // JTAG TDO
        logic                      cptra_jtag_tdoEn;  // JTAG TDO enable

        // AXI Interface
        axi_if #(
            .AW(`CALIPTRA_SLAVE_ADDR_WIDTH(`CALIPTRA_SLAVE_SEL_SOC_IFC)),
            .DW(32),
            .IW(16 - 3),
            .UW(16)
        ) m_axi_bfm_if (.clk(core_clk), .rst_n(cptra_rst_b));

        axi_if #(
            .AW(32),
            .DW(32),
            .IW(16),
            .UW(16)
        ) m_axi_if (.clk(core_clk), .rst_n(cptra_rst_b));

        // AXI Interface
        axi_if #(
            .AW(`CALIPTRA_SLAVE_ADDR_WIDTH(`CALIPTRA_SLAVE_SEL_SOC_IFC)),
            .DW(32),
            .IW(16),
            .UW(16)
        ) s_axi_if (.clk(core_clk), .rst_n(cptra_rst_b));

        axi_if #(
            .AW(32),
            .DW(32),
            .IW(16 + 3),
            .UW(16)
        ) axi_sram_if (.clk(core_clk), .rst_n(cptra_rst_b));

        // QSPI Interface
        logic                                qspi_clk;
        logic [`CALIPTRA_QSPI_CS_WIDTH-1:0]  qspi_cs_n;
        wire  [`CALIPTRA_QSPI_IO_WIDTH-1:0]  qspi_data;
        logic [`CALIPTRA_QSPI_IO_WIDTH-1:0]  qspi_data_host_to_device, qspi_data_device_to_host;
        logic [`CALIPTRA_QSPI_IO_WIDTH-1:0]  qspi_data_host_to_device_en;

    `ifdef CALIPTRA_INTERNAL_UART
        logic uart_loopback;
    `endif

        logic ready_for_fuses;
        logic ready_for_fw_push;
        logic mailbox_data_avail;
        logic mbox_sram_cs;
        logic mbox_sram_we;
        logic [14:0] mbox_sram_addr;
        logic [39-1:0] mbox_sram_wdata;
        logic [39-1:0] mbox_sram_rdata;

        logic imem_cs;
        logic [`CALIPTRA_IMEM_ADDR_WIDTH-1:0] imem_addr;
        logic [`CALIPTRA_IMEM_DATA_WIDTH-1:0] imem_rdata;

        //device lifecycle
        security_state_t security_state;

        ras_test_ctrl_t ras_test_ctrl;
        logic [63:0] generic_input_wires;
        logic        etrng_req;
        logic  [3:0] itrng_data;
        logic        itrng_valid;

        logic cptra_error_fatal;
        logic cptra_error_non_fatal;

        //Interrupt flags
        logic int_flag;
        logic cycleCnt_smpl_en;

        //Reset flags
        logic assert_hard_rst_flag;
        logic deassert_hard_rst_flag;
        logic assert_rst_flag_from_service;
        logic deassert_rst_flag_from_service;

        el2_mem_if el2_mem_export ();

       //=========================================================================-
       // DUT instance
       //=========================================================================-
        caliptra_top caliptra_top_dut (
            .cptra_pwrgood              (cptra_pwrgood),
            .cptra_rst_b                (cptra_rst_b),
            .clk                        (core_clk),

            .cptra_obf_key              (cptra_obf_key),

            .jtag_tck   (cptra_jtag_tck   ),
            .jtag_tdi   (cptra_jtag_tdi   ),
            .jtag_tms   (cptra_jtag_tms   ),
            .jtag_trst_n(cptra_jtag_trst_n),
            .jtag_tdo   (cptra_jtag_tdo   ),
            .jtag_tdoEn (cptra_jtag_tdoEn ),
            
            //SoC AXI Interface
            .s_axi_w_if(s_axi_if.w_sub),
            .s_axi_r_if(s_axi_if.r_sub),

            //AXI DMA Interface
            .m_axi_w_if(m_axi_if.w_mgr),
            .m_axi_r_if(m_axi_if.r_mgr),

            .qspi_clk_o (qspi_clk),
            .qspi_cs_no (qspi_cs_n),
            .qspi_d_i   (qspi_data_device_to_host),
            .qspi_d_o   (qspi_data_host_to_device),
            .qspi_d_en_o(qspi_data_host_to_device_en),

        `ifdef CALIPTRA_INTERNAL_UART
            .uart_tx(uart_loopback),
            .uart_rx(uart_loopback),
        `endif

            .el2_mem_export(el2_mem_export.veer_sram_src),

            .ready_for_fuses(ready_for_fuses),
            .ready_for_fw_push(ready_for_fw_push),
            .ready_for_runtime(),

            .mbox_sram_cs(mbox_sram_cs),
            .mbox_sram_we(mbox_sram_we),
            .mbox_sram_addr(mbox_sram_addr),
            .mbox_sram_wdata(mbox_sram_wdata),
            .mbox_sram_rdata(mbox_sram_rdata),
                
            .imem_cs(imem_cs),
            .imem_addr(imem_addr),
            .imem_rdata(imem_rdata),

            .mailbox_data_avail(mailbox_data_avail),
            .mailbox_flow_done(),
            .BootFSM_BrkPoint(BootFSM_BrkPoint),

            .recovery_data_avail(1'b1/*TODO*/),

            //SoC Interrupts
            .cptra_error_fatal    (cptra_error_fatal    ),
            .cptra_error_non_fatal(cptra_error_non_fatal),

        `ifdef CALIPTRA_INTERNAL_TRNG
            .etrng_req             (etrng_req),
            .itrng_data            (itrng_data),
            .itrng_valid           (itrng_valid),
        `else
            .etrng_req             (),
            .itrng_data            (4'b0),
            .itrng_valid           (1'b0),
        `endif

            .generic_input_wires(generic_input_wires),
            .generic_output_wires(),

            .security_state(security_state),
            .scan_mode     (scan_mode)
        );


        caliptra_top_sva sva();

        //=================== END CALIPTRA_TOP_TB ========================

        logic s_axi_if_rd_is_upper_dw_latched;
        logic s_axi_if_wr_is_upper_dw_latched;
        // AXI Interconnect connections
        assign s_axi_if.awvalid                      = axi_interconnect.sintf_arr[3].AWVALID;
        assign s_axi_if.awaddr                       = axi_interconnect.sintf_arr[3].AWADDR;
        assign s_axi_if.awid                         = axi_interconnect.sintf_arr[3].AWID;
        assign s_axi_if.awlen                        = axi_interconnect.sintf_arr[3].AWLEN;
        assign s_axi_if.awsize                       = axi_interconnect.sintf_arr[3].AWSIZE;
        assign s_axi_if.awburst                      = axi_interconnect.sintf_arr[3].AWBURST;
        assign s_axi_if.awlock                       = axi_interconnect.sintf_arr[3].AWLOCK;
        assign s_axi_if.awuser                       = axi_interconnect.sintf_arr[3].AWUSER;
        assign axi_interconnect.sintf_arr[3].AWREADY = s_axi_if.awready;
        // FIXME this is a gross hack
        always@(posedge core_clk or negedge rst_l)
            if (!rst_l)
                s_axi_if_wr_is_upper_dw_latched <= 0;
            else if (s_axi_if.awvalid && s_axi_if.awready)
                s_axi_if_wr_is_upper_dw_latched <= s_axi_if.awaddr[2] && (s_axi_if.awsize < 3);
        `CALIPTRA_ASSERT(CPTRA_AXI_WR_32BIT, (s_axi_if.awvalid && s_axi_if.awready) -> (s_axi_if.awsize < 3), core_clk, !rst_l)

        assign s_axi_if.wvalid                       = axi_interconnect.sintf_arr[3].WVALID;
        assign s_axi_if.wdata                        = axi_interconnect.sintf_arr[3].WDATA >> (s_axi_if_wr_is_upper_dw_latched ? 32 : 0);
        assign s_axi_if.wstrb                        = axi_interconnect.sintf_arr[3].WSTRB >> (s_axi_if_wr_is_upper_dw_latched ? 4 : 0);
        assign s_axi_if.wlast                        = axi_interconnect.sintf_arr[3].WLAST;

        assign axi_interconnect.sintf_arr[3].WREADY  = s_axi_if.wready;

        assign axi_interconnect.sintf_arr[3].BVALID  = s_axi_if.bvalid;
        assign axi_interconnect.sintf_arr[3].BRESP   = s_axi_if.bresp;
        assign axi_interconnect.sintf_arr[3].BID     = s_axi_if.bid;
        assign s_axi_if.bready                       = axi_interconnect.sintf_arr[3].BREADY;

        assign s_axi_if.arvalid                      = axi_interconnect.sintf_arr[3].ARVALID;
        assign s_axi_if.araddr                       = axi_interconnect.sintf_arr[3].ARADDR;
        assign s_axi_if.arid                         = axi_interconnect.sintf_arr[3].ARID;
        assign s_axi_if.arlen                        = axi_interconnect.sintf_arr[3].ARLEN;
        assign s_axi_if.arsize                       = axi_interconnect.sintf_arr[3].ARSIZE;
        assign s_axi_if.arburst                      = axi_interconnect.sintf_arr[3].ARBURST;
        assign s_axi_if.arlock                       = axi_interconnect.sintf_arr[3].ARLOCK;
        assign s_axi_if.aruser                       = axi_interconnect.sintf_arr[3].ARUSER;
        assign axi_interconnect.sintf_arr[3].ARREADY = s_axi_if.arready;
        // FIXME this is a gross hack
        always@(posedge core_clk or negedge rst_l)
            if (!rst_l)
                s_axi_if_rd_is_upper_dw_latched <= 0;
            else if (s_axi_if.arvalid && s_axi_if.arready)
                s_axi_if_rd_is_upper_dw_latched <= s_axi_if.araddr[2] && (s_axi_if.arsize < 3);
        `CALIPTRA_ASSERT(CPTRA_AXI_RD_32BIT, (s_axi_if.arvalid && s_axi_if.arready) -> (s_axi_if.arsize < 3), core_clk, !rst_l)

        assign axi_interconnect.sintf_arr[3].RVALID  = s_axi_if.rvalid;
        assign axi_interconnect.sintf_arr[3].RDATA   = 64'(s_axi_if.rdata) << (s_axi_if_rd_is_upper_dw_latched ? 32 : 0);
        assign axi_interconnect.sintf_arr[3].RRESP   = s_axi_if.rresp;
        assign axi_interconnect.sintf_arr[3].RID     = s_axi_if.rid;
        assign axi_interconnect.sintf_arr[3].RLAST   = s_axi_if.rlast;
        assign s_axi_if.rready                       = axi_interconnect.sintf_arr[3].RREADY;
        
        // -- CALIPTRA SRAM 
        // AXI Interconnect connections
        assign axi_sram_if.awvalid                     = axi_interconnect.sintf_arr[4].AWVALID;
        assign axi_sram_if.awaddr                      = axi_interconnect.sintf_arr[4].AWADDR;
        assign axi_sram_if.awid                        = axi_interconnect.sintf_arr[4].AWID;
        assign axi_sram_if.awlen                       = axi_interconnect.sintf_arr[4].AWLEN;
        assign axi_sram_if.awsize                      = axi_interconnect.sintf_arr[4].AWSIZE;
        assign axi_sram_if.awburst                     = axi_interconnect.sintf_arr[4].AWBURST;
        assign axi_sram_if.awlock                      = axi_interconnect.sintf_arr[4].AWLOCK;
        assign axi_sram_if.awuser                      = axi_interconnect.sintf_arr[4].AWUSER;
        assign axi_interconnect.sintf_arr[4].AWREADY   = axi_sram_if.awready;

        assign axi_sram_if.wvalid                      = axi_interconnect.sintf_arr[4].WVALID;
        assign axi_sram_if.wdata                       = axi_interconnect.sintf_arr[4].WDATA;
        assign axi_sram_if.wstrb                       = axi_interconnect.sintf_arr[4].WSTRB;
        assign axi_sram_if.wlast                       = axi_interconnect.sintf_arr[4].WLAST;
        assign axi_interconnect.sintf_arr[4].WREADY    = axi_sram_if.wready;

        assign axi_interconnect.sintf_arr[4].BVALID    = axi_sram_if.bvalid;
        assign axi_interconnect.sintf_arr[4].BRESP     = axi_sram_if.bresp;
        assign axi_interconnect.sintf_arr[4].BID       = axi_sram_if.bid;
        assign axi_sram_if.bready                      = axi_interconnect.sintf_arr[4].BREADY;

        assign axi_sram_if.arvalid                     = axi_interconnect.sintf_arr[4].ARVALID;
        assign axi_sram_if.araddr                      = axi_interconnect.sintf_arr[4].ARADDR;
        assign axi_sram_if.arid                        = axi_interconnect.sintf_arr[4].ARID;
        assign axi_sram_if.arlen                       = axi_interconnect.sintf_arr[4].ARLEN;
        assign axi_sram_if.arsize                      = axi_interconnect.sintf_arr[4].ARSIZE;
        assign axi_sram_if.arburst                     = axi_interconnect.sintf_arr[4].ARBURST;
        assign axi_sram_if.arlock                      = axi_interconnect.sintf_arr[4].ARLOCK;
        assign axi_sram_if.aruser                      = axi_interconnect.sintf_arr[4].ARUSER;
        assign axi_interconnect.sintf_arr[4].ARREADY   = axi_sram_if.arready;

        assign axi_interconnect.sintf_arr[4].RVALID    = axi_sram_if.rvalid;
        assign axi_interconnect.sintf_arr[4].RDATA     = axi_sram_if.rdata;
        assign axi_interconnect.sintf_arr[4].RRESP     = axi_sram_if.rresp;
        assign axi_interconnect.sintf_arr[4].RID       = axi_sram_if.rid;
        assign axi_interconnect.sintf_arr[4].RLAST     = axi_sram_if.rlast;
        assign axi_sram_if.rready                      = axi_interconnect.sintf_arr[4].RREADY;
        


        // AXI Interconnect connections
        assign axi_interconnect.mintf_arr[2].AWVALID = '0;
        assign axi_interconnect.mintf_arr[2].AWADDR  = '0;
        assign axi_interconnect.mintf_arr[2].AWID    = '0;
        assign axi_interconnect.mintf_arr[2].AWLEN   = '0;
        assign axi_interconnect.mintf_arr[2].AWSIZE  = '0;
        assign axi_interconnect.mintf_arr[2].AWBURST = '0;
        assign axi_interconnect.mintf_arr[2].AWLOCK  = '0;
        assign axi_interconnect.mintf_arr[2].AWUSER  = '0;
//        assign something.awready    = axi_interconnect.mintf_arr[2].AWREADY;
        
        assign axi_interconnect.mintf_arr[2].WVALID = '0;
        assign axi_interconnect.mintf_arr[2].WDATA  = '0;
        assign axi_interconnect.mintf_arr[2].WSTRB  = '0;
        assign axi_interconnect.mintf_arr[2].WLAST  = '0;
//        assign something.wready    = axi_interconnect.mintf_arr[2].WREADY;
        
//        assign something.bvalid = axi_interconnect.mintf_arr[2].BVALID;
//        assign something.bresp  = axi_interconnect.mintf_arr[2].BRESP;
//        assign something.bid    = axi_interconnect.mintf_arr[2].BID;
        assign axi_interconnect.mintf_arr[2].BREADY = '0;

        assign axi_interconnect.mintf_arr[2].ARVALID = '0;
        assign axi_interconnect.mintf_arr[2].ARADDR  = '0;
        assign axi_interconnect.mintf_arr[2].ARID    = '0;
        assign axi_interconnect.mintf_arr[2].ARLEN   = '0;
        assign axi_interconnect.mintf_arr[2].ARSIZE  = '0;
        assign axi_interconnect.mintf_arr[2].ARBURST = '0;
        assign axi_interconnect.mintf_arr[2].ARLOCK  = '0;
        assign axi_interconnect.mintf_arr[2].ARUSER  = '0;
//        assign something.arready    = axi_interconnect.mintf_arr[2].ARREADY;
        
//        assign something.rvalid = axi_interconnect.mintf_arr[2].RVALID;
//        assign something.rdata  = axi_interconnect.mintf_arr[2].RDATA;
//        assign something.rresp  = axi_interconnect.mintf_arr[2].RRESP;
//        assign something.rid    = axi_interconnect.mintf_arr[2].RID;
//        assign something.rlast  = axi_interconnect.mintf_arr[2].RLAST;
        assign axi_interconnect.mintf_arr[2].RREADY = '0;

        // AXI Interconnect connections
        assign axi_interconnect.mintf_arr[3].AWVALID = m_axi_if.awvalid;
        assign axi_interconnect.mintf_arr[3].AWADDR  = m_axi_if.awaddr;
        assign axi_interconnect.mintf_arr[3].AWID    = m_axi_if.awid;
        assign axi_interconnect.mintf_arr[3].AWLEN   = m_axi_if.awlen;
        assign axi_interconnect.mintf_arr[3].AWSIZE  = m_axi_if.awsize;
        assign axi_interconnect.mintf_arr[3].AWBURST = m_axi_if.awburst;
        assign axi_interconnect.mintf_arr[3].AWLOCK  = m_axi_if.awlock;
        assign axi_interconnect.mintf_arr[3].AWUSER  = m_axi_if.awuser;
        assign m_axi_if.awready                      = axi_interconnect.mintf_arr[3].AWREADY;

        assign axi_interconnect.mintf_arr[3].WVALID  = m_axi_if.wvalid;
        assign axi_interconnect.mintf_arr[3].WDATA   = m_axi_if.wdata;
        assign axi_interconnect.mintf_arr[3].WSTRB   = m_axi_if.wstrb;
        assign axi_interconnect.mintf_arr[3].WLAST   = m_axi_if.wlast;
        assign m_axi_if.wready                       = axi_interconnect.mintf_arr[3].WREADY;

        assign m_axi_if.bvalid                       = axi_interconnect.mintf_arr[3].BVALID;
        assign m_axi_if.bresp                        = axi_interconnect.mintf_arr[3].BRESP;
        assign m_axi_if.bid                          = axi_interconnect.mintf_arr[3].BID;
        assign axi_interconnect.mintf_arr[3].BREADY  = m_axi_if.bready;

        assign axi_interconnect.mintf_arr[3].ARVALID = m_axi_if.arvalid;
        assign axi_interconnect.mintf_arr[3].ARADDR  = m_axi_if.araddr;
        assign axi_interconnect.mintf_arr[3].ARID    = m_axi_if.arid;
        assign axi_interconnect.mintf_arr[3].ARLEN   = m_axi_if.arlen;
        assign axi_interconnect.mintf_arr[3].ARSIZE  = m_axi_if.arsize;
        assign axi_interconnect.mintf_arr[3].ARBURST = m_axi_if.arburst;
        assign axi_interconnect.mintf_arr[3].ARLOCK  = m_axi_if.arlock;
        assign axi_interconnect.mintf_arr[3].ARUSER  = m_axi_if.aruser;
        assign m_axi_if.arready                      = axi_interconnect.mintf_arr[3].ARREADY;

        assign m_axi_if.rvalid                       = axi_interconnect.mintf_arr[3].RVALID;
        assign m_axi_if.rdata                        = axi_interconnect.mintf_arr[3].RDATA;
        assign m_axi_if.rresp                        = axi_interconnect.mintf_arr[3].RRESP;
        assign m_axi_if.rid                          = axi_interconnect.mintf_arr[3].RID;
        assign m_axi_if.rlast                        = axi_interconnect.mintf_arr[3].RLAST;
        assign axi_interconnect.mintf_arr[3].RREADY  = m_axi_if.rready;

        // AXI Interconnect connections
        assign axi_interconnect.mintf_arr[4].AWVALID  = m_axi_bfm_if.awvalid;
        assign axi_interconnect.mintf_arr[4].AWADDR   = m_axi_bfm_if.awaddr;
        assign axi_interconnect.mintf_arr[4].AWID     = m_axi_bfm_if.awid;
        assign axi_interconnect.mintf_arr[4].AWLEN    = m_axi_bfm_if.awlen;
        assign axi_interconnect.mintf_arr[4].AWSIZE   = m_axi_bfm_if.awsize;
        assign axi_interconnect.mintf_arr[4].AWBURST  = m_axi_bfm_if.awburst;
        assign axi_interconnect.mintf_arr[4].AWLOCK   = m_axi_bfm_if.awlock;
        assign axi_interconnect.mintf_arr[4].AWUSER   = m_axi_bfm_if.awuser;
        assign m_axi_bfm_if.awready                   = axi_interconnect.mintf_arr[4].AWREADY;

        assign axi_interconnect.mintf_arr[4].WVALID   = m_axi_bfm_if.wvalid;
        assign axi_interconnect.mintf_arr[4].WDATA    = m_axi_bfm_if.wdata;
        assign axi_interconnect.mintf_arr[4].WSTRB    = m_axi_bfm_if.wstrb;
        assign axi_interconnect.mintf_arr[4].WLAST    = m_axi_bfm_if.wlast;
        assign m_axi_bfm_if.wready                    = axi_interconnect.mintf_arr[4].WREADY;

        assign m_axi_bfm_if.bvalid                    = axi_interconnect.mintf_arr[4].BVALID;
        assign m_axi_bfm_if.bresp                     = axi_interconnect.mintf_arr[4].BRESP;
        assign m_axi_bfm_if.bid                       = axi_interconnect.mintf_arr[4].BID;
        assign axi_interconnect.mintf_arr[4].BREADY   = m_axi_bfm_if.bready;

        assign axi_interconnect.mintf_arr[4].ARVALID  = m_axi_bfm_if.arvalid;
        assign axi_interconnect.mintf_arr[4].ARADDR   = m_axi_bfm_if.araddr;
        assign axi_interconnect.mintf_arr[4].ARID     = m_axi_bfm_if.arid;
        assign axi_interconnect.mintf_arr[4].ARLEN    = m_axi_bfm_if.arlen;
        assign axi_interconnect.mintf_arr[4].ARSIZE   = m_axi_bfm_if.arsize;
        assign axi_interconnect.mintf_arr[4].ARBURST  = m_axi_bfm_if.arburst;
        assign axi_interconnect.mintf_arr[4].ARLOCK   = m_axi_bfm_if.arlock;
        assign axi_interconnect.mintf_arr[4].ARUSER   = m_axi_bfm_if.aruser;
        assign m_axi_bfm_if.arready                   = axi_interconnect.mintf_arr[4].ARREADY;

        assign m_axi_bfm_if.rvalid                    = axi_interconnect.mintf_arr[4].RVALID;
        assign m_axi_bfm_if.rdata                     = axi_interconnect.mintf_arr[4].RDATA;
        assign m_axi_bfm_if.rresp                     = axi_interconnect.mintf_arr[4].RRESP;
        assign m_axi_bfm_if.rid                       = axi_interconnect.mintf_arr[4].RID;
        assign m_axi_bfm_if.rlast                     = axi_interconnect.mintf_arr[4].RLAST;
        assign axi_interconnect.mintf_arr[4].RREADY   = m_axi_bfm_if.rready;
        

       //=========================================================================-
       // RTL instance
       //=========================================================================-
        mcu_top rvtop_wrapper (
        .rst_l                  ( rst_l         ),
        .dbg_rst_l              ( porst_l       ),
        .clk                    ( core_clk      ),
        .rst_vec                ( reset_vector[31:1]),
        .nmi_int                ( nmi_int       ),
        .nmi_vec                ( nmi_vector[31:1]),
        .jtag_id                ( jtag_id[31:1]),



        //-------------------------- LSU AXI signals--------------------------
        // // AXI Write Channels

        .lsu_axi_awvalid        (axi_interconnect.mintf_arr[0].AWVALID),
        .lsu_axi_awready        (axi_interconnect.mintf_arr[0].AWREADY),
        .lsu_axi_awid           (axi_interconnect.mintf_arr[0].AWID),
        .lsu_axi_awaddr         (axi_interconnect.mintf_arr[0].AWADDR),
        .lsu_axi_awregion       (axi_interconnect.mintf_arr[0].AWREGION),
        .lsu_axi_awlen          (axi_interconnect.mintf_arr[0].AWLEN),
        .lsu_axi_awsize         (axi_interconnect.mintf_arr[0].AWSIZE),
        .lsu_axi_awburst        (axi_interconnect.mintf_arr[0].AWBURST),
        .lsu_axi_awlock         (axi_interconnect.mintf_arr[0].AWLOCK),
        .lsu_axi_awcache        (axi_interconnect.mintf_arr[0].AWCACHE),
        .lsu_axi_awprot         (axi_interconnect.mintf_arr[0].AWPROT),
        .lsu_axi_awqos          (axi_interconnect.mintf_arr[0].AWQOS),

        .lsu_axi_wvalid         (axi_interconnect.mintf_arr[0].WVALID),
        .lsu_axi_wready         (axi_interconnect.mintf_arr[0].WREADY),
        .lsu_axi_wdata          (axi_interconnect.mintf_arr[0].WDATA),
        .lsu_axi_wstrb          (axi_interconnect.mintf_arr[0].WSTRB),
        .lsu_axi_wlast          (axi_interconnect.mintf_arr[0].WLAST),

        .lsu_axi_bvalid         (axi_interconnect.mintf_arr[0].BVALID),
        .lsu_axi_bready         (axi_interconnect.mintf_arr[0].BREADY),
        .lsu_axi_bresp          (axi_interconnect.mintf_arr[0].BRESP),
        .lsu_axi_bid            (axi_interconnect.mintf_arr[0].BID),

        .lsu_axi_arvalid        (axi_interconnect.mintf_arr[0].ARVALID),
        .lsu_axi_arready        (axi_interconnect.mintf_arr[0].ARREADY),
        .lsu_axi_arid           (axi_interconnect.mintf_arr[0].ARID),
        .lsu_axi_araddr         (axi_interconnect.mintf_arr[0].ARADDR),
        .lsu_axi_arregion       (axi_interconnect.mintf_arr[0].ARREGION),
        .lsu_axi_arlen          (axi_interconnect.mintf_arr[0].ARLEN),
        .lsu_axi_arsize         (axi_interconnect.mintf_arr[0].ARSIZE),
        .lsu_axi_arburst        (axi_interconnect.mintf_arr[0].ARBURST),
        .lsu_axi_arlock         (axi_interconnect.mintf_arr[0].ARLOCK),
        .lsu_axi_arcache        (axi_interconnect.mintf_arr[0].ARCACHE),
        .lsu_axi_arprot         (axi_interconnect.mintf_arr[0].ARPROT),
        .lsu_axi_arqos          (axi_interconnect.mintf_arr[0].ARQOS),

        .lsu_axi_rvalid         (axi_interconnect.mintf_arr[0].RVALID),
        .lsu_axi_rready         (axi_interconnect.mintf_arr[0].RREADY),
        .lsu_axi_rid            (axi_interconnect.mintf_arr[0].RID),
        .lsu_axi_rdata          (axi_interconnect.mintf_arr[0].RDATA),
        .lsu_axi_rresp          (axi_interconnect.mintf_arr[0].RRESP),
        .lsu_axi_rlast          (axi_interconnect.mintf_arr[0].RLAST),

        //-------------------------- IFU AXI signals--------------------------
        // AXI Write Channels

        .ifu_axi_awvalid        ( axi_interconnect.mintf_arr[1].AWVALID ),
        .ifu_axi_awready        ( axi_interconnect.mintf_arr[1].AWREADY ),
        .ifu_axi_awid           ( axi_interconnect.mintf_arr[1].AWID    ),
        .ifu_axi_awaddr         ( axi_interconnect.mintf_arr[1].AWADDR  ),
        .ifu_axi_awregion       ( axi_interconnect.mintf_arr[1].AWREGION),
        .ifu_axi_awlen          ( axi_interconnect.mintf_arr[1].AWLEN   ),
        .ifu_axi_awsize         ( axi_interconnect.mintf_arr[1].AWSIZE  ),
        .ifu_axi_awburst        ( axi_interconnect.mintf_arr[1].AWBURST ),
        .ifu_axi_awlock         ( axi_interconnect.mintf_arr[1].AWLOCK  ),
        .ifu_axi_awcache        ( axi_interconnect.mintf_arr[1].AWCACHE ),
        .ifu_axi_awprot         ( axi_interconnect.mintf_arr[1].AWPROT  ),
        .ifu_axi_awqos          ( axi_interconnect.mintf_arr[1].AWQOS   ),

        .ifu_axi_wvalid         ( axi_interconnect.mintf_arr[1].WVALID  ),
        .ifu_axi_wready         ( axi_interconnect.mintf_arr[1].WREADY  ),
        .ifu_axi_wdata          ( axi_interconnect.mintf_arr[1].WDATA   ),
        .ifu_axi_wstrb          ( axi_interconnect.mintf_arr[1].WSTRB   ),
        .ifu_axi_wlast          ( axi_interconnect.mintf_arr[1].WLAST   ),

        .ifu_axi_bvalid         ( axi_interconnect.mintf_arr[1].BVALID  ),
        .ifu_axi_bready         ( axi_interconnect.mintf_arr[1].BREADY  ),
        .ifu_axi_bresp          ( axi_interconnect.mintf_arr[1].BRESP   ),
        .ifu_axi_bid            ( axi_interconnect.mintf_arr[1].BID     ),

        .ifu_axi_arvalid        ( axi_interconnect.mintf_arr[1].ARVALID ),
        .ifu_axi_arready        ( axi_interconnect.mintf_arr[1].ARREADY ),
        .ifu_axi_arid           ( axi_interconnect.mintf_arr[1].ARID    ),
        .ifu_axi_araddr         ( axi_interconnect.mintf_arr[1].ARADDR  ),
        .ifu_axi_arlen          ( axi_interconnect.mintf_arr[1].ARLEN   ),
        .ifu_axi_arsize         ( axi_interconnect.mintf_arr[1].ARSIZE  ),
        .ifu_axi_arburst        ( axi_interconnect.mintf_arr[1].ARBURST ),
        .ifu_axi_arlock         ( axi_interconnect.mintf_arr[1].ARLOCK  ),
        .ifu_axi_arcache        ( axi_interconnect.mintf_arr[1].ARCACHE ),
        .ifu_axi_arprot         ( axi_interconnect.mintf_arr[1].ARPROT  ),
        .ifu_axi_arqos          ( axi_interconnect.mintf_arr[1].ARQOS   ),
        .ifu_axi_arregion       ( axi_interconnect.mintf_arr[1].ARREGION),

        .ifu_axi_rvalid         ( axi_interconnect.mintf_arr[1].RVALID  ),
        .ifu_axi_rready         ( axi_interconnect.mintf_arr[1].RREADY  ),
        .ifu_axi_rid            ( axi_interconnect.mintf_arr[1].RID     ),
        .ifu_axi_rdata          ( axi_interconnect.mintf_arr[1].RDATA   ),
        .ifu_axi_rresp          ( axi_interconnect.mintf_arr[1].RRESP   ),
        .ifu_axi_rlast          ( axi_interconnect.mintf_arr[1].RLAST   ),

        //-------------------------- SB AXI signals--------------------------
        // AXI Write Channels
        .sb_axi_awvalid         (sb_axi_awvalid),
        .sb_axi_awready         (sb_axi_awready),
        .sb_axi_awid            (sb_axi_awid),
        .sb_axi_awaddr          (sb_axi_awaddr),
        .sb_axi_awregion        (sb_axi_awregion),
        .sb_axi_awlen           (sb_axi_awlen),
        .sb_axi_awsize          (sb_axi_awsize),
        .sb_axi_awburst         (sb_axi_awburst),
        .sb_axi_awlock          (sb_axi_awlock),
        .sb_axi_awcache         (sb_axi_awcache),
        .sb_axi_awprot          (sb_axi_awprot),
        .sb_axi_awqos           (sb_axi_awqos),

        .sb_axi_wvalid          (sb_axi_wvalid),
        .sb_axi_wready          (sb_axi_wready),
        .sb_axi_wdata           (sb_axi_wdata),
        .sb_axi_wstrb           (sb_axi_wstrb),
        .sb_axi_wlast           (sb_axi_wlast),

        .sb_axi_bvalid          (sb_axi_bvalid),
        .sb_axi_bready          (sb_axi_bready),
        .sb_axi_bresp           (sb_axi_bresp),
        .sb_axi_bid             (sb_axi_bid),


        .sb_axi_arvalid         (sb_axi_arvalid),
        .sb_axi_arready         (sb_axi_arready),
        .sb_axi_arid            (sb_axi_arid),
        .sb_axi_araddr          (sb_axi_araddr),
        .sb_axi_arregion        (sb_axi_arregion),
        .sb_axi_arlen           (sb_axi_arlen),
        .sb_axi_arsize          (sb_axi_arsize),
        .sb_axi_arburst         (sb_axi_arburst),
        .sb_axi_arlock          (sb_axi_arlock),
        .sb_axi_arcache         (sb_axi_arcache),
        .sb_axi_arprot          (sb_axi_arprot),
        .sb_axi_arqos           (sb_axi_arqos),

        .sb_axi_rvalid          (sb_axi_rvalid),
        .sb_axi_rready          (sb_axi_rready),
        .sb_axi_rid             (sb_axi_rid),
        .sb_axi_rdata           (sb_axi_rdata),
        .sb_axi_rresp           (sb_axi_rresp),
        .sb_axi_rlast           (sb_axi_rlast),

        //-------------------------- DMA AXI signals--------------------------
        // AXI Write Channels
        .dma_axi_awvalid        (axi_interconnect.sintf_arr[2].AWVALID),
        .dma_axi_awready        (axi_interconnect.sintf_arr[2].AWREADY),
        .dma_axi_awid           (axi_interconnect.sintf_arr[2].AWID),
        .dma_axi_awaddr         (axi_interconnect.sintf_arr[2].AWADDR),
        .dma_axi_awsize         (axi_interconnect.sintf_arr[2].AWSIZE),
        .dma_axi_awprot         (axi_interconnect.sintf_arr[2].AWPROT),
        .dma_axi_awlen          (axi_interconnect.sintf_arr[2].AWLEN),
        .dma_axi_awburst        (axi_interconnect.sintf_arr[2].AWBURST),

        .dma_axi_wvalid         (axi_interconnect.sintf_arr[2].WVALID),
        .dma_axi_wready         (axi_interconnect.sintf_arr[2].WREADY),
        .dma_axi_wdata          (axi_interconnect.sintf_arr[2].WDATA),
        .dma_axi_wstrb          (axi_interconnect.sintf_arr[2].WSTRB),
        .dma_axi_wlast          (axi_interconnect.sintf_arr[2].WLAST),

        .dma_axi_bvalid         (axi_interconnect.sintf_arr[2].BVALID),
        .dma_axi_bready         (axi_interconnect.sintf_arr[2].BREADY),
        .dma_axi_bresp          (axi_interconnect.sintf_arr[2].BRESP),
        .dma_axi_bid            (axi_interconnect.sintf_arr[2].BID),

        .dma_axi_arvalid        (axi_interconnect.sintf_arr[2].ARVALID),
        .dma_axi_arready        (axi_interconnect.sintf_arr[2].ARREADY),
        .dma_axi_arid           (axi_interconnect.sintf_arr[2].ARID),
        .dma_axi_araddr         (axi_interconnect.sintf_arr[2].ARADDR),
        .dma_axi_arsize         (axi_interconnect.sintf_arr[2].ARSIZE),
        .dma_axi_arprot         (axi_interconnect.sintf_arr[2].ARPROT),
        .dma_axi_arlen          (axi_interconnect.sintf_arr[2].ARLEN),
        .dma_axi_arburst        (axi_interconnect.sintf_arr[2].ARBURST),

        .dma_axi_rvalid         (axi_interconnect.sintf_arr[2].RVALID),
        .dma_axi_rready         (axi_interconnect.sintf_arr[2].RREADY),
        .dma_axi_rid            (axi_interconnect.sintf_arr[2].RID),
        .dma_axi_rdata          (axi_interconnect.sintf_arr[2].RDATA),
        .dma_axi_rresp          (axi_interconnect.sintf_arr[2].RRESP),
        .dma_axi_rlast          (axi_interconnect.sintf_arr[2].RLAST),

        .timer_int              ( timer_int ),
        .soft_int               ( soft_int ),
        .extintsrc_req          ( ext_int ),

        .lsu_bus_clk_en         ( 1'b1  ),// Clock ratio b/w cpu core clk & AHB master interface
        .ifu_bus_clk_en         ( 1'b1  ),// Clock ratio b/w cpu core clk & AHB master interface
        .dbg_bus_clk_en         ( 1'b1  ),// Clock ratio b/w cpu core clk & AHB Debug master interface
        .dma_bus_clk_en         ( 1'b1  ),// Clock ratio b/w cpu core clk & AHB slave interface

        .trace_rv_i_insn_ip     (trace_rv_i_insn_ip),
        .trace_rv_i_address_ip  (trace_rv_i_address_ip),
        .trace_rv_i_valid_ip    (trace_rv_i_valid_ip),
        .trace_rv_i_exception_ip(trace_rv_i_exception_ip),
        .trace_rv_i_ecause_ip   (trace_rv_i_ecause_ip),
        .trace_rv_i_interrupt_ip(trace_rv_i_interrupt_ip),
        .trace_rv_i_tval_ip     (trace_rv_i_tval_ip),

        .jtag_tck               ( 1'b0  ),
        .jtag_tms               ( 1'b0  ),
        .jtag_tdi               ( 1'b0  ),
        .jtag_trst_n            ( 1'b0  ),
        .jtag_tdo               ( jtag_tdo ),
        .jtag_tdoEn             (),

        .mpc_debug_halt_ack     ( mpc_debug_halt_ack),
        .mpc_debug_halt_req     ( 1'b0),
        .mpc_debug_run_ack      ( mpc_debug_run_ack),
        .mpc_debug_run_req      ( 1'b1),
        .mpc_reset_run_req      ( 1'b1),             // Start running after reset
         .debug_brkpt_status    (debug_brkpt_status),

        .i_cpu_halt_req         ( 1'b0  ),    // Async halt req to CPU
        .o_cpu_halt_ack         ( o_cpu_halt_ack ),    // core response to halt
        .o_cpu_halt_status      ( o_cpu_halt_status ), // 1'b1 indicates core is halted
        .i_cpu_run_req          ( 1'b0  ),     // Async restart req to CPU
        .o_debug_mode_status    (o_debug_mode_status),
        .o_cpu_run_ack          ( o_cpu_run_ack ),     // Core response to run req

        .dec_tlu_perfcnt0       (),
        .dec_tlu_perfcnt1       (),
        .dec_tlu_perfcnt2       (),
        .dec_tlu_perfcnt3       (),

        .mem_clk                (mcu_el2_mem_export.clk),

        .iccm_clken             (mcu_el2_mem_export.iccm_clken),
        .iccm_wren_bank         (mcu_el2_mem_export.iccm_wren_bank),
        .iccm_addr_bank         (mcu_el2_mem_export.iccm_addr_bank),
        .iccm_bank_wr_data      (mcu_el2_mem_export.iccm_bank_wr_data),
        .iccm_bank_wr_ecc       (mcu_el2_mem_export.iccm_bank_wr_ecc),
        .iccm_bank_dout         (mcu_el2_mem_export.iccm_bank_dout),
        .iccm_bank_ecc          (mcu_el2_mem_export.iccm_bank_ecc),

        .dccm_clken             (mcu_el2_mem_export.dccm_clken),
        .dccm_wren_bank         (mcu_el2_mem_export.dccm_wren_bank),
        .dccm_addr_bank         (mcu_el2_mem_export.dccm_addr_bank),
        .dccm_wr_data_bank      (mcu_el2_mem_export.dccm_wr_data_bank),
        .dccm_wr_ecc_bank       (mcu_el2_mem_export.dccm_wr_ecc_bank),
        .dccm_bank_dout         (mcu_el2_mem_export.dccm_bank_dout),
        .dccm_bank_ecc          (mcu_el2_mem_export.dccm_bank_ecc),

        .iccm_ecc_single_error  (),
        .iccm_ecc_double_error  (),
        .dccm_ecc_single_error  (),
        .dccm_ecc_double_error  (),

    // remove mems DFT pins for opensource
        .ic_data_ext_in_pkt     ('0),
        .ic_tag_ext_in_pkt      ('0),

        .core_id                ('0),
        .scan_mode              ( 1'b0 ),         // To enable scan mode
        .mbist_mode             ( 1'b0 ),        // to enable mbist

        .dmi_uncore_enable      (),
        .dmi_uncore_en          (),
        .dmi_uncore_wr_en       (),
        .dmi_uncore_addr        (),
        .dmi_uncore_wdata       (),
        .dmi_uncore_rdata       ()

    );


    //=========================================================================-
    // AXI MEM instance
    //=========================================================================-


    axi_slv #(.TAGW(7)) imem(

        .aclk           (core_clk),
        .rst_l          (rst_l),

        .arvalid        (axi_interconnect.sintf_arr[0].ARVALID),
        .arready        (axi_interconnect.sintf_arr[0].ARREADY),
        .araddr         (axi_interconnect.sintf_arr[0].ARADDR),
        .arid           (axi_interconnect.sintf_arr[0].ARID),
        .arlen          (axi_interconnect.sintf_arr[0].ARLEN),
        .arburst        (axi_interconnect.sintf_arr[0].ARBURST),
        .arsize         (axi_interconnect.sintf_arr[0].ARSIZE),

        .rvalid         (axi_interconnect.sintf_arr[0].RVALID),
        .rready         (axi_interconnect.sintf_arr[0].RREADY),
        .rdata          (axi_interconnect.sintf_arr[0].RDATA),
        .rresp          (axi_interconnect.sintf_arr[0].RRESP),
        .rid            (axi_interconnect.sintf_arr[0].RID),
        .rlast          (axi_interconnect.sintf_arr[0].RLAST),

        .awvalid        (axi_interconnect.sintf_arr[0].AWVALID),
        .awready        (axi_interconnect.sintf_arr[0].AWREADY),
        .awaddr         (axi_interconnect.sintf_arr[0].AWADDR),
        .awid           (axi_interconnect.sintf_arr[0].AWID),
        .awlen          (axi_interconnect.sintf_arr[0].AWLEN),
        .awburst        (axi_interconnect.sintf_arr[0].AWBURST),
        .awsize         (axi_interconnect.sintf_arr[0].AWSIZE),

        .wdata          (axi_interconnect.sintf_arr[0].WDATA),
        .wstrb          (axi_interconnect.sintf_arr[0].WSTRB),
        .wvalid         (axi_interconnect.sintf_arr[0].WVALID),
        .wready         (axi_interconnect.sintf_arr[0].WREADY),

        .bvalid         (axi_interconnect.sintf_arr[0].BVALID),
        .bready         (axi_interconnect.sintf_arr[0].BREADY),
        .bresp          (axi_interconnect.sintf_arr[0].BRESP),
        .bid            (axi_interconnect.sintf_arr[0].BID)

    );

// TODO: Replace with axi memory?
    //axi_slv #(.TAGW(`MCU_RV_LSU_BUS_TAG)) lmem(
    // -- Addtional 3 required for QVIP Interconnect
    // `MCU_RV_LSU_BUS_TAG + 3
    axi_slv #(.TAGW(7)) lmem(
        .aclk(core_clk),
        .rst_l(rst_l),

        .arvalid        (axi_interconnect.sintf_arr[1].ARVALID),
        .arready        (axi_interconnect.sintf_arr[1].ARREADY),
        .araddr         (axi_interconnect.sintf_arr[1].ARADDR),
        .arid           (axi_interconnect.sintf_arr[1].ARID),
        .arlen          (axi_interconnect.sintf_arr[1].ARLEN),
        .arburst        (axi_interconnect.sintf_arr[1].ARBURST),
        .arsize         (axi_interconnect.sintf_arr[1].ARSIZE),

        .rvalid         (axi_interconnect.sintf_arr[1].RVALID),
        .rready         (axi_interconnect.sintf_arr[1].RREADY),
        .rdata          (axi_interconnect.sintf_arr[1].RDATA),
        .rresp          (axi_interconnect.sintf_arr[1].RRESP),
        .rid            (axi_interconnect.sintf_arr[1].RID),
        .rlast          (axi_interconnect.sintf_arr[1].RLAST),

        .awvalid        (axi_interconnect.sintf_arr[1].AWVALID),
        .awready        (axi_interconnect.sintf_arr[1].AWREADY),
        .awaddr         (axi_interconnect.sintf_arr[1].AWADDR),
        .awid           (axi_interconnect.sintf_arr[1].AWID),
        .awlen          (axi_interconnect.sintf_arr[1].AWLEN),
        .awburst        (axi_interconnect.sintf_arr[1].AWBURST),
        .awsize         (axi_interconnect.sintf_arr[1].AWSIZE),

        .wdata          (axi_interconnect.sintf_arr[1].WDATA),
        .wstrb          (axi_interconnect.sintf_arr[1].WSTRB),
        .wvalid         (axi_interconnect.sintf_arr[1].WVALID),
        .wready         (axi_interconnect.sintf_arr[1].WREADY),

        .bvalid         (axi_interconnect.sintf_arr[1].BVALID),
        .bready         (axi_interconnect.sintf_arr[1].BREADY),
        .bresp          (axi_interconnect.sintf_arr[1].BRESP),
        .bid            (axi_interconnect.sintf_arr[1].BID)

    );


endmodule
