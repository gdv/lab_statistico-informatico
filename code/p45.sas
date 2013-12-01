%MACRO report(nazione=);

PROC PRINT DATA=reddito;
    WHERE nazione="&nazione";
RUN;

%MEND report;
