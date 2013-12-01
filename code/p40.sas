ODS PDF FILE = 'c:\Documents...\file.pdf';
PROC FREQ DATA=dataset;
  TABLES variabile;
run;
ODS PDF CLOSE;
