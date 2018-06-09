# Filtro de optimizacion de error:
#
# Estima la densidad espectral de la señal observada,
# estima la varianza del ruido y se dseña el filtro.
#
close all;
clear all;
clc;
%% Frecuencias de entrada y muestreo
% Frecuencia de entrada
f=1e3;
 f1 = 2e3;
 % Frecuencia de muestreo
 fs=30e3; %1e3;%100e3; 30e3;50e3; 
 % Número de muestras
 N = 1500;
 
 % Tiempo
 t = 0:N-1;
 
 %% Fuga espectral
  L1=(f*N)/fs;
  L2=(f1*N)/fs;
  if((mod(L1,1)!=0)||(mod(L2,1)!=0))
    printf("Existe fuga espectral\n\n");
  endif
 
 M = 300;   %% Vantana de muestreo
 % Frecuencia normalizada
fn=f/fs;
 fn1 = f1/fs;
%% Señal de entrada
 am = 2.5;  % Amplitud
 fx=am*sin(2*pi*fn*t) + am*sin(2*pi*fn1*t);
%% Coeficientes para la extrapolacion
 x1 = 2*pi*fs*t(2);
 x2 = 2*pi*fs*t(3);
 x3 = 2*pi*fs*t(4);
 
% Desviación estandar
stddev=sqrt(2)/2;
 vari=stddev*stddev;
 printf("Varianza: %f \n", vari );
 
for i=0:M:(N-M)
  %% Ruido   
    r=stddev*randn(1,M);

  FFX = fft(fx(i+1:i+M));
   %% Filtro sin ruido valores conocidos 
   Rs = (FFX.*conj(FFX));   %%  <------------- Densidad espectral
   
   H = Rs./(Rs+vari);
   Ss(i+1:i+M) = ifft(FFX.*H);
  
  s(i+1:i+M)=fx(i+1:i+M)+r;
   %% Señal con ruido aditivo
    Fs = fft(s(i+1:i+M));
    
    Css = real(ifft(Fs.*conj(Fs)))/M;
    %% Extrapolacion lineal "help extpl" para mayor informacion  
%    cse = extpl(Css(3), Css(2), 0, x2, x1);

    %% Extrapolacion polinomial "help extquad" para mayor informacion
    cse = extquad(Css(2), Css(3), Css(4), x1, x2, x3, 0); 
    
    newvar = Css(1)-cse;
    
    if (newvar < 0 )
      newvari = 0;
    else
      newvari = newvar;
    endif
    printf("Varianza estimada: %f\n", newvari);
  
    Csk=[cse,Css(2:M)];
    Ps=fft(Csk)/M;    %% <---------- Agregar /N
%  
%    printf("Css(1:4) = %f %f %f %f\n\n", Css(1:4));
%  
%    printf("Csk(1:4) = %f %f %f %f\n", Csk(1:4));
    
    Hsb = Ps./(Ps+vari);    
    Hs = Ps./(Ps+newvari);  % <---------------------  Rs en lugar de Ps
    ssr(i+1:i+M) = ifft(Fs.*Hs);
    ssrb(i+1:i+M) = ifft(Fs.*Hsb);
endfor

figure;
  %% Imprimir señales
  subplot(4,1,1);
  plot(t/fs,fx);
  title("Señal sin ruido");
  
  subplot(4,1,2);
  plot(t/fs,s); %stem(nf,P3);
  title("Señal con ruido");
%  ylabel("Ruido blanco E[r]=0");
  
  grid on;
  subplot(4,1,3);
  plot(t/fs,ssrb); %stem(nf,P2);
  title("Varianza conocida");

  grid on;
  subplot(4,1,4);
  plot(t/fs,ssr); %stem(nf,P2);
  title("Varianza estimada");
  xlabel("Tiempo en segundos (s)")

  grid on;
