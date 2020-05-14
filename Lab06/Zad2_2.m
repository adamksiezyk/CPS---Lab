%% Construct band-pass filters for the required frequencies
clear all; close all; clc;

[s, fs] = audioread('s.wav');
f = 0:0.5:fs/2-1;
f_patterns = [697, 770, 852, 941, 1209, 1336, 1477];    % Pattern freq.
N = length(f_patterns);
z = [];
b = poly(z);
a = zeros(N, 3);
H = zeros(N, length(f));
figure; hold;
for i = 1:N
    p = 0.99*exp(j*2*pi*f_patterns(i)/fs);  p = [p conj(p)];
    a(i, :) = poly(p);
    H = freqz(b, a(i, :), f, fs);   H = H/max(H);
    plot(f, 20*log(abs(H)));
end

grid; xlim([600 1500]); title('Magnitude [Hz]'); xlabel('f [Hz]');
legendCell = cellstr(num2str(f_patterns', '%-d [Hz]')); legend(legendCell);

s = filter(b, a(1, :), s); figure;
spectrogram(s, 4096, 4096-512, [0:5:2000], fs);

%% Algorithm
[s, fs] = audioread('s.wav');

numpad = ['1', '2', '3'; '4', '5', '6'; '7', '8', '9'; '*', '0', '#'];
N = 1000;                                               % Number of samples
decision = 0.03;
f_ind = round(f_patterns/fs*N)+1;                       % Pattern index in transform
j = 1;                                                  % PIN index
i = 1;
while i<length(s)-N
    check = s(i:i+N)>decision;
    if s(i)>decision && sum(check)>1
        x1 = filter(b, a(1,:), s(i:i+N));   % Filter and estimate the 1-st
        x2 = filter(b, a(2,:), s(i:i+N));   % freq. component
        x3 = filter(b, a(3,:), s(i:i+N));
        x4 = filter(b, a(4,:), s(i:i+N));
        X1 = max(fft(x1));   X2 = max(fft(x2));   X3 = max(fft(x3));   X4 = max(fft(x4));
        if (X1>X2 && X1>X3 && X1>X4) x = 1; end
        if (X2>X1 && X2>X3 && X2>X4) x = 2; end
        if (X3>X1 && X3>X2 && X3>X4) x = 3; end
        if (X4>X1 && X4>X2 && X4>X3) x = 4; end
        
        x5 = filter(b, a(5,:), s(i:i+N));   % Filter and estimate the 1-st
        x6 = filter(b, a(6,:), s(i:i+N));   % freq. component
        x7 = filter(b, a(7,:), s(i:i+N));
        X1 = max(fft(x1));   X2 = max(fft(x2));   X3 = max(fft(x3));   X4 = max(fft(x4));
        if (X1>X2 && X1>X3 && X1>X4) x = 1; end
        if (X2>X1 && X2>X3 && X2>X4) x = 2; end
        if (X3>X1 && X3>X2 && X3>X4) x = 3; end
        if (X4>X1 && X4>X2 && X4>X3) x = 4; end
    end
    i = i+1;
end
        
