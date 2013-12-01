DATA meteo;
   INFILE 'Z:\FileSAS\meteo.txt' DLM=',' ;
   INPUT prov $ temp1 temp2 temp3 temp4 temp5;
RUN;

DATA nomiss;
   SET meteo;
       IF temp1=. THEN temp1=0;
       IF temp2=. THEN temp2=0;
       IF temp3=. THEN temp3=0;
       IF temp4=. THEN temp4=0;
       IF temp5=. THEN temp5=0;
RUN;

DATA nomiss;
    SET meteo;
    array temp[5];
    do i = 1 to 5;
        IF temp[i]=. THEN temp[i]=0;
        end;
run;

data ristrutturato;
    set meteo;
    array temp[5];
    do i = 1 to 5;
        IF temp[i] ne . THEN do;
            temperatura = temp[i];
            keep temperatura prov i;
            output;
        end;
    end;
run;


data media;
    set meteo;
    media=mean(temp1,temp2,temp3,temp4,temp5);
run;

data media;
    set meteo;
    array temp[5];
    tot=0;
    quanti=0;
    do i = 1 to 5;
        IF temp[i] ne . THEN do;
	    tot+temp[i];
	    quanti+1;
        end;
    end;
    media=tot/quanti;
    keep prov media;
    output;
run;
