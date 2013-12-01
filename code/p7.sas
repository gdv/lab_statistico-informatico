DATA nome;
 INFILE nomefile;
 INPUT nome$ 1-10 cognome$ 11-20
       altezza 21-25 peso 28-30;
RUN;
