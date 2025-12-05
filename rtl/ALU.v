module ALU(
    input  [31:0] A, B,
    input  [2:0]  ALUControl,
    output [31:0] ALUResult,
    output        Zero
);
    reg [31:0] result;
    assign ALUResult = result;
    assign Zero = (result == 32'b0);

    always @(*) begin
        case (ALUControl)
            3'b000: result = A + B;
            3'b001: result = A << B[4:0];
            3'b010: result = A - B;
            3'b100: result = A ^ B;
            3'b101: result = A >> B[4:0];
            3'b110: result = A | B;
            3'b111: result = A & B;
            default: result = 32'b0;
        endcase
    end
endmodule