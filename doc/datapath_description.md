# Single-Cycle RV32I Datapath (ASCII)

High-level single-cycle datapath (simplified):

   Instruction Fetch + PC Update
   -----------------------------

           +-------------+
   PC ---> | Program     |----+
   (reg)   | Counter     |    |
           +-------------+    |
                   |          |
                   | PC[31:0] |
                   v          |
             +------------------------+
             |   InstructionMemory    |
             |  (address = PC)        |
             +------------------------+
                        |
                        | instr[31:0]
                        v
   Decode + Register Fetch + Immediate Generation
   ---------------------------------------------

        +------------------------+
        |      ControlUnit       |
        |   (opcode, funct3/7)   |
        +------------------------+
             |    |      |    |
             |    |      |    +--> ALUSrc
             |    |      +------> MemtoReg
             |    +-------------> MemRead / MemWrite
             +------------------> RegWrite, Branch, Jump, etc.


   instr[19:15] rs1   instr[24:20] rs2   instr[11:7] rd
          |                   |                  |
          v                   v                  v
        +--------------------------------------------+
        |               RegisterFile                 |
        |                                            |
        |   rs1_addr, rs2_addr, rd_addr             |
        |   rd_data (write-back), RegWrite          |
        +--------------------------------------------+
             |                    |
             | rs1_data[31:0]     | rs2_data[31:0]
             v                    v
                              +----------------------+
   instr[31:0] -------------->|       ImmGen        |
                              |  (immediate extend) |
                              +----------------------+
                                         |
                                         | imm[31:0]
                                         v

   ALU Operand Selection + Execution
   ---------------------------------

                  rs2_data[31:0]
                         |
                         |           imm[31:0]
                         |              |
                         v              v
                     +------------------------+
                     |        Mux2_32         |
                     |       (ALUSrc)         |
                     +------------------------+
                                |
                                | ALU_in2[31:0]
                rs1_data[31:0]  v
                          \   +------------------------+
                           -->|          ALU           |
                              |                        |
                              | ALUResult[31:0], Zero  |
                              +------------------------+
                                        |
                                        | ALUResult[31:0]
                                        v

   Data Memory + Write-Back Selection
   ----------------------------------

                   +-------------------------+
      ALUResult -->|       DataMemory        |
      (addr)       | (MemRead, MemWrite)     |
     rs2_data ---->| (write data)            |
                   +-------------------------+
                             |
                             | readData[31:0]
                             v

             ALUResult[31:0]
                     |              readData[31:0]
                     |                     |
                     v                     v
                 +-------------------------------+
                 |            Mux2_32            |
                 |           (MemtoReg)          |
                 +-------------------------------+
                              |
                              | writeData[31:0]
                              v

                      +----------------------+
                      |     RegisterFile     |
                      |  rd_data <= writeData|
                      +----------------------+

   PC Update and Branch / Jump
   ---------------------------

                     PC[31:0]
                        |
                        v
                  +------------+
                  |  Adder     |  PC+4
                  | PC + 4     |------------------+
                  +------------+                  |
                                                 (Mux for PC)
   imm[31:0] (branch/jump offset)                 |
           |                                      |
           v                                      v
     +-----------+        BranchTaken?      +----------------+
     |   Adder   |<------------------------ |  Mux2_32       |
     | PC + imm  |                          |  (next PC)    |
     +-----------+                          +----------------+
            |                                      |
            +--------------------------------------+
                           nextPC[31:0] ----------> PC register

BranchTaken is typically derived from:
- Branch control signals from ControlUnit
- Zero / comparison results from ALU
- Jump control signals
