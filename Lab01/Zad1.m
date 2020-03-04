clear all; close all;

%% A
% Generate a sine-wave with different sampling frequences fs.

A = 230;
f = 50;

fs1 = 10000;
fs2 = 500;
fs3 = 200;

t1 = 0:1/fs1:0.1;
t2 = 0:1/fs2:0.1;
t3 = 0:1/fs3:0.1;

s1 = A*sin(2*pi*f*t1);
s2 = A*sin(2*pi*f*t2);
s3 = A*sin(2*pi*f*t3);

plot(t1, s1, 'b-', t2, s2, 'r-o', t3, s3, 'k-x');

%% B
% Generate a sine-wave with different sampling frequences fs.

A = 230;
f = 50;

fs1 = 10000;
fs2 = 26;
fs3 = 25;
fs4 = 24;

t1 = 0:1/fs1:1;
t2 = 0:1/fs2:1;
t3 = 0:1/fs3:1;
t4 = 0:1/fs4:1;

s1 = A*sin(2*pi*f*t1);
s2 = A*sin(2*pi*f*t2);
s3 = A*sin(2*pi*f*t3);
s4 = A*sin(2*pi*f*t4);

plot(t1, s1, 'b-', t2, s2, 'g-o', t3, s3, 'r-o', t4, s4, 'k-o');

%% C
% Generate sine-wave with changing frequency

fs = 100;
t = 0:1/fs:1;
f = 0;

if(0)
    for i = 1:61
        i;
        f;
        s = sin(2*pi*f*t);
        plot(t, s);
        f = f + 5;
    end
end

if(0)
    figure;
    s5 = sin(2*pi*5*t);
    s105 = sin(2*pi*105*t);
    s205 = sin(2*pi*205*t);
    plot(t, s5, 'g-', t, s105, 'r-x', t, s205, 'b-o');
end

if(0)
    figure;
    s95 = sin(2*pi*95*t);
    s195 = sin(2*pi*195*t);
    s295 = sin(2*pi*295*t);
    plot(t, s95, 'g-', t, s195, 'r-x', t, s295, 'b-o');
end

if(0)
    figure;
    s95 = sin(2*pi*5*t);
    s105 = sin(2*pi*105*t);
    plot(t, s5, 'g-o', t, s105, 'r-x');
end

%% D
% Generate modulated sine-wave

fs1 = 10000;
fn = 50;
fm = 1;
df = 5;
t1 = 0:1/fs1:1;

sm1 = df*sin(2*pi*fm*t1);
s1 = sin(2*pi*sm.*t1);

fs2 = 25;
t2 = 0:1/fs2:1;
sm2 = sin(2*pi*t2);
s2 = sin(2*pi*sm2.*t2);

error = interp1(t2, s2, t1) - interp1(t1, s1, t1);

figure;
subplot(2,1,1); plot(t1, sm1); title('Modulation wave'); xlabel('t [s]');
subplot(2,1,2); plot(t1, s1, 'b-', t2, s2, 'r-x', t1, error, 'g-', t2, zeros(size(t2))); title('Carrier wave'); xlabel('t [s]');