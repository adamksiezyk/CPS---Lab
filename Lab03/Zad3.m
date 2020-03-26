%% DtFT
clear all; close all; clc;

N = 100;
n = 0:N-1;
k = 0:N-1;

A1 = 1;   A2 = 0.0001;              % Amplitude
f1 = 100;   f2 = 125;               % Frequency
fi1 = pi/7; fi2 = pi/11;            % Phase shift
fs = 1000;  t = 0:1/fs:(N-1)/fs;    % Sampling freq. and time vector

x = A1*cos(2*pi*f1*t + fi1) + A2*cos(2*pi*f2*t + fi2);  % Signal

f = 0:0.1:500;
X = sum(x'.*exp(-j*2*pi/fs*n'*f)); % Spectrum

figure; plot(f, X); xlim([0 200]);


%% Window

% Init. windows
window_rect = boxcar(N)';
window_hamming = hamming(N)';
window_chebyshev100 = chebwin(N, 100)';
window_chebyshev140 = chebwin(N, 140)';
window_blackman = blackman(N)';

% Filter signals
x_rect = x .* window_rect;
x_hamming = x .* window_hamming;
x_chebyshev100 = x .* window_chebyshev100;
x_chebyshev140 = x .* window_chebyshev140;
x_blackman = x .* window_blackman;

% Spectrum of filtered signals
X_rect = sum(x_rect'.*exp(-j*2*pi/fs*n'*f));
X_hamming = sum(x_hamming'.*exp(-j*2*pi/fs*n'*f));
X_chebyshev100 = sum(x_chebyshev100'.*exp(-j*2*pi/fs*n'*f));
X_chebyshev140 = sum(x_chebyshev140'.*exp(-j*2*pi/fs*n'*f));
X_blackman = sum(x_blackman'.*exp(-j*2*pi/fs*n'*f));

% Plot filtered signals
figure;
subplot(2,5,1); plot(t, x_rect, 'b-', t, window_rect, 'r-'); title('Rectangular window');
subplot(2,5,2); plot(t, x_hamming, 'b-', t, window_hamming, 'r-'); title('Hamming window');
subplot(2,5,3); plot(t, x_chebyshev100, 'b-', t, window_chebyshev100, 'r-'); title('Chebyshev window 100 dB');
subplot(2,5,4); plot(t, x_chebyshev140, 'b-', t, window_chebyshev140, 'r-'); title('Chebyshev window 140 dB');
subplot(2,5,5); plot(t, x_blackman, 'b-', t, window_blackman, 'r-'); title('Blackman window');

% Plot spectrum of filtered signals
subplot(2,5,6); plot(f, X_rect); xlim([0 200]);
subplot(2,5,7); plot(f, X_hamming); xlim([0 200]);
subplot(2,5,8); plot(f, X_chebyshev100); xlim([0 200]);
subplot(2,5,9); plot(f, X_chebyshev140); xlim([0 200]);
subplot(2,5,10); plot(f, X_blackman); xlim([0 200]); pause;

% Plot all spectrums
clf;
plot(f, abs(X_rect), 'r-', f, abs(X_hamming), 'g-', f, abs(X_chebyshev100), 'b-', f, abs(X_chebyshev140), 'c-', f, X_blackman, 'm-');
legend('X_{rect}', 'X_{hamming}', 'X_{chebyshev100}', 'X_{chebyshev140}', 'X_{Blackman}');
xlim([0 200]);


%% Change samples number

N = 1000;
n = 0:N-1;
k = 0:N-1;
t = 0:1/fs:(N-1)/fs;
x = A1*cos(2*pi*f1*t + fi1) + A2*cos(2*pi*f2*t + fi2);
window_chebyshev100 = chebwin(N, 100)';
window_chebyshev140 = chebwin(N, 140)';
x_chebyshev100 = x .* window_chebyshev100;
x_chebyshev140 = x .* window_chebyshev140;
X_chebyshev100 = sum(x_chebyshev100'.*exp(-j*2*pi/fs*n'*f));
X_chebyshev140 = sum(x_chebyshev140'.*exp(-j*2*pi/fs*n'*f));

figure;
plot(f, abs(X_chebyshev100), 'b-', f, abs(X_chebyshev140), 'r-');
legend('X_{chebyshev100}', 'X_{chebyshev140}');
xlim([90 110]);