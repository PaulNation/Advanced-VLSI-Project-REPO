module rc_step_generator #(
    parameter WIDTH         = 16,
    parameter RC_MIN        = 16'd1,   // Minimum RC value
    parameter RC_MAX        = 16'd1500,  // Maximum RC value
    parameter RC_STEP       = 16'd100,   // Increment step for RC
    parameter DWELL_CYCLES  = 1000       // Number of clock cycles to hold each RC value
)(
    input  logic                   clk,
    input  logic                   reset_n,  // Active-low reset
    output logic [WIDTH-1:0]       rc
);

  // Internal registers for current RC and dwell counter.
  logic [WIDTH-1:0] rc_reg, rc_next;
  // Calculate the number of bits needed to count DWELL_CYCLES.
  localparam integer DWELL_WIDTH = $clog2(DWELL_CYCLES);
  logic [DWELL_WIDTH-1:0] dwell_counter, dwell_next;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      rc_reg       <= RC_MIN;
      dwell_counter <= 0;
    end else begin
      rc_reg       <= rc_next;
      dwell_counter <= dwell_next;
    end
  end

  always_comb begin
    // Default: increment dwell counter.
    dwell_next = dwell_counter + 1;
    rc_next    = rc_reg;
    // When the dwell period is over, increment RC by RC_STEP
    if (dwell_counter == DWELL_CYCLES - 1) begin
      dwell_next = 0;
      if (rc_reg + RC_STEP > RC_MAX)
        rc_next = RC_MIN; // Wrap around
      else
        rc_next = rc_reg + RC_STEP;
    end
  end

  assign rc = rc_reg;

endmodule
