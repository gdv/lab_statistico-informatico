/* Leggere i dati in ingresso e memorizzarli in un data set SAS permanente. */
libname esame 'Z:\FileSAS';
data esame.fema;
    infile 'Z:\FileSAS\FEMA.csv' firstobs=2 dlm=',' dsd;
	input id data MMDDYY10. filler tipo $:99.  State $:99.  County $:99. Applicant $:999. 
           EducationChar$ NumeroProgetti  importo :DOLLAR10.2;
	drop filler;
run;

/* Stampare solo le prime 3 variabili del data set letto, visualizzando la data nel formato europeo (prima */
/* il giorno e dopo il mese). */

proc print data=esame.fema;
	format data DDMMYY10.;
	run;

/* Calcolare media, massimo e minimo della variabile Federal Share Obligated */
/* stratificata per County. */
proc means data=esame.fema mean max min;
    var importo;
    class county;
run;

/* Ripetere il punto precedente solo sulle osservazioni dell'anno 2008. */
proc means data=esame.fema mean max min;
    var importo;
    class county;
    where data>='01/01/2008'd and data<'01/01/2009'd;
run;
/* oppure */
proc means data=esame.fema mean max min;
    var importo;
    class county;
    where year(data) = 2008;
run;

/* Si calcoli la correlazione fra le variabili Federal Share Obligated e Number of Projects. */
proc corr data=esame.fema;
    var importo NumeroProgetti;
run;

/* Scrivere una macro che esegua il punto precedente solo relativamente alle */
/* osservazioni con data compresa fra due estremi ricevuti in ingresso. */
MACRO corr_tra_date(inizio=, fine=);
proc corr data=esame.fema;
    var importo NumeroProgetti;
    where data>=&inizio and data<=&fine;
run;
%MEND corr_tra_date;

/* prova */
scegli_stato(Kansas);

/* Rappresentare graficamente la correlazione fra le variabili  correlate al punto */
/* precedente. */
/* Bisogna rappresentare sia le variabili che la retta di regressione. */

   /*Mi sembra ragionevole assumere che l'importo sia la variabile dipendente*/
ods graphics on;
proc reg data=esame.fema;
    model importo=numeroprogetti;
run;
ods graphics off;


/* Creare un nuovo dataset temporaneo contenente solo le osservazioni relative */
/* allo Stato del Texas. */
/* Nel nuovo dataset creare una nuova variabile StanziamentoMedio */
/* che contiene il rapporto fra i fondi stanziati e il numero di progetti. */
data nuovo;
    set esame.fema;
    rapporto=importo/NumeroProgetti;
    if state eq 'Texas';
run;


/* Scrivere una macro di SAS che riceve in ingresso il nome di uno stato e */
/* esegue il punto precedente relativamente allo stato in ingresso. */
%MACRO scegli_stato(stato=);
data nuovo;
    set esame.fema;
    rapporto=importo/NumeroProgetti;
    %if state eq &stato %THEN output;
run;
%MEND scegli_stato;

scegli_stato(stato=Texas)
/* Determinare quale stato ha ricevuto la quantità  maggiore di fondi totali */
/* (quindi bisogna determinare per ogni stato il totale dei fondi ricevuti). */
proc means data=esame.fema sum noprint nway;
    var importo;
    class state;
    output out=distribuzione sum=totale;
run;
proc means data=distribuzione noprint nway;
    var totale;
    id state;
    output out=risultato maxid=quale;
run;
proc print data=risultato;
    var quale;
run;



/* Determinare come i fondi siano stati ripartiti, sia in valore assoluto che in */
/* percentuale, rispetto allo stato e al fatto che il richiedente sia nel campo */
/* dell'istruzione (Education Applicant). */

proc freq data=esame.fema;
    tables EducationChar*State;
    weight importo;
run;


/* Creare un nuovo data set con i risultati ottenuti al punto precedente. */
ods trace on;
proc freq data=esame.fema;
    tables EducationChar*State;
    weight importo;

run;
ods trace off;

proc freq data=esame.fema;
	tables EducationChar*State;
    weight importo;
	ods output Freq.Table1.CrossTabFreqs = risultati;
run;
proc print data=risultati;run;

/* Ristrutturare il dataset in modo da avere una osservazione per ogni stato */
/* ed una coppia di variabili per ogni stanziamento che tale stato ha ricevuto. */
/* Per ogni stanziamento bisogna memorizzare il nome del progetto e lo */
/* stanziamento ricevuto. Ad esempio, le variabili nel nuovo data set potrebbero */
/* essere STATO, PROGETTO1, .. , PROGETTOn, STANZIAMENTO1, .. , PROGETTOn, dove n */
/* deve essere determinato. */

/* Scrivere il contenuto del nuovo data set in un file di campi separati da punti */
/* e virgole. */

proc means data=esame.fema n noprint nway;
    class state;
    var NumeroProgetti;
    output out=quanti n=numero;
run;
proc means data=quanti max;
    var numero;
run;
/* L'array deve avere dimensione 7384
 */
proc sort data=esame.fema;
    by stato;
run;
data ristrutturato;
    set esame.fema;
    by stato;
    array progetto[7384];
    array stanziamento[7384];

    if first.stato then do;
        do i=1 to 7384;
            progetto[i]=.;
            stanziamento[i]=.;
            end;
        i=0;
        end;

    i+1;
    progetto[i]=Applicant;
    stanziamento[i]=importo;

    if last.stato then output;
    keep stato progetto1-progetto7384 stanziamento1-stanziamento7384;
    put "E:\nuovo.txt" dlm=';' dsd;
run;


/* Leggere il file di dati FEMA2.txt contenente, per ogni tipologia di emergenza, */
/* un valore di severità  associato. */
data fema2;
    infile 'Z:\FileSAS\FEMA2.txt';
	input valore 1-2 tipo$:30.;
run;


/* Determinare la correlazione fra tale valore di severitÃ  e lo stanziamento */
/* ottenuto. */
proc sort data=esame.fema;
    by tipo;
proc sort data=fema2;
    by tipo;

data fusi;
    merge esame.fema fema2;
    by tipo;
run;

proc corr data=fusi;
    var valore importo;
run;

/* La correlazione calcolata in questo punto Ã¨ piÃ¹ o meno forte rispetto a quella */
/* calcolata al punto 5? */
proc corr data=fusi best=1;
    var valore NumeroProgetti;
    with importo;
run;
    /* dall'output è evidente che la correlazione più significativa è quella con
        NumeroProgetti
        */