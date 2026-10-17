//===- RISCVSystemOperandsZCheriPurecap.td -----------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the symbolic operands permitted for various kinds of
// CHERI RISC-V system instruction.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// CHERI CSR (control and status register read/write) instruction options.
//===----------------------------------------------------------------------===//


class CheriSysReg<string name, bits<12> op> {
  string Name = name;
  bits<12> Encoding = op;
  bit isExt = 0;
  bit isY = 1;
  bit isZcheri = 1;
  bit isZcheriAlias = 0;
}

class RVYSysReg<string name, bits<12> op>
    : CheriSysReg<name, op> {
  let isZcheri = 0;
}

class ZCheriSysReg<string name, bits<12> op>
    : CheriSysReg<name, op> {
  let isY = 0;
}

multiclass CheriExtSysReg<string name, bits<12> op> {
  let isExt = 1 in {
    let isZcheriAlias = 1 in
    def "" : RVYSysReg<name, op>;
    def C  : ZCheriSysReg<!strconcat(name, "c"), op>;
  }
}

multiclass CheriSysRegsList<string kind> {
  def NAME # SysRegsList : GenericTable {
    let FilterClass = "CheriSysReg";
    let FilterClassField = "is" # kind;
    let Fields = [
      "Name", "Encoding", "isExt"
    ];

    let PrimaryKey = [ "Encoding" ];
    let PrimaryKeyName = "lookup" # NAME # "SysRegByEncoding";
  }

  def lookup # NAME # SysRegByName : SearchIndex {
    let Table = !cast<GenericTable>(NAME # "SysRegsList");
    let Key = [ "Name" ];
  }
}

// NB: Separate filtered tables since we have duplicate names too, not just
// encodings, and need to be able to find the right one based on Zcheri vs Y,
// but SearchIndex lookups can only ever give a single result, and we can't
// take advantage of PrimaryKeyReturnRange since case-insensitive string
// lookups can't be done for the primary key. Splitting into three lists does
// make the implementation rather easier to understand though.

defm RVY : CheriSysRegsList<"Y">;
defm ZCheri : CheriSysRegsList<"Zcheri">;
defm ZCheriAlias : CheriSysRegsList<"ZcheriAlias">;

//===----------------------------------------------------------------------===//
// Debug-mode Cheri CSRs
//===----------------------------------------------------------------------===//
defm : CheriExtSysReg<"dpc", 0x7b1>;
defm : CheriExtSysReg<"dscratch0", 0x7b2>;
defm : CheriExtSysReg<"dscratch1", 0x7b3>;
def : ZCheriSysReg<"dinfc", 0x7bd>;
def : SysReg<"drootcsel", 0x7bd>;
def : RVYSysReg<"drootc", 0x7be>;

//===----------------------------------------------------------------------===//
// Machine-mode Cheri CSRs
//===----------------------------------------------------------------------===//
defm : CheriExtSysReg<"mtvec", 0x305>;
defm : CheriExtSysReg<"mscratch", 0x340>;
defm : CheriExtSysReg<"mepc", 0x341>;
def : ZCheriSysReg<"mtidc", 0x780>;
def : RVYSysReg<"mtidc", 0x37f>;

//===----------------------------------------------------------------------===//
// Supervisor-mode Cheri CSRs
//===----------------------------------------------------------------------===//
defm : CheriExtSysReg<"stvec", 0x105>;
defm : CheriExtSysReg<"sscratch", 0x140>;
defm : CheriExtSysReg<"sepc", 0x141>;
def : SysReg<"stval2", 0x14b>;
def : ZCheriSysReg<"stidc", 0x580>;
def : RVYSysReg<"stidc", 0x17f>;

//===----------------------------------------------------------------------===//
// User-mode Cheri CSRs
//===----------------------------------------------------------------------===//
defm : CheriExtSysReg<"jvt", 0x017>;
def : ZCheriSysReg<"utidc", 0x480>;
def : RVYSysReg<"utidc", 0x07f>;

//===----------------------------------------------------------------------===//
// Zcherihybrid CSRs
//===----------------------------------------------------------------------===//
def : ZCheriSysReg<"dddc", 0x7bc>;
def : RVYSysReg<"dddc", 0x7bf>;
def : ZCheriSysReg<"mtdc", 0x74c>;
def : ZCheriSysReg<"stdc", 0x163>;
def ZCHERI_CSR_DDC : ZCheriSysReg<"ddc", 0x416>;
def RVY_CSR_DDC : RVYSysReg<"ddc", 0x03f>;

//===----------------------------------------------------------------------===//
// Hypervisor Trap Handling
//===----------------------------------------------------------------------===//
def : SysReg<"htval2", 0x64b>;

//===----------------------------------------------------------------------===//
// Virtual Supervisor Registers
//===----------------------------------------------------------------------===//
defm : CheriExtSysReg<"vstvec", 0x205>;
defm : CheriExtSysReg<"vsscratch", 0x240>;
defm : CheriExtSysReg<"vsepc", 0x241>;
def : ZCheriSysReg<"vstdc", 0x245>;
def : SysReg<"vstval2", 0x24b>;
def : ZCheriSysReg<"vstidc", 0xa80>;
def : RVYSysReg<"vstidc", 0x27f>;
