N = 99; % 100 taps cause N+1
Fpass = 0.2; % Passband Frequency
Fstop = 0.23; % Stopband Frequency                                                                                         
Astop = 80;   % Stopband Attenuation (dB)

f = fdesign.lowpass('N,Fp,Fst,Ap',N, Fpass,Fstop,Astop);
lpFilter = design(f, 'equiripple','FilterStructure', 'dffir','SystemObject',true); % Lowpass

info(lpFilter)

lpFilter.FullPrecisionOverride=false;
lpFilter.CoefficientsDataType='Custom';
lpFilter.CustomCoefficientsDataType=numerictype(1,14,13);
lpFilter.OutputDataType='Same as Accumulator';
lpFilter.ProductDataType='Full precision';
lpFilter.AccumulatorDataType='Full precision';

measure(lpFilter,'Arithmetic','fixed')

% Plotting Freq
figure(1);
freqz(lpFilter);
title('Frequency Response of the Designed Lowpass Filter');



% For the above two-stage filtering operation our goal is to compare the filter output from MATLAB® with that from the generated HDL code.
% Plotting the input samples and the filtered output shows the lowpass and highpass behavior.
figure(2);
x = chirp(0:199,0,199,0.4);

lpcoeffs = lpFilter.Numerator;            % store original lowpass coefficients
y1 = lpFilter(fi(x,1,14,13).');           % filter the signal

subplot(2,1,1);plot([x,x]);
xlabel('Time [samples]');ylabel('Amplitude'); title('Input Stimulus');
subplot(2,1,2);plot(y1);
xlabel('Time [samples]');ylabel('Amplitude'); title('Filtered Output');

%As the symmetric structure is selected, the field 'TestbenchCoeffStimulus'
% has to be the half of length of filter.

workingdir = 'C:\Users\nievep\Downloads\Advanced VLSI Design\Project 1\REPO\Advanced-VLSI-Project-REPO\Project 1\MatlabFilterCalculation\Filter2 V2';

generatehdl(lpFilter,'Name','FilterProgrammable', ...
                 'InputDataType',numerictype(1,14,13), ...
                 'TargetLanguage','Verilog', ...
                 'TargetDirectory',workingdir, ...
                 'CoefficientSource','ProcessorInterface', ...
                 'GenerateHDLTestbench','on', ...
                 'TestBenchUserStimulus',x, ...
                 'TestbenchCoeffStimulus',lpFilter.Numerator);