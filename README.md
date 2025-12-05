# RISC-V RV32I Single-Cycle Processor
Pure Verilog-2001 Implementation (QuestaSim / ModelSim Compatible)

This repository contains a modular single-cycle RISC-V RV32I processor written entirely in Verilog-2001. The design is based on the architecture described in Patterson & Hennessy and includes:

- ALU  
- ALU Control  
- Control Unit  
- Register File  
- Immediate Generator  
- Instruction Memory  
- Data Memory  
- Program Counter  
- Multiplexers  
- Fully integrated CPU datapath

The project includes synthesizable RTL, module-level testbenches, a full CPU testbench, and sample machine-code programs loaded using `$readmemh`.

---

## Directory Structure

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
├── tb/                       # Testbenches
│   ├── ALU_tb.v
│   ├── ALUControl_tb.v
│   ├── ControlUnit_tb.v
│   ├── RegisterFile_tb.v
│   ├── ImmGen_tb.v
│   ├── InstructionMemory_tb.v
│   ├── DataMemory_tb.v
│   ├── CPU_TOP_tb.v
│
├── mem/                      # Program memory files
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

## RV32I Instruction Set Support

The processor implements the following RV32I instructions:

- R-type: ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA  
- I-type: ADDI, ANDI, ORI, LW, JALR  
- S-type: SW  
- B-type: BEQ, BNE, BLT, BGE  
- U-type: LUI  
- J-type: JAL  

All instructions execute in a single clock cycle.

---

## Simulation Instructions (QuestaSim / ModelSim)

### Compile RTL and Testbench
```
vlib work
vlog rtl/*.v tb/CPU_TOP_tb.v
```

### Run Simulation
```
vsim CPU_TOP_tb
run -all
```

### Add Waveforms (optional)
```
add wave sim:/CPU_TOP_tb/DUT/*
add wave sim:/CPU_TOP_tb/DUT/ALU/*
add wave sim:/CPU_TOP_tb/DUT/RegisterFile/*
```

---

## Program Loading (`risc.dat`)

The instruction memory loads a HEX machine-code file:

```verilog
$readmemh("risc.dat", mem);
```

To load a different program:

1. Replace `mem/risc.dat` with another `.dat` file  
2. Re-run the simulation  

Example programs are provided under `mem/example_programs/`.

---

## Tools Used
- Verilog-2001  
- Mentor QuestaSim / ModelSim  
- RARS, Venus, or Ripes for generating machine code  

---

## Author
Mohamed Hassan

