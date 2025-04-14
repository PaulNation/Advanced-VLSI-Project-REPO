module fir_pipeline 
#(
    parameter DATA_IN_WIDTH  = 16,
    parameter DATA_OUT_WIDTH = 64,
    parameter TAP_WIDTH      = 32,
    parameter TAP_COUNT      = 102
)
(
    input wire                               clk,
    input wire                               reset_n,
    input wire   signed [DATA_IN_WIDTH-1:0]  data_in,
    output reg   signed [DATA_OUT_WIDTH-1:0] data_out
);

//-----------------------------------------------------------
// Internal registers and arrays
//-----------------------------------------------------------

// Delay line for input samples
reg signed [DATA_IN_WIDTH-1:0] delay [0:TAP_COUNT-2];

// Coefficient values for each tap
reg signed [TAP_WIDTH-1:0]  taps [0:TAP_COUNT-1] = '{32'b11111111111110000101000100011100, 32'b11111111111000110010100001001110, 32'b11111111101101000000010001110011};

// Pipeline registers for MAC (Multiply-Accumulate) chain
// Each stage holds the running sum of products up to that tap.
//horizontal cut registers
//reg signed [DATA_OUT_WIDTH-1:0] pipeline [0:TAP_COUNT-1];


//vertical cut registers
reg signed [DATA_OUT_WIDTH-1:0] sum [0:TAP_COUNT-2];
reg signed [DATA_IN_WIDTH-1:0] delay2 [0:TAP_COUNT-2];

integer i, j;


//-----------------------------------------------------------
// Tap Coefficient Initialization
//-----------------------------------------------------------
//initial begin
// $readmemb("lpFilterTapsBinarySigned.txt", taps);
//end

//-----------------------------------------------------------
// Delay Line (Shift Register)
//-----------------------------------------------------------
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        for (i = 0; i < TAP_COUNT-1; i = i + 1)begin
            delay[i] <= 0;
            delay2[i] <= 0;
        end
    end else begin
        // Shift the delay line: new sample enters at delay[0]
        for (i = 1; i < TAP_COUNT-1; i = i + 1)begin
            delay[i] <= delay2[i-1];
            delay2[i] <= delay[i];
        end
        delay2[0] <= delay[0];
        delay[0] <= data_in;
    end
end

//-----------------------------------------------------------
// Pipelined MAC Operation
//-----------------------------------------------------------
// Each stage j adds the product of delay[j] and taps[j] to the running sum.


/*     
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
    for (j = 0; j < TAP_COUNT; j = j + 1)
                pipeline[j] <= 0;
    end
        else begin
    pipeline[0] <=  data_in * taps[0];
    for (j = 0; j < TAP_COUNT-1; j = j + 1)
                pipeline[j+1] <= (delay2[j] * taps[j+1]);
    end
end
 */

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        for (j = 0; j < TAP_COUNT-1; j = j + 1) begin
            sum[j] <= 0;
        end
    end
    else begin
        sum[0] <=  data_in * taps[0];
        for (j = 1; j < TAP_COUNT-1; j = j + 1) begin
            sum[j] <= sum[j-1] + (delay2[j-1] * taps[j]);
        end
        //data_out <= 0;
        //data_out <= sum[TAP_COUNT-2] + (delay2[TAP_COUNT-2] * taps[TAP_COUNT-1]);
    end
end

//-----------------------------------------------------------
// Final Output Register
//-----------------------------------------------------------

// always @(posedge clk or negedge reset_n) begin
//    if (!reset_n)
//        data_out <= 0;
//    else begin
// 		  // Compute filter output
//        data_out <= 0;
//       for (i = 0; i < TAP_COUNT; i = i + 1) begin
//            data_out <= data_out + pipeline[i];
//        end
// 	 end
// end

assign data_out = sum[TAP_COUNT-2] + (delay2[TAP_COUNT-2] * taps[TAP_COUNT-1]);

endmodule