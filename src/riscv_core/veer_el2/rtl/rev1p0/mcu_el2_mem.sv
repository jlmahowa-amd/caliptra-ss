//********************************************************************************
// SPDX-License-Identifier: Apache-2.0
// Copyright 2020 Western Digital Corporation or its affiliates.
// Copyright (c) 2023 Antmicro <www.antmicro.com>
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
//********************************************************************************

module mcu_el2_mem
import mcu_el2_pkg::*;
#(
`include "mcu_el2_param.vh"
 )
(
   input logic         clk,
   input logic         rst_l,
   input logic         dccm_clk_override,
   input logic         icm_clk_override,
   input logic         dec_tlu_core_ecc_disable,

   //DCCM ports
   input logic         dccm_wren,
   input logic         dccm_rden,
   input logic [mcu_pt.DCCM_BITS-1:0]  dccm_wr_addr_lo,
   input logic [mcu_pt.DCCM_BITS-1:0]  dccm_wr_addr_hi,
   input logic [mcu_pt.DCCM_BITS-1:0]  dccm_rd_addr_lo,
   input logic [mcu_pt.DCCM_BITS-1:0]  dccm_rd_addr_hi,
   input logic [mcu_pt.DCCM_FDATA_WIDTH-1:0]  dccm_wr_data_lo,
   input logic [mcu_pt.DCCM_FDATA_WIDTH-1:0]  dccm_wr_data_hi,


   output logic [mcu_pt.DCCM_FDATA_WIDTH-1:0]  dccm_rd_data_lo,
   output logic [mcu_pt.DCCM_FDATA_WIDTH-1:0]  dccm_rd_data_hi,

   //ICCM ports
   input logic [mcu_pt.ICCM_BITS-1:1]  iccm_rw_addr,
   input logic                                        iccm_buf_correct_ecc,                    // ICCM is doing a single bit error correct cycle
   input logic                                        iccm_correction_state,               // ICCM is doing a single bit error correct cycle
   input logic         iccm_wren,
   input logic         iccm_rden,
   input logic [2:0]   iccm_wr_size,
   input logic [77:0]  iccm_wr_data,

   output logic [63:0] iccm_rd_data,
   output logic [77:0] iccm_rd_data_ecc,

   // Icache and Itag Ports

   input  logic [31:1]  ic_rw_addr,
   input  logic [mcu_pt.ICACHE_NUM_WAYS-1:0]   ic_tag_valid,
   input  logic [mcu_pt.ICACHE_NUM_WAYS-1:0]   ic_wr_en,
   input  logic         ic_rd_en,
   input  logic [63:0] ic_premux_data,      // Premux data to be muxed with each way of the Icache.
   input  logic         ic_sel_premux_data, // Premux data sel
   input mcu_el2_ic_data_ext_in_pkt_t   [mcu_pt.ICACHE_NUM_WAYS-1:0][mcu_pt.ICACHE_BANKS_WAY-1:0]         ic_data_ext_in_pkt,
   input mcu_el2_ic_tag_ext_in_pkt_t    [mcu_pt.ICACHE_NUM_WAYS-1:0]           ic_tag_ext_in_pkt,

   input  logic [mcu_pt.ICACHE_BANKS_WAY-1:0][70:0]               ic_wr_data,         // Data to fill to the Icache. With ECC
   input  logic [70:0]               ic_debug_wr_data,   // Debug wr cache.
   output logic [70:0]               ic_debug_rd_data ,  // Data read from Icache. 2x64bits + parity bits. F2 stage. With ECC
   input  logic [mcu_pt.ICACHE_INDEX_HI:3]               ic_debug_addr,      // Read/Write addresss to the Icache.
   input  logic                      ic_debug_rd_en,     // Icache debug rd
   input  logic                      ic_debug_wr_en,     // Icache debug wr
   input  logic                      ic_debug_tag_array, // Debug tag array
   input  logic [mcu_pt.ICACHE_NUM_WAYS-1:0]                ic_debug_way,       // Debug way. Rd or Wr.

   output logic [63:0]              ic_rd_data ,        // Data read from Icache. 2x64bits + parity bits. F2 stage. With ECC
   output logic [25:0]               ictag_debug_rd_data,// Debug icache tag.


   output logic [mcu_pt.ICACHE_BANKS_WAY-1:0] ic_eccerr,    // ecc error per bank
   output logic [mcu_pt.ICACHE_BANKS_WAY-1:0] ic_parerr,          // parity error per bank
   output logic [mcu_pt.ICACHE_NUM_WAYS-1:0]   ic_rd_hit,
   output logic         ic_tag_perr,        // Icache Tag parity error

   mcu_el2_mem_if.veer_sram_src mem_export,

   input  logic         scan_mode

);

   logic active_clk;
   rvoclkhdr active_cg   ( .en(1'b1),         .l1clk(active_clk), .* );

   mcu_el2_mem_if mem_export_local ();

   assign mem_export      .clk = clk;
   assign mem_export_local.clk = clk;

   assign mem_export      .iccm_clken         = mem_export_local.iccm_clken;
   assign mem_export      .iccm_wren_bank     = mem_export_local.iccm_wren_bank;
   assign mem_export      .iccm_addr_bank     = mem_export_local.iccm_addr_bank;
   assign mem_export      .iccm_bank_wr_data  = mem_export_local.iccm_bank_wr_data;
   assign mem_export      .iccm_bank_wr_ecc   = mem_export_local.iccm_bank_wr_ecc;
   assign mem_export_local.iccm_bank_dout     = mem_export.      iccm_bank_dout;
   assign mem_export_local.iccm_bank_ecc      = mem_export.      iccm_bank_ecc;

   assign mem_export      .dccm_clken         = mem_export_local.dccm_clken;
   assign mem_export      .dccm_wren_bank     = mem_export_local.dccm_wren_bank;
   assign mem_export      .dccm_addr_bank     = mem_export_local.dccm_addr_bank;
   assign mem_export      .dccm_wr_data_bank  = mem_export_local.dccm_wr_data_bank;
   assign mem_export      .dccm_wr_ecc_bank   = mem_export_local.dccm_wr_ecc_bank;
   assign mem_export_local.dccm_bank_dout     = mem_export      .dccm_bank_dout;
   assign mem_export_local.dccm_bank_ecc      = mem_export      .dccm_bank_ecc;

   // DCCM Instantiation
   if (mcu_pt.DCCM_ENABLE == 1) begin: Gen_dccm_enable
      mcu_el2_lsu_dccm_mem #(.mcu_pt(mcu_pt)) dccm (
         .clk_override(dccm_clk_override),
         .dccm_mem_export(mem_export_local.veer_dccm),
         .*
      );
   end else begin: Gen_dccm_disable
      assign dccm_rd_data_lo = '0;
      assign dccm_rd_data_hi = '0;
   end

if ( mcu_pt.ICACHE_ENABLE ) begin: icache
   mcu_el2_ifu_ic_mem #(.mcu_pt(mcu_pt)) icm  (
      .clk_override(icm_clk_override),
      .*
   );
end
else  begin
   assign   ic_rd_hit[mcu_pt.ICACHE_NUM_WAYS-1:0] = '0;
   assign   ic_tag_perr    = '0 ;
   assign   ic_rd_data  = '0 ;
   assign   ictag_debug_rd_data  = '0 ;
   assign   ic_debug_rd_data  = '0 ;
   assign   ic_eccerr      = '0;
end // else: !if( mcu_pt.ICACHE_ENABLE )



if (mcu_pt.ICCM_ENABLE) begin : iccm
   mcu_el2_ifu_iccm_mem  #(.mcu_pt(mcu_pt)) iccm (.*,
                  .clk_override(icm_clk_override),
                  .iccm_rw_addr(iccm_rw_addr[mcu_pt.ICCM_BITS-1:1]),
                  .iccm_rd_data(iccm_rd_data[63:0]),
                  .iccm_mem_export(mem_export_local.veer_iccm)
                   );
end
else  begin
   assign  iccm_rd_data    = '0 ;
   assign iccm_rd_data_ecc = '0 ;
end


endmodule
