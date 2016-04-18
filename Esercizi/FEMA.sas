libname a 'z:\FileSAS';
data a.fema;
        infile 'z:\FileSAS\FEMA.csv' dlm=',' dsd firstobs=2 ;
        input DisasterNumber DeclarationDate MMDDYY10. filler IncidentType :$99.
                State :$40.
                County :$99. ApplicantName :$99. EducationApplicant :$3. NumberProjects
                FederalShareObligated :DOLLAR15.2;
        drop filler;
run;

proc means data=a.fema n nmiss;
        var filler;
run;

/* punto 2 */
data punto2;
        set a.fema;
        keep DisasterNumber DeclarationDate IncidentType;
run;

proc format;
        value $ed 'Yes'=1 'No'=0;
run;

proc print data=a.fema;
        format DeclarationDate DDMMYY10.;
        format EducationApplicant $ed.;
run;

/* punto 3 */
proc means data=a.fema mean max min;
        var FederalShareObligated ;
        class county;
run;


/* punto 4 */
proc means data=a.fema mean max min;
        var FederalShareObligated ;
        class county;
        where year(DeclarationDate)=2008;
run;

/* oppure */
proc means data=a.fema mean max min;
        var FederalShareObligated ;
        class county;
        where DeclarationDate >= '01Jan2008'd and DeclarationDate <= '21Dec2008'd ;
run;

/* punto 5 */
data punto8;
    set a.fema;
    StanziamentoMedio=FederalShareObligated/NumberProjects;
    if state eq 'Texas';
run;


/* punto 6 */
proc means data=a.fema noprint nway;
    var FederalShareObligated;
    class state;
    output out=punto10 sum=totale;
run;

proc means data=punto10 noprint;
    var totale;
    id state;
    output out=punto10a maxid=quale_stato;
run;

proc print data=punto10a;
    var quale_stato;
run;

/* punto 7 */
proc freq data=a.fema;
    weight FederalShareObligated;
    tables state*EducationApplicant;
    where FederalShareObligated >= 0;
run;

/* punto 8 */

proc freq data=a.fema;
    weight FederalShareObligated;
    tables state*EducationApplicant;
    where FederalShareObligated >= 0;
    ods output Freq.Table1.CrossTabFreqs=punto12;
run;

/* punto 9 */
proc means data=a.fema noprint nway;
    class state;
    output out=dim n=numero;
run;
proc means data=dim max;
    var numero;
run;


proc sort data=a.fema;
    by state;
run;


data ristrutturato;
    set a.fema;
    by state;
    array destinatario[7384] $;
    array stanziamento[7384];
    retain destinatario1-destinatario7384;
    retain stanziamento1-stanziamento7384;

    if first.state then do;
        do i=1 to &dimensione;
            destinatario[i]=.;
            stanziamento[i]=.;
            end;
        i=0;
        end;

    i+1;
    destinatario[i]= ApplicantName ;
    stanziamento[i]= FederalShareObligated ;

    if last.state then output;
    keep state destinatario1-destinatario7384
        stanziamento1-stanziamento7384;
run;

proc print data=ristrutturato;run;

/* punto 10 */
data _NULL_;
    set ristrutturato;
    file 'z:\FileSAS\fema-output.txt' dlm=';' dsd lrecl=99999;
    put state $:40. (destinatario1-destinatario&dimensione) ($:99.)
        stanziamento1-stanziamento&dimensione;
run;

/* punto 11 */
data legenda;
    infile 'z:\FileSAS\FEMA2.txt' truncover;
    input livello 1-2 IncidentType $ 3-99 ;
run;

proc sort data=a.fema;
    by IncidentType;
run;
proc sort data=legenda;
    by IncidentType;
run;

/* punto 12 */
data punto15;
    merge legenda a.fema;
    by IncidentType;
run;
