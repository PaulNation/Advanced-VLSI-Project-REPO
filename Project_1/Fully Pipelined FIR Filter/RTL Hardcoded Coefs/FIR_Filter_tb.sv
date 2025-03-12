`timescale 1ns / 1ps
module FIR_Filter_tb();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////
parameter COUNT = 9;
parameter CLK_PERIOD  =  44100; //periodic time of  44.1KHz CLK 22675.73696

parameter DATA_IN_WIDTH =		16;
parameter DATA_OUT_WIDTH =		64;
parameter TAP_WIDTH =			32;
parameter TAP_COUNT =      	127;
/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////
reg   signed   [DATA_IN_WIDTH-1:0]          data_in;
reg                            clk, reset_n;
wire  signed   [DATA_OUT_WIDTH-1:0]          data_out;

wire  signed   [COUNT-1:0]     counts;
wire  signed   [DATA_IN_WIDTH-1:0]          signal;

//////////////////////////////////////////////////////// 
///////////////// Design Instaniation //////////////////
////////////////////////////////////////////////////////
 fir_pipeline FIR (
    .clk(clk),
    .reset_n(reset_n),
    .data_in(data_in),
    .data_out(data_out)
);

 SineWave sine
(
    .clk(clk),
    .r_addr(counts),
    .r_data(signal)
);

counter counter(
    .clk(clk),
    .reset_n(reset_n),
    .count(counts)
);  

///////////////////// Clock Generator //////////////////
initial 
	begin
        clk  = 1'b1 ;     
        forever      
        #(CLK_PERIOD/2) clk = ~clk ;  		
	end
	
////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial 
   begin
     // initialization 
	  data_in = 0 ;
     
	 //reset
		reset_n = 1'b1 ; 
        #100
        reset_n = 1'b0 ;
        #100
        reset_n = 1'b1 ;

    assign data_in = signal;
#(20000000);

$stop;   
end
endmodule