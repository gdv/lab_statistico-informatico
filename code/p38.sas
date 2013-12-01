PROC FREQ DATA=dataset;
  TABLES variabile;
  ODS OUTPUT CrossFreqsTab = dataset2;
run;
