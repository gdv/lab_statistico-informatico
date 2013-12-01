data ferrovia;
    infile 'Z:\FileSAS\ferrovia.txt';
    input numeropasseggeri per anno mese$ tempo codicemese logaritmonumeropasseggeri relcamb;
run;

/*
* punto1
*/
proc means data=ferrovia sum nway;
    var numeropasseggeri;
    class anno;
run;

/* punto 1, con proc freq */
proc freq data=ferrovia;
    weight numeropasseggeri;
    tables anno;
run;

/*
 * punto 2
 *
 *Per calcolare la correlazione, il numero di passeggeri deve occupare una
 *variabile per ogni mese. Diventa quindi necessario ristrutturare il dataset in
 *modo da avere un dataset con una osservazione per anno
*/
proc sort data=ferrovia;
    by anno;
run;
data mesi;
    set ferrovia;
    array mesi[12];
    retain mesi1-mesi12;
    by anno;
    if first.anno then do;
        do i=1 to 12;
            mesi[i]=.;
            end;
        end;
    mesi[codicemese]=numeropasseggeri;
    if last.anno then output;
    keep anno mesi1-mesi12;
run;

proc corr data=mesi;
        var mesi1-mesi12;
run;

/*
Punto 3:
Utilizziamo la proc means
*/

proc means nway noprint data=ferrovia sum nway noprint;
    var numeropasseggeri;
    class anno;
    output out=anno sum=numpasseggeri;
run;

/*
punto 4
*/
proc freq data=ferrovia;
    tables anno*mese;
    weight numeropasseggeri;
run;
