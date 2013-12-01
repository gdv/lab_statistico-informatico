LIBNAME esercizi "E:\libreriaSAS";

DATA esercizi.nomipersone;
 INFILE 'E:\anagrafe.txt' LRECL=2000;
 INPUT nome$ cognome$ altezza peso;
RUN;
