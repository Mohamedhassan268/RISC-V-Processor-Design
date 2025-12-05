# High-Level Block Diagram (CPU_TOP)

Top-level single-cycle RV32I CPU (CPU_TOP):

             +---------------------------------------------+
             |                 CPU_TOP                     |
             |                                             |
             |   +-------------+      +----------------+   |
   clk ----->|-->| Program     | PC   | Instruction    |   |
   rst ----->|   | Counter     |----->| Memory         |   |
             |   +-------------+      +----------------+   |
             |             |                 | instr[31:0] |
             |             |                 v             |
             |             |        +----------------+     |
             |             |        | ControlUnit    |     |
             |             |        +----------------+     |
             |             | ctrl signals  |              |
             |             |               |              |
             |   +----------------+   +----------------+   |
             |   | RegisterFile    |   | ImmGen        |   |
             |   | rs1, rs2, rd    |   | (Immediate    |   |
             |   +----------------+   |  Generator)   |   |
             |       |    |           +----------------+   |
             |   rs1 |    | rs2                | imm[31:0] |
             |       v    v                    v           |
             |   +----------------+   +----------------+   |
             |   |   Mux2_32      |-->|      ALU       |   |
             |   | (ALUSrc)       |   |                |   |
             |   +----------------+   +----------------+   |
             |              | ALUResult[31:0]  | Zero     |
             |              v                  |          |
             |        +----------------+       |          |
             |        |   DataMemory   |<------+          |
             |        +----------------+                  |
             |              | readData[31:0]              |
             |              v                             |
             |        +----------------+                  |
             |        |   Mux2_32      | (MemtoReg)       |
             |        +----------------+                  |
             |              | writeData[31:0]             |
             |              v                             |
             |        +----------------+                  |
             |        | RegisterFile   | (write-back)     |
             |        +----------------+                  |
             |                                             |
             +---------------------------------------------+

Additional control and datapath elements (inside CPU_TOP, not drawn as boxes above):

- ALUControl: generates ALU control signals from funct3/funct7 + ALUOp
- PC + 4 adder: computes next sequential PC
- Branch target adder: PC + imm (for branches and jumps)
- Mux2_32 for PC selection (branch/jump vs PC+4), controlled by branch/jump logic
