%% DAB - read signal
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

[c, lags] = xcorr(x, sigPhaseRefSymb);
lags = lags(1, ReadSize:end);
c = c(ReadSize:end, 1);
figure;
stem(lags, abs(c)); title('Cross corelation of sigPhaseRefSymb and the DAB signal');


%% Find frames

[v, i] = maxk(c, 3);
Frames = zeros(3*76, 2552);
l = 0;
for k = 1:3
    for j = 1:76
        if(i(k)+j*2551 > ReadSize)
            break
        end
        l = l+1;
        Frames(l,:) = x(i(k)+(j-1)*2551:i(k)+j*2551);
    end
end
Frames = Frames(1:l, :);


%% Check if prefixes are correct

figure;
for i = 1:size(Frames, 1)
    Prefix = xcorr(Frames(i, 1:504), Frames(i, :));
    stem(abs(Prefix)); title("Frame " + i); pause;
end