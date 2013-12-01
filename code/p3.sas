LIBNAME esercizi "E:\libreriaSAS";

DATA esercizi.nomipersone;
 INFILE 'E:\anagrafe.txt';
 INPUT nome$ cognome$ altezza peso;
RUN;
