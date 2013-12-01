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
proc corr data=a.fema;
        var FederalShareObligated NumberProjects;
run;


/* punto 6 */

%macro punto6(inizio=,fine=);
proc corr data=a.fema;
        var FederalShareObligated NumberProjects;
        where DeclarationDate >= "&inizio"d and DeclarationDate <= "&fine"d ;
run;
%mend punto6;


%punto6(inizio=26Aug1998, fine=26Aug1998);

/* punto 7 */
proc reg data=a.fema;
        model FederalShareObligated=NumberProjects;
        plot (predicted. FederalShareObligated)* NumberProjects /overlay;
run;

/* punto 8 */
data punto8;
        set a.fema;
        StanziamentoMedio=FederalShareObligated/NumberProjects;
        if state eq 'Texas';
run;


/* punto 9 */
%macro punto9(stato=);
data punto9_&stato;
        set a.fema;
        StanziamentoMedio=FederalShareObligated/NumberProjects;
        if state eq "&stato";
run;
%mend punto9;

%punto9(stato=Texas);
%punto9(stato=Alabama);

/* punto 10 */
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

/* punto 11 */
proc freq data=a.fema;
        weight FederalShareObligated;
        tables state*EducationApplicant;
        where FederalShareObligated >= 0;
run;

/* punto 12 */

proc freq data=a.fema;
        weight FederalShareObligated;
        tables state*EducationApplicant;
        where FederalShareObligated >= 0;
        ods output Freq.Table1.CrossTabFreqs=punto12;
run;

/* punto 13 */
proc means data=a.fema noprint nway;
        class state;
        output out=dim n=numero;
run;
proc means data=dim max;
        var numero;
run;


%let dimensione= 7384;
proc sort data=a.fema;
        by state;
run;


data ristrutturato;
        set a.fema;
        by state;
        array destinatario[&dimensione] $;
        array stanziamento[&dimensione];
        retain destinatario1-destinatario&dimensione;
        retain stanziamento1-stanziamento&dimensione;

        if first.state then do;
                do i=1 to &dimensione;
                        destinatario[i]=.;
                        stanziamento[i]=.;
                end;
                i=0;
        end;

        i+1;
        destinatario[i]= ApplicantName ;
        stanziamento[i]=		FederalShareObligated ;

        if last.state then output;
        keep state destinatario1-destinatario&dimensione
                        stanziamento1-stanziamento&dimensione;
run;

proc print data=ristrutturato;run;

/* punto 14 */
data _NULL_;
        set ristrutturato;
        file 'z:\FileSAS\fema-output.txt' dlm=';' dsd lrecl=99999;
        put state $:40. (destinatario1-destinatario&dimensione) ($:99.)
                        stanziamento1-stanziamento&dimensione;
run;

/* punto 15 */
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

data punto15;
        merge legenda a.fema;
        by IncidentType;
run;

proc corr data=punto15;
        var livello;
        with            FederalShareObligated ;
run;
