# RISC-V RV32I Single-Cycle Processor  
### Verilog-2001 Implementation and Architectural Documentation

## 1. Introduction

This repository contains a complete implementation of a **single-cycle RISC-V RV32I processor**, written entirely in **pure Verilog-2001**.  
The design is based on the single-cycle architecture described in _Computer Organization and Design — RISC-V Edition_ by Patterson & Hennessy.

The objective of this project is to provide:

- An academically accurate and modular RISC-V processor  
- A clean reference implementation for computer architecture education  
- RTL suitable for waveform debugging and datapath analysis  
- A well-documented pipeline of instruction execution in a single cycle  
- A repository suitable for coursework, learning, and experimentation  

All RTL is synthesizable, and every module includes a corresponding testbench.

---

## 2. Supported Instruction Set (RV32I Subset)

### R-Type  
ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA  

### I-Type  
ADDI, ANDI, ORI, LW, JALR  

### S-Type  
SW  


Every instruction executes in **one clock cycle**, with PC update logic supporting branches, jumps, and sequential execution.

---

## 3. Documentation and Diagrams

Two documentation files describe the processor architecture in detail.

### 3.1 High-Level Block Diagram  
A structural overview of CPU_TOP showing major RTL modules and how they interact.

View the full diagram:  
**[`docs/High-Level Block Diagram.md`](docs/High-Level%20Block%20Diagram.md)**

---

### 3.2 Single-Cycle Datapath Diagram  
A classical Patterson-style ASCII datapath, including:  
- Instruction fetch  
- Register file access  
- Immediate extension  
- ALU operand selection  
- Branch/jump target logic  
- Memory and write-back paths  

View the full diagram:  
**[`docs/Single-Cycle Datapath.md`](docs/Single-Cycle%20Datapath.md)**

---

### 3.3 Diagram Preview (excerpt)

```text
           +----------+        +------------------------+
clk -----> |   PC     | -----> |   InstructionMemory    |
rst -----> |          |        +------------------------+
           +----------+                    |
                                           v
                                   +----------------+
                                   | Control Unit   |
                                   +----------------+
```

(Complete diagrams are available in the `docs/` directory.)

---

## 4. Repository Structure

```
RISCV_SingleCycle_CPU/
│
├── rtl/                      # Synthesizable Verilog RTL
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
├── tb/                       # Module-level testbenches
│   ├── ALU_tb.v
│   ├── ALUControl_tb.v
│   ├── ControlUnit_tb.v
│   ├── RegisterFile_tb.v
│   ├── ImmGen_tb.v
│   ├── InstructionMemory_tb.v
│   ├── DataMemory_tb.v
│   ├── CPU_TOP_tb.v
│
├── mem/                      # Program files for IMEM
│   ├── risc.dat
│   └── example_programs/
│       ├── add_loop.dat
│       ├── factorial.dat
│       └── memory_test.dat
│
├── docs/                     # Architectural documentation
│   ├── High-Level Block Diagram.md
│   ├── Single-Cycle Datapath.md
│   ├── module_interactions.md
│   └── testing_strategy.md
│
└── README.md                 # Project overview
```

---

## 5. Implementation Overview

### 5.1 Verilog Design Principles

This project strictly uses **Verilog-2001**, avoiding SystemVerilog features.  
Design guidelines:

- Sequential logic uses `always @(posedge clk)`  
- Combinational logic uses `always @(*)`  
- No SystemVerilog (`logic`, `always_ff`, enums, interfaces, etc.)  
- Memories implemented using register arrays  
- `$readmemh` is used for loading instructions  

### 5.2 Datapath Summary

The processor contains:

- Program Counter with sequential + branch/jump targets  
- Instruction Memory  
- Control Unit decoding the opcode/funct fields  
- Register File (dual-read, single-write)  
- Immediate Generator (I/S/B/U/J formats)  
- ALU with arithmetic, logic, and shift support  
- Data Memory for LW/SW instructions  
- Multiplexers for ALUSrc, MemToReg, and PC selection  
- Branch decision logic using ALU comparison  

A full explanation is provided in the documentation files.

---

## 6. Simulation Workflow (QuestaSim )

### 6.1 Compile RTL and Testbench

```
vlib work
vlog rtl/*.v tb/CPU_TOP_tb.v
```

### 6.2 Run Simulation

```
vsim CPU_TOP_tb
run -all
```

### 6.3 Waveform Inspection (optional)

```
add wave sim:/CPU_TOP_tb/DUT/*
add wave sim:/CPU_TOP_tb/DUT/ALU/*
add wave sim:/CPU_TOP_tb/DUT/RegisterFile/*
```

---

## 7. Program Loading (risc.dat)

Instruction memory loads a hex program file:

```verilog
$readmemh("risc.dat", mem);
```

To run a custom program:

1. Generate RV32I machine code (e.g., using RARS, Ripes, or Venus).  
2. Save the hex machine code to `mem/risc.dat`.  
3. Re-run the CPU simulation.

Sample programs are included in `mem/example_programs/`.

---

## 8. Testing and Verification

Each major RTL module has an associated testbench:

- ALU operation tests  
- Register file write/read validation  
- Immediate generation format checks  
- Control signal decoding  
- Memory load/store access  
- Full-integration test using `CPU_TOP_tb.v`  

Testing methodology is described in:  
`docs/testing_strategy.md`

---

## 9. Author

**Mohamed Hassan**  
Digital Design & Computer Architecture

---

## 10. License

MIT License
