%% Read audio
clear all; close all; clc;

[s, fs] = audioread('s.wav');
[s6, fs] = audioread('s6.wav');

%% Manual decoding
spectrogram(s6, 4096, 4096-512, [0:5:2000], fs);
% s6: 39335

%% Filter and decode
load('butter.mat');                                 % Load filter z-zeros, p-poles, k-gain
fs;                                                 % Sampling freq.                
f = 0:fs-1;                                         % Freq.
[b, a] = butter(4, [1100/(fs/2) 1500/(fs/2)], 'bandpass');  % Design the filter
s6f = filter(b, a, s6);                             % Filter the signal
spectrogram(s6f, 4096, 4096-512, [0:5:2000], fs);   % Show the spectrum
figure; hold on; plot(s6); plot(s6f);               