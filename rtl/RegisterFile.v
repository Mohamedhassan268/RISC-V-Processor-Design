module RegisterFile(
    input             clk,
    input             reset_n,
    input      [4:0]  rs1, rs2,
    input      [4:0]  rd,
    input      [31:0] write_data,
    input             reg_write,
    output     [31:0] read_data1, read_data2
);
    reg [31:0] regs [0:31];

    assign read_data1 = regs[rs1];
    assign read_data2 = regs[rs2];

    integer i;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (reg_write) begin
            if (rd != 5'b0)
                regs[rd] <= write_data;
        end
    end
endmodule