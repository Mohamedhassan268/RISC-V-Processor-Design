# RISC-V RV32I Single-Cycle Processor  
### Verilog-2001 Implementation and Architectural Documentation

## 1. Overview

This repository contains a full implementation of a **single-cycle RISC-V RV32I processor** designed in **pure Verilog-2001**.  
The design follows the architecture presented in _Computer Organization and Design RISC-V Edition_ by Patterson and Hennessy.

The objective of this project is to provide a clean, modular, and synthesizable implementation suitable for:
- Digital design coursework  
- Computer architecture education  
- RTL simulation and experimentation  
- Reference datapath study  

All components of the processor—including the ALU, register file, immediate generator, control logic, and memory modules—are implemented from first principles without the use of SystemVerilog constructs.

---

## 2. Architecture Summary

The processor implements the **RV32I base integer instruction set**, supporting:

**R-type:** ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA  
**I-type:** ADDI, ANDI, ORI, LW, JALR  
**S-type:** SW  
**B-type:** BEQ, BNE, BLT, BGE  
**U-type:** LUI  
**J-type:** JAL  

All instructions execute in a **single clock cycle**, resulting in a straightforward datapath that integrates:

- Arithmetic Logic Unit (ALU)  
- Register File (32 registers × 32 bits)  
- Immediate Value Generator  
- Instruction Memory  
- Data Memory  
- Control Unit and ALU Control  
- Program Counter with sequential update and branch/jump support  
- Multiplexer network implementing the datapath selection logic  

The processor supports:
- ALU operations  
- Register read/write  
- Immediate decoding  
- Memory operations (load/store)  
- Branch comparison  
- Jumps and PC redirection  

---

## 3. Repository Structure

```
RISCV_SingleCycle_CPU/
│
├── rtl/                     
│   ├── ALU.v
│   ├── ALUControl.v
│   ├── ControlUnit.v
│   ├── RegisterFile.v
│   ├── ImmGen.v
│   ├── InstructionMemory.v
│   ├── DataMemory.v
│   ├── ProgramCounter.v
│   ├── Mux2_32.v
│   ├── CPU_TOP.v
│   └── risc.dat
│
├── tb/
│   ├── ALU_tb.v
│   ├── ALUControl_tb.v
│   ├── ControlUnit_tb.v
│   ├── RegisterFile_tb.v
│   ├── ImmGen_tb.v
│   ├── InstructionMemory_tb.v
│   ├── DataMemory_tb.v
│   ├── CPU_TOP_tb.v
│
├── mem/
│   ├── risc.dat
│   └── example_programs/
│       ├── add_loop.dat
│       ├── factorial.dat
│       └── memory_test.dat
│
├── docs/
│   ├── schematic_ascii.md
│   ├── datapath_description.md
│   ├── module_interactions.md
│   └── testing_strategy.md
│
└── README.md
```

---

## 4. Implementation Details

### 4.1 Verilog Design Style
The implementation adheres strictly to **Verilog-2001**:

- All storage elements use `always @(posedge clk)`  
- Combinational logic is described using `always @(*)`  
- No SystemVerilog constructs (e.g., `logic`, `always_ff`, `enum`)  
- Arrays used only where synthesizable (e.g., register file)  
- Instruction memory uses `$readmemh` for loading programs  

### 4.2 Instruction Memory
Program instructions are stored in `risc.dat` in hexadecimal format.  
The processor reads this file during simulation using:

```verilog
$readmemh("risc.dat", mem);
```

### 4.3 Datapath Behavior
The CPU executes each instruction in one clock cycle.  
Operations include:

- Register file read → ALU / immediate selection  
- ALU result → memory or write-back  
- Branch logic determines next PC  
- PC increments or redirects based on control logic  

A complete datapath description and ASCII schematic are provided in the `docs/` directory.

---

## 5. Simulation Procedure (QuestaSim / ModelSim)

### 5.1 Compile RTL and Testbench
```
vlib work
vlog rtl/*.v tb/CPU_TOP_tb.v
```

### 5.2 Execute Simulation
```
vsim CPU_TOP_tb
run -all
```

### 5.3 Inspect Internal Signals (optional)
```
add wave sim:/CPU_TOP_tb/DUT/*
add wave sim:/CPU_TOP_tb/DUT/ALU/*
add wave sim:/CPU_TOP_tb/DUT/RegisterFile/*
```

---

## 6. Program Testing

To run a different program:

1. Replace the file `mem/risc.dat` with another machine-code file.  
2. Ensure that the program is in **hexadecimal instruction format**, one instruction per line.  
3. Re-run the simulation.

Sample programs are provided in:
```
mem/example_programs/
```

---

## 7. Tools Used

- Mentor Graphics QuestaSim / ModelSim  
- Verilog-2001 RTL  
- RARS, Ripes, or Venus for assembling RV32I machine code  

---

## 8. Author

Mohamed Hassan 
Digital Design and Computer Architecture  
