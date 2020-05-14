clear all; close all; clc;

%% Load signals
[x1, fs1] = audioread('x1.wav'); x1 = x1(:, 1)';
[x2, fs2] = audioread('x2.wav'); x2 = x2';
fs = 48e3;  % Output sampling frequency

%% Resample the 1-st signal
[p1, q1] = rat(fs/fs1); % Sampling ratio
x1 = interp(x1, p1);    % Interpolate fs1 -> fs1*p1
x1 = decimate(x1, q1);  % Decimate fs1*p1 -> fs1*p1/q1

%% Resample the 2-nd signal
[p2, q2] = rat(fs/fs2); % Sampling ratio
x2 = interp(x2, p2);    % Interpolate fs2 -> fs2*p2
x2 = decimate(x2, q2);  % Decimate fs2*p2 -> fs2*p2/q2

%% Mix the signals
x = x1;
k = length(x2);
x(1:k) = x1(1:k) + x2;
sound(x, fs);