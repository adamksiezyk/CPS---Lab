%% Load analog filter data
clear all; close all; clc;

load('butter.mat'); % Load analog filter z-zeros, p-poles, k-gain
f1 = 1189;          % BP start freq.
f2 = 1229;          % BP stop freq.
fs = 16e3;          % Sampling freq.
f = 0:fs-1;    w = 2*pi*f;

%% Transform the analog into a digital filter
[zz, pp, kk] = bilinear(z,p,k,fs);


%% Construct the analog and digital filter
[b,a] = zp2tf(z,p,k);
[bb,aa] = zp2tf(zz,pp,kk);
H_s = freqs(b,a,w);         temp_s = 20*log10(abs(H_s));
H_z = freqz(bb,aa,f,fs);    temp_z = 20*log10(abs(H_z));

%% Plot
figure;
plot(f, 20*log10(abs(H_s)), 'b', f, 20*log10(abs(H_z)), 'm');
xlim([1130 1270]); legend('|H(s)| [dB]', '|H(z)| [dB]'); xlabel('f [Hz]');
xline(f1, 'k', 'f_{start}'); xline(f2, 'k', 'f_{stop}'); yline(-3, 'k', '-3 dB');

%% Generate signal
t = 0:1/fs:1-1/fs;      % Time vector
f1 = 1209; f2 = 1272;   % Signal freq.
x1 = sin(2*pi*f1*t);    x2 = sin(2*pi*f2*t);
x = x1 + x2;

%% Filter the signal
b1 = bb;        M = length(bb); % number of {b} coefficients
a1 = aa(2:end); N = length(a1); % number of {a} coeffs, remove a0=1, weight of y(n)
bx = zeros(1,M);                % buffer for input samples x(n)
by = zeros(1,N);                % buffer for output samples y(n)
y1 = zeros(1,fs);               % preallocate y1

for n = 1:length(x)                     % MAIN LOOP
    bx = [x(n), bx(1:M-1)];             % put new x(n) into bx buffer
    y1(n) = sum(bx.*b1)-sum( by.*a1);   % do filtration, find y(n)
    by = [y1(n), by(1:N-1)];            % put y(n) into by buffer
end

X = abs(fft(x, fs));
Y1 = abs(fft(y1, fs));

figure;
subplot(221); plot(f, 20*log10(X));
subplot(222); plot(f, 20*log10(Y1));
subplot(223); plot(t, x); xlim([0, 0.08]);
subplot(224); plot(t, y1); xlim([0, 0.08]);

%% Filter the signal using filter()
y2 = filter(bb, aa, x);
error = y2-y1;
figure; plot(t, y1, 'b-o', t, y2, 'r-x', t, error, 'k'); xlim([0, 0.04]);

%% Correct the analog filter

% Digital requirements
f1 = 1189;
f2 = 1229;
fs = 16e3;
f = 0:fs-1;   w = 2*pi*f;

% Analog requirements
f1 = 2*fs*tan(pi*f1/fs)/(2*pi);
f2 = 2*fs*tan(pi*f2/fs)/(2*pi);
w0 = 2*pi*sqrt(f1*f2);
dw = 2*pi*(f2-f1);

% Build the analog filter
[b,a] = butter(4, 1, 's');
[b,a] = lp2bp(b, a, w0, dw);
H_s = freqs(b, a, w);
z = roots(b); p = roots(a); k = 1/max(H_s);
figure; subplot(121); plot(f, temp_s, 'b', f, 20*log10(abs(H_s)), 'm');
xlim([1130 1300]); legend('|H(s)|-original', '|H(s)|-transform'); xlabel('f [Hz]');
xline(1189, 'k', 'f_{start}'); xline(1229, 'k', 'f_{stop}'); yline(-3, 'k', '-3 dB');

% Conversion from analog to digital filter
[zz, pp, kk] = bilinear(z, p, k, fs);
[bb, aa] = zp2tf(zz, pp, kk);
H_z = freqz(bb, aa, f, fs); H_z = H_z/max(H_z);
subplot(122); plot(f, temp_z, 'b', f, 20*log10(abs(H_z)), 'm');
xlim([1130 1300]); legend('|H(b)|-original', '|H(z)|-transform'); xlabel('f [Hz]');
xline(1189, 'k', 'f_{start}'); xline(1229, 'k', 'f_{stop}'); yline(-3, 'k', '-3 dB');