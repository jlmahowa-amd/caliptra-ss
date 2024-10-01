# Licensed under the Apache-2.0 license

python3 -m peakrdl regblock caliptra_fpga_realtime_regs.rdl -o ./ --cpuif axi4-lite
python3 -m peakrdl regblock mcu_fpga_realtime_regs.rdl -o ./ --cpuif axi4-lite
