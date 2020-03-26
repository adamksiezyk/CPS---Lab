%% ADSL
clear all; close all; clc

data = load("lab_03.mat");
x = data.x_9';
K = 8;
N = 512;
M = 32;

% Seperate frames
Frames = zeros(K, N);
for i = 1:8
    Frames(i,:) = x(M+(i-1)*(N+M)+1 : i*(N+M));
end

X = fft(Frames, N, 2);

%X = zeros(8, 512);
% for i = 1:8
%     X(i,:) = fft(Frames(i,:));
% end


%% Plot the spectrum

figure;
f = 0:N-1;
for i = 1:8
    stem(f, abs(X(i,:))); title("Widmo ramki "+i); pause;
end