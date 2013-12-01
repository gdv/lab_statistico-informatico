data pioggia;
	infile 'z:\FileSAS\pioggia.txt';
	input SEEDED$ SEASON$ TE TW NC SC NWC STAGIONEPROGRESSIVO;
run;

proc sort data=pioggia;
	by STAGIONEPROGRESSIVO;
run;
data pioggia;
	set pioggia;
	by STAGIONEPROGRESSIVO;
	retain anno;
	if first.STAGIONEPROGRESSIVO and season='SPRING' then do;
		anno+1;
		stagione=0;
	end;
	if first.STAGIONEPROGRESSIVO then stagione+1;
run;
proc print data=pioggia;run;

/* punto 1 */
proc means data=pioggia mean;
	class seeded season;
	output out=punto1 mean(te)=media_te mean(tw)=media_tw;
run;

/* punto 2 */
proc corr data=pioggia;
	var TE TW NC SC NWC STAGIONEPROGRESSIVO;
run;

/* punto 3 */
proc corr data=pioggia best=2;
	var TE TW NC SC NWC STAGIONEPROGRESSIVO;
run;
/* le due variabili maggiormente correlate sono TW e NWC */
proc reg data=pioggia ;
	model tw=nwc;
	plot (predicted. tw)*nwc /overlay;
run;

/* punto 5 */
proc freq data=pioggia;
	tables seeded*season;
	weight nc;
run;

/* punto 4 */
proc means data=pioggia nway noprint;
	var te;
	class seeded stagione anno;
	output out=punto4 sum=totale_te;
run;
proc sort data=punto4;
	by anno seeded stagione ;
run;

data punto4a;
	set punto4;
	array te[4] spring summer autumn winter;
	retain te;
	by anno seeded;

	if first.seeded then do;
		do i=1 to 4;
			te[i]=.;
		end;
		
	end;

	
	te[stagione]=totale_te;

	if last.seeded then output;
	keep anno seeded spring summer autumn winter;
run;
proc print data=punto4a;run;
