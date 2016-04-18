data elezioni;
        infile 'z:\FileSAS\fl2000.txt' dlm=',' dsd;
        input county $:30. technology $:30. columns voti1-voti14;
        /* in voti1 si trovano le schede bianche,
                in voti2 si trovano le nulle.
        */
run;
proc print data=elezioni;run;

data elezioni2;
        set elezioni;
        array voti[14];
        do codice=1 to 14;
                numero_voti=voti[codice];
                output;
        end;
        drop voti1-voti14;
run;
proc print data=elezioni2;run;

/* punto 1 */
proc means data=elezioni2 sum;
        var numero_voti;
        class codice;
        where codice > 2;
run;

/* punti 1 e 2 */

proc format;
    value candidato
        1='Bianche'
        2='Nulle'
        3='Bush'
        4='Gore'
        5='Browne'
        6='Nader'
        7='Harris'
        8='Hagelin'
        9='Buchanan'
        10='McReynolds'
        11='Phylips'
        12='Moorehead'
        13='Chote'
        14='McCharthy';
run;


proc freq data=elezioni2;
        format codice candidato.;
        weight numero_voti;
        tables  codice;
        where codice > 2;
run;

/* punto 3 */
proc means data=elezioni2 noprint nway;
        var numero_voti;
        class county;
        id codice;
        output out=punto3 maxid=candidato_vincente max=voti;
run;
proc print data=punto3;
        var candidato_vincente voti;
        format candidato_vincente candidato.;
run;

/* punto 4 */
proc means data=elezioni2 sum nway;
        var numero_voti;
        class columns codice;
        output out=punto4c sum=totale_voti;
proc means data=elezioni2 sum nway;
        var numero_voti;
        class technology codice;
        output out=punto4t sum=totale_voti;
run;

/* punto 5 */
data elezioni;
    set elezioni;
    non_validi=voti1+voti2;
run;
proc means data=elezioni noprint nway;
    var non_validi;
    id county;
    output out=punto5a maxid=dove;
run;
proc print data=punto5a;run;

proc means data=elezioni2 noprint nway;
    var numero_voti;
    class county;
    output out=punto5b sum=voti_totali;
run;
proc print data=punto5b;run;

proc sort data=elezioni; by county; run;
proc sort data=punto5b; by county; run;

data punto5c;
    merge punto5b elezioni;
    by county;
    percentuale_non_validi=non_validi/voti_totali;
run;
proc print data=punto5c;run;

proc means data=punto5c noprint nway;
    var percentuale_non_validi;
    id county;
    output out=punto5d maxid=dove;
run;
proc print data=punto5d;run;

/* punto 6 con merge */
proc means data=elezioni2 sum nway;
    var numero_voti;
    class county;
    where codice > 2;
    output out=validi sum=voti_validi;
run;

proc sort data=elezioni;
    by county;
run;

proc sort data=validi;
    by county;
run;

data punto6merge;
    merge elezioni validi;
    by county;
    drop _type_ _freq_;
run;

proc means data=punto6merge n;
    var columns;
    where voti6/voti_validi >= 2/100;
run;

/* punto 6 con ods */
ods trace on;
proc freq data=elezioni2;
    tables codice*county;
    weight numero_voti;
    where codice>2;
    ods output Freq.Table1.CrossTabFreqs=punto6ods;
run;
ods trace off;

proc means data=punto6ods n;
    where codice=6 and PercentCol >= 2;
    var codice;
run;
