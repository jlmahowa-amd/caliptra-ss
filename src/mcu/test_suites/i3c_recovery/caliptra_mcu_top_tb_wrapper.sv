`ifndef VERILATOR
module caliptra_mcu_top_tb_wrapper (
    // I3C Interface
    inout  logic i3c_scl_io,
    inout  logic i3c_sda_io
    );
`else
module caliptra_mcu_top_tb_wrapper (
    input bit core_clk,
    input bit rst_l,

    // I3C Interface
    input  logic scl_i,
    input  logic sda_i,
    output logic scl_o,
    output logic sda_o,
    output logic sel_od_pp_o
    );
`endif

caliptra_mcu_top_tb tb (
`ifdef VERILATOR
    .core_clk(core_clk),
    .rst_l(rst_l),
    .scl_i(scl_i),
    .sda_i(sda_i),
    .scl_o(scl_o),
    .sda_o(sda_o),
    .sel_od_pp_o(sel_od_pp_o)
`else
    // I3C bus IO
    .i3c_scl_io(i3c_scl_io),
    .i3c_sda_io(i3c_sda_io)
`endif
);

endmodule