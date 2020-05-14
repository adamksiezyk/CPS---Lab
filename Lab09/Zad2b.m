clear all; close all; clc;

%% Load signals
[Sa, ~] = audioread('mowa_1.wav');      % Original signal from user A (to compare)
[Sb, ~] = audioread('mowa_2.wav');      % Received signal from user B
[SaGSb, fs] = audioread('mowa_3.wav');  % Signal form user A disturbed by the signal from user B

d = SaGSb;  % Reference signal
x = Sb;     % Input signal

%% Filter out signal Sb from Sa+G(Sb)
M = 15;                             % Filter length
mi = 0.6;                           % Adaptation speed coeffitient
[~, e, ~] = my_adapt(M, mi, d, x);  % Error vector

figure; hold on;
plot(Sa); plot(SaGSb); plot(e);
legend('Reference signal', 'Registered signal', 'Filtered signal');