module variable_lowpass_filter #(
    parameter DATA_WIDTH = 16,    // Bit-width for data
    parameter FRAC_WIDTH = 8      // Number of fractional bits for coefficient
)(
    input  logic                   clk,
    input  logic                   rst,
    input  logic signed [DATA_WIDTH-1:0] in_sample,
    // The coefficient 'alpha' is provided in fixed-point format (0 <= alpha < 1)
    input  logic [FRAC_WIDTH-1:0]  alpha,   
    output logic signed [DATA_WIDTH-1:0] out_sample
);

  // Internal register to hold the previous output (y[n-1])
  logic signed [DATA_WIDTH-1:0] y_reg;

  // Define scaling factor (for fixed-point arithmetic)
  localparam int SCALE = 1 << FRAC_WIDTH;

  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      y_reg <= 0;
    else begin
      // Multiply in_sample by alpha and the previous output by (SCALE - alpha)
      // Then shift right by FRAC_WIDTH to properly scale the sum.
      y_reg <= ((alpha * in_sample) + ((SCALE - alpha) * y_reg)) >>> FRAC_WIDTH;
    end
  end

  assign out_sample = y_reg;

endmodule
