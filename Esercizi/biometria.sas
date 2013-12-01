libname a 'z:\FileSAS';
data a.biometria;
	infile 'z:\FileSAS\biometria.txt';
	input DENSITA PERCENTUALEGRASSO ETA PESO ALTEZZA
			COLLO TORACE ADDOME FIANCO POLPACCIO GINOCCHIO
			CAVIGLIA BICIPITE AVAMBRACCIO POLSO;
run;
proc means data=a.biometria n nmiss;
run;

/* punto 2 
2.Calcolare media, deviazione standard e skewness della circonferenza del collo e del torace.
*/

proc means data=a.biometria mean std skew;
	var collo torace;
run;

/* punto 3 */
proc means mean max min;	
	var peso;
	class eta;
    output out=punto3 mean=media;
run;

/* punto 4 */
data b;
	set a.biometria;
	pesokg=peso*0.456;
run;

/* punto 5 */

proc corr data=a.biometria;
	var PESO ALTEZZA;
	with COLLO TORACE ADDOME FIANCO POLPACCIO GINOCCHIO
			CAVIGLIA BICIPITE AVAMBRACCIO POLSO;
run;

/* punto 6 */
proc reg data=a.biometria;
	model peso=altezza;
	plot (peso predicted.)*altezza /overlay;
run;

/* controllo outliers */
proc means data=a.biometria max min;	
	var altezza peso;
run;

/* punto 7 */
proc freq data=a.biometria;
	tables eta;
run;

/* punto 8 */
proc means data=a.biometria noprint nway;
	var altezza peso;
	class eta;
	output out=punto8 mean=altezzamedia pesomedio;
run;
proc print data=punto8;run;

/* punto 9 */
proc means data=punto8 noprint;
	var pesomedio;
	id eta;
	output out=punto9 maxid=quale;
run;
proc print data=punto9;
	var quale;
run;

/* punto 10 */
proc means data=a.biometria noprint nway;
	var eta;
	class eta;
	output out=dim n=numero;
run;
proc means data=dim max;
	var numero;
run;

%let dimensione = 17;

proc sort data=a.biometria;
	by eta;
run;

data punto10;
	set a.biometria;
	by eta;
	array c[&dimensione ];
	retain c1-c&dimensione ;

	if first.eta then do;
		do i=1 to &dimensione ;
			c[i]=.;
		end;
		i=0;
	end;

	i+1;
	c[i]=torace;

	if last.eta then output;
	keep eta c1-c&dimensione ;
run;

/*
Per ogni paziente, calcolare una variabile SCARTAMENTO che equivale alla
differenza fra il peso del paziente e il peso medio relativo all'età del
paziente (questa media è calcolata al punto 3).
*/

proc sort data=punto3;
    by eta;
run;
proc sort data=a.biometria;
    by eta;
run;
data punto11;
    merge punto3 a.biometria;
    by eta;
    scartamento = peso - media;
run;



/* Scrivere una macro che riceve in ingresso un valore
  detto soglia e crea un dataset chiamato SELEZIONATI che
  contiene le osservazioni relative a pazienti il cui peso differisca
  dalla media relativa all'età per un valore che è pari al massimo alla
  soglia.
*/

%macro punto12 (soglia=);
    data punto12;
        set punto11;
        if abs(scartamento) le soglia;
    run;
%mend punto12;
