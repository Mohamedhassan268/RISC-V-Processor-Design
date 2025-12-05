`timescale 1ns/1ps

module CPU_TOP_tb;

    reg clk;
    reg reset_n;

    // Choose which program file to run:
    // - "mem/risc.dat"  (your main program)
    // - or any other, e.g. "mem/test1.dat"
CPU_TOP dut (
    .clk     (clk),
    .reset_n (reset_n)
);
    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Monitor some key internal signals
    initial begin
        $display("time   PC          instr       ALUResult   MemRead MemWrite RegWrite Branch Zero");
        $monitor("%0t  %h  %h  %h   %b       %b        %b        %b     %b",
                 $time,
                 dut.PC,
                 dut.instr,
                 dut.alu_result,
                 dut.MemRead,
                 dut.MemWrite,
                 dut.RegWrite,
                 dut.Branch,
                 dut.alu_zero);
    end

    // Test sequence
    initial begin
        $display("==== Starting CPU_TOP_tb ====");

        clk     = 0;
        reset_n = 0;   // assert reset (active low)

        // hold reset for a bit
        #20;
        reset_n = 1;   // release reset, CPU starts

        // Let CPU run for some cycles
        repeat (100) @(posedge clk);

        $display("==== CPU_TOP_tb finished ====");
        $display("Final PC = %h", dut.PC);
        $finish;
    end

endmodule
