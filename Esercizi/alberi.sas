data alberi;
	infile 'Z:\FileSAS\alberi.txt' missover firstobs=2;
	input ID trattamento albero $ ramo $ lunghezzaramo numeronodi distanza1-distanza29;
run;
/*
 * Notare l'utilizzo dell'opzione missover nella infile
 * Diventa necessaria in quanto non tutte le osservazioni hanno gli stessi dati
 */


proc sort data=alberi;
	by descending numeronodi albero;
run;
proc print data=alberi;
    var ID albero ramo  numeronodi;
run;

/*
 Punto 2
 */
data punto2;
    set alberi;
    array distanza[29];
    do progressivodistanza=1 to 29;
        keep ID ALBERO RAMO NUMERONODI PROGRESSIVODISTANZA DISTANZANODO;
        if distanza[progressivodistanza] ne . then do;
            distanzanodo=distanza[progressivodistanza];
            output;
            end;
        end;
run;


/*
 Punto 3
 */
proc sort data=punto2;
    by id;
run;

data punto3;
    set punto2;
    by id;
    array distanze[29];
    if first.id then do;
        do i=1 to 29;
            distanze[i]=.;
            end;
        end;
    distanze[progressivodistanza]=distanzanodo;
    if last.id then do;
        keep id distanze1-distanze29;
        output;
        end;
run;
