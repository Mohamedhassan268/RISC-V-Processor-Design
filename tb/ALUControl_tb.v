`timescale 1ns/1ps

module ALUControl_tb;

    reg  [1:0] ALUOp;
    reg  [2:0] funct3;
    reg  [6:0] funct7;
    wire [2:0] ALUControl;

    ALUControl dut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    // Monitor block
    initial begin
        $monitor("time=%0t  ALUOp=%b  funct3=%b  funct7=%b  ALUControl=%b",
                  $time, ALUOp, funct3, funct7, ALUControl);
    end

    // Test sequence block
    initial begin
        // Test 1: LW/SW = ADD
        ALUOp  = 2'b00;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // Test 2: BEQ = SUB
        ALUOp  = 2'b01;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
// Test 3: R-type ADD (funct3=000, funct7=0000000)
ALUOp  = 2'b10;
funct3 = 3'b000;
funct7 = 7'b0000000;  // ADD
#10;


        $finish;
    end

endmodule
