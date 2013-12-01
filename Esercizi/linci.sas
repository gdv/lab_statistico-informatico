libname corso 'Z:\FileSAS';
data corso.linci;
    infile 'Z:\FileSAS\dati.txt';
    input var1 var2 id anno1 prese1 anno2 prese2 anno3 prese3;
    drop var1 var2;
run;

data corso.linci2;
    set corso.linci;
    array anno[3];
    array prese[3];
    do i=1 to 3;
        periodo=anno[i];
        catture=prese[i];
        keep periodo catture;
        output;
        end;
run;

/* punto 2 */


title 'Numero medio di linci catturate';
proc means data=corso.linci2 mean;
    var catture;
run;


/* punto 3 */
proc reg data=corso.linci2;
    model catture=periodo;
run;

proc reg data=corso.linci2;
    model catture=periodo;
    plot (predicted. catture)*periodo  /overlay;
run;

/* punto 5 */
proc means data=corso.linci2 noprint;
    var catture;
    id periodo;
    output out=punto5 minid=anno_min;
run;

proc print data=punto5;
    var anno_min;
run;

/* punto 6 */
data punto6;
    set corso.linci2;
    retain precedente;
    differenza = catture - precedente;
    precedente = catture;
run;
