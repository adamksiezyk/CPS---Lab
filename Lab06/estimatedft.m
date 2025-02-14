% Goertzel DFT
function PIN = estimatedft(s,fs)
% Input: s-signal, fs-sampling freq.
% Output: decoded DTMF PIN

numpad = ['1', '2', '3'; '4', '5', '6'; '7', '8', '9'; '*', '0', '#'];
f_patterns = [697, 770, 852, 941, 1209, 1336, 1477];    % Freq. patterns
N = 1000;                                                % Number of samples
decision = 0.03;
f_ind = round(f_patterns/fs*N)+1;                       % Pattern index in transform
x = 1;                                                  % PIN index
i = 1;
while i<length(s)-N
    check = s(i:i+N)>decision;
    if s(i)>decision && sum(check)>50
        symbol = abs(goertzel(s(i:i+N), f_ind));
        [~, f1] = max(symbol(1:4));
        [~, f2] = max(symbol(5:end));
        PIN(x) = numpad(f1, f2);
            x = x+1;
        for j = N:N:length(s)-i-N
            check = s(i+j : i+j+N)>decision;
            if sum(check)==0
                i = i+j;
                break
            end
        end
    end
    i = i+1;
end