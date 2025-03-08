module FIR_Filter_L2_Top 
#(
    parameter DATA_IN_WIDTH  = 16,
    parameter DATA_OUT_WIDTH = 64,
    parameter TAP_WIDTH      = 32,
    parameter TAP_COUNT      = 102
)
(
    input wire                               clk,
    input wire                               reset_n,
    input wire   signed [DATA_IN_WIDTH-1:0]  data_in_1,
	 input wire   signed [DATA_IN_WIDTH-1:0]  data_in_2,
    output reg   signed [DATA_OUT_WIDTH-1:0] data_out_1,
	 output reg   signed [DATA_OUT_WIDTH-1:0] data_out_2
);

//input side of diagram
reg [DATA_IN_WIDTH-1:0] data_sum;
assign data_sum = data_in_1 + data_in_2;


//Data out for sub parallel filters
reg [DATA_OUT_WIDTH-1:0] dataOut_H0;
reg [DATA_OUT_WIDTH-1:0] dataOut_H1;
reg [DATA_OUT_WIDTH-1:0] dataOut_H0H1;

fir_parallel #( .TAPFILE("H0.txt") ) H0(clk, reset_n, data_in_1, dataOut_H0);
fir_parallel #( .TAPFILE("H1.txt") ) H1(clk, reset_n, data_in_2, dataOut_H1);
fir_parallel #( .TAPFILE("H0_H1.txt") ) H0_H1(clk, reset_n, data_sum, dataOut_H0H1);


//output side of diagram:
reg signed [DATA_OUT_WIDTH-1:0] delay [0:1];
integer i;
//-----------------------------------------------------------
// Delay Line (for H1)
//-----------------------------------------------------------
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        for (i = 0; i < 2; i = i + 1)
            delay[i] <= 0;
    end else begin
        // Shift the delay line: new sample enters at delay[0]
        for (i = 1; i < 2; i = i + 1)
            delay[i] <= delay[i-1];
        delay[0] <= dataOut_H1;
    end
end


assign data_out_2 = dataOut_H0H1 - dataOut_H1 - dataOut_H0;
assign data_out_1 = dataOut_H0 + delay[1];

endmodule