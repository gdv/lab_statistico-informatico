/*
punto 1
*/
libname lib 'Z:\FileSAS';
data lib.esame;
    infile 'Z:\FileSAS\auto.txt';
    input MPG 1-6 CILINDRI 7-9 LUNGHEZZA 10-15 POTENZA 16-21 PESO 22-28 ACCELERAZIONE 29-34 ANNO 35-38 ORIGINE 39-41 MODELLO$ 42-86;
run;




/*
punto 2
*/
data consumi;
    set lib.esame;
    consumo=4.4*100/ (1.60935  *mpg);
    keep modello consumo;
run;


/*
punto 3
*/

proc means data=lib.esame mean stddev skewness;
    var potenza;
    class anno;
run;

/*
punto 4
*/


proc corr data=lib.esame;
    var potenza peso accelerazione;
    with mpg;
run;



/*
punto 5
*/
proc reg  data=lib.esame;
    model mpg=peso;
    plot (mpg predicted.)*peso /overlay;
run;


/*
punto 6
*/
proc freq  data=lib.esame;
    tables anno*origine;
run;


/*
punto 8
*/
/* prima determino la dimensione dell'array */
proc means data=lib.esame n nway;
    class anno;
    output out=temp n=num;
run;
proc means data=temp max;
run;



/* poi ristrutturo il dataset */

proc sort data=lib.esame;
    by anno;
run;
data tabella;
    set lib.esame;
    by anno;
    array nome[40] $;
    retain nome1-nome40;
    if first.anno then do;
        do nummodelli=1 to 40;
            nome[nummodelli]=.;
            end;
        nummodelli=0;
        end;
    nummodelli+1;
    nome[nummodelli]=modello;
    if last.anno then do;
        keep anno nummodelli nome1-nome40;
        output;
        end;
run;
