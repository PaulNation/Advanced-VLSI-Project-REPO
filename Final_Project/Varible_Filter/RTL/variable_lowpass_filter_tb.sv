`timescale 1ns/1ps
module variable_lowpass_filter_tb;

  /////////////////////////////////////////////////////////
  ////////////// Parameter Definitions ////////////////////
  /////////////////////////////////////////////////////////
  parameter DATA_WIDTH  = 16;
  parameter FRAC_WIDTH  = 32;
  parameter ADDR_WIDTH  = 9;
  parameter COUNT       = 9;
  // Clock period in ns; for example, if this is 44100 ns then the clock frequency is ~22.7 kHz.
  parameter CLK_PERIOD  = 44100; 

  /////////////////////////////////////////////////////////
  ////////////// Signal Declarations //////////////////////
  /////////////////////////////////////////////////////////
  reg                         clk;
  reg                         reset_n;
  
  // SineWave and counter signals
  wire signed [DATA_WIDTH-1:0] sine_signal;
  wire [ADDR_WIDTH-1:0]        counter_addr;
  
  // Coefficient calculator signals:
  // 'sampling_frequency' is provided as a constant (in Hz).
  reg  [DATA_WIDTH-1:0]       sampling_frequency;
  // 'cutoff_frequency' is swept from 1 Hz to 1 kHz.
  wire [DATA_WIDTH-1:0]       cutoff_frequency;
  // Computed coefficient (in fixed-point with FRAC_WIDTH fractional bits)
  wire [FRAC_WIDTH-1:0]       alpha;
  
  // Filter output
  wire signed [DATA_WIDTH-1:0] filter_out;
  
  /////////////////////////////////////////////////////////
  ////////////// Module Instantiations ////////////////////
  /////////////////////////////////////////////////////////
  
  // Counter module to address the SineWave memory.
  counter #(COUNT) counter_inst (
    .clk(clk),
    .reset_n(reset_n),
    .count(counter_addr)
  );
  
  // SineWave module to load test data from "binary_signal.txt".
  SineWave #(ADDR_WIDTH, DATA_WIDTH) sine_inst (
    .clk(clk),
    .r_addr(counter_addr),
    .r_data(sine_signal)
  );
  
  // Cutoff frequency step generator:
  // Sweeps cutoff_frequency from 1 Hz to 1 kHz in steps of 10 Hz,
  // holding each value for DWELL_CYCLES clock cycles.
  rc_step_generator #(
    .WIDTH(DATA_WIDTH),
    .RC_MIN(16'd1),     // Minimum cutoff frequency = 1 Hz
    .RC_MAX(16'd1000),  // Maximum cutoff frequency = 1000 Hz
    .RC_STEP(16'd10),   // Increment cutoff frequency by 10 Hz each step
    .DWELL_CYCLES(1000) // Hold each cutoff frequency value for 1000 clock cycles
  ) cutoff_sweep_inst (
    .clk(clk),
    .reset_n(reset_n),
    .rc(cutoff_frequency)
  );
  
  // Coefficient calculator computes:
  // α = (2π·fc)/(fs + 2π·fc)
  coefficient_calculator #(DATA_WIDTH, FRAC_WIDTH) coeff_calc_inst (
    .clk(clk),
    .rst(~reset_n),  // Inverting active-low reset for modules with active-high reset
    .sampling_frequency(sampling_frequency), // fs in Hz
    .cutoff_frequency(cutoff_frequency),     // fc in Hz (swept from 1 Hz to 1 kHz)
    .alpha(alpha)
  );
  
  // Variable lowpass filter module using the computed coefficient.
  variable_lowpass_filter #(DATA_WIDTH, FRAC_WIDTH) filter_inst (
    .clk(clk),
    .rst(~reset_n),
    .in_sample(sine_signal),
    .alpha(alpha),
    .out_sample(filter_out)
  );
  
  /////////////////////////////////////////////////////////
  /////////////// Clock Generator /////////////////////////
  /////////////////////////////////////////////////////////
  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end
  
  /////////////////////////////////////////////////////////
  ////////////// Simulation Control ///////////////////////
  /////////////////////////////////////////////////////////
  initial begin
    // Set the sampling frequency (in Hz); for example, 44100 Hz.
    sampling_frequency = 16'd44100;
    
    // Apply reset (active-low) for several clock cycles.
    reset_n = 1'b0;
    #(CLK_PERIOD * 10);
    reset_n = 1'b1;
    
    // Let the simulation run long enough to observe the cutoff frequency sweep and filter behavior.
    #(CLK_PERIOD * 1000000);
    $stop;
  end

endmodule
