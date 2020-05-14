clear all; close all; clc;

%% Generate signals
f1 = 1001.2; f2 = 303.1; f3 = 2110.4;                               % Frequencies
fs1 = 8e3; fs2 = 32e3; fs3 = 48e3;                                  % Sampling freq.
t1 = 0:1/fs1:1-1/fs1; t2 = 0:1/fs2:1-1/fs2; t3 = 0:1/fs3:1-1/fs3;   % Time vectors
x1 = sin(2*pi*f1*t1); x2 = sin(2*pi*f2*t2); x3 = sin(2*pi*f3*t3);   % Signals
x4 = sin(2*pi*f1*t3) + sin(2*pi*f2*t3) + sin(2*pi*f3*t3);           % Original sum

figure; hold on;
plot(t1, x1); plot(t2, x2); plot(t3, x3); xlim([0, 1/f3]); xlabel('t [s]');
legend(sprintf('%.1f Hz', f1), sprintf('%.1f Hz', f2), sprintf('%.1f Hz', f3));

%% Upsampling
%x1_up = upsample(x1, fs3/fs1);                          % 8kHz(*6)->48kHz
%x2_up = upsample(x2, 3); x2_up = decimate(x2_up, 2);    % 32kHz(*3)->96kHz(/2)->48kHz
[p1, q1] = rat(fs3/fs1);
[p2, q2] = rat(fs3/fs2);
x1_up = zeros(1, p1*length(x1));
x2_up = zeros(1, p2*lengt
x4_up = x1_up + x2_up + x3;                             % Sum of upsumpled

figure;
plot(t3, x4, 'b', t3, x4_up, 'r'); xlim([0 1/f3]); legend('Analytic', 'Upsampled');

%% Interpolation
N = 256;
b1 = fir1(N, f1/(fs3/2));
b2 = fir1(N, f2/(fs3/2));
x1_int = filter(b1, 1, x1_up);
x2_int = filter(b2, 1, x2_up);
x1_int = x1_int(N/2:end); x1_int(end+1:end+N/2-1) = zeros(1, N/2-1);
x2_int = x2_int(N/2:end); x2_int(end+1:end+N/2-1) = zeros(1, N/2-1);
x1_int = x1_int/max(x1_int);
x2_int = x2_int/max(x2_int);
x4_int = x1_int + x2_int + x3;

figure;
plot(t3, x4, 'b', t3, x4_int, 'r'); xlim([0 1/f3]); legend('Analytic', 'Interpolated');

%% Compare spectrums
X4 = fft(x4); X4_up = fft(x4_up); X4_int = fft(x4_int);
figure;
subplot(311); plot(abs(X4)); title('X4');
subplot(312); plot(abs(X4_up)); title('X4_{up}');
subplot(313); plot(abs(X4_int)); title('X4_{int}');

%% Interpolation using matlab function
x1_int = interp(x1, fs3/fs1);
x2_int = interp(x2, 3); x2_int = decimate(x2_int, 2);
x4_int = x1_int + x2_int + x3;

figure;
plot(t3, x4, 'b', t3, x4_int, 'r'); xlim([0 1/f3]); legend('Analytic', 'Interpolated');