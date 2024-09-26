# TODO: Move me to tools/scripts Makefile

# Cocotb test suite setup
SIM ?= verilator
TOPLEVEL_LANG = verilog


VERILOG_SOURCES = $(file < $(CALIPTRA_SS)/src/mcu/config/caliptra_mcu_top.vf)
VERILOG_SOURCES += $(CALIPTRA_SS)/mcu/rtl/mcu_top.sv

# Do not import cocotb configuration if it's a RTL testbench
ifeq (,$(filter icarus-test verilator-test,$(MAKECMDGOALS)))
    include $(shell cocotb-config --makefiles)/Makefile.sim
endif
