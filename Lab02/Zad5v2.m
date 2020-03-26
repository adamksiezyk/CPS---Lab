%% Read the DAB signal
clear all; close all; clc;

ReadSize = 500000;      % max 500000
fs_file = 2.048e6;      % cz�stotliwo�� pr�bkowania w zbiorze
fs = 2.048e6;           % cz�stotliwo�� pr�bkowania DAB

% ReadFile = fopen('DAB_real_2.048MHz_IQ_float.dat', 'rb');  % rzeczywisty odebrany DAB ("brudny" - zaszuminy, ...)
ReadFile = fopen('DAB_synt_2.048MHz_IQ_float.dat', 'rb');  % rzeczywisty nadawany DAB ("czysty" - niezaszumiony,...)

iq = fread( ReadFile, [2, ReadSize], 'float' );
x = iq(1,:) + iq(2,:)*i;
[r, c] = size(x);
x = reshape(x, c, r);
if( fs_file ~= fs )
    x = resample(x, fs/1e3, fs_file/1e3);     % signal resampling from fs_file to fs (page 145)
end


%% Generate referance dignal

% PhaseRefSymb - frequency spectrum of the the Phase Reference Symbol
% sigPhaseRefSymb - time waveform of the Phase Reference Symbol
[PhaseRefSymb, sigPhaseRefSymb ] = PhaseRefSymbGen( 1 );


%% Find the the sigPhaseRefSymb in the DAB signal

[cor, lags] = xcorr(x, sigPhaseRefSymb);
lags = lags(1, ReadSize:end);
cor = cor(ReadSize:end, 1);
figure;
stem(lags, abs(cor)); title('Cross corelation of sigPhaseRefSymb and the DAB signal');


%% Find frames

[val, ind] = maxk(cor, 3);
Frames = zeros(3*76, 2552);
c = 0;
for i = 1:3
    for j = 1:76
        if(ind(i)+j*2551 > ReadSize)
            break
        end
        c = c+1;
        Frames(c,:) = x(ind(i)+(j-1)*2551:ind(i)+j*2551);
    end
end
Frames = Frames(1:c, :);


%% Delete prefix

Payload = zeros(size(Frames, 1), 2048);
for i = 1:size(Frames, 1)
    Payload(i, :) = Frames(i, 505:end);
end


%% FFT the payload

X = fft(Payload, 2048, 2);
Fi = zeros(154, 2047);
for i = 1:154
    Fi(i,:) = X(i,1:end-1) / X(i,2:end);
    Fi(i,:) = wrapTo2Pi(angle(Fi(i,:)));
end

%figure; plot(X(1,:), 'o'); %xlim([-max(abs(X)) max(abs(X))]); ylim([-max(abs(X)) max(abs(X))]);


%% Detect bits

bits = ones(1, 154);
for i = 1:154
    if((0 < Fi(i,1)) && (Fi(i,1) <= 1.57))
        bits(i) = 0;
    elseif((1.57 < Fi(i,1)) && (Fi(i,1) <= 3.14))
        bits(i) = 1;
    elseif((3.14 < Fi(i,1)) && (Fi(i,1) <= 4.71))
        bits(i) = 2;
    else
        bits(i) = 3;
    end
end


%% Add AWGN

A = max(abs(x));
xt = Payload + 0.001*A*randn(size(Payload));