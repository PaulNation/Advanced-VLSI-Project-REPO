% Load the FIR coefficients from files
original_coeffs = load('fir_coeffs.txt');  % Load original (floating-point) coefficients
quantized_coeffs = load('quantized_coeffs.txt');  % Load quantized coefficients

% Normalize quantized coefficients (convert back from fixed-point format)
bits = 32;  % Ensure this matches the quantization in Python
scale_factor = 2^(bits - 1);
normalized_coeffs = quantized_coeffs / scale_factor;

% Compute frequency response for both sets of coefficients
[H_orig, w] = freqz(original_coeffs, 1, 1024);
[H_quant, ~] = freqz(normalized_coeffs, 1, 1024);

% Plot magnitude response comparison
figure;
plot(w / pi, 20 * log10(abs(H_orig)), 'k', 'LineWidth', 1.5); hold on;
plot(w / pi, 20 * log10(abs(H_quant)), 'r--', 'LineWidth', 1.5);
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
title('Frequency Response Comparison: Original vs Quantized FIR Filter');
legend('Original FIR', 'Quantized FIR (Q31)');
grid on;
