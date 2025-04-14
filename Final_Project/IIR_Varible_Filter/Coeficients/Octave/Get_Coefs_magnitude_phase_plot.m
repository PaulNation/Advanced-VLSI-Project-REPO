close all;
clear all;
pkg load signal;
pkg load communications;

% Sampling frequency and filter parameters
fs = 48000;
fc_list = 1000:1000:20000;  % 1 kHz to 20 kHz in 1 kHz increments
scale_factor = 2^13;

% Prepare the figure with two subplots:
figure;

% Create subplot for magnitude responses (in dB)
subplot(2,1,1);
hold on;
title('Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;

% Create subplot for phase responses (in degrees)
subplot(2,1,2);
hold on;
title('Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (deg)');
grid on;

% Define a colormap for differentiating curves
colors = hsv(length(fc_list));

% Loop over each cutoff frequency (each filter)
for filt_idx = 1:length(fc_list)
    fc = fc_list(filt_idx);

    % Design a 3rd-order Butterworth low-pass filter
    [b, a] = butter(3, fc/(fs/2));
    % Scale coefficients to signed 32-bit integer range
    b_int32 = fix(b * scale_factor)
    a_int32 = fix(a * scale_factor)
    % Scale back
    b_recovered = double(b_int32) / scale_factor;
    a_recovered = double(a_int32) / scale_factor;

    % Compute frequency response
    [H, w] = freqz(b_recovered, a_recovered, 1024, fs);

    % Convert magnitude to dB and phase to degrees
    mag = 20*log10(abs(H));
    ph  = unwrap(angle(H)) * 180/pi;

    % Plot the magnitude response
    subplot(2,1,1);
    plot(w, mag, 'Color', colors(filt_idx,:), 'LineWidth', 1.2);

    % Plot the phase response
    subplot(2,1,2);
    plot(w, ph, 'Color', colors(filt_idx,:), 'LineWidth', 1.2);
end

% Add legends indicating each filter's cutoff frequency with a smaller font size
legendLabels = arrayfun(@(x) sprintf('Cutoff = %d Hz', x), fc_list, 'UniformOutput', false);

subplot(2,1,1);
hleg = legend(legendLabels, 'Location', 'East');
set(hleg, 'FontSize', 8);  % Adjust the font size to 8 (or your desired size)

subplot(2,1,2);
hleg2 = legend(legendLabels, 'Location', 'East');
set(hleg2, 'FontSize', 8);  % Adjust the font size similarly

hold off;
