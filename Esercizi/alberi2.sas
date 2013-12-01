data alberi;
	infile 'z:\FileSAS\alberi.txt' missover firstobs=2;
	input ID trattamento albero$ ramo$ lunghezzaramo numeronodi
			distanza1-distanza29;
	run;

/* punto 1 */
proc means data=alberi mean nway noprint;
	var numeronodi;
	class albero;
	output out=nuovo mean=media;
run;
proc print data=nuovo;run;

/* punto 2 */
proc means data=alberi sum nway;
	var numeronodi;
	class albero;
	output out=nuovo2 sum=totale;
run;

proc means data=nuovo2 min noprint ;
	var totale;
	id albero;
	output out=punto6 minid=quale;
run;
proc print data=punto6;
    var quale;
run;

/* punto 3 */
proc corr data=alberi;
    var distanza1-distanza29;
run;

/* punto 3 */
/* uso l'opzione best=2 perche' ogni variabile ha correlazione massima
    con se stessa */
proc corr data=alberi best=2;
    var distanza1-distanza29;
run;

/* per ispezione diretta noto che le due variabili maggiormente correlate
    sono distanza2 e distanza25
     */

proc reg data=alberi;
    model distanza25=distanza2;
    plot (Predicted. distanza25)*distanza2 /overlay;
run;
