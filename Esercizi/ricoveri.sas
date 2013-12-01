data esame;
    infile 'Z:\FileSAS\ricoveri.txt' dlm='09'x;
    input id sta age sex race ser can crn inf spr sys hra pre typ fra po2 ph pco bic cre loc;
run;

/* punto 2 */
proc means data=esame mean std skewness;
    var sys;
    class race;
run;

/* punto 3 */
proc reg data=esame ;
    model sys=hra;
    plot (predicted. sys)*hra /overlay;
run;

/* punto 4 */
proc freq data=esame ;
    tables race*sex;
    where ph=1;
run;


/* punto 6 */
proc means data=esame max min noprint nway;
    class age;
    var sys;
    output out=punto6 max(sys)=massimo_sys min(sys)=minimo_sys
        max(hra)=massimo_hra min(hra)=minimo_hra;
run;
/* punto 7 */
proc means data=punto6 max noprint;
    id age;
    var minimo;
    output out=punto7 maxid=dovemassimo;
run;
/* punto 8 */
libname def 'Z:\FileSAS';
data def.punto8;
    set esame;
    if fra=1 and pre=1;
run;
/* punto 9 */
data esame;
    set esame;
    if fra=1 and pre=1 then punto8=1;
                                    else punto8=0;
run;
proc freq data=esame;
    tables punto8;
run;
/* punto 10 */
proc sort data=esame;
    by race;
run;
proc means data=esame n nway noprint;
    by race;
    output out=quanti n=numero;
run;
proc means data=quanti max;
    var numero;
run;
data punto10;
    set esame;
    array sistolica[175];
    retain sistolica1-sistolica175;
    by race;
    if first.race then do;
        do i=1 to 175;
            sistolica[i]=.;
        end;
        i=0;
    end;
    i+1;
    sistolica[i]=sys;
    if last.race;
    keep race sistolica1-sistolica175;
run;
