PROC PRINT;
    VAR nome;
    ID cognome;
    TITLE 'elenco delle persone';
    WHERE peso > 80;
    FORMAT (cognome nome) $30.;
RUN;
