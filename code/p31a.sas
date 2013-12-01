PROC FREQ DATA=votazioni /CHISQ;
        TABLES candidato*seggio;
        WEIGHT voti;
RUN;
