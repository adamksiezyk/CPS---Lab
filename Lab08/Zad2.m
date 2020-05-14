%% Params
clear all; close all; clc;

fs = 400e3;                                             % Sampling freq.
fc1 = 100e3;                                            % Station 1 carrier freq.
fc2 = 110e3;                                            % Station 2 carrier freq.
[x1, fs1] = audioread('mowa8000.wav'); x1 = x1';        % 1-st signal
x2 = x1(end:-1:1); fs2 = fs1;                           % 2-nd signal
x1 = resample(x1, fs, fs1); x2 = resample(x2, fs, fs2); % Resample the signals
t = 0:1/fs:length(x1)/fs-1/fs;                          % Time vectors
dA = 0.25;                                              % Modulation depth

%% DSB-C
y1 = (1+dA*x1).*cos(2*pi*fc1*t);    % Station 1
y2 = (1+dA*x2).*cos(2*pi*fc2*t);    % Station 2
y_DSB_C = y1+y2;                    % Radio signal

%% DSB-SC
y1 = x1.*cos(2*pi*fc1*t);  % Station 1
y2 = x2.*cos(2*pi*fc2*t);  % Station 2
y_DSB_SC = dA*(y1+y2);     % Radio signal

%% SSB-SC
x1h = myHilbert(x1);                        % Hilbert transform
x2h = myHilbert(x2);
y1 = x1h.*exp(j*2*pi*fc1*t); y1 = real(y1); % Station 1
y2 = x2h.*exp(j*2*pi*fc2*t); y2 = real(y2); % Station 2
y_SSB_SC = dA*(y1+y2);                      % Radio signal

%% Spectrums
Y_DSB_C = fft(y_DSB_C);
Y_DSB_SC = fft(y_DSB_SC);
Y = fft(y_SSB_SC);

f = (0:length(Y_DSB_C)-1)/length(Y_DSB_C)*fs;   % Scale freq.

figure;
subplot(311); plot(f, abs(Y_DSB_C)); title('DSC-C');
subplot(312); plot(abs(Y_DSB_SC)); title('DSB-SC');
subplot(313); plot(abs(Y)); title('SSB-SC');
%% Demodulate DSB-C
y = y_DSB_C;                    % Choose signal
b1 = fir1(256, 105e3/(fs/2));   % FIR filter for 1-st station
y1 = filter(b1, 1, y);          % 1-st station signal
y1 = y1(256/2:end); y1(end+1:end+256/2-1) = zeros(1, 256/2-1);  % Delay compensate
y1h = myHilbert(y1);            % Hilbert transform
m1 = abs(y1h);                  % Demodulate
m1 = (m1-1)/dA;                 % Correct the amplitude
figure; plot(t, x1, 'b', t, m1, 'r');
m1 = decimate(m1, fs/fs1);      % Decimate the audio signal
%soundsc(m1, fs1);               % Play sound

b2 = fir1(256, 105e3/(fs/2), 'high');   % FIR filter for 2-nd station
y2 = filter(b2, 1, y);                  % 2-nd station signal
y2 = y2(256/2:end); y2(end+1:end+256/2-1) = zeros(1, 256/2-1);  % Delay compensate
y2h = myHilbert(y2);                    % Hilbert transform
m2 = abs(y2h);                          % Demodulate
m2 = (m2-1)/dA;                         % Correct the amplitude
figure; plot(t, x2, 'b', t, m2, 'r');
m2 = decimate(m2, fs/fs2);              % Decimate the audio signal
m2 = m2(end:-1:1);                      % Reverse the signal    
%soundsc(m2, fs2);                       % Play sound

%% Demodulate DSB-SC
y = y_DSB_SC;                               % Choose signal
b1 = fir1(256, 105e3/(fs/2));               % FIR filter for 1-st station
y1 = filter(b1, 1, y);                      % 1-st station signal
y1 = y1(256/2:end); y1(end+1:end+256/2-1) = zeros(1, 256/2-1);  % Delay compensate
y1h = myHilbert(y1);                        % Hilbert transform
m1 = real(y1h.*exp(-j*2*pi*fc1*t));         % Demodulate
m1 = m1/dA;                                 % Correct amplitude
figure; plot(t, x1, 'b', t, m1, 'r');
m1 = decimate(m1, fs/fs1);                  % Decimate the audio signal
%soundsc(m1, fs1);                           % Play sound

b2 = fir1(256, 105e3/(fs/2), 'high');       % FIR filter for 2-nd station
y2 = filter(b2, 1, y);                      % 2-nd station signal
y2 = y2(256/2:end); y2(end+1:end+256/2-1) = zeros(1, 256/2-1);  % Delay compensate
y2h = myHilbert(y2);                        % Hilbert transform
m2 = real(y2h.*exp(-j*2*pi*fc2*t));         % Demodulate
m2 = m2/dA;                                 % Correct amplitude
figure; plot(t, x2, 'b', t, m2, 'r');
m2 = decimate(m2, fs/fs1);                  % Decimate the audio signal
m2 = m2(end:-1:1);                          % Reverse the signal    
%soundsc(m2, fs1);                           % Play sound

%% Demodulate SSB-SC
y = y_SSB_SC;                               % Choose signal
b1 = fir1(256, 105e3/(fs/2));               % FIR filter for 1-st station
y1 = filter(b1, 1, y);                      % 1-st station signal
y1 = y1(256/2:end); y1(end+1:end+256/2-1) = zeros(1, 256/2-1);  % Delay compensate
y1h = myHilbert(y1);                        % Hilbert transform
m1 = real(y1h.*exp(-j*2*pi*fc1*t));         % Demodulate
figure; plot(t, x1, 'b', t, m1, 'r');
m1 = decimate(m1, fs/fs1);                  % Decimate the audio signal
%soundsc(m1, fs1);                           % Play sound

b2 = fir1(256, 105e3/(fs/2), 'high');       % FIR filter for 2-nd station
y2 = filter(b2, 1, y);                      % 2-nd station signal
y2 = y2(256/2:end); y2(end+1:end+256/2-1) = zeros(1, 256/2-1);  % Delay compensate
y2h = myHilbert(y2);                        % Hilbert transform
m2 = real(y2h.*exp(-j*2*pi*fc2*t));         % Demodulate
figure; plot(t, x2, 'b', t, m2, 'r');
m2 = decimate(m2, fs/fs1);                  % Decimate the audio signal
m2 = m2(end:-1:1);                          % Reverse the signal    
%soundsc(m2, fs1);                           % Play sound

%% Two SSB-SC stations on one carrier
% Modulate
x1h = myHilbert(x1);                            % Hilbert transform
x2h = myHilbert(x2);
y1 = x1h.*exp(j*2*pi*fc1*t); y1 = real(y1);     % Station 1
y2 = x2h.*exp(-j*2*pi*fc1*t); y2 = real(y2);    % Station 2
y = dA*(y1+y2);                                 % Radio signal
Y = fft(y);                                     % Spectrum
f = (0:length(Y)-1)/length(Y)*fs;               % Scale freq.
figure; plot(f, abs(Y)); title('SSB-SC');

% Demodulate
N = 256;                                        % Filter length
b1 = fir1(N, 100e3/(fs/2), 'high');             % Filter for 1-st station
b2 = fir1(N, 100e3/(fs/2));                     % Filter for 2-nd station
y1r = filter(b1, 1, y);                         % 1-st station signal
y2r = filter(b2, 1, y);                         % 2-nd station signal
y1r = y1r(N/2:end); y1r(end+1:end+N/2-1) = zeros(1, N/2-1); % Compensate delay
y2r = y2r(N/2:end); y2r(end+1:end+N/2-1) = zeros(1, N/2-1);
y1h = myHilbert(y1r);                           % Hilbert transform
y2h = myHilbert(y2r);
m1 = real(y1h.*exp(-j*2*pi*fc1*t));             % Demodulate
m2 = real(y2h.*exp(-j*2*pi*fc1*t));
m1 = m1./std(m1);
m2 = m2./std(m2);
x1 = x1./std(x1);
x2 = x2./std(x2);
figure; plot(t, x1, 'b', t, m1, 'r', t, x2+2, 'm');
figure; plot(t, x2, 'b', t, m2, 'r');
m1 = decimate(m1, fs/fs1);                      % Decimate the audio signal
m2 = decimate(m2, fs/fs1);
m2 = m2(end:-1:1);                              % Reverse the 2-nd station
%sound(m1, fs1);                                 % Play audio
%sound(m2, fs2);