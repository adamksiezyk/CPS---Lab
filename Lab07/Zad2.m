%% Load the signal
clear all; close all; clc;

fs = 3.2e6;     % sampling frequency
N  = 32e6;      % number of samples (IQ)
fc = 0.40e6;    % central frequency of MF station

bwSERV = 80e3;  % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 16e3; % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s-127;

%% IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;

%% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');
figure; psd(spectrum.welch('Hamming',1024), wideband_signal_shifted,'Fs',fs);

%% Filter out the service from the wide-band signal
fcut = 80e3;    % Pass band stop freq.
N = 128;

b = fir1(N, fcut/(fs/2), blackmanharris(N+1));

wideband_signal_filtered = filter( b, 1, wideband_signal_shifted);
wideband_signal_filtered = wideband_signal_filtered(N/2:end);
figure; psd(spectrum.welch('Hamming',1024), wideband_signal_filtered,'Fs',fs);

%% Down-sample to service bandwidth - bwSERV = new sampling rate
x = decimate(wideband_signal_filtered,20);
fs = fs/20;

%% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );

%% Filter mono 30Hz - 15kHz
N = 128;
b = fir1(N,[30/(bwSERV/2) 15e3/(bwSERV/2)],blackmanharris(N+1));

[H, f] = freqz(b, 1, 0:0.5:fcut, fcut);

figure;
subplot(211); plot(f/1000, 20*log10(abs(H))); title('Filter [dB]'); xlabel('f [kHz]');
xline(15, 'r', '15 kHz'); xline(19, 'r', '19 kHz'); yline(-3, 'r', '-3 dB'); yline(-40, 'r', '-40 dB');

ym = filter(b, 1, y);
ym = ym(N/2:end);
subplot(212); psd(spectrum.welch('Hamming',1024), ym,'Fs',fs); title('Filtered mono signal [dB]')
ym = y(1:bwSERV/bwAUDIO:end);       % decimate (1/5)
fs = fs/5;

%% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
soundsc( ym, bwAUDIO*2);

%% Filter pilot 19kHz +/-10Hz
N = 512;
b = fir1(N, [(18.990e3)/(bwSERV/2) (19.010e3)/(bwSERV/2)], blackmanharris(N+1));
[H, f] = freqz(b, 1, 0:0.5:fcut, fcut);
yp =  filter(b, 1, y);
yp = yr(N/2:end);

figure;
subplot(211); plot(f/1000, 20*log10(abs(H))); title('Filter [dB]'); xlabel('f [kHz]');
subplot(212); psd(spectrum.welch('Hamming',1024), yp, 'Fs', fs); title('Pilot');
figure; spectrogram(yp, fs);