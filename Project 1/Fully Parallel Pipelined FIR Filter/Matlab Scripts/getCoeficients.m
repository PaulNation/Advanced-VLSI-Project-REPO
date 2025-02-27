% Define filter specifications:
N = 127;        % 128 taps cause N+1
Fpass = 0.2;    % Passband Frequency
Fstop = 0.23;   % Stopband Frequency                                                                                         
Astop = 80;     % Stopband Attenuation (dB)

% Design the FIR filter using equiripple method
f = fdesign.lowpass('N,Fp,Fst,Ap', N, Fpass, Fstop, Astop);
lpFilter = design(f, 'equiripple', 'FilterStructure', 'dffir', 'SystemObject', true); % Direct form FIR

% Display filter info:
info(lpFilter)

% Plot the frequency response
figure(1);
freqz(lpFilter);
title('Frequency Response of the Designed Lowpass Filter');

% Create a chirp signal as input
figure(2);
x = chirp(0:199, 0, 199, 0.4);
fileID = fopen('chirp_output.txt', 'w');  % Open file for writing
fprintf(fileID, '%f\n', x);  % Write each value on a new line
fclose(fileID);  % Close the file


% Get the filter coefficients (taps)
lpcoeffs = lpFilter.Numerator;  % 128 taps
% When filtering, also use 16-bit signed fixed-point input (Q1.15)
y1 = lpFilter(fi(x, 1, 32).');  



% Plot input stimulus and filtered output
subplot(2,1,1);
plot(x);
xlabel('Time [samples]'); ylabel('Amplitude'); 
title('Input Stimulus');

subplot(2,1,2);
plot(y1);
xlabel('Time [samples]'); ylabel('Amplitude'); 
title('Filtered Output');



% Write the taps to a text file (one per line)
fid = fopen('lpFilterTaps.txt', 'w');
if fid == -1
    error('Cannot open file for writing.');
end

% Write coefficients in binary format
original_coeffs = lpFilter.Numerator;  % Original coefficients
%q = quantizer;
%q_coeffs = quantize(q,original_coeffs);

fid = fopen('lpFilterTaps.txt', 'w');  % Open file for writing
fprintf(fid, '%f\n', original_coeffs);  % Write each value on a new line
fclose(fid);  % Close the file