DATA nome;
 SET data set originale;
 KEEP variabili da tenere;
RUN;

DATA nome;
    SET data set originale;
    DROP variabili da eliminare;
RUN;

DATA nome;
    SET data set originale;
    KEEP variabili da tenere;
    RENAME=(vecchia=nuova);    
RUN;
