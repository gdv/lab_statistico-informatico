DATA nuovo
do i=1 to &dimensione;
  valori[i]=i;
end;
PROC PRINT DATA=nuovo;
    TITLE = "Dati riguardanti &nazione";
run;
