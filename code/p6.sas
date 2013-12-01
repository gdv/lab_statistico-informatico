DATA nome;
 INFILE nomefile DLM='09'x;
 INPUT nome$ cognome$ altezza peso;
RUN;
