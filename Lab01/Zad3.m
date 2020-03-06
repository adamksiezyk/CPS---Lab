% Zadanie 3, signal corelation
close all; clear all;

% load signal
load("adsl_x.mat");

for k = 1:length(x) - 32
    a = x(k:k+32); %prefix adsl

    % corelation
    corr_vect = xcorr(x, a);

    % find peak
    [p, i] = max(corr_vect);
    i2 = find(corr_vect >= 0.987*p);
    
    if length(i2) > 1
        disp('Frame found');
        disp(k);
        figure;
        stem(abs(corr_vect));
    end 
end