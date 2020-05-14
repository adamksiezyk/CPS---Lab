%% Butterworth filter
clear all; close all; clc;

w3dB = 2*pi*100;
figure;
for N = [2 4 6 8]
    for k = 1:N
        p(k) = w3dB * exp(j*((pi/2)+(1/2)*(pi/N)+(k-1)*(pi/N)));
    end
    z = [];
    a = poly(p);
    b = poly(z);
    f = 0:1000; w = 2*pi*f; s = j*w;
    H = polyval(b,s)./polyval(a,s);
    H2 = H/max(H);
    subplot(311); plot(f, 20*log10(abs(H2))); title('|H(f)| [dB]'); xlabel('f [hz]'); hold on;
    subplot(312); semilogx(f,20*log10(abs(H2))); title('|H(f)| [dB]'); xlabel('f [hz]'); hold on;
    subplot(313); plot(f, angle(H2)); title('Phase [rad]'); hold on;
end

%% Impulse and step response

N = 4;
k = 1:N;
w3dB = 2*pi*100;
p = w3dB * exp(j*((pi/2)+(1/2)*(pi/N)+(k-1)*(pi/N)));
z = [];
b = poly(z);
a = poly(p);
H_4 = tf(b,a);
figure;
subplot(211); impulse(H_4); title('Impulse response h(t)');
subplot(212); step(H_4); title('Step response h_{E}(t)');