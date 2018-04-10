/*
Si analizzino i dati del file elezioni.txt, rappresentati i voti 
espressi in Florida nell’elezione presidenziale del 2000. Le 
variabili sono: county, technology, columns, schede bianche, nulle, 
oltre ai voti raccolti dai 12 candidati, ovvero Bush, Gore, Browne, 
Nader, Harris, Hagelin, Buchanan, McReynolds, Phillips, Moorehead, 
Chote, McCarthy.
*/

data elezioni;
	infile 'C:\Users\gianluca.dellavedova\Downloads\elezioni.txt'
		dlm = ',' dsd;
	input county :$99. technology :$99. columns voti1-voti14;
run;

proc means data=elezioni n nmiss;
run;

/*
Calcolare il numero totale di voti raccolti da ogni candidato 
(escluse schede bianche e nulle).
*/
/*
Calcolare la percentuale di voti raccolti da ogni candidato 
(escluse schede bianche e nulle).
*/
data verticale;
	set elezioni;
	array voti[14];
	do candidato = 1 to 14;
		numero = voti[candidato];
		output;
	end;
	keep county technology columns candidato numero;
run;

proc format;
	value cand 1 = 'Bianche'
				2 = 'Nulle'
				3 = 'Bush' 
				4 = 'Gore' 
				5 = 'Browne'
				6 = 'Nader' 
				7 = 'Harris'
				8 = 'Hagelin'
				9 = 'Buchanan'
				10 = 'McReynolds'
				11 = 'Phillips'
				12 = 'Moorehead'
				13 = 'Chote'
				14 = 'McCarthy';
run;
proc freq data=verticale;
	tables candidato;
	weight numero;
	format candidato cand.;
	where candidato gt 2;
run;
/*
Per ogni contea, determinare il candidato che ha ottenuto il numero 
massimo di voti.
*/
proc means data=verticale nway noprint;
	var numero;
	id candidato;
	class county;
	output out=votato maxid=vincitore;
run;
proc print data=votato;
	var county vincitore;
	format vincitore cand.;
run;
/*
Calcolare il numero totale di voti per candidato distinto per tipo 
di colonne nella scheda (columns) e modalità di conteggio 
(technology). Rappresentare le informazioni in due tabelle (una per 
columns, una per technology).
*/
proc freq data=verticale;
	tables candidato*columns;
	weight numero;
	format candidato cand.;
run;

proc freq data=verticale;
	tables candidato*technology;
	weight numero;
	format candidato cand.;
run;

/*
Creare una variabile che contenga i voti non validi (bianche + 
nulle). Dove si è verificato il numero massimo? E dove si è 
verificata la percentuale massima?
*/
data elezioni2;
	set elezioni;
	array voti[14];
	non_validi = voti[1] + voti[2];
	validi = sum(of voti3-voti14);
	perc = non_validi / (validi + non_validi) * 100;
	keep county non_validi perc;
run;

proc means data=elezioni2 noprint;
	var non_validi;
	id county;
	output out=massimo1 maxid=maxnumero;
run;
proc print data=massimo1;
	var maxnumero;
run;

proc means data=elezioni2 noprint;
	var perc;
	id county;
	output out=massimo2 maxid=maxperc;
run;
proc print data=massimo2;
	var maxperc;
run;	
/*
In quante contee Nader ha ottenuto almeno il 2% dei voti validi?
*/
ods trace on;
proc freq data=verticale;
	tables county*candidato;
	weight numero;
	format candidato cand.;
	where candidato gt 2;
run;
ods trace off;
proc freq data=verticale;
	tables county*candidato;
	weight numero;
	format candidato cand.;
	where candidato gt 2;
	ods output Freq.Table1.CrossTabFreqs=votiripartiti;
run;

proc contents data=votiripartiti;
run;

proc print data=votiripartiti;
	var county rowpercent;
	where candidato = 6 and rowpercent ge 2;
run;


proc means data=votiripartiti n;
	var rowpercent;
	where candidato = 6 and rowpercent ge 2;
run;