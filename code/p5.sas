DATA nome;
 INFILE nomefile DLM=',' DSD;
 INPUT nome$ cognome$ altezza peso;
RUN;
