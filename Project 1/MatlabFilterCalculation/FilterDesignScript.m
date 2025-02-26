% 0.039062*pi (rad/sample) * 1 Hz / 2pi (rad/sample)
Fpass_Hz  = 0.2*pi / (2*pi);
Fstop_Hz  = 0.23*pi / (2*pi);
%N-taps
N=100;

% Stopband attenuation (dB)
Ast = 80;

%load('FilterDesign.fda', '-mat');  % Load the filter design variables
filterDesigner;