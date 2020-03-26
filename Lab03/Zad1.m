%% DFT matrix
clear all; close all; clc;

N = 100;
n = 0:N-1;
k = 0:N-1;
A = 1/sqrt(N) * exp(-j*2*pi/N*k'*n);


%% Analyse signal

A1 = 100;   A2 = 200;               % Amplitude
f1 = 100;   f2 = 200;               % Frequency
fi1 = pi/7; fi2 = pi/11;            % Phase shift
fs = 1000;  t = 0:1/fs:(N-1)/fs;    % Sampling freq. and time vector

x = A1*cos(2*pi*f1*t + fi1) + A2*cos(2*pi*f2*t + fi2);  % Signal

X = A*x';   % Spectrum


%% Plot spectrum

%f = -fs/2:fs/N:fs/2-fs/N;
f = (0:N-1)*fs/N;

figure;
subplot(221); stem(f, real(X)); xlabel('f [Hz]'); title("Rel{X(f)}");
subplot(222); stem(f, imag(X)); xlabel('f [Hz]'); title('Im{X(f)}');
subplot(223); stem(f, abs(X)); xlabel('f [Hz]'); title('|X(f)|');
subplot(224); plot(f, unwrap(angle(X))); xlabel('f [Hz]'); title('Phase(X(f))');


%% Signal reconstruction

B = A';
xr = B*X;
Error = abs(xr'-x);
figure;
plot(t, x, 'b-o', t, xr', 'r-x'); title('Signal x - blue, reconstructed xr - red');


%% FFT

X = fft(x);
xr = ifft(X);
Error = abs(xr-x);
figure;
plot(t, x, 'b-o', t, xr, 'r-x');


%% New signal

f1 = 125;
x = A1*cos(2*pi*f1*t + fi1) + A2*cos(2*pi*f2*t + fi2);  % Signal
X = A*x';   % Spectrum
figure;
subplot(221); stem(f, real(X)); xlabel('f [Hz]'); title("Rel{X(f)}");
subplot(222); stem(f, imag(X)); xlabel('f [Hz]'); title('Im{X(f)}');
subplot(223); stem(f, abs(X)); xlabel('f [Hz]'); title('|X(f)|');
subplot(224); stem(f, angle(X)); xlabel('f [Hz]'); title('Phase(X(f))');