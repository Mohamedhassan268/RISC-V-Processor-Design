module DataMemory(
    input             clk,
    input      [31:0] addr,
    input      [31:0] write_data,
    input             WE,
    output     [31:0] read_data
);
    reg [31:0] memory [0:63];

    integer j;
    initial begin
        for (j = 0; j < 64; j = j + 1)
            memory[j] = 32'b0;
    end

    assign read_data = memory[addr[7:2]];

    always @(posedge clk) begin
        if (WE)
            memory[addr[7:2]] <= write_data;
    end
endmodule