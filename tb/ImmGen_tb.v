`timescale 1ns/1ps

module ImmGen_tb;

    reg  [31:0] instr;
    wire [31:0] imm_out;

    // DUT
    ImmGen dut (
        .instr(instr),
        .imm_out(imm_out)
    );

    initial begin
        // I-type example (addi)
        instr = 32'b000000000101_00000_000_00001_0010011;
        #10;

        // S-type example (sw)
        instr = 32'b0000000_00010_00001_010_00101_0100011;
        #10;

        // B-type example (beq)
        instr = 32'b1_000000_00010_00001_000_0000_1_1100011;
        #10;

        $stop;
    end

endmodule
