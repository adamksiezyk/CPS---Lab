close all;
clear all;

%% Data
fs = 1200;          % Sampling freq.
BW = 200;           % Bandwidth
fc = 300;           % Carrier freq.
N = 128;            % FIR length, the order must be even because odd-order symmetric
                    % FIR filters must have zero gain at the Nyquist freq.
f_start = fc+(BW);  % Start pass freq.
f_stop = fc-(BW);   % Stop pass freq.

%% Hamming window
figure; hold on;
b1 = fir1(N,[f_stop/(fs/2) f_start/(fs/2)],hamming(N+1));
[h1,f1] = freqz(b1,1,N,fs);
plot(f1,20*log10(abs(h1)));


%% Hanning window
b2 = fir1(N,[f_stop/(fs/2) f_start/(fs/2)],hanning(N+1));
[h2,f2] = freqz(b2,1,N,fs);
plot(f2,20*log10(abs(h2)));


%% Rectangle window
b3 = fir1(N,[f_stop/(fs/2) f_start/(fs/2)],boxcar(N+1));
[h3,f3] = freqz(b3,1,N,fs);
plot(f3,20*log10(abs(h3)));


%% Blackman window
b4 = fir1(N,[f_stop/(fs/2) f_start/(fs/2)],blackman(N+1));
[h4,f4] = freqz(b4,1,N,fs);
plot(f4,20*log10(abs(h4)));


%% Blackmana-Harris window
b5 = fir1(N,[f_stop/(fs/2) f_start/(fs/2)],blackmanharris(N+1));
[h5,f5] = freqz(b5,1,N,fs);
plot(f5,20*log10(abs(h5)));

%% Magnitude
xlim([0 600]);
legend('Hamming', 'Hanning', 'Rectangle', 'Blackman', 'Blackman-Harris');
title('H(f)-FIR filters');
xline(100, 'r'); xline(500, 'r'); yline(-3, 'r');

%% Phase
figure;
subplot(511); plot(f1, angle(h1)); title('FIR angle-Hamming');
subplot(512); plot(f1, angle(h2)); title('FIR angle-Hanning');
subplot(513); plot(f3, angle(h3)); title('FIR angle-Rectanle');
subplot(514); plot(f4, angle(h4)); title('FIR angle-Blackman');
subplot(515); plot(f5, angle(h5)); title('FIR angle-Blackman-Harris');

%% Signal
t = 0:1/fs:1-1/fs;
f1 = 50; f2 = 300; f3 = 550;
x = sin(2*pi*f1*t) + sin(2*pi*f2*t) + sin(2*pi*f3*t);
f = (0:length(t)-1)*fs/length(t);
X = fft(x);

%% Power spectral density
% Filter the signal
y1 = filter(b1, 1, x);  Y1 = fft(y1);   % Hamming
y2 = filter(b2, 1, x);  Y2 = fft(y2);   % Hanning
y3 = filter(b3, 1, x);  Y3 = fft(y3);   % Rectangle
y4 = filter(b4, 1, x);  Y4 = fft(y4);   % Blackman
y5 = filter(b5, 1, x);  Y5 = fft(y5);   % Blackman-Harris
figure; hold on;
plot(f, 20*log10(abs(X)));
plot(f, 20*log10(abs(Y1)));
plot(f, 20*log10(abs(Y2)));
plot(f, 20*log10(abs(Y3)));
plot(f, 20*log10(abs(Y4)));
plot(f, 20*log10(abs(Y5)));