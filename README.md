# 32-bit Single-Cycle RISC-V Processor

![Verilog](https://img.shields.io/badge/Language-Verilog-blue?logo=verilog)
![Architecture](https://img.shields.io/badge/Architecture-RISC--V-red)
![Type](https://img.shields.io/badge/Type-Single--Cycle-green)

A fully synthesizable 32-bit Single-Cycle Processor based on the **RISC-V Harvard Architecture**. This project implements the core integer instruction set, separating instruction and data memory for efficient single-cycle execution.

---

## 🏗️ System Architecture

The design follows a modular approach, integrating the Data Path and Control Logic.

![System Block Diagram](docs/system_diagram.png)
*(Note: Upload the diagram from Page 2 of your PDF here)*

### Core Modules
| Module | Description |
| :--- | :--- |
| **Program Counter (PC)** | Holds the current instruction address. Handles sequential execution (`PC+4`) and Branching (`PC + Offset`). |
| **Instruction Memory** | ROM (Read-Only Memory) storing the program code. Word-aligned. |
| **Register File** | 32 x 32-bit registers with **Dual-Read** and **Single-Write** ports. |
| **ALU** | Performs arithmetic (`ADD`, `SUB`) and logical (`AND`, `OR`, `XOR`, `SHIFT`) operations. Generates the `Zero` flag. |
| **Control Unit** | Decodes instructions into control signals (`RegWrite`, `MemWrite`, `ALUSrc`, etc.). Split into **Main Decoder** and **ALU Decoder**. |
| **Data Memory** | RAM for storing simulation results (Load/Store operations). |

---

## ⚡ Supported Instruction Set (RV32I Subset)

The processor supports the following 32-bit instructions:

| Type | Instructions | Opcode | Function |
| :--- | :--- | :--- | :--- |
| **R-Type** | `add`, `sub`, `and`, `or`, `xor`, `sll`, `srl` | `0110011` | Arithmetic & Logic on Registers |
| **I-Type** | `addi`, `lw` (Load Word) | `0010011` / `0000011` | Immediate Arithmetic & Memory Load |
| **S-Type** | `sw` (Store Word) | `0100011` | Memory Store |
| **B-Type** | `beq` (Branch Equal), `blt` (Branch <) | `1100011` | Conditional Branching |

---

## 🧪 Simulation & Verification

The design was verified using a **Fibonacci Series Generator** written in assembly and loaded via `$readmemh` into the Instruction Memory.

### Test Case: Fibonacci Sequence
The assembly program initializes the registers and computes the Fibonacci sequence iteratively, storing results in memory.

```assembly
# Assembly Logic used for verification
loop:
  beq x3, x4, update_x1   # Branch decision
  add x2, x2, x1          # x2 = x2 + x1
  sw  x2, 0(x7)           # Store result to memory
  ...
