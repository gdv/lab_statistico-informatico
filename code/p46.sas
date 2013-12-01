%MACRO report(nazione=,variabili=);

PROC PRINT DATA=reddito;
    WHERE nazione="&nazione";
    %IF &variabili NE ALL %THEN
        VAR &variabili;
    %END
RUN;

%MEND report;
