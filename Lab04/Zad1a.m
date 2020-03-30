%% FFT from the sec. layer
clear all; close all; clc;

N = 1024;           % Nr. of samples
x = randn(1, N);    % Generate random signal vec.

% X_DFT
X_DFT = DFT(x);     % DFT spectrum of signal x

% X_FFT = Xe + cXo
x1 = x(1:2:end);    % Even samples
x2 = x(2:2:end);    % Odd samples
X1 = DFT(x1);       % DFT of even samples
X2 = DFT(x2);       % DFT of odd samples
X_FFT1 = [X1, X1] + exp(-j*2*pi/N*(0:1:N-1)) .* [X2, X2];   % DFT of signal x

Error = abs(X_FFT1 - X_DFT);

figure;
plot(1:N, X_FFT1, 'o', 1:N, X_DFT, 'rx', 1:N, Error, 'k-');


%% FFT X1=X11+cX12 , X2=X21 +cX22

x11 = x1(1:2:end);  % Even even samples
X11 = DFT(x11);     
x12 = x1(2:2:end);  % Even odd samples
X12 = DFT(x12);
X1 =  [X11, X11] + exp(-j*2*pi/(N/2)*(0:N/2-1)) .* [X12, X12];  % DFT of even samples

x21 = x2(1:2:end);  % Odd even samples
X21 = DFT(x21);     
x22 = x2(2:2:end);  % Odd odd samples
X22 = DFT(x22);
X2 = [X21, X21] + exp(-j*2*pi/(N/2)*(0:N/2-1)) .* [X22, X22];   % DFT of odd samples

X_FFT2 = [X1, X1] + exp(-j*2*pi/N*(0:N-1)) .* [X2, X2];         % DFT of signal x

Error = abs(X_DFT - X_FFT2);

figure;
plot(1:N, X_DFT, 'o', 1:N, X_FFT2, 'rx', 1:N, Error, 'k-');