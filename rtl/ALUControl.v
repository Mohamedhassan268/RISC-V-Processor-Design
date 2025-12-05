module ALUControl (
    input      [1:0] ALUOp,
    input      [2:0] funct3,
    input      [6:0] funct7,
    output reg [2:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: begin
            ALUControl = 3'b000;   // ADD for LW/SW
        end

        2'b01: begin
            ALUControl = 3'b010;   // SUB for BEQ
        end

        2'b10: begin
            case (funct3)
                3'b000: begin
                    if (funct7[5] == 1'b1)
                        ALUControl = 3'b010;   // SUB
                    else
                        ALUControl = 3'b000;   // ADD / ADDI
                end
                3'b111: ALUControl = 3'b111;   // AND
                3'b110: ALUControl = 3'b110;   // OR
                3'b100: ALUControl = 3'b100;   // XOR
                3'b001: ALUControl = 3'b001;   // SLL
                3'b101: ALUControl = 3'b101;   // SRL
                default: ALUControl = 3'b000;  // default ADD
            endcase
        end

        default: begin
            ALUControl = 3'b000;   // default ADD
        end
    endcase
end
endmodule
