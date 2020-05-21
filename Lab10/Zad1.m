clear all; close all; clc;

%% Load the signal
[x, fs] = audioread('mowa1.wav');   % Read the signal

figure;
plot(x); title('Original signal'); pause    % Plot the signal

%soundsc(x, fs);                             % Listen to the signal

bezdzw = x(80700:81400);    %głoska bezdzwieczna (Przy!ci!sku...)
dzw = x(3000:3700);         %gloska dzwieczna (!M!aterial kursu...)
subplot(211); plot(bezdzw); title('Głoska bezdźwięczna');
subplot(212); plot(dzw); title('Głoska dźwięczna'); pause;

x = dzw;        % Choose signal

N=length(x);    % signal length
Mlen=240;		% Hamming window length
Mstep=180;		% Window shift in time domain
Np=10;			% Prediction filter degree
gdzie=Mstep+1;	% pocz�tkowe po�o�enie pobudzenia d�wi�cznego

lpc=[];								   % tablica na wsp�czynniki modelu sygna�u mowy
s=[];									   % ca�a mowa zsyntezowana
ss=[];								   % fragment sygna�u mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygna�u mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragment�w (ramek) jest do przetworzenia

%% Pre emphasis
 x_pre=filter([1 -0.9735], 1, x);	% filtracja wst�pna (preemfaza)
 
 P = dspdata.psd(abs(x), 'Fs', fs); % Power spectral density
 P_pre = dspdata.psd(abs(x_pre), 'Fs', fs);
 
 subplot(221); plot(x); title('Signal - original');
 subplot(222); plot(x_pre); title('Signal - pre emphasis');
 subplot(223); plot(P); title('Power spectral density - original');
 subplot(224); plot(P_pre); title('Power spectral density - pre emphasis'); pause;
 
 %% Analyze and synthesis of speech
 for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygna�u
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x_pre(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    bx = bx - mean(bx);  % usu� warto�� �redni�
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    subplot(411); plot(n,bx); title('fragment sygna�u mowy');
    subplot(412); plot(r); title('jego funkcja autokorelacji'); 
    
    offset=20; rmax=max( r(offset : Mlen) );	   % znajd� maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajd� indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % g�oska d�wi�czna/bezd�wi�czna?
    % if (T>80) T=round(T/2); end							% znaleziono drug� podharmoniczn�
    T							   							% wy�wietl warto�� T
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;											% oblicz wsp�czynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);										% oblicz jego odp. cz�stotliwo�ciow�
    subplot(413); plot(abs(H)); title('widmo filtra traktu g�osowego');
    
    % lpc=[lpc; T; wzm; a; ];								% zapami�taj warto�ci parametr�w
    
    % SYNTEZA - odtw�rz na podstawie parametr�w ----------------------------------------------------------------------
    % T = 80;                                        % usu� pierwszy znak �%� i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end					% �przenie�� pobudzenie d�wi�czne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            pob=2*(rand(1,1)-0.5); gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            if (n==gdzie) pob=1; gdzie=gdzie+T;	   % pobudzenie d�wi�czne
            else pob=0; end
        end
        ss(n)=wzm*pob-bs*a;		% filtracja �syntetycznego� pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesun�cie bufora wyj�ciowego
    end
    subplot(414); plot(ss); title('zsyntezowany fragment sygna�u mowy'); pause
    s = [s ss];						% zapami�tanie zsyntezowanego fragmentu mowy
 end
 
 %% De-emphasis
 s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny