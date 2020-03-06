close all; clear all; clc;

% signal param.
A = 230;
f = 50;
fs = 10000;
fs2 = 200;
t = 0:1/fs:0.1;
t2 = 0:1/fs2:0.1;

% signal
s = A*sin(2*pi*f*t);
% sampled signal
s2 = A*sin(2*pi*f*t2);

% signal reconstruction
y = zeros(size(t));
for i = 1:length(t2)
    
    tmp = s2(i)*sinc(fs2*(t-t2(i)));
    y = y + tmp;
    
end

hold on
% analog
plot(t,s,'g-')
% reconstructed
plot(t,y)
% error
plot(t,abs(s-y),'r-');
hold off