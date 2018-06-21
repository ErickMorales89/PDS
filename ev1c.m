% Adaptative median filter (Filtro adaptativo de media)
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
Nv=21;
cntro=(Nv+1)/2;  % punto medio de la ventana
anc=(Nv-1)/2;  % ancho de la ventana 
wind = 3;  % primer vecindario
nbh = (wind-1)/2;
ceros=zeros(anc,1);
%% Ruido distribución gausiano 
var1=0.001; %0.005; 0.01; 0.05; 0.1;
r=var1*randn(N,1);
%% Se agregan ceros para que el primer y último valor que de en medio de la 
%ventana
f=[ceros;s+r;ceros];    %s+r señal más ruido aditivo
% f=s+r;
sound(f,fs);    
subplot(3,1,2);
plot(f);
title('Audio con ruido');
N=length(f);    % Nueva longitud con los ceros agregados
se=zeros(N-2*anc,1);   % variable que almacenara los datos de salida

%% usar nbh
for i=cntro:N-cntro 
    band=1;
    nbh = (wind-1)/2;
    while band
        minim=min(f(i-nbh:i+nbh));
        maxim=max(f(i-nbh:i+nbh));
        medi=median(f(i-nbh:i+nbh));
        
        med=abs(medi);
        mini=abs(minim);
        maxi=abs(maxim);
        
        Er1=med-mini;
        Er2=med-maxi;
        Ev1=f(i)-mini;
        Ev2=f(i)-maxi;
        if((Er1>0)&&(Er2<0))
            if((Ev1>0)&&(Ev2<0))
                se(i-anc)=f(i);
                band=0; %break;
            else
                se(i-anc)=medi;
                band=0; %break;
            end
        else
            nbh=nbh+1;
            band=1;
            if nbh>=anc
                se(i-anc)=medi;
                band=0; %break
            end
        end
    end
end

subplot(3,1,3);
plot(se);
title('Audio procesado');