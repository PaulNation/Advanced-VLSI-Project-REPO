module iir_filter_pipelined 
#(
    parameter DATA_IN_WIDTH  = 16,
    parameter DATA_OUT_WIDTH = 32,
    parameter TAP_WIDTH      = 16,
    // Feed-forward taps: include current sample x(n)
    parameter FF_TAP_COUNT   = 4,
    // Feedback taps: note that A[0] is assumed to be 1 (unity gain)
    parameter FB_TAP_COUNT   = 3
)
(
    input  wire                               clk,
    input  wire                               reset_n,
    input  wire   signed [DATA_IN_WIDTH-1:0]  data_in,
    output wire    signed [DATA_OUT_WIDTH-1:0] data_out
);

    // Delay line for past input samples
    reg signed [DATA_OUT_WIDTH-1:0] x_delay [0:FF_TAP_COUNT-2];
    // Delay line for past output samples
    reg signed [DATA_OUT_WIDTH-1:0] y_delay [0:FF_TAP_COUNT-2];
    reg signed [DATA_OUT_WIDTH-1:0] pipe;
    
    //wires for multiplication
    wire signed [DATA_OUT_WIDTH-1:0] w_product_a [0:FB_TAP_COUNT-1];
    wire signed [DATA_OUT_WIDTH-1:0] w_product_b [0:FF_TAP_COUNT-1];

    integer i, j;
    //adding all the stuff wire
    //wire signed [DATA_OUT_WIDTH-1:0] sum;
        // input register
    reg signed [DATA_IN_WIDTH-1:0] r_x;

    // output register
    reg signed [DATA_OUT_WIDTH-1:0] data_out_reg;

    reg signed [TAP_WIDTH-1:0] B [0:FF_TAP_COUNT-1] = '{1000,1001,1002,1003};
    reg signed [TAP_WIDTH-1:0] A [0:FB_TAP_COUNT-1] = '{1,2,3};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initialize input delay line
            for (i = 0; i < FF_TAP_COUNT-1; i = i + 1)
                x_delay[i] <= 0;
            // Initialize output delay line
            for (j = 0; j < FF_TAP_COUNT-1; j = j + 1)
                y_delay[j] <= 0;
            r_x <= 0;
            data_out_reg <= 0;
            pipe <= 0;
        end else begin
            r_x <= data_in;
            // Update the input delay line: shift older samples
            for (i = 0; i < FF_TAP_COUNT-2; i = i + 1)
                x_delay[i] <= x_delay[i+1] + w_product_b[i+1];
            x_delay[FF_TAP_COUNT-2] <= w_product_b[FF_TAP_COUNT-1];

            // Update the output delay line: shift older outputs
            for (j = 0; j < FF_TAP_COUNT-2; j = j + 1)
                y_delay[j] <= y_delay[j+1] + w_product_a[j];
            y_delay[FF_TAP_COUNT-2] <= w_product_a[FB_TAP_COUNT-1];
            pipe <= w_product_b[0] + x_delay[0];
            data_out_reg <= (pipe + y_delay[0]) >>> TAP_WIDTH-3;
        end
    end


    // Compute the filter output
    generate
		 genvar o;
		 for (o = 0; o < FB_TAP_COUNT; o = o + 1) begin : a_loop
		 assign w_product_a[o] = (-(A[o]) * ((pipe + y_delay[0]) >>> TAP_WIDTH-3)) ; //(-(A[o]) * data_out_reg)
		 end
    endgenerate

    
    generate
		 genvar c;
		 for (c = 0; c < FF_TAP_COUNT; c = c + 1) begin : b_loop
		 assign w_product_b[c] = B[c] * r_x; //B[c] * r_x 
		 end
    endgenerate



    // Compute the filter output
    assign data_out = data_out_reg;


endmodule