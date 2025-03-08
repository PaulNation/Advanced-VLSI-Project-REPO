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
parameter TAP_COUNT =      	34;
/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////
reg   signed   [DATA_IN_WIDTH-1:0]          data_in_1, data_in_2, data_in_3;
reg                            clk, reset_n;
wire  signed   [DATA_OUT_WIDTH-1:0]          data_out_1, data_out_2, data_out_3;


wire  signed   [COUNT-1:0]     counts;
wire  signed   [DATA_IN_WIDTH-1:0]          signal_1, signal_2, signal_3;
//////////////////////////////////////////////////////// 
///////////////// Design Instaniation //////////////////
////////////////////////////////////////////////////////
 FIR_Filter_L3_Pipelined_Top FIR (
    .clk(clk),
    .reset_n(reset_n),
    .data_in_1(data_in_1),
	 .data_in_2(data_in_2),
	 .data_in_3(data_in_3),
    .data_out_1(data_out_1),
	 .data_out_2(data_out_2),
	 .data_out_3(data_out_3)
);

 SineWave sine
(
    .clk(clk),
    .r_addr(counts),
    .r_data_1(signal_1),
	 .r_data_2(signal_2),
	 .r_data_3(signal_3)
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
	  data_in_1 = 0 ;
     data_in_2 = 0 ;
	  data_in_3 = 0 ;
	 //reset
		reset_n = 1'b1 ; 
        #100
        reset_n = 1'b0 ;
        #100
        reset_n = 1'b1 ;

    assign data_in_1 = signal_1;
	 assign data_in_2 = signal_2;
	 assign data_in_3 = signal_3;
#(20000000);

$stop;   
end
endmodule