/*  dati grezzi che si trovano nel file riguardano varie specie animali. I dati sono associabili alle seguenti variabili:

SPECIE: nome della specie.
PESO: peso corporeo in kg.
CERVELLO: peso del cervello in grammi.
SONNO1: durata del sonno senza sogni in un giorno.
SONNO2: durata del sonno con sogni in un giorno.
SONNOTOT: durata totale (in ore) del sonno in un giorno.
VITA: massima vita possibile in anni.
GESTAZIONE: durata in giorni della gestazione.
PREDATORE: indicatore di come la specie sia preda (5) o predatore (1), varia fra 1 e 5.
LUOGOSONNO: indicatore della pericolosità del luogo in cui dorme, varia fra 1 e 5.
PERICOLO: indicatore di quanto sia a pericolo la specie, varia fra 1 e 5.

Si richiede di scrivere un programma SAS per l'analisi dei dati secondo i seguenti punti.

1. Leggere i dati in ingresso e memorizzarli in un dataset SAS temporaneo. */

data zoologia;
        infile 'z:\FileSAS\16a-dati.txt' ;
        input SPECIE $ 1-25 PESO CERVELLO SONNO1 SONNO2 SONNOTOT VITA GESTAZIONE PREDATORE
          LUOGOSONNO PERICOLO;
run;




/*
2. Il valore -999.0 corrisponde a valori mancanti. Modificare il dataset (o crearne uno nuovo)
in cui i dati mancanti siano rappresentati con il punto. */
data zoologia;
        set zoologia;
        array dati[10] PESO CERVELLO SONNO1 SONNO2 SONNOTOT VITA GESTAZIONE PREDATORE
          LUOGOSONNO PERICOLO;
        do i=1 to 10;
                if dati[i]=-999 then dati[i]=.;
        end;
        drop i;
run;
proc print;run;
/* 3. Calcolare il valore medio di sonno con sogni e sonno totale stratificato per PERICOLO. */

proc means data=zoologia mean;
        var sonno2 sonnotot;
        class pericolo;
run;

/* 4. Calcolare media, deviazione standard e skewness della variabile GESTAZIONE. */
proc means data=zoologia mean std skewness;
        var gestazione;
run;

/* 5. Quale animale ha la vita (massima) più breve? */
proc means data=zoologia min;
        var vita;
        id specie;
        where vita ne .;
        output out=punto5 minid=quale min=quanto;
run;
proc print data=punto5;run;


/* 6. Aggiungere al dataset una variabile PERCSONNO che indica la percentuale di tempo
passata dormendo. */

data zoologia;
        set zoologia;
        percsonno=sonnotot/24*100;
run;

/* 7. Calcolare, la distribuzione percentuale del numero di specie per ogni possibile
valore della variabile LUOGOSONNO. */

proc freq data=zoologia;
        tables luogosonno;
run;

/* 8. Determinare la correlazione fra PERCSONNO (var. indipendente) e la durata di vita,
la durata di gestazione e la variabile PERICOLO (possibili var. dipendenti). */

proc corr data=zoologia;
        var percsonno;
        with vita gestazione pericolo;
run;

/* 9. Rappresentare graficamente la correlazione più forte trovata al punto precedente
(rappresentare sia la retta di regressione che il grafico dei punti effettivi del dataset) */
proc corr data=zoologia best=1;
        var percsonno;
        with vita gestazione pericolo;
run;

proc reg data=zoologia;
        model gestazione=percsonno;
        plot (gestazione predicted.)*percsonno /overlay;
run;

/* 10. Stampare gli animali in ordine crescente di tempo di gestazione. */

proc sort data=zoologia;
        by gestazione;
        run;
proc print data=zoologia;run;

/* 11. Ristrutturare il dataset in modo da avere una osservazione per ogni valore distinto
della variabile LUOGOSONNO e come dati, oltre al valore della variabile LUOGOSONNO, i nomi
delle specie che hanno quel determinato valore. */

proc means data=zoologia n noprint nway;
        class luogosonno;
        var luogosonno;
        output out=dimensione n=numero;
proc means data=dimensione max;
        var numero;
run;

proc sort data=zoologia;
        by luogosonno;
data ristrutturato;
        set zoologia;
        by luogosonno;
        array nomi[27] $;
        retain nomi;

        if first.luogosonno then do;
                do i=1 to 27;
                        nomi[i]=.;
                end;
                i=0;
        end;

        i+1;
        nomi[i]=specie;

        if last.luogosonno then output;
        keep luogosonno nomi1-nomi27;
run;


proc print data=ristrutturato;

run;
