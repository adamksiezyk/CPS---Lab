%% Radix-2
clear all; close all; clc;

N = 1024;                           % Number of samples
x = randn(1, N) + j*randn(1, N);    % Signal
xr = real(x);   xi = imag(x);
save('Zad3-x.mat', 'x');
save('Zad3-xr.dat', 'xr', '-ascii');
save('Zad3-xi.dat', 'xi', '-ascii');


%% myFFT

xmat = load('Zad3-x.mat').x;                          % Load .mat signal
xdat = load('Zad3-xr.dat') + j*load('Zad3-xi.dat');   % Load .dat signal

Xmat = fft(xmat);   Xdat = fft(xdat);   % Calculate the spectrum of x1 and x2
Error = abs(Xmat - Xdat);

figure; plot(Error);


%% MatLab vs C++

XR_double = load('XR_double.dat');
XI_double = load('XI_double.dat');
XCpp_double = XR_double + j*XI_double;
XR_float = load('XR_float.dat');
XI_float = load('XI_float.dat');
XCpp_float = XR_float + j*XI_float;

Error_double = abs(Xmat - XCpp_double);
Error_float = abs(Xmat - XCpp_float);
figure;
subplot(221); hold on; grid('on'); plot(Xmat, 'o'); plot(XCpp_double, 'rx'); legend('X(k)-MatLab', 'X(k)-C++ double'); title('Spectrum double');
subplot(222); hold on; grid('on'); plot(Xmat, 'o'); plot(XCpp_float, 'rx'); legend('X(k)-MatLab', 'X(k)-C++ float'); title('Spectrum float');
subplot(223); plot(Error_double, 'k-'); title('Error double'); xlim([0, 1024]);
subplot(224); plot(Error_float, 'k-'); title('Error float'); xlim([0, 1024]);