ODS GRAPHICS ON;
PROC FREQ DATA=dataset;
  TABLES variabile /PLOTS=FREQPLOT;
run;
ODS GRAPHICS OFF;
