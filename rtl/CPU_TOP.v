module CPU_TOP #(
    parameter MEM_FILE = "C:/Users/HP OMEN/OneDrive/Desktop/Digital design projects/RISCV_SingleCycle_QuestSim/rtl/risc.dat"
)(
    input  wire clk,
    input  wire reset_n
);

    reg  [31:0] PC;
    wire [31:0] next_PC;
    wire [31:0] pc_plus4;
    wire [31:0] branch_target;

    wire [31:0] instr;

    InstructionMemory #(
        .MEM_FILE(MEM_FILE)
    ) instr_mem (
        .addr  (PC),
        .instr (instr)
    );

    // ... (rest of your existing CPU_TOP exactly as before)

endmodule
