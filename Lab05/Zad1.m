%% Set the null points and pole points
clear all; close all; clc;

p = [-0.5+9.5*j, -1+10*j, -0.5+10.5*j]; p = [p, conj(p)];
z = [5*j, 15*j];                        z = [z, conj(z)];
% construct the polynomes
a = poly(p);
b = poly(z);
f = 0:0.01:4;    w = 2*pi*f; s = j*w;
H = polyval(b, s)./polyval(a, s);

%% Plot the null and pole points

figure;
plot(p, 'bo'); hold on; plot(z, 'rx'); xlim([-1.5 1.5]); ylim([-16 16]);
legend('Null points', 'Pole points'); xlabel('Re'); ylabel('Im'); grid on;

%% Plot the transmission function

figure;
subplot(211); plot(f, abs(H)); title('|H(f)|'); xlabel('f [Hz]');
subplot(212); plot(f, 20*log10(abs(H))); title('|H(f)| [dB]'); xlabel('f [Hz]');

%% Correct the plot

H2 = H./max(H);
figure;
subplot(211); plot(f, abs(H2)); title('|H2(f)|'); xlabel('f [Hz]');
subplot(212); plot(f, 20*log10(abs(H2))); title('|H2(f)| [dB]'); xlabel('f [Hz]');

%% Phase plot

figure; plot( f, unwrap(angle(H))); xlabel('f [Hz]'); title('Phase [rad]'); grid;