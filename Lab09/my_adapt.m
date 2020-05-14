function [y, e, h] = my_adapt(M, mi, d, x)
% In: M-długość filtru, mi-współczynnik szybkości adaptacji
% Out: y-odfiltrowany sygnał, e-błąd

y = []; e = [];                 % sygnały wyjściowe z filtra
bx = zeros(M,1);                % bufor na próbki wejściowe x
h = zeros(M,1);                 % początkowe (puste) wagi filtru
for n = 1 : length(x)
    bx = [ x(n); bx(1:M-1) ];   % pobierz nową próbkę x[n] do bufora
    y(n) = h' * bx;             % oblicz y[n] = sum( x .* bx) – filtr FIR
    e(n) = d(n) - y(n);         % oblicz e[n]
    h = h + mi * e(n) * bx;     % LMS
    % h = h + mi * e(n) * bx /(bx'*bx); % NLMS
end