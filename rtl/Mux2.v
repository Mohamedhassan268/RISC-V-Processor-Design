module Mux2_32(
input wire [31:0]a,
input wire [31:0]b,
input          sel,
output wire [31:0]y, 
);
assign y = sel ? b : a;
endmodule