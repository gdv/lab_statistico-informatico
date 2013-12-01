/* parte proveniente dalla soluzione precedente */

data persone;
    infile 'Z:\FileSAS\altezze.txt';
    input nome$1-8 cognome$10-16 natoil DDMMYY8. altezza peso;
    bmi=peso/((altezza/100) ** 2);
run;

data persone;
    set persone;
    if bmi<18.5 then tipo='sottopeso';
    else if bmi ge 18.5 and bmi <20 then tipo='normopeso';
    else if bmi ge 20 and bmi <25 then tipo='sovrappeso';
    else tipo='obeso';
run;

data secondo;
    set persone;
    if bmi < 20;
run;

/* inizio parte nuova */

libname corso 'z:\FileSAS';

data corso.persone;
	set persone;
	keep nome cognome;
	file 'z:\FileSAS\esportati.csv';
	put  nome cognome;
run;
