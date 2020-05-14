%% Parameters
clear all; close all; clc;

fs = 256000;
fc = fs/2;
N = 4;
f = 0:fs-1;   w = 2*pi*f; s = j*w;

% Filters
[z1, p1, k1] = butter(6, 0.25);         % N-order, fc=64kHz/fs=0.25
[z2, p2, k2] = cheby1(4, 3, 0.25);      % 3dB-max attenuation in passband
[z3, p3, k3] = cheby2(4, 40, 0.5);      % fc=128kHz/fs=0.5 40db-min attenuation in stopband
[z4, p4, k4] = ellip(3, 3, 40, 0.25);

[b1, a1] = zp2tf(z1,p1,k1);
[b2, a2] = zp2tf(z2,p2,k2);
[b3, a3] = zp2tf(z3,p3,k3);
[b4, a4] = zp2tf(z4,p4,k4);

H1 = freqz(b1, a1,fs);
H2 = freqz(b2, a2,fs);
H3 = freqz(b3, a3,fs);
H4 = freqz(b4, a4,fs);

%% Plot attenuation

figure; hold on; title('Filters [dB]'); xlabel('f [MHz]'); grid; xlim([0 256]); ylim([-200 10]);
plot(f/1000, 20*log10(abs(H1)));
plot(f/1000, 20*log10(abs(H2)));
plot(f/1000, 20*log10(abs(H3)));   
plot(f/1000, 20*log10(abs(H4))); legend('Butterworth', 'Chebyshev 1', 'Chebyshev 2', 'Ellip');
xline(128,'r'); xline(64, 'r'); yline(-3,'r'); yline(-40,'r');

%% Plot poles

figure;
subplot(221); plot(p1, 'o'); grid; xlim([-1 1]); ylim([-1 1]); xline(0); yline(0);
subplot(222); plot(p2, 'o'); grid; xlim([-1 1]); ylim([-1 1]); xline(0); yline(0);
subplot(223); plot(p3, 'o'); grid; xlim([-1 1]); ylim([-1 1]); xline(0); yline(0);
subplot(224); plot(p4, 'o'); grid; xlim([-1 1]); ylim([-1 1]); xline(0); yline(0);