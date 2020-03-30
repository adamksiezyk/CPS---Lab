%% Fourier transform of real signals

N = 1024;           % Number of samples
x1 = randn(1, N);   % Signal 1
x2 = randn(1, N);   % Signal 2
y = x1 + j*x2;      % Sum of the signals
Y = fft(y);         % Spectrum of signal y

X1R = zeros(1, N);  % Real part of the spectrum of signal x1
X1I = zeros(1, N);  % Imaginary part of the spectrum of signla x1
X2R = zeros(1, N);  % Real part of the spectrum of signal x2
X2I = zeros(1, N);  % Imaginary part of the spectrum of signla x2
for k = 2:N
    X1R(k) = 0.5*(real(Y(k))+real(Y(N+2-k)));
    X1I(k) = 0.5*(imag(Y(k))-imag(Y(N+2-k)));
    X2R(k) = 0.5*(imag(Y(k))+imag(Y(N+2-k)));
    X2I(k) = 0.5*(real(Y(N+2-k))-real(Y(k)));
end
X1R(1) = real(Y(1));
X1I(1) = 0;
X2R(1) = imag(Y(1));
X2I(1) = 0;

X1 = X1R + j*X1I;   % Construct the X1 spectrum
X2 = X2R + j*X2I;   % Construct the X2 spectrum

X1m = fft(x1);      % Reference X1 specreum
X2m = fft(x2);      % Reference X2 spectrum

Error1 = abs(X1m-X1);
Error2 = abs(X2m-X2);

figure;
subplot(211); plot(1:N, X1m, 'o', 1:N, X1, 'rx', 1:N, Error1, 'k-'); title('X1'); legend('FFT', 'Using symetry'); xlim([1 N]);
subplot(212); plot(1:N, X2m, 'o', 1:N, X2, 'rx', 1:N, Error2, 'k-'); title('X2'); legend('FFT', 'Using symetry'); xlim([1 N]);