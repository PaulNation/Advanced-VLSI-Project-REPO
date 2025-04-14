`timescale 1ns / 1ps
module FIR_Filter_tb();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////
parameter COUNT = 15;
parameter CLK_PERIOD  =  20833.33;

parameter DATA_IN_WIDTH = 16;
parameter DATA_OUT_WIDTH = 32;
parameter TAP_WIDTH = 16;
parameter FF_TAP_COUNT = 4;
parameter FB_TAP_COUNT = 3;
parameter NUM_LP_FILTERS = 20;

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////
wire signed [DATA_IN_WIDTH-1:0] data_in;
reg clk, reset_n;
wire signed [DATA_OUT_WIDTH-1:0] data_out;

wire signed [COUNT-1:0] counts;
wire signed [DATA_IN_WIDTH-1:0] signal;

// Declare filter_index register
reg [8:0] filter_index;

assign data_in = signal;

//////////////////////////////////////////////////////// 
///////////////// Design Instantiation /////////////////
////////////////////////////////////////////////////////

// Instantiate the IIR filter
iir_filter_pipelined #(
    .DATA_IN_WIDTH(DATA_IN_WIDTH),
    .DATA_OUT_WIDTH(DATA_OUT_WIDTH),
    .TAP_WIDTH(TAP_WIDTH),
    .FF_TAP_COUNT(FF_TAP_COUNT),
    .FB_TAP_COUNT(FB_TAP_COUNT)
) IIR (
    .clk(clk),
    .reset_n(reset_n),
    .data_in(data_in),
    .data_out(data_out)
);

// Instantiate the coefficient selector
coeff_selector #(
    .TAP_WIDTH(TAP_WIDTH),
    .FF_TAP_COUNT(FF_TAP_COUNT),
    .FB_TAP_COUNT(FB_TAP_COUNT),
    .NUM_LP_FILTERS(NUM_LP_FILTERS)
) coeff_sel (
    .filter_index(filter_index),
    .B(IIR.B),
    .A(IIR.A)
);

// Instantiate the sine wave generator
SineWave sine (
    .clk(clk),
    .r_addr(counts),
    .r_data(signal)
);

// Instantiate the counter
counter counter (
    .clk(clk),
    .reset_n(reset_n),
    .count(counts)
);  
integer i;
///////////////////// Clock Generator //////////////////
initial begin
    clk = 1'b1;     
    forever #(CLK_PERIOD/2) clk = ~clk;  		
end
	
////////////////////////////////////////////////////////
////////////////// Initial Block /////////////////////// 
////////////////////////////////////////////////////////
initial begin
    // Reset sequence
    reset_n = 1'b1; 
    #(100)
    reset_n = 1'b0;
    #(100)
    reset_n = 1'b1;

    // Initialize filter_index
    filter_index = 0;

    // Cycle through filter indices
        for(i = NUM_LP_FILTERS-1; i >= 0; i = i - 1)begin
        // #(20000000/10)
        // reset_n = 1'b1; 
        // #(20000000/10)
        // reset_n = 1'b0;
        #(20000000/10)
        //reset_n = 1'b1;
        filter_index = filter_index + 1;

        end
    //#(20000000);
    $stop;   
end

endmodule
