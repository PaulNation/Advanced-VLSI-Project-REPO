module coefficient_calculator #(
    parameter DATA_WIDTH  = 16,  // Bit-width for sampling_frequency and cutoff_frequency (in Hz)
    parameter FRAC_WIDTH  = 8    // Number of fractional bits for the coefficient
)(
    input  logic                    clk,
    input  logic                    rst,
    input  logic [DATA_WIDTH-1:0]   sampling_frequency, // fs in Hz
    input  logic [DATA_WIDTH-1:0]   cutoff_frequency,     // fc in Hz
    output logic [FRAC_WIDTH-1:0]   alpha               // fixed-point result (0 <= alpha < 1)
);

  // Fixed-point scaling factor S = 2^(FRAC_WIDTH)
  localparam integer S = (1 << FRAC_WIDTH);
  // Fixed-point representation of 2π (≈6.2832) using FRAC_WIDTH fractional bits.
  localparam integer TWO_PI_FIXED = 32'd26986075409; // For FRAC_WIDTH = 8: 6.2832 * 256 ≈ 1608

  // Intermediate signals:
  // 'numerator' represents (2π * fc) in fixed-point.
  logic [DATA_WIDTH+FRAC_WIDTH-1:0] numerator;
  // 'denom' represents (fs + 2π * fc) in fixed-point; fs is scaled by S.
  logic [DATA_WIDTH+FRAC_WIDTH-1:0] denom;
  // 'alpha_fixed' is the computed coefficient scaled by S (using extra bits for precision).
  logic [DATA_WIDTH+2*FRAC_WIDTH-1:0] alpha_fixed;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      alpha <= 0;
    end else begin
      // Compute numerator = TWO_PI_FIXED * cutoff_frequency
      numerator = TWO_PI_FIXED * cutoff_frequency;
      // Compute denominator = sampling_frequency * S + numerator
      denom = (sampling_frequency * S) + numerator;
      
      // Compute α_fixed = (numerator * S) / denom
      // This yields α in fixed-point representation.
      if (denom != 0)
         alpha_fixed = (numerator * S) / denom;
      else
         alpha_fixed = 0;
      
      // Assign the lower FRAC_WIDTH bits as the fixed-point coefficient.
      alpha <= alpha_fixed[FRAC_WIDTH-1:0];
    end
  end

endmodule
