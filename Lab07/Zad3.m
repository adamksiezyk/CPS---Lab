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
%figure; psd(spectrum.welch('Hamming',1024), wideband_signal_shifted,'Fs',fs);

%% Filter out the service from the wide-band signal
fcut = 80e3;    % Pass band stop freq.
N = 128;

b = fir1(N, fcut/(fs/2), blackmanharris(N+1));

wideband_signal_filtered = filter( b, 1, wideband_signal_shifted);
wideband_signal_filtered = wideband_signal_filtered(N/2:end);
%figure; psd(spectrum.welch('Hamming',1024), wideband_signal_filtered,'Fs',fs);

%% Down-sample to service bandwidth - bwSERV = new sampling rate
x = decimate(wideband_signal_filtered,20);
fs = fs/20;

%% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );

%% Filter mono 30Hz - 15kHz
N = 512;
b = fir1(N,[30/(bwSERV) 15e3/(bwSERV)],blackmanharris(N+1));

[H, f] = freqz(b, 1, 0:0.5:fcut, fs);

figure;
subplot(211); plot(f/1000, 20*log10(abs(H))); title('Filter [dB]'); xlabel('f [kHz]');
xline(15, 'r', '15 kHz'); xline(19, 'r', '19 kHz'); yline(-3, 'r', '-3 dB'); yline(-40, 'r', '-40 dB');

ym = filter(b, 1, y);
ym = ym(N/2:end);
subplot(212); psd(spectrum.welch('Hamming',1024), ym,'Fs',fs); title('Filtered mono signal [dB]')

%% Listen to the final result

ym = ym(1:bwSERV/bwAUDIO:end);  % decimate (1/5)
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
if(0)
    soundsc( ym, bwAUDIO*2);
end

%% Filter pilot 19kHz +/-10Hz
N = 256;    % Filter length
b = fir1(N, [(18.99e3)/(bwSERV) (19.01e3)/(bwSERV)], blackmanharris(N+1));  % Filter
[H, f] = freqz(b, 1, 0:0.1:fcut, fs);                   
yp =  filter(b, 1, y);                                  % Filter the pilot
yp = yp(N/2:end);                                       % Compensate delay
Yp = psd(spectrum.welch('Hamming',1024), yp, 'Fs', fs); % Pilot spectrum
[~, ind] = max(Yp.Data);    fpl = Yp.Frequencies(ind);  % fpl - pilot freq.

figure;
subplot(211); plot(f/1000, 20*log10(abs(H))); title('Filter [dB]'); xlabel('f [kHz]');
subplot(212); psd(spectrum.welch('Hamming',1024), yp, 'Fs', fs); title('Pilot');

%% Filter stereo
N = 256;    % Filter length
b = fir1(N, [(2*fpl-16e3)/80e3 (2*fpl+16e3)/80e3], blackmanharris(N+1));    % Filter
[H,f] = freqz(b, 1, 0:fcut, fs);
ys = filter(b, 1, y);   % Filter the stereo signal
ys = ys(N/2:end);       % Compensate delay

figure;
plot(f, 20*log10(abs(H))); grid; xlabel('f [Hz]'); title('Stereo bandpass [dB]');
xline(fpl, 'r', 'f_{pl}'); xline(3*fpl, 'r', '3*f_{pl}'); yline(-60, 'r', '-60 dB');

%% Shift the stereo signal
figure;
subplot(311); psd(spectrum.welch('Hamming',1024), y, 'Fs', fs); title('Signal');
subplot(312); psd(spectrum.welch('Hamming',1024), ys, 'Fs', fs); title('Stereo signal');

N = 1.6e6;                                          % Number of samples
c = cos(2*pi*(fpl/bwSERV)*(0:length(ys)-1)');    % Cosinus
ys = ys.*c;                                         % Shifted signal

subplot(313); psd(spectrum.welch('Hamming',1024), ys, 'Fs', fs); title('Shifted stereo signal');

%% Anty-aliasing low pass filter
N = 256;
b = fir1(N, 2*fpl/80e3, blackmanharris(N+1));
[H,f] = freqz(b, 1, 0:fcut,fs);
ys = filter(b, 1, ys);
ys = ys(N/2:end);
figure; subplot(211); plot(f, 20*log10(abs(H))); title('Low pass filter [dB]'); grid;
xline(2*fpl, 'r', '2*fpl');
subplot(212); psd(spectrum.welch('Hamming',1024), ys, 'Fs', fs); title('Filtered stereo');

%% Decimate the stereo signal
ys = decimate(ys, 5);
fs = fs/5;

%% Construct the stereo signal
ys = ys-mean(ys);
ys = ys/(1.001*max(abs(ys)));

yl = 0.5*(ym+ys);
yr = 0.5*(ym-ys);

%% Listen to the stereo signal
if(1)
    soundsc([yl yr], bwAUDIO*2);
end