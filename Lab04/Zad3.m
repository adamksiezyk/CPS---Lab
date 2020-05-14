%% Radix-2
clear all; close all; clc;

N = 1024;                           % Number of samples
x = randn(1, N) + j*randn(1, N);    % Signal
xr = real(x);   xi = imag(x);
save('Zad3-x.mat', 'x');
% save('Zad3-xr.dat', 'xr', '-ascii', '-double');
% save('Zad3-xi.dat', 'xi', '-ascii', '-double');
%Mat = fopen('Zad3-x.mat','w');
DatR = fopen('Zad3-xr.dat','w');
DatI = fopen('Zad3-xi.dat','w');
for i = 1:N
    %fprintf(Mat,'%.20f\n', 'x[i]');
    fprintf(DatR,'%.20f\n', xr(i));
    fprintf(DatI,'%.20f\n', xi(i));
end
fclose(DatR); fclose(DatI); %fclose(Mat);


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
XR_fftw = load('XR_fftw.dat');
XI_fftw = load('XI_fftw.dat');
Xfftw = XR_fftw + j*XI_fftw;

Error_double = abs(Xmat - XCpp_double);
Error_float = abs(Xmat - XCpp_float);
Error_fftw = abs(Xmat - Xfftw);
figure;
subplot(231); hold on; grid('on'); plot(Xmat, 'o'); plot(XCpp_double, 'rx'); legend('X(k)-MatLab', 'X(k)-C++ double'); title('Spectrum double');
subplot(232); hold on; grid('on'); plot(Xmat, 'o'); plot(XCpp_float, 'rx'); legend('X(k)-MatLab', 'X(k)-C++ float'); title('Spectrum float');
subplot(233); hold on; grid('on'); plot(Xmat, 'o'); plot(Xfftw, 'rx'); legend('X(k)-MatLab', 'X(k)-FFTW'); title('Spectrum FFTW');
subplot(234); plot(Error_double, 'k-'); title('Error double'); xlim([0, 1024]);
subplot(235); plot(Error_float, 'k-'); title('Error float'); xlim([0, 1024]);
subplot(236); plot(Error_fftw, 'k-'); title('Error FFTW'); xlim([0, 1024]);