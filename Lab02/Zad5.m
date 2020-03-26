%% DAB
clear all; close all; clc

% Generate DFT matrix
N = 2048;       % Matrix size
F = dftmtx(N);  % DFT matrix
A = sqrt(N)*F;  % Scaled F


%% Read DAB

[PhaseRefSymb, sigPhaseRefSymb ] = PhaseRefSymbGen(1);
% sigPhaseRefSymb - referential time signal
% PhaseRefSymb - sectrum of the referential signal

x = sigPhaseRefSymb(end-2047:end);  % Delete prefix
%X = A*x;                            % Analyse
X = fft(x);


%% Rotate the coefficients

fi = [pi/4 3*pi/4 5*pi/4 7*pi/4];   % Available rotations
Y = zeros(size(X));
for i=1:length(X)
    if(abs(X(i))>1e-10)
        Y(i) = X(i)*exp(i*fi(mod(i,length(fi))+1)); % Rotate every coefficient
    end
end

%% Sythesize y

%S = inv(F)/sqrt(N);
%y = S*Y;
y = ifft(Y);
SigSymb(1:505,1) = y(end-504:end,1);