clear all; close all; clc;

%% Read the signal
[x, fs] = audioread('DontWorryBeHappy.wav');    % Read the signal
xL = x(:, 1)';                                  % Left channel
xR = x(:, 2)';                                  % Right channel

%%
Q = 2;
N = 128;
n = 0:N-1;
k = 0:N/2-1;
h = sin(pi*(n+0.5)/N);  % Window
A = sqrt(4/N) * cos(2*pi/N*(k'+0.5).*(n+0.5+N/4)); % Analysis matrix
S = A'; % Synthesis matrix

y = zeros(2, length(x));
for k = 1:N/2:length(x)-N
    n = k:k+N-1;
    dxL = xL(n);
    dxR = xR(n);
    
    dxL_w = dxL.*h;
    dxR_w = dxR.*h;
    
    dxL_a = A*dxL_w';
    dxR_a = A*dxR_w';
    
    dxL_q = round(Q*dxL_a);
    dxR_q = round(Q*dxR_a);
    
    dxL_s = S*dxL_q;
    dxR_s = S*dxR_q;
    
    dxL_d = h.*dxL_s';
    dxR_d = h.*dxR_s';
    
    y(1, k:k+N-1) = y(1, k:k+N-1) + dxL_d;
    y(2, k:k+N-1) = y(2, k:k+N-1) + dxR_d;
end

%% Plot
t = (0:length(x)-1)/fs;
figure;
subplot(211); plot(t, x(:, 1), 'b', t, y(1, :), 'r'); title('Stereo-L'); legend('Original', 'Synthetic');
subplot(212); plot(t, x(:, 2), 'b', t, y(2, :), 'r'); title('Stereo-R'); legend('Original', 'Synthetic');