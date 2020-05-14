% Prog5: filtry analogowe
clear all; close all;

if(0)  % GORSZE
   b = [ 4 3 2];
   a = [ 3 2 1]
   z = roots( b );
   p = roots( a );
end
if(0)  % LEPSZE!
   p = [-0.5+9.5*j, -1+10*j, -0.5+10.5*j]; p = [p, conj(p)];
   z = [5*j, 15*j];                        z = [z, conj(z)];
   b = poly( z );
   a = poly( p );
end
if(0)
    R = 10;         % resistance in ohms
    L = 2*10^(-3);  % inductance in henrys
    C = 5*10^(-6);  % capacitance in farads
    w0 = 1/sqrt(L*C); f0 = w0/(2*pi), % undumped resonance frequency 
    ksi = (R/L)/(2*w0),               % should be smaller than 1 
    w1 = w0*sqrt(1-ksi^2); f1 = w1/(2*pi), pause % damped resonance frequency
    b = [ 1 ];                % coeffs of nominator polynomial
    a = [ L*C, R*C, 1 ];      % coeffs of denominator poly (from the highest order)  
    z = roots( b );
    p = roots( a );
end
if(1)
   N = 8; 
  [b,a] = butter(N,2*pi*[100 1000],'s');
  %[b,a] = cheby1(N,3,2*pi*1000,'s');   % Rp=3
  %[b,a] = cheby2(N,100,2*pi*1000,'s'); % Rs=100
  %[b,a] = ellip(N,3,100,2*pi*1000,'s'); 
  %[b,a] = ellip(N,3,100,2*pi*[100 1000],'s'); 
   z = roots( b );
   p = roots( a );
end    
if(0)
   N = 8;
   f0 = 1000;
 % [b,a] = butter(N,2*pi*f0,'s');
   dfi = pi/N;
   fi = pi/2 + dfi/2 + dfi*(0:N-1);
   p = (2*pi*f0) * exp(j*fi);
   if(0) % Low-Pass
      z = []; wzm = prod(-p);
   else  % High-Pass
      z = zeros(1,N); wzm = 1; 
   end    
   b = wzm*poly( z );
   a = poly( p );
end    

figure; plot( real(z), imag(z), 'bo', real(p), imag(p), 'r*');
title('Z&P'); grid; pause

f = 0 : 1 : 10000;
%f = 0 : 0.01 : 10;
w = 2*pi*f;
s = j*w;
H = polyval(b,s) ./ polyval(a,s);
%H = freqs( b,a,f);
figure; plot( f, 20*log10(abs(H))); xlabel('f [Hz]');
title('|H(f)|'); grid; pause
figure; semilogx( f, 20*log10(abs(H))); xlabel('f [Hz]');
title('|H(f)|'); grid; pause

figure; plot( f, unwrap( angle(H) )); xlabel('f [Hz]');
title('faza [rad]'); grid; pause

figure; impulse(b,a); pause
figure; step(b,a); pause
