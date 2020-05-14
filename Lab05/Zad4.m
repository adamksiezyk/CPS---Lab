%% Design the low-pass filter with ZP
clear all; close all; clc;

fc = 1e5;   % cut-off freq.

% ZP design of LowPass filter
z = j*2*pi*[1e5];   z = [ z conj(z) ];
p = [];             p = [p, conj(p)];
b = poly(z); a = poly(p);
b = b / abs(polyval( b,0) / polyval( a,0) );

%% Butterworth low-pass filter
clear all; close all; clc;

w3dB = 1;
N = 8;
for k = 1:N
    p(k) = w3dB * exp(j*((pi/2)+(1/2)*(pi/N)+(k-1)*(pi/N)));
end
z = [];
a = poly(p);
b = poly(z);

%% Construct and plot the low-pass filter

w = 0:0.005:2; s = j*w;
H = polyval(b,s)./polyval(a,s);
H = H/max(H);
plot(w, 20*log10(abs(H))); title('|H(f)| [dB]'); xlabel('\omega [rad/s]');

%% Transform to band-pass filter

fc = 96e6;
fb = 1e5;
f = 95.8e6:96.2e6;  w = 2*pi*f; s = j*w;
w1 = 2*pi*(fc-fb);  w2 = 2*pi*(fc+fb);  w0 = sqrt(w1*w2);   dw = w2-w1;
[zz,pp,kk]=test(z,p,1,w0,dw);
bb = poly(zz);  aa = poly(pp);
H_BP = polyval(bb,s)./polyval(aa,s);
plot(20*log10(abs(H_BP)));