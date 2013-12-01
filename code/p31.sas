PROC FREQ DATA=votazioni;
        TABLES candidato*seggio;
        WEIGHT voti;
RUN;
