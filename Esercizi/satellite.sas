/*
punto 1
*/

data esame;
    infile 'Z:\FileSAS\dati.txt';
    input prodotto$ 1-13 numsatellite altitudine azimuth medio minimo massimo 3.;
run;
proc print data=esame;
run;
/*
punto 2
*/
proc means data=esame mean;
    var altitudine azimuth;
    class numsatellite;
    output out=punto2 mean(altitudine)=altezzamedia;
run;
/*
punto 3
*/
proc means data=esame mean stddev skewness;
    var minimo;
run;
/*
punto 4
*/
data nuovo;
    set esame;
    scarto=massimo-minimo;
run;
/*
punto 5
*/
proc means nway data=nuovo mean;
	var scarto;
	class numsatellite;
	output out=eserc mean=scarto_medio;
run;
proc sort data=eserc;
	by scarto_medio;
run;
/*
punto 6
*/
proc sort data=esame;
    by numsatellite;
data ristru;
    set esame;
    by numsatellite;
    array alt[4];
    array azi[4];
/*	retain alt1-alt4 azi1-azi4; */
    retain alt azi;
    if first.numsatellite then do;
        do i=1 to 4;
            alt[i]=.;
            azi[i]=.;
            end;
        i=0;
        end;
    i+1;
    alt[i]=altitudine;
    azi[i]=azimuth;
    if last.numsatellite then do;
        keep numsatellite alt1-alt4 azi1-azi4;
        output;
        end;
run;


/*
punto 7
*/
data punto9;
    merge esame punto2;
    by satellite;
run;
