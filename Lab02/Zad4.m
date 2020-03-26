%% Read aufio and plot it
clear all; close all; clc;

[x, fs] = audioread('mowa.wav');    % Read audio, x-samples, fs-sampling rate
plot(x);    % Plot the signal


%% Choose 10 parts of the signal and analyse it

% Choose partial signals
xi = zeros(10, 256);
for i=1:10
    n = randi([500 30000], 1, 1);
    xi(i,:) = x(n:n+255)';
end

% Analysys matrix
N = 256;
k = 0:N-1;
n = 0:N-1;
A = sqrt(2/N)*cos(pi*k'/N*(n+0.5)); % DCT-II Matrix
A(1,:) = A(1,:)/sqrt(2);            % Differnet amplitude for the firs column

% Analyse the partial signals
yi = zeros(256, 10);
for i=1:10
    yi(:,i) = A*xi(i,:)';
end

% Plot the partial signals and their spectrum
f = (0:N-1)*fs/N;
figure;
for i=1:10
    subplot(2,1,1); plot(xi(i,:)); title('xi(n) '); xlim([0 255]); xlabel('n');
    subplot(2,1,2); stem(f, yi(:,i)); title('yi(f)'); xlabel('f [Hz]');
    pause;
end
