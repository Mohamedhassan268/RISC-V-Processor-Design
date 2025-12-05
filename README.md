
```markdown
# RISC-V RV32I Single-Cycle Processor  
### Pure Verilog Implementation (QuestaSim / ModelSim Compatible)

This repository contains a clean and modular **single-cycle RISC-V RV32I CPU** implemented entirely in **pure Verilog-2001**.  
The design follows the textbook architecture from *Patterson & Hennessy*, including:

- ALU  
- Control Unit  
- Register File  
- Immediate Generator  
- Instruction & Data Memory  
- Program Counter  
- MUXes  
- Fully integrated single-cycle datapath  

The project includes:
- RTL implementation of all CPU components  
- A modular testbench for each module  
- A full CPU testbench (`CPU_TOP_tb.v`)  
- Example RISC-V machine-code programs loaded using `$readmemh`  
- Documentation and ASCII schematics  

---

## 📁 Directory Structure

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
│   └── risc.dat              # Example program (optional)
│
├── tb/                       # Module-level and CPU-level testbenches
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
│   ├── risc.dat              # Main program loaded by InstructionMemory
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

## 🧠 Architecture Overview

This CPU implements the **RV32I base instruction set**, including:

- R-type (ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA)  
- I-type (ADDI, ANDI, ORI, LW, JALR)  
- S-type (SW)  
- B-type (BEQ, BNE, BLT, BGE)  
- U-type (LUI)  
- J-type (JAL)

The processor executes each instruction in **one cycle**, enabling a simplified datapath ideal for education and hardware learning.

---

## 🧪 Simulation (QuestaSim / ModelSim)

### 1. Compile RTL and Testbench

```

vlib work
vlog rtl/*.v tb/CPU_TOP_tb.v

```

### 2. Run Simulation

```

vsim CPU_TOP_tb
run -all

```

### 3. View Internal Signals

Inside QuestaSim:

```

add wave sim:/CPU_TOP_tb/DUT/*
add wave sim:/CPU_TOP_tb/DUT/ALU/*
add wave sim:/CPU_TOP_tb/DUT/RegisterFile/*

````

---

## 📦 Loading Programs (`risc.dat`)

The instruction memory reads hexadecimal machine code using:

```verilog
$readmemh("risc.dat", mem);
````

Example programs are available under:

```
mem/example_programs/
```

### To test a program:

1. Copy the desired `.dat` into `mem/risc.dat`.
2. Run the simulation again.

---

## 🧰 Tools Used

* **QuestaSim / ModelSim**
* **Verilog-2001**
* Optional: **Ripes**, **RARS**, or **Venus** to generate RV32I machine code

---

## 📄 License

MIT License (or choose one)

---

## ✨ Author

**Mohannad Mohamed**
Digital Design Engineer
RISC-V / FPGA / Verilog Projects

```

---

# ✅ This is the **exact** README to copy.

If you want, I can also generate:

### 📘 `schematic_ascii.md`  
### 📘 `datapath_description.md`  
### 📘 module-by-module documentation  
### 📘 waveform debugging guide  
### 📘 improved testbenches  

Just tell me what you want next.
```
