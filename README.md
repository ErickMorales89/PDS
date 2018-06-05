# PDS
Filter Wiener

En el dominio de la frecuencia, el filtro que optimiza el error cuadratico promedio es:
              Ps(u)
H(u) = --------------------
          Ps(u) + Pr(u)
          
filt_opt_error.m instancia al archivo extquad.m que es una función de extrapolación cuadratica,
la cual se puede sustituir en el código por la extrapolación lineal extpl.m 

Sea el modelo:

  f(n) = s(n) + r(n)
  
  f(n) señal observada
  s(n) señal limpia (libre de ruido)
  r(n) ruido aditivo con distribución N(0,var)
    var: varianza
    
el archivo filt_opt_error.m estima la señal limpia.
