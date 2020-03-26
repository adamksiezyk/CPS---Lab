%% DAB - read signal
clear all; close all; clc;

ReadSize = 500000;      % max 500000
fs_file = 2.048e6;      % cz�stotliwo�� pr�bkowania w zbiorze
fs = 2.048e6;           % cz�stotliwo�� pr�bkowania DAB

ReadFile = fopen('DAB_real_2.048MHz_IQ_float.dat', 'rb');  % rzeczywisty odebrany DAB ("brudny" - zaszuminy, ...)
%ReadFile = fopen('DAB_synt_2.048MHz_IQ_float.dat', 'rb');  % rzeczywisty nadawany DAB ("czysty" - niezaszumiony,...)

iq = fread( ReadFile, [2, ReadSize], 'float' );
x = iq(1,:) + iq(2,:)*i;
[r, c] = size(x);
x = reshape(x, c, r);
if( fs_file ~= fs )
    x = resample(x, fs/1e3, fs_file/1e3);     % signal resampling from fs_file to fs (page 145)
end


%% Generate referance signal

% PhaseRefSymb - frequency spectrum of the the Phase Reference Symbol
% sigPhaseRefSymb - time waveform of the Phase Reference Symbol
[PhaseRefSymb, sigPhaseRefSymb ] = PhaseRefSymbGen( 1 );


%% Find the the sigPhaseRefSymb in the DAB signal

[c, lags] = xcorr(x, sigPhaseRefSymb);
lags = lags(1,ReadSize:end);
c = c(ReadSize:end, 1);
figure;
stem(lags, c); title('Cross corelation of sigPhaseRefSymb and the DAB signal');


%% Find the Null Symbol

[v, i] = maxk(c, 3);
NullSymb = ones(3, 2656);
figure;
for j = 2
    NullSymb(j, :) = x(i(j)-2656:i(j)-1);
    plot(real(NullSymb(j,:))); pause;
end


%% FFT the Null Symbol

%X = fft(NullSymb, 2656, 2);
X = fft(NullSymb(2,:));
f = -2048/2:2048/2656:2048/2-2048/2656;
figure;
subplot(121); stem(f, real(X(1,:))); title('Re(X(f))'); xlabel('f [MHz]'); subplot(122); stem(f, imag(X(1,:))); title('Im(X(f)'); suptitle('Spectrum of Null Symbol 1'); xlabel('f [MHz]'); pause;
subplot(121); stem(f, real(X(2,:))); title('Re(X(f))'); xlabel('f [MHz]'); subplot(122); stem(f, imag(X(2,:))); title('Im(X(f)'); suptitle('Spectrum of Null Symbol 2'); xlabel('f [MHz]'); pause;
subplot(121); stem(f, real(X(3,:))); title('Re(X(f))'); xlabel('f [MHz]'); subplot(122); stem(f, imag(X(3,:))); title('Im(X(f)'); suptitle('Spectrum of Null Symbol 3'); xlabel('f [MHz]'); pause;


%% 