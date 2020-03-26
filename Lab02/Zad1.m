%% Zadanie 1 - generate the DCT-II anlysis matrix
clear all; close all; clc;

% Parameters
N = 20;
k = 0:N-1;
n = 0:N-1;

A = sqrt(2/N)*cos(pi*k'/N*(n+0.5)); % DCT-II Matrix
A(1,:) = A(1,:)/sqrt(2);            % Differnet amplitude for the firs column

% Check if the matrix is orthonormal
orth = A*A';

%% Zadanie 2 - generate the DCT-II synthesis matrix

S = A';
I = S*A;

x = randn(1, N);    % Generate random vector
X = A*x';           % DCT-II analysis
xs = S*X;           % DCT-II synthesis

figure;
subplot(2,1,1); plot(x, 'b-o'); hold on; plot(xs, 'r-x'); title('Blue - x(n), Red - xs(n)');
subplot(2,1,2); stem(X); title('X(k)');

%% Dla dociekliwych
clear all; close all; clc;

N = 20;         % Number of 
A = randn(N,N); % Analysis matrix of random transformation
S = inv(A);     % Synthesis matrix of random transformation

orth = A'*A;    % Check if the matrix is orthonormal
I = A*S;        % Check if S = inv(A)

x = randn(1, N);    % Generate random vector
X = A*x';           % DCT-II analysis
xs = S*X;           % DCT-II synthesis, reconstruction with inv(A) is always perfect

figure;
subplot(2,1,1); plot(x, 'b-o'); hold on; plot(xs, 'r-x'); title('Blue - x(n), Red - xs(n)');
subplot(2,1,2); stem(X); title('X(k)');

%% Part 2
clear all; close all; clc;

% Parameters
N = 20;
k = 0:N-1;
n = 0:N-1;

A = sqrt(2/N)*cos(pi*(k+0.25)'/N*(n+0.5));  % Incorrect DCT-II Matrix
A(1,:) = A(1,:)/sqrt(2);                    % we multipy the first row by 1/sqrt(2) and
                                            % the whole matrix by 1/sqrt(N)
                                            % to make the matrix orthogonal
%S = inv(A);
S = A';
                                            
orth = A*A';    % Check if the matrix is orthonormal

x = randn(1, N);    % Noise signal
y = cos(2*pi/20*n);    % Harmonic signal

X = A*x';   % Analaysis of noise signal
Y = A*y';   % Analaysis of harmonic signal

xs = S*X;   % Synthesis of noise signal
ys = S*Y;   % Synthesis of harmonic signal

figure;
subplot(2,2,1); plot(x, 'b-o'); hold on; plot(xs, 'r-x'); title('Noise signal x(n) - blue, reconstructed noise signal xs(n) - red');
subplot(2,2,2); plot(y, 'b-o'); hold on; plot(ys, 'r-x'); title('Harmonic signal y(n) - blue, reconstructed harmonic signal ys(n) - red');
subplot(2,2,3); stem(X); title('X(k)');
subplot(2,2,4); stem(Y); title('Y(k)');