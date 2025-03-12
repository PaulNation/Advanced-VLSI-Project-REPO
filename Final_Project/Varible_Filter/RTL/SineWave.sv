module SineWave
#(parameter ADDR_WIDTH = 9, DATA_WIDTH = 32)
(
input                   clk,
input  [ADDR_WIDTH-1:0] r_addr,
output [DATA_WIDTH-1:0] r_data
);
reg signed [DATA_WIDTH-1 : 0] sine [0 : (2**ADDR_WIDTH)-1];
  
initial
        $readmemb("binary_signal.txt", sine); 

assign r_data = sine[r_addr];
endmodule