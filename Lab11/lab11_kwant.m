function xq = lab11_kwant(x, Nb)
    % Input: x-signal, N-quantization degree
    % Output: dq-quantized signal

    xL = x(:, 1);
    xR = x(:, 2);
    minL = min(xL);
    minR = min(xR);
    maxL = max(xL);
    maxR = max(xR);
    rangeL = maxL - minL;
    rangeR = maxR - minR;
    
    Nq = 2^Nb;
    dx = rangeL/Nq;
    xqL = dx*round(xL/dx);
    
    dx = rangeR/Nq;
    xqR = dx*round(xR/dx);
    
    xq = horzcat(xqL, xqR);
end