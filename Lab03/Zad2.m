%% DtFT
clear all; close all; clc;

N = 100;
n = 0:N-1;
k = 0:N-1;
A = 1/N * exp(-j*2*pi/N*k'*n);

A1 = 100;   A2 = 200;               % Amplitude
f1 = 125;   f2 = 200;               % Frequency
fi1 = pi/7; fi2 = pi/11;            % Phase shift
fs = 1000;  t = 0:1/fs:(N-1)/fs;    % Sampling freq. and time vector

x = A1*cos(2*pi*f1*t + fi1) + A2*cos(2*pi*f2*t + fi2);  % Signal

X1 = A*x';   % Spectrum


%% Increse frequency resolution

M = 100;
xz = [x, zeros(1,M)];

X2 = fft(xz)./(N);

f = 0:0.25:1000;
X3 = sum(x'.*exp(-j*2*pi/fs*n'*f))/N;

fx1 = fs*(0:N-1)/N;
fx2 = fs*(0:N+M-1)/(N+M);
fx3 = f;

figure; hold on;
stem(fx1, X1);
stem(fx2, X2, 'b');
plot(fx3, X3, 'r');


%%
figure;
subplot(311); stem(fx1, X1); xlabel('f [Hz]'); title('X1(f)');
subplot(312); stem(fx2, X2); xlabel('f [Hz]'); title('X2(f)');
subplot(313); plot(fx3, X3, 'b-'); xlabel('f [Hz]'); title('X3(f)');


%% Plot

figure;
plot(fx1,X1,'o',fx2,X2,'bx',fx3,X3,'k-');


%% Change X3 frequency

f = -2*fs:0.25:2*fs;
fx3 = f;
X3 = sum(x'.*exp(-j*2*pi/fs*n'*f));
figure;
plot(fx1,X1,'o',fx2,X2,'bx',fx3,X3,'k-');