`timescale 1ns/1ps

module ControlUnit_tb;

    // DUT inputs
    reg  [6:0] opcode;

    // DUT outputs
    wire       MemRead;
    wire       MemWrite;
    wire       MemToReg;
    wire       Branch;
    wire       ALUSrc;
    wire       RegWrite;
    wire [1:0] ALUOp;

    // DUT instantiation
    ControlUnit dut (
        .opcode   (opcode),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .MemToReg (MemToReg),
        .Branch   (Branch),
        .ALUSrc   (ALUSrc),
        .RegWrite (RegWrite),
        .ALUOp    (ALUOp)
    );

    // Monitor: always print whenever any signal changes
    initial begin
        $monitor("time=%0t opcode=%b MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                 $time, opcode, MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
    end

    // Test sequence
    initial begin
        $display("==== Starting ControlUnit_tb ====");

        // ----------------------------------------------------
        // Test 0: Unknown / invalid opcode (NOP behavior)
        // Expect: all control signals 0, ALUOp = 00
        // ----------------------------------------------------
        opcode = 7'b0000000;   // not in any case branch
        #1;                    // let combinational logic settle

        $display("Test 0: Unknown opcode (0000000)");
        if (MemRead  !== 0 ||
            MemWrite !== 0 ||
            MemToReg !== 0 ||
            Branch   !== 0 ||
            ALUSrc   !== 0 ||
            RegWrite !== 0 ||
            ALUOp    !== 2'b00) begin

            $display("  [FAIL] Expected all control signals = 0 and ALUOp = 00");
            $display("         Got: MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                     MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
        end else begin
            $display("  [PASS] Unknown opcode correctly produces NOP control signals.");
        end

        #5;

        // ----------------------------------------------------
        // Test 1: R-type (opcode = 0110011)
        // Expect:
        //   MemRead=0, MemWrite=0, MemToReg=0, Branch=0,
        //   ALUSrc=0, RegWrite=1, ALUOp=10
        // ----------------------------------------------------
        opcode = 7'b0110011;
        #1;

        $display("Test 1: R-type (0110011)");
        if (MemRead  !== 0    ||
            MemWrite !== 0    ||
            MemToReg !== 0    ||
            Branch   !== 0    ||
            ALUSrc   !== 0    ||
            RegWrite !== 1    ||
            ALUOp    !== 2'b10) begin

            $display("  [FAIL] R-type control signals incorrect.");
            $display("         Got: MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                     MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
        end else begin
            $display("  [PASS] R-type control signals OK.");
        end

        #5;

        // ----------------------------------------------------
        // Test 2: I-type ADDI (opcode = 0010011)
        // Expect:
        //   MemRead=0, MemWrite=0, MemToReg=0, Branch=0,
        //   ALUSrc=1, RegWrite=1, ALUOp=10
        // ----------------------------------------------------
        opcode = 7'b0010011;
        #1;

        $display("Test 2: I-type (ADDI, 0010011)");
        if (MemRead  !== 0    ||
            MemWrite !== 0    ||
            MemToReg !== 0    ||
            Branch   !== 0    ||
            ALUSrc   !== 1    ||
            RegWrite !== 1    ||
            ALUOp    !== 2'b10) begin

            $display("  [FAIL] I-type (ADDI) control signals incorrect.");
            $display("         Got: MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                     MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
        end else begin
            $display("  [PASS] I-type (ADDI) control signals OK.");
        end

        #5;

        // ----------------------------------------------------
        // Test 3: LW (opcode = 0000011)
        // Expect:
        //   MemRead=1, MemWrite=0, MemToReg=1, Branch=0,
        //   ALUSrc=1, RegWrite=1, ALUOp=00
        // ----------------------------------------------------
        opcode = 7'b0000011;
        #1;

        $display("Test 3: LW (0000011)");
        if (MemRead  !== 1    ||
            MemWrite !== 0    ||
            MemToReg !== 1    ||
            Branch   !== 0    ||
            ALUSrc   !== 1    ||
            RegWrite !== 1    ||
            ALUOp    !== 2'b00) begin

            $display("  [FAIL] LW control signals incorrect.");
            $display("         Got: MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                     MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
        end else begin
            $display("  [PASS] LW control signals OK.");
        end

        #5;

        // ----------------------------------------------------
        // Test 4: SW (opcode = 0100011)
        // Expect:
        //   MemRead=0, MemWrite=1, MemToReg=0, Branch=0,
        //   ALUSrc=1, RegWrite=0, ALUOp=00
        // ----------------------------------------------------
        opcode = 7'b0100011;
        #1;

        $display("Test 4: SW (0100011)");
        if (MemRead  !== 0    ||
            MemWrite !== 1    ||
            MemToReg !== 0    ||
            Branch   !== 0    ||
            ALUSrc   !== 1    ||
            RegWrite !== 0    ||
            ALUOp    !== 2'b00) begin

            $display("  [FAIL] SW control signals incorrect.");
            $display("         Got: MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                     MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
        end else begin
            $display("  [PASS] SW control signals OK.");
        end

        #5;

        // ----------------------------------------------------
        // Test 5: BEQ (opcode = 1100011)
        // Expect:
        //   MemRead=0, MemWrite=0, MemToReg=0,
        //   Branch=1, ALUSrc=0, RegWrite=0, ALUOp=01
        // ----------------------------------------------------
        opcode = 7'b1100011;
        #1;

        $display("Test 5: BEQ (1100011)");
        if (MemRead  !== 0    ||
            MemWrite !== 0    ||
            MemToReg !== 0    ||
            Branch   !== 1    ||
            ALUSrc   !== 0    ||
            RegWrite !== 0    ||
            ALUOp    !== 2'b01) begin

            $display("  [FAIL] BEQ control signals incorrect.");
            $display("         Got: MemRead=%b MemWrite=%b MemToReg=%b Branch=%b ALUSrc=%b RegWrite=%b ALUOp=%b",
                     MemRead, MemWrite, MemToReg, Branch, ALUSrc, RegWrite, ALUOp);
        end else begin
            $display("  [PASS] BEQ control signals OK.");
        end

        $display("==== ControlUnit_tb finished ====");
        $finish;
    end

endmodule
