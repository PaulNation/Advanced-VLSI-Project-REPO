close all;
clear all;
pkg load signal;
pkg load communications;

% Parameters
fc = 1000;   % Cutoff frequency
fs = 48000;  % Sampling frequency

% Design a 6th-order Butterworth low-pass filter
[b, a] = butter(3, fc / (fs / 2))

% Scale coefficients to the range of signed 32-bit integers
scale_factor = 2^24;
%b_norm = b / max(abs(b));
b_int32 = fix(b * scale_factor)

%a_norm = a / max(abs(a));
a_int32 = fix(a * scale_factor)

% Convert coefficients to 32-bit two's complement binary strings.
% For negative numbers, add 2^32 to convert to two's complement.
b_bin_cell = cell(1, length(b_int32));
for i = 1:length(b_int32)
    val = b_int32(i);
    b_bin_cell{i} = dec2bin(val, 32);
end
b_bin_str = strjoin(b_bin_cell, ', ');

a_bin_cell = cell(1, length(a_int32));
for i = 1:length(a_int32)
    val = a_int32(i);
    a_bin_cell{i} = dec2bin(val, 32);
end
a_bin_str = strjoin(a_bin_cell, ', ');

% Create output strings with labels
numerator_str = ['B: ' b_bin_str];
denominator_str = ['A: ' a_bin_str];

% Write the coefficients to a text file
filename = 'filter_coefficients_binary.txt';
fid = fopen(filename, 'w');
if fid == -1
    error('Cannot open file for writing: %s', filename);
end
fprintf(fid, '%s\n%s\n', numerator_str, denominator_str);
fclose(fid);

disp(['Filter coefficients have been written to ', filename]);

% Scale the 32-bit integer coefficients back to floating point values
% by dividing by the scale factor.
b_recovered = double(b_int32) / scale_factor ;
a_recovered = double(a_int32) / scale_factor ;

% (Optional) Compute frequency responses for verification using the recovered coefficients
[H_orig, w] = freqz(b, a, 1024, fs);
H_recovered = freqz(b_recovered, a_recovered, 1024, fs);

% Plot magnitude and phase responses for comparison
figure;
subplot(2, 1, 1);
plot(w, 20*log10(abs(H_orig)), 'b', 'DisplayName', 'Original');
hold on;
plot(w, 20*log10(abs(H_recovered)), 'r--', 'DisplayName', 'Recovered');
title('Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend show;
grid on;

subplot(2, 1, 2);
plot(w, angle(H_orig), 'b', 'DisplayName', 'Original');
hold on;
plot(w, angle(H_recovered), 'r--', 'DisplayName', 'Recovered');
title('Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
legend show;
grid on;

figure;
zplane(b_int32,a_int32);
hold on;
title('zplane');
