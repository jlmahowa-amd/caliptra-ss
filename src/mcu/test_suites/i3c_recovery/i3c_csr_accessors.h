// SPDX-License-Identifier: Apache-2.0

#ifndef I3C_CSR_ACCESSORS_H
#define I3C_CSR_ACCESSORS_H

#include "caliptra_reg.h"
#include "riscv_hw_if.h"

#define DCT_MEM_WIDTH 128
#define DCT_MEM_WIDTH_BYTE (DCT_MEM_WIDTH / 8)
#define DAT_MEM_WIDTH 64
#define DAT_MEM_WIDTH_BYTE (DAT_MEM_WIDTH / 8)
#define REG_WIDTH 32
#define ADDR_INCR 4
#define DAT_REG_WSIZE (2)
#define DCT_REG_WSIZE (4)


/*  Writes value to memory at given address

    Arguments:
    * address - base address of the device that will be accessed on the bus
    * offset - offset of the register relative to base address
    * data - 32-bit value to write at calculated address
*/
void write_reg(uint32_t address, uint32_t offset, uint32_t data) {
    lsu_write_32((address + offset), data);
}

/*  Reads value from memory at given address

    Arguments:
    * address - base address of the device that will be accessed on the bus
    * offset - offset of the register relative to base address

    Returns 32-bit value read at given address
*/
uint32_t read_reg(uint32_t address, uint32_t offset) {
    return lsu_read_32((address + offset));
}

/*  Writes a value to the register

    Arguments:
    * address - absolute address of the register file
    * offset - relative address of the register in register file
    * low_bit - index of the lowest bit of the modified field
    * mask - mask of the register field in the register (should be contiguous)
    * data - value that will be written to the register field
*/
void write_reg_field(uint32_t address, uint32_t offset, uint8_t low_bit, uint32_t mask, uint32_t data) {
    uint32_t value = read_reg(address, offset);

    // Clear field by setting masked bits to 0
    value &= ~mask;
    // Set new field value
    value |= (data << low_bit) & mask;

    // Write updated register value
    write_reg(address, offset, value);
}

/*  Reads a value from the register

    Arguments:
    * address - absolute address of the register file
    * offset - relative address of the register in register file
    * low_bit - index of the lowest bit of the accessed field
    * mask - mask of the register field in the register (should be contiguous)

    Returns a 32-bit value read from the register
*/
uint32_t read_reg_field(uint32_t address, uint32_t offset, uint8_t low_bit, uint32_t mask) {
    uint32_t value = read_reg(address, offset);

    // Clear field by setting masked bits to 0
    value &= mask;
    // Set new field value
    value >>= low_bit;

    // Write updated register value
    return value;
}


/*  Writes a value to the I3C register

    Arguments:
    * offset - relative address of the register in the I3C address space
    * data - 32-bit word to write into the register
*/
void write_i3c_reg(uint32_t offset, uint32_t data) {
    write_reg(CLP_I3C_REG_I3CBASE_START, offset, data);
};

/*  Reads a value from the I3C register

    Arguments:
    * offset - relative address of the register in the I3C address space

    Returns a 32-bit value read from the register
*/
uint32_t read_i3c_reg(uint32_t offset) {
    return read_reg(CLP_I3C_REG_I3CBASE_START, offset);
}

/*  Writes a value to the I3C register field

    Arguments:
    * offset - relative address of the register in the I3C address space
    * low_bit - index of the lowest bit of the accessed field
    * mask - mask of the register field in the register (should be contiguous)
    * data - 32-bit word to write into the register
*/
void write_i3c_reg_field(uint32_t offset, uint8_t low_bit, uint32_t mask, uint32_t data) {
    write_reg_field(CLP_I3C_REG_I3CBASE_START, offset, low_bit, mask, data);
}

/*  Reads a value from the I3C register field

    Arguments:
    * offset - relative address of the register in the I3C address space
    * low_bit - index of the lowest bit of the accessed field
    * mask - mask of the register field in the register (should be contiguous)

    Returns a 32-bit value read from the register
*/
uint32_t read_i3c_reg_field(uint32_t offset, uint8_t low_bit, uint32_t mask) {
    return read_reg_field(CLP_I3C_REG_BASE_ADDR, offset, low_bit, mask);
}
#endif
