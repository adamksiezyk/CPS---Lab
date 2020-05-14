clear all; close all; clc;

[s, fs] = audioread('challenge10.wav');

[b1, a1] = butter(4, [690, 950]/(fs/2), 'bandpass');
[b2, a2] = butter(4, [1200, 1500]/(fs/2), 'bandpass');
s1 = filtfilt(b1, a1, s);
s2 = filtfilt(b2, a2, s);
ss = s1+s2;
%plot(ss);
PIN = estimatedft(ss, fs)

%'123456789*0#553382207431215#634593455227733029#9**43413392*45507007455'