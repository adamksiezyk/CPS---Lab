clear all; close all; clc;

%% Coder
[x, fs] = audioread('DontWorryBeHappy.wav', 'native'); % wczytanie próbki dźwiękowej
x = double(x);
a = 0.9545; % parametr a kodera
d = x - a*[[0, 0]; x(1:end-1, :)]; % KODER
dq = lab11_kwant(d, 4); % kwantyzator

%% Decoder
y = zeros(length(d), 2);
y(1,:) = d(1,:);
for n = 2:length(d)
   y(n,:) = d(n,:) + a*y(n-1,:);
end

yd = zeros(length(dq), 2);
yd(1,:) = dq(1,:);
for n = 2:length(dq)
   yd(n,:) = dq(n,:) + a*yd(n-1,:);
end

%% Plot
figure;
n=1:length(x);
plot( n, x, 'b', n, dq, 'r' );