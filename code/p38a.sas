PROC FREQ DATA=dataset;
  TABLES variabile;
  ODS SELECT CrossFreqsTab;
run;
