PROC MEANS DATA=dataset N MEAN;
    VAR variabile1 variabile2;
    CLASS variabile3;
    ID variabile3;
    OUTPUT OUT=nuovodat MEAN=media
    MAXID=massimo;
run;
