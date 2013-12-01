libname a 'Z:\FIleSAS';
proc contents data=a.nascar;run;

data verticale;
	set a.nascar;
	array bonus[5];
	array giri[5];
	array part[5];
	array pos[5];
	array punti[5];
	array premio[5];
	array status[5];
	do gara=1 to 5;
		bonus_gara=bonus[gara];
		giri_gara=giri[gara];
		part_gara=part[gara];
		pos_gara=pos[gara];
		punti_gara=punti[gara];
		premio_gara=premio[gara];
		status_gara=status[gara];
		punti_totali_gara=bonus_gara+punti_gara;
		if giri_gara ne . then output;
	end;
	drop bonus1-bonus5 giri1-giri5 part1-part5 pos1-pos5 
		 punti1-punti5 premio1-premio5 status1-status5;
run;
proc means data=verticale nmiss;
var bonus_gara punti_gara punti_totali_gara;
run;

/*
1.Per ogni pilota, calcolare i punti totali
*/
proc means data=verticale sum;
	var punti_totali_gara;
	class id;
run;

/*
2.Per ogni pilota calcolare il numero medio (e deviazione standard) 
  di punti totali
*/
proc means data=verticale mean stddev;
	var punti_totali_gara;
	class id;
run;


/*
3.Come il punto precedente, ma solo relativamente 
  alle gare completate.
*/
proc means data=verticale sum;
	var punti_totali_gara;
	class id;
	where status_gara eq 'Running';
run;

/*
4.Per ogni pilota calcolare la somma totale di premi vinti, 
  di giri percorsi e di punti base ottenuti.
*/
proc means data=verticale sum;
	var premio_gara giri_gara punti_gara;
	class id;
run;
