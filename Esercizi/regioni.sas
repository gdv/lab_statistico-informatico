/*
 * Salvo il file regioni.txt, poi leggo i dati
 */
libname libreria 'Z:\FileSAS';
data libreria.regioni;
    infile 'Z:\FileSAS\regioni.txt';
    input regione $:20. popolazione superficie;
run;

data densi;
     set libreria.regioni;
    densita=popolazione/superficie;
run;


data piccole;
    set libreria.regioni;
    if superficie LT 10000;
run;
data grandi;
    set libreria.regioni;
    if superficie GT 20000;
run;
/*
 * creo ed esporto le regioni di media grandezza
 */
data medie;
    set libreria.regioni;
    if superficie GE 10000 AND superficie LE 20000;
run;

/* esportazione */

data medie;
    set medie;
    file 'Z:\FileSAS\esportati.txt' dlm=';';
    put regione popolazione superficie;
run;
