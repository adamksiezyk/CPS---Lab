%% odbiornik FM: P. Swiatkiewicz, T. Twardowski, T. Zielinski, J. Bułat

clear all; close all;

fs = 3.2e6;         % sampling frequency
N  = 32e6;         % number of samples (IQ)
fc = 0.40e6;        % central frequency of FM station

bwSERV = 80e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 16e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s-127;

%% IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;
figure; psd(spectrum.welch('Hamming',1024), wideband_signal,'Fs',fs);

%% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');
figure; psd(spectrum.welch('Hamming',1024), wideband_signal_shifted,'Fs',fs);

%% Filter out the service from the wide-band signal
[b, a] = butter(4, 2*80e3/fs);
wideband_signal_filtered = filter(b, a, wideband_signal_shifted);
figure; psd(spectrum.welch('Hamming',1024), wideband_signal_filtered,'Fs',fs);

%% Down-sample to service bandwidth - bwSERV = new sampling rate
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );    % every 20-th sample
figure; psd(spectrum.welch('Hamming',1024), x,'Fs',fs/20);

%% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );
figure; psd(spectrum.welch('Hamming',1024), dx,'Fs',fs/20);

%% Decimate to audio signal bandwidth bwAUDIO
[b, a] = butter(4, 16e3/(fs/2));    % antyaliasing filter
y = filter(b, a, y);                % filter the signal
ym = y(1:bwSERV/bwAUDIO:end);       % decimate (1/5)
figure; psd(spectrum.welch('Hamming',1024), ym,'Fs',fs/(20*5)); % every 5-th sample

% De-emfaza
% (...)

%% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
soundsc( ym, bwAUDIO*2);
