DATA nome;
 INFILE nomefile;
 INPUT nome$ +1 cognome$ @30
     (altezza peso) COMMA7.;
RUN;
