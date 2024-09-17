# Create path variables
set fpgaDir [file dirname [info script]]
set outputDir $fpgaDir/caliptra_build
set packageDir $outputDir/caliptra_package
set adapterDir $outputDir/soc_adapter_package
# Clean and create output directory.
file delete -force $outputDir
file mkdir $outputDir
file mkdir $packageDir
file mkdir $adapterDir

set caliptrartlDir $fpgaDir/caliptra-rtl
set ssrtlDir $fpgaDir

set VERILOG_OPTIONS {TECH_SPECIFIC_ICG USER_ICG=fpga_fake_icg RV_FPGA_OPTIMIZE TEC_MCU_RV_ICG=clockhdr MCU_RV_BUILD_AXI4}
set_property verilog_define $VERILOG_OPTIONS [current_fileset]

start_gui

create_project soc_package_project $outputDir -part xczu7ev-ffvc1156-2-e

# Add ss RTL
#add_files [ glob $ssrtlDir/ ]
# Add MCU VEER Headers
add_files $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/mcu_el2_param.vh
add_files $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/pic_map_auto.h
add_files $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/mcu_el2_pdef.vh
add_files $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/mcu_common_defines.vh
add_files [ glob $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/*/*.svh ]
# Add MCU VEER sources
add_files [ glob $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/*.sv ]
add_files [ glob $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/*/*.sv ]
add_files [ glob $ssrtlDir/src/riscv_core/veer_el2/rtl/rev1p0/*/*.v ]


# Add VEER Headers
add_files $caliptrartlDir/src/riscv_core/veer_el2/rtl/el2_param.vh
add_files $caliptrartlDir/src/riscv_core/veer_el2/rtl/pic_map_auto.h
add_files $caliptrartlDir/src/riscv_core/veer_el2/rtl/el2_pdef.vh

# Add VEER sources
add_files [ glob $caliptrartlDir/src/riscv_core/veer_el2/rtl/*.sv ]
add_files [ glob $caliptrartlDir/src/riscv_core/veer_el2/rtl/*/*.sv ]
add_files [ glob $caliptrartlDir/src/riscv_core/veer_el2/rtl/*/*.v ]

# Add Caliptra Headers (Weird how much requires the Caliptra RTL directory)
add_files [ glob $caliptrartlDir/src/*/rtl/*.svh ]
# Add Caliptra Sources
add_files [ glob $caliptrartlDir/src/*/rtl/*.sv ]
add_files [ glob $caliptrartlDir/src/*/rtl/*.v ]

# Remove spi_host files that aren't used yet and are flagged as having syntax errors
# TODO: Re-include these files when spi_host is used.
remove_files [ glob $caliptrartlDir/src/spi_host/rtl/*.sv ]

# Remove Caliptra files that need to be replaced by FPGA specific versions
# Replace RAM with FPGA block ram
#remove_files [ glob $caliptrartlDir/src/ecc/rtl/ecc_ram_tdp_file.sv ]
# Key Vault is very large. Replacing KV with a version with the minimum number of entries.
remove_files [ glob $caliptrartlDir/src/keyvault/rtl/kv_reg.sv ]


# MCU
add_files [ glob $ssrtlDir/src/mcu/rtl/*.sv ]
# Add FPGA specific sources
add_files [ glob $fpgaDir/fpgasrc/*.sv]
add_files [ glob $fpgaDir/fpgasrc/*.v]


# Mark all Verilog sources as SystemVerilog because some of them have SystemVerilog syntax.
set_property file_type SystemVerilog [get_files *.v]
