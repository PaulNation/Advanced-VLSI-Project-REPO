close all;
clear all;
pkg load signal;
pkg load communications;

% Sampling frequency and filter parameters
fs = 48000;
fc_list = 1000:1000:20000;  % 1 kHz to 20 kHz in 1 kHz increments
scale_factor = 2^13;

% Open file for writing SystemVerilog 3D array initializations
filename = 'sv_filter_coeffs_3d.txt';
fid = fopen(filename, 'w');
if fid == -1
    error('Cannot open file for writing: %s', filename);
end

% Loop over each cutoff frequency (each filter)
for filt_idx = 1:length(fc_list)
    fc = fc_list(filt_idx);
    % Design a 3th-order Butterworth low-pass filter using 3 cascaded biquads
    [b, a] = butter(3, fc/(fs/2));
    disp(['Filter with cutoff frequency ', num2str(fc)]);
    % Scale coefficients to signed 32-bit integer range
    %b_norm = b / abs(b(1));
    b_int32 = fix(b * scale_factor)
    %a_norm = a / abs(a(1));
    a_int32 = fix(a * scale_factor)

    % Write a comment for the current filter's cutoff frequency
    fprintf(fid, '// Filter %d: cutoff frequency = %d Hz\n', filt_idx-1, fc);

    % Output B coefficients (coefficient type index 0)
    for tap = 1:length(b_int32)
        fprintf(fid, 'mem[%d][0][%d] = %s;\n', filt_idx-1, tap-1, num2str(b_int32(tap)));
    end

    % Output A coefficients (coefficient type index 1)
    for tap = 1:length(a_int32)
        if (tap != length(a_int32))
            fprintf(fid, 'mem[%d][1][%d] = %s;\n', filt_idx-1, tap-1, num2str(a_int32(tap+1)));
        else
            fprintf(fid, 'mem[%d][1][%d] = %s;\n', filt_idx-1, tap-1, '0');
        endif
    end


    fprintf(fid, '\n'); % Blank line between filters
end

fclose(fid);
disp(['SystemVerilog 3D array initializations have been written to ', filename]);

