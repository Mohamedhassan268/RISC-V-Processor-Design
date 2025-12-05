module ControlUnit (
    input  [6:0] opcode,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemToReg,
    output reg       Branch,
    output reg       ALUSrc,
    output reg       RegWrite,
    output reg [1:0] ALUOp
);

    always @(*) begin

        // Default (NOP)
        MemRead  = 0;
        MemWrite = 0;
        MemToReg = 0;
        Branch   = 0;
        ALUSrc   = 0;
        RegWrite = 0;
        ALUOp    = 2'b00;

        case (opcode)

            // ========= R-TYPE (0110011) =========
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc   = 0;
                ALUOp    = 2'b10;
            end

            // ========= I-TYPE (ADDI = 0010011) =========
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b10;
            end

            // ========= LOAD (LW = 0000011) =========
            7'b0000011: begin
                MemRead  = 1;
                RegWrite = 1;
                ALUSrc   = 1;
                MemToReg = 1;
                ALUOp    = 2'b00;
            end

            // ========= STORE (SW = 0100011) =========
            7'b0100011: begin
                MemWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end

            // ========= BRANCH (BEQ = 1100011) =========
            7'b1100011: begin
                Branch   = 1;
                ALUSrc   = 0;
                ALUOp    = 2'b01;
            end

        endcase
    end

endmodule

