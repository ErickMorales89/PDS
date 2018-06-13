% Función para eliminar ruido de un audio
% 
% 
% 
% 
close all;
clear all;
clc;
%% Obtener audio
[y,fs]=audioread('latristeza1.mp3');
y=y(:,1);
N1=length(y);
%% Obtenemos un pedazo del audio (señal limpia)
s=y(N1/8:N1/6);
% sound(s,fs);
subplot(3,1,1);
plot(s);
title('Audio limpio (Original)');
N=length(s);
%% Numero de muestras de la ventana a desplazar Nv tiene que ser impar
Nv=3;
inc1=(Nv+1)/2;  % in1 punto en medio de la ventana
inc2=(Nv-1)/2;  % inc2 ancho de la ventana 
ceros=zeros(inc2,1);
%% valores de x para la extrapolación
x1=2*pi*fs*1;
x2=2*pi*fs*2;
x3=2*pi*fs*3;
%% Ruido distribución gausiano 
var1=0.01; %0.005; 0.01; 0.05; 0.1;
r=var1*randn(N,1);
%% Se agregan ceros para que el primer y último valor quede en medio de la 
%ventana
f=[ceros;s+r;ceros];    %s+r señal más ruido aditivo

sound(f,fs);    
subplot(3,1,2);
plot(f);
title('Audio con ruido');
%% Estimación de la varianza del ruido
FF=fft(f);
crf=real(ifft(FF.*conj(FF)))/N;
sigr=extquad(crf(2), crf(3), crf(4), x1, x2, x3, 0);  % varianza del ruido
%%
f0=0;   % f0 valor inicial para la sumad el valor medio de señal con ruido
f1=0;   % f1 valor inicial para la suma de la varianza
se=zeros(N-2*inc2,1);   % variable que almacenara los datos de salida
N=length(f);    % Nueva longitud con los ceros agregados
for i=inc1:N-inc1
    for j=inc2:-1:-inc2
        f0=f1+f(i-j);
        f1=f1+f(i-j)^2;
    end
    med = f0/Nv;    % Media de la señal con ruido
    sig=(f1/Nv)-med^2;  % varianza de la señal con ruido
    sige=sig-sigr;  % varainza de la señal estimada
    if (sige<0)
        sige=0;
    end
    se(i-inc2)=med+(sige/(sige+sigr))*(f(i)-med);
    f0=0;
    f1=0;
end
subplot(3,1,3);
plot(se);
title('Audio procesado');
