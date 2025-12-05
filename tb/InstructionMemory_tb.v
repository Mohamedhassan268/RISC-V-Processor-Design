`timescale 1ns/1ps

module InstructionMemory_tb;

    reg  [31:0] addr;
    wire [31:0] instr;

    // DUT
    InstructionMemory dut (
        .addr (addr),
        .instr(instr)
    );

    initial begin
        $monitor("time=%0t addr=0x%08h instr=0x%08h",
                 $time, addr, instr);
    end

    initial begin
        // Test 1: first instruction
        addr = 32'h00000000;
        #10;

        // Test 2: second instruction
        addr = 32'h00000004;
        #10;

        // Test 3
        addr = 32'h00000008;
        #10;

        // Test 4
        addr = 32'h0000000C;
        #10;

        $finish;
    end

endmodule
