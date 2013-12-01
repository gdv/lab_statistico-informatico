libname corso 'Z:\FileSAS';

/*
 * controllo che il dataset sia stato caricato correttamente
 */
proc contents data=corso.nascar;
run;

data gare;
    set corso.nascar;
    array pos[5];
    array premio[5];
    array punti[5];
    array bonus[5];
    array status[5] $;
    array giri[5];
    do gara=1 to 5;
        girig=giri[gara];
        posizioneg=pos[gara];
        premiog=premio[gara];
        puntig=punti[gara];
        bonusg=bonus[gara];
        statusg=status[gara];
        puntitotalig=puntig+bonusg;
        if girig ne . then output;
        end;
    drop pos1-pos5 premio1-premio5 punti1-punti5 bonus1-bonus5 status1-status5;
run;

/*
 * punto 1
 */

proc means data=gare sum nway;
    var puntitotalig;
    class macchina;
    output out=classific sum=punti;
run;

/*
 * punto 2
 */

proc means data=gare n nway;
    id macchina gara;
    class macchina gara;
    where statusg EQ 'Running';
    output out=completis n=completi;
run;

/* punto 3 */

proc means data=completis mean kurtosis;
    var completi;
    class macchina;
run;

/* punto 4 */

proc corr data=gare;
    var girig premiog;
run;

/* punto 5 */

proc freq  data=gare;
    tables gara;
    where statusg='Running';
run;

/*
punto 6
*/
proc means data=gare sum nway /noprint;
    var puntitotalig;
    class id;
    output out=puntipilota sum=punti;
run;

proc means data=puntipilota /noprint max;
    var punti;
    id id;
    output out=punto6 maxid=migliore max=numpunti;
run;

proc print data=punto6;
run;
