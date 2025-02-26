% FIR Lowpass Filter Design using firpm

N     = 100;   % Filter Order
Fpass = 0.2;   % Passband Frequency (normalized)
Fstop = 0.23;  % Stopband Frequency (normalized)
Astop = 80;    % Stopband Attenuation (dB)

% Frequency and amplitude vectors
f = [0 Fpass Fstop 1];  % Normalized frequencies
a = [1 1 0 0];          % Desired amplitude response

% Weight vector to control ripple
w = [1 10^(Astop/20)];  % Passband weight = 1, stopband weight = large

% Design the FIR filter
b = firpm(N, f, a, w);

% Plot frequency response
freqz(b, 1, 1024);

% Display filter coefficients
disp('FIR Lowpass Filter Coefficients:');
disp(b);