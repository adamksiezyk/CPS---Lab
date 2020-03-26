clear all;
close all;
clc;
 
data = load('lab_03.mat');
z = mod(305492,16)+1;
N = 512;
M = 32;
x = data.x_5';
m=0;
 
%%USUWANIE PREFIXOW Z SYGNALU
for i=1:length(x)
   if i == (m*(N+M)+1) && m~=8
       for k=i:i+31
          x(i)=[];
       end
       m = m+1;
   end
end

x(4097)=[];
 
 for i = 1:8   
   
    y(i,:) = x(512*(i-1)+1:512+512*(i-1));
 end
 
for i = 1:8
        X(i,:) = fft(y(i,:))./N;
end
 
for i = 1:8
        figure(1);
        subplot(4,2,i);
        plot(abs(X(i,:))); 
        figure(2);
        subplot(4,2,i);
        plot(20*log10(abs(X(i,:))),'r');
end