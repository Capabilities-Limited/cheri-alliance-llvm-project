// RUN: llvm-mc --triple=riscv32 -mattr=+y --riscv-no-aliases --show-encoding --defsym=XLEN=32 < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+y --defsym=XLEN=32 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s
// RUN: llvm-mc --triple=riscv64 --mattr=+y --riscv-no-aliases --show-encoding --defsym=XLEN=64 < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+y --defsym=XLEN=64 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s

yadd a0, a0, a1
// CHECK: yadd	a0, a0, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xb5,0x06]
yaddi a0, a0, 12
// CHECK: yaddi	a0, a0, 12
// CHECK-ASM-SAME: # encoding: [0x7b,0x45,0xc5,0x00]
yadd a0, a0, 12
// CHECK: yaddi	a0, a0, 12
// CHECK-ASM-SAME: # encoding: [0x7b,0x45,0xc5,0x00]
yaddrw a0, a0, a1
// CHECK: yaddrw	a0, a0, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xb5,0x16]
ypermc a0, a0, a0
// CHECK: ypermc	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x26]
ymv a0, a0
// CHECK: ymv	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x05,0x06]
//# Note: mv expands to integer addi and not capability ymv:
mv a0, a0
// CHECK: addi	a0, a0, 0
// CHECK-ASM-SAME: # encoding: [0x13,0x05,0x05,0x00]
yhiw a0, a0, a0
// CHECK: yhiw	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x02]
ybndsw a0, a0, a0
// CHECK: ybndsw	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x36]
ybndsrw a0, a0, a0
// CHECK: ybndsrw	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x46]
ybndswi a0, a0, 12
// CHECK: ybndswi	a0, a0, 12
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0xc5,0xe0]
ybndswi a0, a0, 12
// CHECK: ybndswi	a0, a0, 12
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0xc5,0xe0]
//# Test all the  min and max values for the ybndswi encoding
ybndswi a0, a0, 1
// CHECK: ybndswi	a0, a0, 1
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0x15,0xe0]
ybndswi a0, a0, 255
// CHECK: ybndswi	a0, a0, 255
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0xf5,0xef]
ybndswi a0, a0, 264
// CHECK: ybndswi	a0, a0, 264
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0x05,0xf1]
ybndswi a0, a0, 504
// CHECK: ybndswi	a0, a0, 504
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0xf5,0xf1]
ybndswi a0, a0, 512
// CHECK-ASM: ybndswi	a0, a0, 512
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0x05,0xf2]
ybndswi a0, a0, 528
// CHECK-ASM: ybndswi	a0, a0, 528
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0x15,0xf2]
ybndswi a0, a0, 2048
// CHECK-ASM: ybndswi	a0, a0, 2048
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0x05,0xf8]
ybndswi a0, a0, 4080
// CHECK-ASM: ybndswi	a0, a0, 4080
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0xf5,0xff]
ybndswi a0, a0, 4096
// CHECK: ybndswi	a0, a0, 4096
// CHECK-ASM-SAME: # encoding: [0x7b,0x55,0x05,0xe0]
yunseals a0, a0, a0
// CHECK: yunseals	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x0e]
ybld a0, a0, a0
// CHECK: ybld	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x1e]
ybaser a0, a0
// CHECK: ybaser	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x05,0xf4]
ylenr a0, a0
// CHECK: ylenr	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x35,0xf4]
ytopr a0, a0
// CHECK: ytopr	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x25,0xf4]
ytagr a0, a0
// CHECK: ytagr	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x45,0xf4]
ypermr a0, a0
// CHECK: ypermr	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x15,0xf4]
ytyper a0, a0
// CHECK: ytyper	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x55,0xf4]
yhir a0, a0
// CHECK: yhir	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x75,0xf4]
yeq a0, a0, a0
// CHECK: yeq	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x0c]
yss a0, a0, a0
// CHECK: yss	a0, a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xa5,0x1c]
yamask a0, a0
// CHECK: yamask	a0, a0
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0x05,0xf0]
