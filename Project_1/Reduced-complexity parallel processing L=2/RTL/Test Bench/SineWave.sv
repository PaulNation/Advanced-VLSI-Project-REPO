module SineWave
#(parameter ADDR_WIDTH = 9, DATA_WIDTH = 32)
(
input                   clk,
input  [ADDR_WIDTH-1:0] r_addr,
output [DATA_WIDTH-1:0] r_data_1,
output [DATA_WIDTH-1:0] r_data_2
);
reg [DATA_WIDTH-1 : 0] sine [0 : (2**ADDR_WIDTH)-1];
  
initial
        $readmemb("binary_signal.data", sine); 

assign r_data_1 = sine[r_addr];
assign r_data_2 = sine[r_addr+1];


endmodule