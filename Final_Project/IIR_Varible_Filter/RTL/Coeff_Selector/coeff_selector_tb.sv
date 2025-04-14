module coeff_selector_tb();

  // Parameters
  parameter TAP_WIDTH      = 32;
  parameter FF_TAP_COUNT   = 4;
  parameter FB_TAP_COUNT   = 3;
  parameter NUM_LP_FILTERS = 20;

  // Testbench signals
  logic [4:0] filter_index;
  logic signed [TAP_WIDTH-1:0] B [0:FF_TAP_COUNT-1];
  logic signed [TAP_WIDTH-1:0] A [0:FB_TAP_COUNT-1];

  // Instantiate the DUT (Device Under Test)
  coeff_selector #(
    .TAP_WIDTH(TAP_WIDTH),
    .FF_TAP_COUNT(FF_TAP_COUNT),
    .FB_TAP_COUNT(FB_TAP_COUNT),
    .NUM_LP_FILTERS(NUM_LP_FILTERS)
  ) dut (
    .filter_index(filter_index),
    .B(B),
    .A(A)
  );

  // Task to display the B and A coefficients
  task display_coefficients;
    $display("Filter Index: %0d", filter_index);
    for (int i = 0; i < FF_TAP_COUNT; i++) begin
      $display("B[%0d] = %0d", i, B[i]);
    end
    for (int i = 0; i < FB_TAP_COUNT; i++) begin
      $display("A[%0d] = %0d", i, A[i]);
    end
    $display("");
  endtask

  // Test sequence
  initial begin
    // Iterate over all possible filter indices
    for (int idx = 0; idx < NUM_LP_FILTERS; idx++) begin
      filter_index = idx;
      #10; // Wait for combinational logic to settle
      display_coefficients();
    end

    // End simulation
    $stop;
  end

endmodule
