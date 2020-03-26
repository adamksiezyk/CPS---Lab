%% Initialize the signal and transformation matrics
clear all; close all; clc;

N = 100;                        % Signal samples
fs = 1000;                      % Sampling rate
t = 0:1/fs:(N-1)/fs;            % time vector
f1 = 50; f2 = 100; f3 = 150;    % Frequencies
A1 = 50; A2 = 100; A3 = 150;    % Amplitudes

n = 0:N-1;
k = 0:N-1;

x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);
%x = A1*cos(pi*f1*t) + A2*cos(pi*f2*t) + A3*cos(pi*f3*t);  % Signal

A = sqrt(2/N)*cos(pi*k'/N*(n+0.5)); % DCT-II analysis matrix
A(1,:) = A(1,:)/sqrt(2);            % Differnet amplitude for the firs column
S = A';                             % DCT-II synthesis matrix


%% Plot Transformation functions
figure; % Plot every A row and S column
for i = 1:N
    plot(n, A(i,:), 'b-o', n, S(:,i), 'r-x'); title('A-row - blue, S-col - red'), pause;
end


%% Analyze the signal

y = A*x';   % Analyze the signal
figure;     % Plot the coefficients
f = (0:N-1)*fs/(2*N);
stem(f, y);


%% Reconstruct the signal

xr = S*y;
figure;
plot(t, x, 'b-o', t, xr, 'r-x');


%% Frequency change of f2 by 5 Hz

f2 = 105;   % Change freq.
x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);  % Update signal
y = A*x';   % Analyse signal
figure;     % Plot the frequencies
f = (0:N-1)*fs/(2*N);
subplot(2,1,1); stem(f, y);

xr = S*y;
subplot(2,1,2); plot(t, x, 'b-o', t, xr, 'r-x');


%% Frequency change for all components by 2.5 Hz

f1 = 52.5; f2 = 102.5; f3 = 152.5;  % Change freq.
x = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t) + A3*sin(2*pi*f3*t);  % Update signal
y = A*x';   % Analyse signal
figure;     % Plot the frequencies
f = (0:N-1)*fs/N;
stem(f, y);