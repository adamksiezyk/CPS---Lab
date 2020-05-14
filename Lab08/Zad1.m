%% Load the signal
clear all; close all; clc;

x = load('lab08_am.mat').s9;    % Signal

%% Generate Hilbert filter
fs = 1000;          % Sampling freq.
fc = 200;           % Carrier freq.
t = 0:1/fs:1-1/fs;  % Time vector
M = 64;             % Half of the filter length
N = 2*M+1;          % Filter length
n = -M:M;           % Samples
h=(1-cos(pi*n))./(pi*n); h(M+1)=0;  % Filter impulse response
figure; subplot(311); stem(n, h); title('Hilbert filter impulse response');

%% Generate blackman window
w = blackman(2*M+1)';   % Window
h = h.*w;             % Use window on filter
subplot(312); stem(n, w); title('Blackman window');
subplot(313); stem(n, h); title('Hilbert filter impulse response with Blackman windowa');

%% Demodulate the signal
y = conv(x, h);                 % Filter the signal
y = y(M+1:end-M);               % Delete samples
m = sqrt(x.^2 + y.^2);          % Modulating signal
Sm = fft(m)/length(m);          % Spectrum of modulating signal
Sm(2:end) = 2*Sm(2:end);        % Correct the amplitude for harmonics
f = (0:length(Sm)-1)*fs/length(Sm);
figure; plot(f, abs(Sm)); title('Modulating signal spectrum');

A1 = 0.5; A2 = 0.2; A3 = 0.3;  % Read the coeffs
f1 = 4; f2 = 90; f3 = 100;
mr = 1 + A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t) + A3*cos(2*pi*f3*t); % Reconstructed m

figure; hold on;
plot(t, m, 'b', t, mr, 'r');
legend('Modulating signal', 'Reconstructed modulating signal');

xc = cos(2*pi*fc*t);                    % Carrier signal
xr = mr.*xc;                            % Reconstructed x
figure;
plot(t, x, 'b', t, xr, 'r');