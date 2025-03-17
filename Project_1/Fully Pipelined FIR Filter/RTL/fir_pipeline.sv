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
reg signed [DATA_IN_WIDTH-1:0] delay [0:TAP_COUNT-1];

// Coefficient values for each tap
reg signed [TAP_WIDTH-1:0]  taps [0:TAP_COUNT-1] = '{32'b11111111111110000101000100011100, 32'b11111111111000110010100001001110, 32'b11111111101101000000010001110011, 32'b11111111010111011101110000111000, 32'b11111110110101011110110010000100, 32'b11111110000110010100100000001110, 32'b11111101001100100110001111000010, 32'b11111100001111001011001111010110, 32'b11111011011001000010101110010000, 32'b11111010110111110010101000110100, 32'b11111010111000101110000110111000, 32'b11111011100101000100011110011001, 32'b11111100111110010111010100010101, 32'b11111110111100000101010000001000, 32'b00000001001011101110100110110101, 32'b00000011010011110110001000001100, 32'b00000100111001101000100110000110, 32'b00000101100111111010111100110001, 32'b00000101010101100010100111100101, 32'b00000100001001000010111110000001, 32'b00000010011000001101001000111111, 32'b00000000100010111001101111101100, 32'b11111111001010100000100110100001, 32'b11111110101000000110001000011001, 32'b11111111000100011111011111101110, 32'b00000000010100111100110110111100, 32'b00000001111101110111111000010001, 32'b00000011011011001011111111100001, 32'b00000100001100000000101100011010, 32'b00000011111101111001110010001101, 32'b00000010110011110110100011111110, 32'b00000001000110010010100000101101, 32'b11111111011011100111010000000100, 32'b11111110011011010011001101101110, 32'b11111110011111101100110010101111, 32'b11111111101011011100101000111111, 32'b00000001100110100010000111100001, 32'b00000011100100101110100110111001, 32'b00000100110011111011100110100011, 32'b00000100101110000110100000111010, 32'b00000011001000110110001101011100, 32'b00000000011101000010001100100101, 32'b11111101100011000100010101000111, 32'b11111011100100000011000000011100, 32'b11111011100011110001010101110010, 32'b11111110001010001101000101110100, 32'b00000011010011101001110010101011, 32'b00001010001101001001100110000011, 32'b00010001011110111100101000011100, 32'b00010111100010100111010001011110, 32'b00011010111110100000001110101110, 32'b00011010111110100000001110101110, 32'b00010111100010100111010001011110, 32'b00010001011110111100101000011100, 32'b00001010001101001001100110000011, 32'b00000011010011101001110010101011, 32'b11111110001010001101000101110100, 32'b11111011100011110001010101110010, 32'b11111011100100000011000000011100, 32'b11111101100011000100010101000111, 32'b00000000011101000010001100100101, 32'b00000011001000110110001101011100, 32'b00000100101110000110100000111010, 32'b00000100110011111011100110100011, 32'b00000011100100101110100110111001, 32'b00000001100110100010000111100001, 32'b11111111101011011100101000111111, 32'b11111110011111101100110010101111, 32'b11111110011011010011001101101110, 32'b11111111011011100111010000000100, 32'b00000001000110010010100000101101, 32'b00000010110011110110100011111110, 32'b00000011111101111001110010001101, 32'b00000100001100000000101100011010, 32'b00000011011011001011111111100001, 32'b00000001111101110111111000010001, 32'b00000000010100111100110110111100, 32'b11111111000100011111011111101110, 32'b11111110101000000110001000011001, 32'b11111111001010100000100110100001, 32'b00000000100010111001101111101100, 32'b00000010011000001101001000111111, 32'b00000100001001000010111110000001, 32'b00000101010101100010100111100101, 32'b00000101100111111010111100110001, 32'b00000100111001101000100110000110, 32'b00000011010011110110001000001100, 32'b00000001001011101110100110110101, 32'b11111110111100000101010000001000, 32'b11111100111110010111010100010101, 32'b11111011100101000100011110011001, 32'b11111010111000101110000110111000, 32'b11111010110111110010101000110100, 32'b11111011011001000010101110010000, 32'b11111100001111001011001111010110, 32'b11111101001100100110001111000010, 32'b11111110000110010100100000001110, 32'b11111110110101011110110010000100, 32'b11111111010111011101110000111000, 32'b11111111101101000000010001110011, 32'b11111111111000110010100001001110, 32'b11111111111110000101000100011100};


// Pipeline registers for MAC (Multiply-Accumulate) chain
// Each stage holds the running sum of products up to that tap.
reg signed [DATA_OUT_WIDTH-1:0] pipeline [0:TAP_COUNT-1];

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
        for (i = 0; i < TAP_COUNT; i = i + 1)
            delay[i] <= 0;
    end else begin
        // Shift the delay line: new sample enters at delay[0]
        for (i = 1; i < TAP_COUNT; i = i + 1)
            delay[i] <= delay[i-1];
        delay[0] <= data_in;
    end
end

//-----------------------------------------------------------
// Pipelined MAC Operation
//-----------------------------------------------------------
// Each stage j adds the product of delay[j] and taps[j] to the running sum.


    
        always @(posedge clk or negedge reset_n) begin
            if (!reset_n) begin
		for (j = 0; j < TAP_COUNT; j = j + 1)
                	pipeline[j] <= 0;
	    end
            else begin
		pipeline[0] <=  data_in * taps[0];
		for (j = 0; j < TAP_COUNT; j = j + 1)
                	pipeline[j+1] <= (delay[j] * taps[j+1]);
	    end
        end



//-----------------------------------------------------------
// Final Output Register
//-----------------------------------------------------------

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        data_out <= 0;
    else begin
		  // Compute filter output
        data_out <= 0;
        for (i = 0; i < TAP_COUNT; i = i + 1) begin
            data_out <= data_out + pipeline[i];
        end
	 end
end
endmodule
