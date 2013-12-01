libname corso 'z:\FileSAS';
data vento;
        infile 'z:\FileSAS\vento.txt';
        input anno 1-2 mese 3-4 giorno 5-6 rilevazione1-rilevazione12;
run;

/* per il punto 5 devo ristrutturare il dataset */
data verticale;
        set vento;
        by anno;
        array rilevazione[12];
        do stazione=1 to 12;
                velocita=rilevazione[stazione];
                if velocita ne . then output;
        end;
        keep anno velocita stazione;
run;

/* punto 2 */
proc means data=vento n;
    var rilevazione1;
    class anno;
run;

/* punto 3 */
proc freq data=corso.vento;
        tables anno;
        where velocita ne .;
run;

/* punto 4 */
proc means data=verticale2 nway noprint;
        var velocita;
        class stazione;
        output out=punto4 mean=media;
run;
proc means data=punto4 noprint min;
        var media;
        id stazione;
        output out=punto4b minid=quale;
run;
proc print data=punto4b; var quale; run;

/* punto 5 */
proc freq data=verticale;
        tables stazione*anno;
        weight velocita;
run;

/* punto 6 */
proc corr data=vento;
        var rilevazione1-rilevazione12;
run;

/* punto 7 */
proc corr data=vento best=2;
        var rilevazione1-rilevazione12;
run;
proc reg data=vento;
        model rilevazione5=rilevazione6;
        plot (p. rilevazione5)*rilevazione6 /overlay;
run;
quit;


/* punto 8 */
    ods trace on;
proc freq data=verticale;
        tables stazione*anno;
        weight velocita;
        ODS OUTPUT  Freq.Table1.CrossTabFreqs = dataset2;
run;
    ods trace off;

data dataset2;
    set dataset2;
    if percent >= 1 and stazione ne . and anno ne .;
    keep anno stazione percent;
run;
