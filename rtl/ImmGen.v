module ImmGen (
    input  [31:0] instr,
    output reg [31:0] imm_out
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            // I-type: lw (0000011), addi (0010011)
            7'b0000011,
            7'b0010011: begin
                imm_out = {{20{instr[31]}}, instr[31:20]};
            end

            // S-type: sw (0100011)
            7'b0100011: begin
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            // B-type: beq/bne/blt (1100011)
            7'b1100011: begin
                imm_out = {{19{instr[31]}}, instr[31], instr[7],
                           instr[30:25], instr[11:8], 1'b0};
            end

            default: begin
                imm_out = 32'b0;
            end
        endcase
    end

endmodule
