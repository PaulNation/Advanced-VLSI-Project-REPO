close all;
clear all;
pkg load signal;
pkg load communications;

% Parameters for the test signal
fs = 48000;             % Sampling frequency (Hz)
Ts = 1/fs;
n = 0:(48000-1);
t = n * Ts;
%t = linspace(0, 1, fs);  % Time vector for 1 second
f1 = 1000;              % Frequency of first sine wave (Hz)
f2 = 20000;             % Frequency of second sine wave (Hz)
bits=16;
% Generate the input signal: sum of two sine waves
data = 0.1*sin(2*pi*f1*t) + 0.1*sin(2*pi*f2*t);
%data_norm = data / max(abs(data));
data_quant = ((data * (2^bits-1))-1);
%data_int = dec2bin(data_quant, 32);
data_int = cast(data_quant, "int16");
% Scale factor for converting coefficients to 32-bit integers (using 24 bits for fraction)
scale_factor = 2^13;

% Define the list of cutoff frequencies: 1 kHz to 20 kHz in 1 kHz increments
fc_list = 1000:1000:20000;
num_filters = length(fc_list);

% Preallocate a matrix to store the filtered outputs for each filter.
% Each column corresponds to the output from one filter.
filtered_out = zeros(length(data), num_filters);

% Loop over each cutoff frequency to design the filter, quantize coefficients,
% recover them, and then filter the test signal.
for k = 1:num_filters
    fc = fc_list(k);

    % Design a 3th-order Butterworth low-pass filter (using 3 cascaded biquad sections)
    [b, a] = butter(3, fc/(fs/2));

    % Scale coefficients to signed 32-bit integer range
    b_int32 = fix(b * scale_factor)
    a_int32 = fix(a * scale_factor)

    % (Optional: You could convert these integers to two's complement binary strings here)

    % Recover coefficients back to floating point by dividing by the scale factor
    b_recovered = double(b_int32) / scale_factor;
    a_recovered = double(a_int32) / scale_factor;

    % Check stability by examining the poles of the filter (denom. coefficients)
    poles = roots(a_recovered);
    if all(abs(poles) < 1)
        disp(['Filter with cutoff frequency ', num2str(fc), ' Hz is stable.']);
    else
        disp(['Warning: Filter with cutoff frequency ', num2str(fc), ' Hz is unstable!']);
    end

    % Apply the filter to the input test signal
    filtered_out(:, k) = filter(b_recovered, a_recovered, data_int);
end

%% Plotting the Test Signal and Filtered Outputs
% Create a figure with subplots for each filtered output
figure;
for k = 1:num_filters
    %figure;
    subplot(5, 4, k);
    % Plot the original signal (dashed blue) for reference
    plot(t, data_int, 'b--', 'LineWidth', 1);
    hold on;
    % Plot the filtered output (solid red)
    plot(t, filtered_out(:, k), 'r-', 'LineWidth', 1.5);
    title(sprintf('fc = %d Hz', fc_list(k)));
    xlim([0, 0.01]);  % Display the first 10 milliseconds
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
end
S  = axes( 'visible', 'off', 'title', 'Filtered Outputs for 20 Butterworth Low-Pass Filters' );

% Open a text file for writing the 2's complement binary test vector (24 bits)
% fid = fopen('test_vector.txt', 'w');
% if fid == -1
%     error('Could not open file for writing.');
% end

% % For each sample, output a 24-bit two's complement binary representation.
% for k = 1:length(data_int)
%     val = data_int(k);
%     binStr = dec2bin(val, bits);
%     fprintf(fid, '%s\n', binStr);
% end

% fclose(fid);
% disp('Test vector file "test_vector.txt" generated successfully.');

