## Single-Cycle Datapath (Simplified ASCII)

```text
   PC       PC+4
   |         ^
   v         |
+------+   +------+
|  PC  |-->| +4   |
+------+   +------+
   |          \
   |           \
   v            \
+-------------------+
| InstructionMemory |
+-------------------+
        |
        v
   instr[31:0]
        |
   +-----------------+
   |   ControlUnit   |
   +-----------------+
        |   |   |
        |   |   +--> MemRead / MemWrite / MemToReg
        |   +------> ALUSrc
        +----------> RegWrite / Branch / Jump

   rs1, rs2, rd from instr
        |
        v
+-------------------+
|   RegisterFile    |
+-------------------+
   |           |
   |           +--------------------+
   |                                |
rs1_data                        rs2_data
   |                                |
   |                                v
   |                      +-------------------+
   |                      |    Mux2_32        |
   |                imm --|  (ALUSrc select)  |
   |                      +-------------------+
   |                                |
   +------------+                   |
                |                   v
                |             +----------+
                +------------>|   ALU    |
                              +----------+
                                   |
                             ALUResult / Zero

           ALUResult (addr)          rs2_data (wd)
                    |                        |
                    v                        v
               +-------------------------------+
               |           DataMemory          |
               +-------------------------------+
                           |
                       readData
                           |
      ALUResult -----------+--------- readData
                           v
                    +-------------+
                    |  Mux2_32    |
                    | (MemToReg)  |
                    +-------------+
                           |
                       writeData
                           |
                       RegisterFile (rd)

Branch / jump logic uses:
- Zero flag and funct3 (BEQ/BNE/BLT/BGE)
- Branch / Jump control
to select between PC+4 and branch/jump target for the next PC.
```
