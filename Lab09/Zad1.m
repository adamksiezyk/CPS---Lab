clear all; close all; clc;

%% Generate signal
fs = 8e3;               % Sampling frequency
A1 = -0.5;  f1 = 34.2;  % 1-st component parameters
A2 = 1;     f2 = 115.5; % 2-nd component parameters
t = 0:1/fs:1-1/fs;      % Time vector

d = A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t);

%% Add noise [dB]
d10 = awgn(d, 10, 'measured');
d20 = awgn(d, 20, 'measured');
d40 = awgn(d, 40, 'measured');

%% Filter out noise
M = 50;     % Filter length
mi = 0.01;  % Adaptation speed coefficient

x10 = [d10(1), d10(1:end-1)];       % Signal to be filtered, shifted d signal
x20 = [d20(1), d20(1:end-1)];
x40 = [d40(1), d40(1:end-1)];

y10 = my_adapt(M, mi, d10, x10);    % Output signal
y20 = my_adapt(M, mi, d20, x20);
y40 = my_adapt(M, mi, d40, x40);

SNR10 = 10*log10(sum(d.^2)./sum((d-y10).^2));   % Calculate SNR
SNR20 = 10*log10(sum(d.^2)./sum((d-y20).^2));
SNR40 = 10*log10(sum(d.^2)./sum((d-y40).^2));

figure;
plot(t, d, 'b', t, d40, 'r', t, y40, 'm');
legend('dref-original', 'd-with noise', 'y-filtered');