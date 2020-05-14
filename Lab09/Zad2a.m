clear all; close all; clc;

%% Load signal
[x, fs] = audioread('mowa8000.wav');
x = x';

%% Filter the signal
h = zeros(1, 256);  % Original filter
h(31) = 0.1; h(121) = -0.5; h(256) = 0.8;
d = conv(x, h);     % Filter the signal

%% Estimate the filter coeffitients
M = 256;
mi = 0.04;
[~, ~, h_est] = my_adapt(M, mi, d, x);

figure; hold on;
stem(h); stem(h_est); legend('h-original', 'h-estimated');
