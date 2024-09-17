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

//`include "common_defines.sv"
`include "config_defines.svh"
`include "caliptra_reg_defines.svh"
`include "caliptra_macros.svh"

`include "config_defines_mcu.svh"
//`include "mcu_common_defines.vh"

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
    input  wire S_AXI_CALIPTRA_RREADY,

    //-------------------------- LSU AXI signals--------------------------
    // AXI Write Channels
    output wire                      M_AXI_MCU_LSU_AWVALID,
    input  wire                      M_AXI_MCU_LSU_AWREADY,
    output wire [3-1:0]              M_AXI_MCU_LSU_AWID,
    output wire [              31:0] M_AXI_MCU_LSU_AWADDR,
    output wire [               3:0] M_AXI_MCU_LSU_AWREGION,
    output wire [               7:0] M_AXI_MCU_LSU_AWLEN,
    output wire [               2:0] M_AXI_MCU_LSU_AWSIZE,
    output wire [               1:0] M_AXI_MCU_LSU_AWBURST,
    output wire                      M_AXI_MCU_LSU_AWLOCK,
    output wire [               3:0] M_AXI_MCU_LSU_AWCACHE,
    output wire [               2:0] M_AXI_MCU_LSU_AWPROT,
    output wire [               3:0] M_AXI_MCU_LSU_AWQOS,

    output wire                      M_AXI_MCU_LSU_WVALID,
    input  wire                      M_AXI_MCU_LSU_WREADY,
    output wire [63:0]               M_AXI_MCU_LSU_WDATA,
    output wire [ 7:0]               M_AXI_MCU_LSU_WSTRB,
    output wire                      M_AXI_MCU_LSU_WLAST,

    input  wire                      M_AXI_MCU_LSU_BVALID,
    output wire                      M_AXI_MCU_LSU_BREADY,
    input  wire [               1:0] M_AXI_MCU_LSU_BRESP,
    input  wire [3-1:0]              M_AXI_MCU_LSU_BID,

    // AXI Read Channels
    output wire                      M_AXI_MCU_LSU_ARVALID,
    input  wire                      M_AXI_MCU_LSU_ARREADY,
    output wire [3-1:0]              M_AXI_MCU_LSU_ARID,
    output wire [              31:0] M_AXI_MCU_LSU_ARADDR,
    output wire [               3:0] M_AXI_MCU_LSU_ARREGION,
    output wire [               7:0] M_AXI_MCU_LSU_ARLEN,
    output wire [               2:0] M_AXI_MCU_LSU_ARSIZE,
    output wire [               1:0] M_AXI_MCU_LSU_ARBURST,
    output wire                      M_AXI_MCU_LSU_ARLOCK,
    output wire [               3:0] M_AXI_MCU_LSU_ARCACHE,
    output wire [               2:0] M_AXI_MCU_LSU_ARPROT,
    output wire [               3:0] M_AXI_MCU_LSU_ARQOS,

    input  wire                      M_AXI_MCU_LSU_RVALID,
    output wire                      M_AXI_MCU_LSU_RREADY,
    input  wire [3-1:0]              M_AXI_MCU_LSU_RID,
    input  wire [              63:0] M_AXI_MCU_LSU_RDATA,
    input  wire [               1:0] M_AXI_MCU_LSU_RRESP,
    input  wire                      M_AXI_MCU_LSU_RLAST,

    //-------------------------- IFU AXI signals--------------------------
    // AXI Write Channels
    output wire                      M_AXI_MCU_IFU_AWVALID,
    input  wire                      M_AXI_MCU_IFU_AWREADY,
    output wire [3-1:0]              M_AXI_MCU_IFU_AWID,
    output wire [              31:0] M_AXI_MCU_IFU_AWADDR,
    output wire [               3:0] M_AXI_MCU_IFU_AWREGION,
    output wire [               7:0] M_AXI_MCU_IFU_AWLEN,
    output wire [               2:0] M_AXI_MCU_IFU_AWSIZE,
    output wire [               1:0] M_AXI_MCU_IFU_AWBURST,
    output wire                      M_AXI_MCU_IFU_AWLOCK,
    output wire [               3:0] M_AXI_MCU_IFU_AWCACHE,
    output wire [               2:0] M_AXI_MCU_IFU_AWPROT,
    output wire [               3:0] M_AXI_MCU_IFU_AWQOS,

    output wire                      M_AXI_MCU_IFU_WVALID,
    input  wire                      M_AXI_MCU_IFU_WREADY,
    output wire [63:0]               M_AXI_MCU_IFU_WDATA,
    output wire [ 7:0]               M_AXI_MCU_IFU_WSTRB,
    output wire                      M_AXI_MCU_IFU_WLAST,

    input  wire                      M_AXI_MCU_IFU_BVALID,
    output wire                      M_AXI_MCU_IFU_BREADY,
    input  wire [               1:0] M_AXI_MCU_IFU_BRESP,
    input  wire [3-1:0]              M_AXI_MCU_IFU_BID,

    // AXI Read Channels
    output wire                      M_AXI_MCU_IFU_ARVALID,
    input  wire                      M_AXI_MCU_IFU_ARREADY,
    output wire [3-1:0]              M_AXI_MCU_IFU_ARID,
    output wire [              31:0] M_AXI_MCU_IFU_ARADDR,
    output wire [               3:0] M_AXI_MCU_IFU_ARREGION,
    output wire [               7:0] M_AXI_MCU_IFU_ARLEN,
    output wire [               2:0] M_AXI_MCU_IFU_ARSIZE,
    output wire [               1:0] M_AXI_MCU_IFU_ARBURST,
    output wire                      M_AXI_MCU_IFU_ARLOCK,
    output wire [               3:0] M_AXI_MCU_IFU_ARCACHE,
    output wire [               2:0] M_AXI_MCU_IFU_ARPROT,
    output wire [               3:0] M_AXI_MCU_IFU_ARQOS,

    input  wire                      M_AXI_MCU_IFU_RVALID,
    output wire                      M_AXI_MCU_IFU_RREADY,
    input  wire [3-1:0]              M_AXI_MCU_IFU_RID,
    input  wire [              63:0] M_AXI_MCU_IFU_RDATA,
    input  wire [               1:0] M_AXI_MCU_IFU_RRESP,
    input  wire                      M_AXI_MCU_IFU_RLAST,

    //-------------------------- SB AXI signals--------------------------
    // AXI Write Channels
    output wire                     sb_axi_awvalid,
    input  wire                     sb_axi_awready,
    output wire [1-1:0]             sb_axi_awid,
    output wire [             31:0] sb_axi_awaddr,
    output wire [              3:0] sb_axi_awregion,
    output wire [              7:0] sb_axi_awlen,
    output wire [              2:0] sb_axi_awsize,
    output wire [              1:0] sb_axi_awburst,
    output wire                     sb_axi_awlock,
    output wire [              3:0] sb_axi_awcache,
    output wire [              2:0] sb_axi_awprot,
    output wire [              3:0] sb_axi_awqos,

    output wire                     sb_axi_wvalid,
    input  wire                     sb_axi_wready,
    output wire [63:0]              sb_axi_wdata,
    output wire [ 7:0]              sb_axi_wstrb,
    output wire                     sb_axi_wlast,

    input  wire                     sb_axi_bvalid,
    output wire                     sb_axi_bready,
    input  wire [              1:0] sb_axi_bresp,
    input  wire [1-1:0]             sb_axi_bid,

    // AXI Read Channels
    output wire                     sb_axi_arvalid,
    input  wire                     sb_axi_arready,
    output wire [1-1:0]             sb_axi_arid,
    output wire [             31:0] sb_axi_araddr,
    output wire [              3:0] sb_axi_arregion,
    output wire [              7:0] sb_axi_arlen,
    output wire [              2:0] sb_axi_arsize,
    output wire [              1:0] sb_axi_arburst,
    output wire                     sb_axi_arlock,
    output wire [              3:0] sb_axi_arcache,
    output wire [              2:0] sb_axi_arprot,
    output wire [              3:0] sb_axi_arqos,

    input  wire                     sb_axi_rvalid,
    output wire                     sb_axi_rready,
    input  wire [1-1:0]             sb_axi_rid,
    input  wire [             63:0] sb_axi_rdata,
    input  wire [              1:0] sb_axi_rresp,
    input  wire                     sb_axi_rlast,

    //-------------------------- DMA AXI signals--------------------------
    // AXI Write Channels
    input  wire                      S_AXI_MCU_DMA_AWVALID,
    output wire                      S_AXI_MCU_DMA_AWREADY,
    input  wire [1-1:0]              S_AXI_MCU_DMA_AWID,
    input  wire [              31:0] S_AXI_MCU_DMA_AWADDR,
    input  wire [               2:0] S_AXI_MCU_DMA_AWSIZE,
    input  wire [               2:0] S_AXI_MCU_DMA_AWPROT,
    input  wire [               7:0] S_AXI_MCU_DMA_AWLEN,
    input  wire [               1:0] S_AXI_MCU_DMA_AWBURST,


    input  wire                      S_AXI_MCU_DMA_WVALID,
    output wire                      S_AXI_MCU_DMA_WREADY,
    input  wire [63:0]               S_AXI_MCU_DMA_WDATA,
    input  wire [ 7:0]               S_AXI_MCU_DMA_WSTRB,
    input  wire                      S_AXI_MCU_DMA_WLAST,

    output wire                      S_AXI_MCU_DMA_BVALID,
    input  wire                      S_AXI_MCU_DMA_BREADY,
    output wire [               1:0] S_AXI_MCU_DMA_BRESP,
    output wire [1-1:0]              S_AXI_MCU_DMA_BID,

    // AXI Read CHANNELS
    input  wire                      S_AXI_MCU_DMA_ARVALID,
    output wire                      S_AXI_MCU_DMA_ARREADY,
    input  wire [1-1:0]              S_AXI_MCU_DMA_ARID,
    input  wire [              31:0] S_AXI_MCU_DMA_ARADDR,
    input  wire [               2:0] S_AXI_MCU_DMA_ARSIZE,
    input  wire [               2:0] S_AXI_MCU_DMA_ARPROT,
    input  wire [               7:0] S_AXI_MCU_DMA_ARLEN,
    input  wire [               1:0] S_AXI_MCU_DMA_ARBURST,

    output wire                      S_AXI_MCU_DMA_RVALID,
    input  wire                      S_AXI_MCU_DMA_RREADY,
    output wire [1-1:0]              S_AXI_MCU_DMA_RID,
    output wire [              63:0] S_AXI_MCU_DMA_RDATA,
    output wire [               1:0] S_AXI_MCU_DMA_RRESP,
    output wire                      S_AXI_MCU_DMA_RLAST

);

        logic                       rst_l;
        logic                       porst_l;
        logic [31:1]  ext_int;
        logic                       nmi_int;
        logic                       timer_int;
        logic                       soft_int;

        logic        [31:0]         reset_vector;
        logic        [31:0]         nmi_vector;
        logic        [31:1]         jtag_id;
initial begin
            jtag_id[31:28] = 4'b1;
            jtag_id[27:12] = '0;
            jtag_id[11:1]  = 11'h45;
            reset_vector = 0;//`MCU_RV_RESET_VEC;
            nmi_vector   = 32'hee000000;
end

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


        mcu_el2_mem_if                  mcu_el2_mem_export ();

        logic [4-1:0][38:0]         iccm_bank_wr_fdata;
        logic [4-1:0][38:0]         iccm_bank_fdout;
        logic [4-1:0][39-1:0]       dccm_wr_fdata_bank;
        logic [4-1:0][39-1:0]       dccm_bank_fdout;



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

        .lsu_axi_awvalid        (M_AXI_MCU_LSU_AWVALID),
        .lsu_axi_awready        (M_AXI_MCU_LSU_AWREADY),
        .lsu_axi_awid           (M_AXI_MCU_LSU_AWID),
        .lsu_axi_awaddr         (M_AXI_MCU_LSU_AWADDR),
        .lsu_axi_awregion       (M_AXI_MCU_LSU_AWREGION),
        .lsu_axi_awlen          (M_AXI_MCU_LSU_AWLEN),
        .lsu_axi_awsize         (M_AXI_MCU_LSU_AWSIZE),
        .lsu_axi_awburst        (M_AXI_MCU_LSU_AWBURST),
        .lsu_axi_awlock         (M_AXI_MCU_LSU_AWLOCK),
        .lsu_axi_awcache        (M_AXI_MCU_LSU_AWCACHE),
        .lsu_axi_awprot         (M_AXI_MCU_LSU_AWPROT),
        .lsu_axi_awqos          (M_AXI_MCU_LSU_AWQOS),

        .lsu_axi_wvalid         (M_AXI_MCU_LSU_WVALID),
        .lsu_axi_wready         (M_AXI_MCU_LSU_WREADY),
        .lsu_axi_wdata          (M_AXI_MCU_LSU_WDATA),
        .lsu_axi_wstrb          (M_AXI_MCU_LSU_WSTRB),
        .lsu_axi_wlast          (M_AXI_MCU_LSU_WLAST),

        .lsu_axi_bvalid         (M_AXI_MCU_LSU_BVALID),
        .lsu_axi_bready         (M_AXI_MCU_LSU_BREADY),
        .lsu_axi_bresp          (M_AXI_MCU_LSU_BRESP),
        .lsu_axi_bid            (M_AXI_MCU_LSU_BID),

        .lsu_axi_arvalid        (M_AXI_MCU_LSU_ARVALID),
        .lsu_axi_arready        (M_AXI_MCU_LSU_ARREADY),
        .lsu_axi_arid           (M_AXI_MCU_LSU_ARID),
        .lsu_axi_araddr         (M_AXI_MCU_LSU_ARADDR),
        .lsu_axi_arregion       (M_AXI_MCU_LSU_ARREGION),
        .lsu_axi_arlen          (M_AXI_MCU_LSU_ARLEN),
        .lsu_axi_arsize         (M_AXI_MCU_LSU_ARSIZE),
        .lsu_axi_arburst        (M_AXI_MCU_LSU_ARBURST),
        .lsu_axi_arlock         (M_AXI_MCU_LSU_ARLOCK),
        .lsu_axi_arcache        (M_AXI_MCU_LSU_ARCACHE),
        .lsu_axi_arprot         (M_AXI_MCU_LSU_ARPROT),
        .lsu_axi_arqos          (M_AXI_MCU_LSU_ARQOS),

        .lsu_axi_rvalid         (M_AXI_MCU_LSU_RVALID),
        .lsu_axi_rready         (M_AXI_MCU_LSU_RREADY),
        .lsu_axi_rid            (M_AXI_MCU_LSU_RID),
        .lsu_axi_rdata          (M_AXI_MCU_LSU_RDATA),
        .lsu_axi_rresp          (M_AXI_MCU_LSU_RRESP),
        .lsu_axi_rlast          (M_AXI_MCU_LSU_RLAST),

        //-------------------------- IFU AXI signals--------------------------
        // AXI Write Channels

        .ifu_axi_awvalid        ( M_AXI_MCU_IFU_AWVALID ),
        .ifu_axi_awready        ( M_AXI_MCU_IFU_AWREADY ),
        .ifu_axi_awid           ( M_AXI_MCU_IFU_AWID    ),
        .ifu_axi_awaddr         ( M_AXI_MCU_IFU_AWADDR  ),
        .ifu_axi_awregion       ( M_AXI_MCU_IFU_AWREGION),
        .ifu_axi_awlen          ( M_AXI_MCU_IFU_AWLEN   ),
        .ifu_axi_awsize         ( M_AXI_MCU_IFU_AWSIZE  ),
        .ifu_axi_awburst        ( M_AXI_MCU_IFU_AWBURST ),
        .ifu_axi_awlock         ( M_AXI_MCU_IFU_AWLOCK  ),
        .ifu_axi_awcache        ( M_AXI_MCU_IFU_AWCACHE ),
        .ifu_axi_awprot         ( M_AXI_MCU_IFU_AWPROT  ),
        .ifu_axi_awqos          ( M_AXI_MCU_IFU_AWQOS   ),

        .ifu_axi_wvalid         ( M_AXI_MCU_IFU_WVALID  ),
        .ifu_axi_wready         ( M_AXI_MCU_IFU_WREADY  ),
        .ifu_axi_wdata          ( M_AXI_MCU_IFU_WDATA   ),
        .ifu_axi_wstrb          ( M_AXI_MCU_IFU_WSTRB   ),
        .ifu_axi_wlast          ( M_AXI_MCU_IFU_WLAST   ),

        .ifu_axi_bvalid         ( M_AXI_MCU_IFU_BVALID  ),
        .ifu_axi_bready         ( M_AXI_MCU_IFU_BREADY  ),
        .ifu_axi_bresp          ( M_AXI_MCU_IFU_BRESP   ),
        .ifu_axi_bid            ( M_AXI_MCU_IFU_BID     ),

        .ifu_axi_arvalid        ( M_AXI_MCU_IFU_ARVALID ),
        .ifu_axi_arready        ( M_AXI_MCU_IFU_ARREADY ),
        .ifu_axi_arid           ( M_AXI_MCU_IFU_ARID    ),
        .ifu_axi_araddr         ( M_AXI_MCU_IFU_ARADDR  ),
        .ifu_axi_arlen          ( M_AXI_MCU_IFU_ARLEN   ),
        .ifu_axi_arsize         ( M_AXI_MCU_IFU_ARSIZE  ),
        .ifu_axi_arburst        ( M_AXI_MCU_IFU_ARBURST ),
        .ifu_axi_arlock         ( M_AXI_MCU_IFU_ARLOCK  ),
        .ifu_axi_arcache        ( M_AXI_MCU_IFU_ARCACHE ),
        .ifu_axi_arprot         ( M_AXI_MCU_IFU_ARPROT  ),
        .ifu_axi_arqos          ( M_AXI_MCU_IFU_ARQOS   ),
        .ifu_axi_arregion       ( M_AXI_MCU_IFU_ARREGION),

        .ifu_axi_rvalid         ( M_AXI_MCU_IFU_RVALID  ),
        .ifu_axi_rready         ( M_AXI_MCU_IFU_RREADY  ),
        .ifu_axi_rid            ( M_AXI_MCU_IFU_RID     ),
        .ifu_axi_rdata          ( M_AXI_MCU_IFU_RDATA   ),
        .ifu_axi_rresp          ( M_AXI_MCU_IFU_RRESP   ),
        .ifu_axi_rlast          ( M_AXI_MCU_IFU_RLAST   ),

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
        .dma_axi_awvalid        (S_AXI_MCU_DMA_AWVALID),
        .dma_axi_awready        (S_AXI_MCU_DMA_AWREADY),
        .dma_axi_awid           (S_AXI_MCU_DMA_AWID),
        .dma_axi_awaddr         (S_AXI_MCU_DMA_AWADDR),
        .dma_axi_awsize         (S_AXI_MCU_DMA_AWSIZE),
        .dma_axi_awprot         (S_AXI_MCU_DMA_AWPROT),
        .dma_axi_awlen          (S_AXI_MCU_DMA_AWLEN),
        .dma_axi_awburst        (S_AXI_MCU_DMA_AWBURST),

        .dma_axi_wvalid         (S_AXI_MCU_DMA_WVALID),
        .dma_axi_wready         (S_AXI_MCU_DMA_WREADY),
        .dma_axi_wdata          (S_AXI_MCU_DMA_WDATA),
        .dma_axi_wstrb          (S_AXI_MCU_DMA_WSTRB),
        .dma_axi_wlast          (S_AXI_MCU_DMA_WLAST),

        .dma_axi_bvalid         (S_AXI_MCU_DMA_BVALID),
        .dma_axi_bready         (S_AXI_MCU_DMA_BREADY),
        .dma_axi_bresp          (S_AXI_MCU_DMA_BRESP),
        .dma_axi_bid            (S_AXI_MCU_DMA_BID),

        .dma_axi_arvalid        (S_AXI_MCU_DMA_ARVALID),
        .dma_axi_arready        (S_AXI_MCU_DMA_ARREADY),
        .dma_axi_arid           (S_AXI_MCU_DMA_ARID),
        .dma_axi_araddr         (S_AXI_MCU_DMA_ARADDR),
        .dma_axi_arsize         (S_AXI_MCU_DMA_ARSIZE),
        .dma_axi_arprot         (S_AXI_MCU_DMA_ARPROT),
        .dma_axi_arlen          (S_AXI_MCU_DMA_ARLEN),
        .dma_axi_arburst        (S_AXI_MCU_DMA_ARBURST),

        .dma_axi_rvalid         (S_AXI_MCU_DMA_RVALID),
        .dma_axi_rready         (S_AXI_MCU_DMA_RREADY),
        .dma_axi_rid            (S_AXI_MCU_DMA_RID),
        .dma_axi_rdata          (S_AXI_MCU_DMA_RDATA),
        .dma_axi_rresp          (S_AXI_MCU_DMA_RRESP),
        .dma_axi_rlast          (S_AXI_MCU_DMA_RLAST),

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
