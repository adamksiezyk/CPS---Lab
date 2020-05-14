function [zz,pp,gain] = test(z,p,gain,w0,dw)
% LowPass to BandStop TZ
zz = []; pp = [];
for k=1:length(z) % transformation of zeros
    zz = [ zz roots([ 1 -dw/z(k) w0^2 ])' ];
    gain = gain*(-z(k));
end
for k=1:length(p) % transformation of poles
    pp = [ pp roots([ 1 -dw/p(k) w0^2 ])' ];
    gain = gain/(-p(k)); 
end
for k=1:(length(p)-length(z))
    zz = [ zz roots([ 1 0 w0^2 ])' ];
end