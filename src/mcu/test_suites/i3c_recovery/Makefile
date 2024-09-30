# TODO: Move me to tools/scripts Makefile
BUILD_DIR = ${CALIPTRA_SS}/run
DUT ?= caliptra_mcu_top_tb
TB_DEFS = +define+CALIPTRA_INTERNAL_QSPI+CALIPTRA_INTERNAL_TRNG+CALIPTRA_INTERNAL_UART
SIM_BUILD = ${BUILD_DIR}/obj_dir
VERILATOR_DEBUG = --trace --trace-structs
TEST_FILES   = $(sort $(wildcard test_*.py))
MODULE = caliptra_mcu_top_tb

# Cocotb test suite setup
SIM = verilator
TOPLEVEL_LANG = verilog
TOPLEVEL=caliptra_mcu_top_tb
EXTRA_ARGS = -Wno-WIDTH -Wno-UNOPTFLAT -Wno-LITENDIAN -Wno-CMPCONST -Wno-MULTIDRIVEN -Wno-UNPACKED -Wno-ALWCOMBORDER
EXTRA_ARGS += --timing
EXTRA_ARGS += -I${BUILD_DIR}

# Testbench DPI sources
TB_DPI_SRCS = jtagdpi/jtagdpi.c \
              tcp_server/tcp_server.c
TB_DPI_INCS := $(addprefix -I$(CALIPTRA_SS)/src/mcu/test_suites/libs/,$(dir $(TB_DPI_SRCS)))
TB_DPI_SRCS := $(addprefix $(CALIPTRA_SS)/src/mcu/test_suites/libs/,$(TB_DPI_SRCS))
CFLAGS += -std=c++17 $(TB_DPI_INCS)

EXTRA_ARGS += $(TB_DPI_SRCS) \
              --cc -CFLAGS "$(CFLAGS)" \
	          +libext+.v+.sv +define+RV_OPENSOURCE \
	          --timescale 1ns/1ps \
	          --top-module $(DUT) \
	          --autoflush $(VERILATOR_DEBUG) \
	          $(TB_DEFS)

VERILOG_INCLUDE_DIRS = \
${CALIPTRA_ROOT}/src/keyvault/rtl \
${CALIPTRA_ROOT}/src/doe/rtl \
${CALIPTRA_ROOT}/src/integration/asserts \
${CALIPTRA_ROOT}/src/libs/rtl \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl \
${CALIPTRA_ROOT}/src/lc_ctrl/rtl \
${CALIPTRA_ROOT}/src/spi_host/rtl \
${CALIPTRA_ROOT}/src/spi_host/tb \
${CALIPTRA_SS}/src/mcu/rtl \
${I3C_ROOT}/src \
${I3C_ROOT}/src/libs/axi \
${CALIPTRA_ROOT}/src/soc_ifc/rtl \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl \
${CALIPTRA_ROOT}/src/pcrvault/rtl \
${CALIPTRA_ROOT}/src/entropy_src/rtl \
${CALIPTRA_ROOT}/src/entropy_src/tb \
${CALIPTRA_ROOT}/src/csrng/rtl \
${CALIPTRA_ROOT}/src/uart/rtl \
${CALIPTRA_ROOT}/src/sha512/coverage \
${CALIPTRA_ROOT}/src/sha256/coverage \
${CALIPTRA_ROOT}/src/hmac/coverage \
${CALIPTRA_ROOT}/src/soc_ifc/coverage \
${CALIPTRA_SS}/src/mcu/tb \
${CALIPTRA_SS}/src/mcu/coverage \
${CALIPTRA_ROOT}/src/caliptra_prim_generic/rtl \
${CALIPTRA_ROOT}/src/ahb_lite_bus/rtl \
${CALIPTRA_ROOT}/src/sha512/rtl \
${CALIPTRA_ROOT}/src/sha256/rtl \
${CALIPTRA_ROOT}/src/sha512_masked/rtl \
${CALIPTRA_ROOT}/src/hmac/rtl \
${CALIPTRA_ROOT}/src/kmac/rtl \
${CALIPTRA_ROOT}/src/edn/rtl \
${CALIPTRA_ROOT}/src/aes/rtl \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/include \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib \
${CALIPTRA_SS}/src/riscv_core/veer_el2/rtl/rev1p0

VERILOG_SOURCES = \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/el2_pdef.vh \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/include/el2_def.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib/el2_mem_if.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_defines_pkg.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_macros.svh \
${CALIPTRA_ROOT}/src/doe/rtl/doe_defines_pkg.sv \
${CALIPTRA_ROOT}/src/integration/asserts/caliptra_top_sva.sv \
${CALIPTRA_ROOT}/src/libs/rtl/caliptra_sva.svh \
${CALIPTRA_ROOT}/src/libs/rtl/caliptra_macros.svh \
${CALIPTRA_ROOT}/src/libs/rtl/caliptra_sram.sv \
${CALIPTRA_ROOT}/src/libs/rtl/ahb_defines_pkg.sv \
${CALIPTRA_ROOT}/src/libs/rtl/caliptra_ahb_srom.sv \
${CALIPTRA_ROOT}/src/libs/rtl/apb_slv_sif.sv \
${CALIPTRA_ROOT}/src/libs/rtl/ahb_slv_sif.sv \
${CALIPTRA_ROOT}/src/libs/rtl/caliptra_icg.sv \
${CALIPTRA_ROOT}/src/libs/rtl/clk_gate.sv \
${CALIPTRA_ROOT}/src/libs/rtl/caliptra_2ff_sync.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_util_pkg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_alert_pkg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_subreg_pkg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_mubi_pkg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_cipher_pkg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_pkg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_sparse_fsm_pkg.sv \
${CALIPTRA_ROOT}/src/lc_ctrl/rtl/lc_ctrl_reg_pkg.sv \
${CALIPTRA_ROOT}/src/lc_ctrl/rtl/lc_ctrl_state_pkg.sv \
${CALIPTRA_ROOT}/src/lc_ctrl/rtl/lc_ctrl_pkg.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_reg_pkg.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_cmd_pkg.sv \
${CALIPTRA_ROOT}/src/spi_host/tb/spi_device_pkg.sv \
${CALIPTRA_ROOT}/src/spi_host/tb/spiflash.sv \
${CALIPTRA_SS}/src/mcu/rtl/config_defines_mcu.svh \
${CALIPTRA_SS}/src/mcu/rtl/caliptra_reg_defines.svh \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/soc_ifc_pkg.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/soc_ifc_reg_pkg.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/common_defines.sv \
${CALIPTRA_ROOT}/src/pcrvault/rtl/pv_defines_pkg.sv \
${CALIPTRA_ROOT}/src/pcrvault/rtl/pv_macros.svh \
${CALIPTRA_ROOT}/src/pcrvault/rtl/pv_gen_hash.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_main_sm_pkg.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_ack_sm_pkg.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_reg_pkg.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_pkg.sv \
${CALIPTRA_ROOT}/src/entropy_src/tb/physical_rng.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_reg_pkg.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_pkg.sv \
${CALIPTRA_ROOT}/src/uart/rtl/uart_reg_pkg.sv \
${CALIPTRA_ROOT}/src/sha512/coverage/sha512_ctrl_cov_if.sv \
${CALIPTRA_ROOT}/src/sha512/coverage/sha512_ctrl_cov_bind.sv \
${CALIPTRA_ROOT}/src/sha256/coverage/sha256_ctrl_cov_if.sv \
${CALIPTRA_ROOT}/src/sha256/coverage/sha256_ctrl_cov_bind.sv \
${CALIPTRA_ROOT}/src/hmac/coverage/hmac_ctrl_cov_if.sv \
${CALIPTRA_ROOT}/src/hmac/coverage/hmac_ctrl_cov_bind.sv \
${CALIPTRA_ROOT}/src/soc_ifc/coverage/soc_ifc_cov_if.sv \
${CALIPTRA_ROOT}/src/soc_ifc/coverage/soc_ifc_cov_bind.sv \
${CALIPTRA_SS}/src/mcu/tb/caliptra_mcu_top_tb_pkg.sv \
${CALIPTRA_SS}/src/mcu/tb/caliptra_veer_sram_export.sv \
${CALIPTRA_SS}/src/mcu/tb/caliptra_mcu_top_tb_services.sv \
${CALIPTRA_SS}/src/mcu/coverage/caliptra_mcu_top_cov_if.sv \
${CALIPTRA_SS}/src/mcu/coverage/caliptra_mcu_top_cov_props.sv \
${CALIPTRA_SS}/src/mcu/coverage/caliptra_mcu_top_cov_bind.sv \
${CALIPTRA_SS}/src/mcu/test_suites/libs/jtagdpi/jtagdpi.sv \
${CALIPTRA_SS}/src/mcu/tb/caliptra_mcu_top_tb.sv \
${CALIPTRA_ROOT}/src/libs/rtl/ahb_to_reg_adapter.sv \
${CALIPTRA_ROOT}/src/caliptra_prim_generic/rtl/caliptra_prim_generic_flop_en.sv \
${CALIPTRA_ROOT}/src/caliptra_prim_generic/rtl/caliptra_prim_generic_flop.sv \
${CALIPTRA_ROOT}/src/caliptra_prim_generic/rtl/caliptra_prim_generic_buf.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_flop_en.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_cdc_rand_delay.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_flop_2sync.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_lfsr.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_mubi4_sync.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_diff_decode.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_sec_anchor_buf.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_slicer.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_count.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_sparse_fsm_flop.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_dom_and_2share.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_sec_anchor_flop.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_reg_we_check.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_packer_fifo.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_max_tree.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_subreg_arb.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_subreg.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_intr_hw.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_onehot_check.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_mubi8_sync.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_fifo_sync_cnt.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_buf.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_lc_sync.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_alert_receiver.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_flop.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_alert_sender.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_fifo_sync.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_arbiter_ppc.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_sum_tree.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_subreg_ext.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_edge_detector.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_byte_merge.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_byte_select.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_command_queue.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_core.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_data_fifos.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_fsm.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_reg_top.sv \
${CALIPTRA_ROOT}/src/spi_host/rtl/spi_host_shift_register.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/mbox_csr_pkg.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/sha512_acc_csr_pkg.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/el2_mem.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/el2_dma_ctrl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/el2_pic_ctrl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/el2_veer.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/el2_veer_wrapper.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dbg/el2_dbg.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dec/el2_dec_decode_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dec/el2_dec_gpr_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dec/el2_dec_ib_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dec/el2_dec.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dec/el2_dec_tlu_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dec/el2_dec_trigger.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dmi/dmi_jtag_to_core_sync.v \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dmi/dmi_wrapper.v \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/dmi/rvjtag_tap.v \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/exu/el2_exu_alu_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/exu/el2_exu_div_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/exu/el2_exu_mul_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/exu/el2_exu.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_aln_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_bp_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_compress_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_iccm_mem.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_ic_mem.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_ifc_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu_mem_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/ifu/el2_ifu.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib/ahb_to_axi4.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib/axi4_to_ahb.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib/el2_lib.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib/beh_lib.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lib/mem_lib.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_addrcheck.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_bus_buffer.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_bus_intf.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_clkdomain.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_dccm_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_dccm_mem.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_ecc.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_lsc_ctl.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_stbuf.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu.sv \
${CALIPTRA_ROOT}/src/riscv_core/veer_el2/rtl/lsu/el2_lsu_trigger.sv \
${CALIPTRA_ROOT}/src/ahb_lite_bus/rtl/ahb_lite_bus_inf.sv \
${CALIPTRA_ROOT}/src/ahb_lite_bus/rtl/ahb_lite_address_decoder.sv \
${CALIPTRA_ROOT}/src/ahb_lite_bus/rtl/ahb_lite_bus.sv \
${CALIPTRA_ROOT}/src/ahb_lite_bus/rtl/ahb_lite_2to1_mux.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_reg_pkg.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_reg.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_fsm.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_read_client.sv \
${CALIPTRA_ROOT}/src/keyvault/rtl/kv_write_client.sv \
${CALIPTRA_ROOT}/src/pcrvault/rtl/pv_reg_pkg.sv \
${CALIPTRA_ROOT}/src/pcrvault/rtl/pv_reg.sv \
${CALIPTRA_ROOT}/src/pcrvault/rtl/pv.sv \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_reg_pkg.sv \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_params_pkg.sv \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_ctrl.sv \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512.sv \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_core.v \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_h_constants.v \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_k_constants.v \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_w_mem.v \
${CALIPTRA_ROOT}/src/sha512/rtl/sha512_reg.sv \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_reg_pkg.sv \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_params_pkg.sv \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_ctrl.sv \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256.sv \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_core.v \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_k_constants.v \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_w_mem.v \
${CALIPTRA_ROOT}/src/sha256/rtl/sha256_reg.sv \
${CALIPTRA_ROOT}/src/sha512_masked/rtl/sha512_masked_defines_pkg.sv \
${CALIPTRA_ROOT}/src/sha512_masked/rtl/sha512_masked_core.sv \
${CALIPTRA_ROOT}/src/hmac/rtl/hmac_param_pkg.sv \
${CALIPTRA_ROOT}/src/hmac/rtl/hmac_reg_pkg.sv \
${CALIPTRA_ROOT}/src/hmac/rtl/hmac_ctrl.sv \
${CALIPTRA_ROOT}/src/hmac/rtl/hmac.sv \
${CALIPTRA_ROOT}/src/hmac/rtl/hmac_core.v \
${CALIPTRA_ROOT}/src/hmac/rtl/hmac_reg.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/soc_ifc_top.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/soc_ifc_boot_fsm.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/soc_ifc_arb.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/soc_ifc_reg.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/mbox.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/mbox_csr.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/sha512_acc_top.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/sha512_acc_csr.sv \
${CALIPTRA_ROOT}/src/soc_ifc/rtl/wdt.sv \
${CALIPTRA_ROOT}/src/kmac/rtl/sha3_pkg.sv \
${CALIPTRA_ROOT}/src/kmac/rtl/keccak_round.sv \
${CALIPTRA_ROOT}/src/kmac/rtl/keccak_2share.sv \
${CALIPTRA_ROOT}/src/kmac/rtl/sha3pad.sv \
${CALIPTRA_ROOT}/src/kmac/rtl/sha3.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_reg_top.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_bucket_ht.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_cntr_reg.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_enable_delay.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_markov_ht.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_watermark_reg.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_main_sm.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_repcnts_ht.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_adaptp_ht.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_core.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_repcnt_ht.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src_ack_sm.sv \
${CALIPTRA_ROOT}/src/entropy_src/rtl/entropy_src.sv \
${CALIPTRA_ROOT}/src/edn/rtl/edn_pkg.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_reg_pkg.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_pkg.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox_canright_pkg.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox_canright.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox_canright_masked.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_cipher_core.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_cipher_control_fsm_n.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_cipher_control_fsm_p.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox_lut.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_mix_columns.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox_dom.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sub_bytes.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sbox_canright_masked_noreuse.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_sel_buf_chk.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_cipher_control_fsm.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_shift_rows.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_mix_single_column.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_cipher_control.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_prng_masking.sv \
${CALIPTRA_ROOT}/src/aes/rtl/aes_key_expand.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_core.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_main_sm.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_ctr_drbg_upd.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_ctr_drbg_cmd.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_reg_top.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_ctr_drbg_gen.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_block_encrypt.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_state_db.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng_cmd_stage.sv \
${CALIPTRA_ROOT}/src/csrng/rtl/csrng.sv \
${CALIPTRA_ROOT}/src/uart/rtl/uart_tx.sv \
${CALIPTRA_ROOT}/src/uart/rtl/uart_reg_top.sv \
${CALIPTRA_ROOT}/src/uart/rtl/uart_rx.sv \
${CALIPTRA_ROOT}/src/uart/rtl/uart.sv \
${CALIPTRA_ROOT}/src/uart/rtl/uart_core.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_assert.sv \
${CALIPTRA_ROOT}/src/caliptra_prim/rtl/caliptra_prim_assert_dummy_macros.svh \
${I3C_ROOT}/src/libs/axi/axi_pkg.sv \
${I3C_ROOT}/src/libs/axi/axi_if.sv \
${I3C_ROOT}/src/libs/axi/axi_sub_arb.sv \
${I3C_ROOT}/src/libs/axi/axi_sub_rd.sv \
${I3C_ROOT}/src/libs/axi/axi_sub.sv \
${I3C_ROOT}/src/libs/axi/axi_addr.v \
${I3C_ROOT}/src/libs/axi/skidbuffer.v \
${I3C_ROOT}/src/libs/axi/axi_sub_wr.sv \
${I3C_ROOT}/src/libs/mem/prim_ram_1p_pkg.sv \
${I3C_ROOT}/src/libs/mem/prim_generic_ram_1p.sv \
${I3C_ROOT}/src/libs/mem/prim_ram_1p_adv.sv \
${I3C_ROOT}/src/libs/mem/prim_ram_1p.sv \
${I3C_ROOT}/src/csr/I3CCSR_pkg.sv \
${I3C_ROOT}/src/ctrl/controller_pkg.sv \
${I3C_ROOT}/src/i3c_pkg.sv \
${I3C_ROOT}/src/phy/buf_od.sv \
${I3C_ROOT}/src/phy/buf_pp.sv \
${I3C_ROOT}/src/phy/bufs.sv \
${I3C_ROOT}/src/phy/i3c_phy.sv \
${I3C_ROOT}/src/phy/i3c_io.sv \
${I3C_ROOT}/src/csr/I3CCSR.sv \
${I3C_ROOT}/src/hci/queues/read_queue.sv \
${I3C_ROOT}/src/hci/queues/write_queue.sv \
${I3C_ROOT}/src/hci/ahb_if.sv \
${I3C_ROOT}/src/hci/axi_adapter.sv \
${I3C_ROOT}/src/hci/configuration.sv \
${I3C_ROOT}/src/hci/dxt.sv \
${I3C_ROOT}/src/hci/tti.sv \
${I3C_ROOT}/src/hci/queues.sv \
${I3C_ROOT}/src/hci/hci.sv \
${I3C_ROOT}/src/ctrl/bus_timers.sv \
${I3C_ROOT}/src/ctrl/bus_monitor.sv \
${I3C_ROOT}/src/ctrl/ccc.sv \
${I3C_ROOT}/src/ctrl/daa.sv \
${I3C_ROOT}/src/ctrl/i2c_controller_fsm.sv \
${I3C_ROOT}/src/ctrl/i2c_target_fsm.sv \
${I3C_ROOT}/src/ctrl/i3c_controller_fsm.sv \
${I3C_ROOT}/src/ctrl/i3c_target_fsm.sv \
${I3C_ROOT}/src/ctrl/flow_active.sv \
${I3C_ROOT}/src/ctrl/flow_standby_i2c.sv \
${I3C_ROOT}/src/ctrl/flow_standby_i3c.sv \
${I3C_ROOT}/src/ctrl/controller_standby_i2c.sv \
${I3C_ROOT}/src/ctrl/controller_standby_i3c.sv \
${I3C_ROOT}/src/ctrl/controller_active.sv \
${I3C_ROOT}/src/ctrl/controller_standby.sv \
${I3C_ROOT}/src/ctrl/controller.sv \
${I3C_ROOT}/src/recovery/recovery_handler.sv \
${I3C_ROOT}/src/i3c.sv \
${I3C_ROOT}/src/i3c_wrapper.sv \
${CALIPTRA_SS}/src/mcu/rtl/caliptra_mcu_top.sv

# Do not import cocotb configuration if it's a RTL testbench
ifeq (,$(filter icarus-test verilator-test,$(MAKECMDGOALS)))
    include $(shell cocotb-config --makefiles)/Makefile.sim
endif
