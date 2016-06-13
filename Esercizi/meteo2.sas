/* punti 1 e 2 */
data meteo;
	infile 'Z:\FIleSAS\dati81.csv' dlm=',' dsd;
	input provincia$ temperatura giorno;
	fahr=1.8*temperatura+32;
run;
proc print;run;

/* punto 3 */

proc sort data=meteo;
	by provincia;
run;

proc means data=meteo n nway noprint;
	class provincia;
	var temperatura;
	output out=dimensione n=numero;
run;
proc means data=dimensione max;
	var numero;
run;



data nuovo;
	set meteo;
	by provincia;
	array temp[5];
	retain temp1-temp5;

    if first.provincia then do;
		do i=1 to 5;
			temp[i]=.;
		end;
	end;

	temp[giorno]=fahr;

    if last.provincia then output;
    drop temperatura giorno fahr i;
run;
proc print data=ultimo;run;

/* punto 4 */
data ultimo;
	set nuovo;
	array temp[5];

	do i=1 to 5;
		if temp[i] ne . then ultima=temp[i];
	end;

	drop temp1-temp5;
	output;
run;

/* punto 5 */
proc sort data=meteo;
	by provincia;
run;

data punto5;
	set meteo;
	by provincia;
	if last.provincia then output;
run;
