ODS TRACE ON;
PROC FREQ DATA=dataset;
  TABLES variabile;
run;
ODS TRACE OFF;
