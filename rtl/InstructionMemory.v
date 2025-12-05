module InstructionMemory #(
    // ABSOLUTE PATH TO YOUR FILE
    parameter MEM_FILE = "C:/Users/HP OMEN/OneDrive/Desktop/Digital design projects/RISCV_SingleCycle_QuestSim/rtl/risc.dat"
)(
    input  [31:0] addr,
    output [31:0] instr
);
    reg [31:0] memory [0:63];

    integer i;
    initial begin
        // optional init to zero
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 32'h00000000;

        $display("InstructionMemory: loading program from %s", MEM_FILE);
        $readmemh(MEM_FILE, memory);
    end

    assign instr = memory[addr[7:2]];

endmodule

