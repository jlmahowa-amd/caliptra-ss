// SPDX-License-Identifier: Apache-2.0

#include "caliptra_defines.h"
#include "printf.h"
#include "riscv_hw_if.h"
#include "i3c_csr_accessors.h"
#include "I3CCSR.h"

#define HCI_VERSION (0x120)
#define I3C_RECOVERY_LOCAL_IMAGE 0x0

// Helpers for Recovery Flow CSRs
#define I3C_DEVICE_ID_LOW 0x0
#define I3C_DEVICE_ID_MASK 0x1
#define I3C_DEVICE_STATUS_LOW 0x4
#define I3C_DEVICE_STATUS_MASK 0x10
#define I3C_LOCAL_C_IMAGE_SUPPORT_LOW 0x6
#define I3C_LOCAL_C_IMAGE_SUPPORT_MASK 0x40
#define I3C_PUSH_C_IMAGE_SUPPORT_LOW 0x7
#define I3C_PUSH_C_IMAGE_SUPPORT_MASK 0x80
#define I3C_INDIRECT_CONTROL_LOW 0x5
#define I3C_INDIRECT_CONTROL_MASK 0x20
#define I3C_RECOVERY_STATUS_LOW 0x0
#define I3C_RECOVERY_STATUS_MASK 0xff


volatile char* stdout = (char*)STDOUT;
volatile uint32_t intr_count = 0;
volatile uint32_t rst_count __attribute__((section(".dccm.persistent"))) = 0;
#ifdef CPT_VERBOSITY
enum printf_verbosity verbosity_g = CPT_VERBOSITY;
#else
enum printf_verbosity verbosity_g = LOW;
#endif

int check_and_report_value(uint32_t value, uint32_t expected) {
  if (value == expected) {
    printf("CORRECT\n");
    return 0;
  }
  else {
    printf("ERROR (0x%x vs 0x%x)\n", value, expected);
    return 1;
  }
}


int report_recovery_status(uint32_t value) {
  printf("Recovery status: ");
  switch (value)
  {
  case 0x0:
    printf("Not in recovery mode.\n");
    return 1;
  case 0x1:
    printf("Awaiting recovery image.\n");
    break;
  case 0x2:
    printf("Booting recovery image.\n");
    break;
  case 0x3:
    printf("Recovery successful.\n");
    break;
  case 0xc:
    printf("Recovery failed.\n");
    break;
  case 0xd:
    printf("Recovery image authentication error.\n");
    break;
  case 0xe:
    printf("Error entering recovery mode.\n");
    break;
  case 0xf:
    printf("Invalid component address space.\n");
    break;
  default:
    printf("Undefined recovery status.\n");
    break;
  }
  return 0;
}

void main() {
  int error, data;

  printf("---------------------------\n");
  printf(" I3C CSR Smoke Test \n");
  printf("---------------------------\n");


  // Run test for I3C Base registers ------------------------------------------
  printf("==Step 0: Verify I3C HCI Version\n");

  // Read RO register
  data = read_i3c_reg(I3C_REG_I3CBASE_HCI_VERSION);
  printf("Check I3C HCI Version: ");
  error += check_and_report_value(data, HCI_VERSION);

  // Secondary Controller Mode (Target)
  // Configure the I3C core
  // Set the following bits in `PROT_CAP`:
  // * bit 0 - `DEVICE_ID`
  write_i3c_reg_field(CLP_I3C_REG_I3C_EC_SECFWRECOVERYIF_PROT_CAP_0, I3C_DEVICE_ID_LOW, I3C_DEVICE_ID_MASK, 0x1);
  // * bit 4 - `DEVICE_STATUS`
  write_i3c_reg_field(CLP_I3C_REG_I3C_EC_SECFWRECOVERYIF_PROT_CAP_0, I3C_DEVICE_STATUS_LOW, I3C_DEVICE_STATUS_MASK, 0x1);
  // * bit 6 `Local C-image support` OR bit 7 `Push C-image support`
#ifdef I3C_RECOVERY_LOCAL_IMAGE
  write_i3c_reg_field(CLP_I3C_REG_I3C_EC_SECFWRECOVERYIF_PROT_CAP_0, I3C_LOCAL_C_IMAGE_SUPPORT_LOW, I3C_LOCAL_C_IMAGE_SUPPORT_MASK, 0x1);
#else
  write_i3c_reg_field(CLP_I3C_REG_I3C_EC_SECFWRECOVERYIF_PROT_CAP_0, I3C_PUSH_C_IMAGE_SUPPORT_LOW, I3C_PUSH_C_IMAGE_SUPPORT_MASK, 0x1);
  // * (if bit 7 is set) bit 5 `INDIRECT_CTRL`
  write_i3c_reg_field(CLP_I3C_REG_I3C_EC_SECFWRECOVERYIF_PROT_CAP_0, I3C_INDIRECT_CONTROL_LOW, I3C_INDIRECT_CONTROL_MASK, 0x1);
#endif
  // Enter recovery mode
  // Write `0x3` to `DEVICE_STATUS`
  write_i3c_reg_field(I3C_REG_I3C_EC_SECFWRECOVERYIF_DEVICE_STATUS_0, I3C_DEVICE_STATUS_LOW, I3C_DEVICE_STATUS_MASK, 0x3);

  // Ensure the recovery handler changed mode and is awaiting recovery image
  // Read `RECOVERY_STATUS` - should be `1`

  data = read_i3c_reg_field(I3C_REG_I3C_EC_SECFWRECOVERYIF_RECOVERY_STATUS, I3C_RECOVERY_STATUS_LOW, I3C_RECOVERY_STATUS_MASK);
  while (!data) {
    data = read_i3c_reg_field(I3C_REG_I3C_EC_SECFWRECOVERYIF_RECOVERY_STATUS, I3C_RECOVERY_STATUS_LOW, I3C_RECOVERY_STATUS_MASK);
  }

  error += report_recovery_status(data);

  printf("\n----------------------------------------\n");
  // End the sim in failure or print hello world upon success
  if (error > 0) printf("%c", 0x1);
  else printf("\nHello World\n");
}
