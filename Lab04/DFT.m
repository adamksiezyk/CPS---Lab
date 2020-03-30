% DFT. Input: x-signal. Output: X-DFT Spectrum of signal x

function X=DFT(x)

N = length(x);  % Number of samples
n = 0:N-1;
k = 0:N-1;

X = sum(x' .* exp(-j*2*pi/N*k'*n));