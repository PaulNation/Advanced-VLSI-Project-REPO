close all;
clear all;
pkg load signal;
pkg load communications;

% Parameters
fc = 1000;  % Cutoff frequency
fs = 48000; % Sampling frequency
t = linspace(0, 1, fs); % Time vector
f1 = 1000;  % Frequency of first sine wave
f2 = 20000; % Frequency of second sine wave

% Generate the input signal
data = sin(2 * pi * f1 * t) + sin(2 * pi * f2 * t);

% Design a 6th-order Butterworth low-pass filter
[b, a] = butter(1, fc / (fs / 2));

% Scale coefficients to the range of signed 32-bit integers
scale_factor = 2^24;
%b_norm = b / max(abs(b));
b_int32 = fix(b * scale_factor);

%a_norm = a / max(abs(a));
a_int32 = fix(a * scale_factor);

% Scale the 32-bit integer coefficients back to floating point values
% by dividing by the scale factor.
b_recovered = double(b_int32) / scale_factor ;
a_recovered = double(a_int32) / scale_factor ;


% Apply the filter to the data
filtered = filter(b_recovered, a_recovered, data);

% Plot the original and filtered signals
figure;
subplot(2, 1, 1);
plot(t, data);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0, 0.01]); % Display the first 10 milliseconds

subplot(2, 1, 2);
plot(t, filtered);
title('Filtered Signal with Quantized Coeffs');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0, 0.01]); % Display the first 10 milliseconds

% Plot the frequency response of the filter
figure;
freqz(b, a, 1024, fs);
title('Frequency Response of the Butterworth Low-Pass Filter');

% Normalize the data so that the maximum absolute value maps to 8388607 (2^23 - 1)
data_norm = data / max(abs(data));
data_int = int32(data_norm * (2^23 - 1));

% Open a text file for writing the 2's complement binary test vector (24 bits)
fid = fopen('test_vector.txt', 'w');
if fid == -1
    error('Could not open file for writing.');
end

% For each sample, output a 24-bit two's complement binary representation.
for k = 1:length(data_int)
    val = data_int(k);
    % For negative values, add 2^24 to get the two's complement representation.
    % if val < 0
    %     val = val + 2^24;
    % end
    binStr = dec2bin(val, 24);
    fprintf(fid, '%s\n', binStr);
end

fclose(fid);
disp('Test vector file "test_vector.txt" generated successfully.');

% Convert the quantized integer back to floating point for plotting.
% Multiply by max(abs(data))/(2^23 - 1) to recover the original amplitude scale.
data_quant = double(data_int) / (2^23 - 1) * max(abs(data));

% Plot comparison between original and quantized signals
figure;
plot(t, data, 'b', 'LineWidth', 1.5);
hold on;
plot(t, data_quant, 'r--', 'LineWidth', 1.5);
title('Comparison of Original Signal and Quantized Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal', 'Quantized Signal');
xlim([0, 0.01]); % Display the first 10 milliseconds
grid on;

