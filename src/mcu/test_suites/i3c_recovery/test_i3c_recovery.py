# SPDX-License-Identifier: Apache-2.0

import logging
from cocotbext_i3c.i3c_controller import I3cController
from cocotbext_i3c.i3c_recovery_interface import I3cRecoveryInterface

import cocotb
from cocotb.handle import SimHandleBase
from cocotb.triggers import Timer


class I3CTopTestInterface:
    def __init__(self, dut: SimHandleBase) -> None:
        self.dut = dut
        self.sel_od = dut.sel_od_pp_o

        self.log = logging.getLogger("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        self.i3c_controller = I3cController(
            sda_i=dut.sda_i,
            sda_o=dut.sda_o,
            scl_i=dut.scl_i,
            scl_o=dut.scl_o,
            debug_state_o=None,
            speed=12.5e6,
        )


@cocotb.test()
async def test_i3c_target(dut):

    cocotb.log.setLevel(logging.DEBUG)

    tb = I3CTopTestInterface(dut)
    rec_if = I3cRecoveryInterface(tb.i3c_controller)

    address = 0x23
    command = I3cRecoveryInterface.Command.PROT_CAP
    data = [0x24, 0x25, 0x26]

    await rec_if.command_write(address, command, data)
    await rec_if.command_read(address, command)

    await Timer(10, "ns")
