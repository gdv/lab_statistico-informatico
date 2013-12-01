PROC CORR DATA=meteo BEST=1;
    VAR temp1-temp3;
    WITH temp4-temp5;
RUN;
