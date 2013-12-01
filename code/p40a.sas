ODS HTML FILE = 'e:\file.html';
PROC FREQ DATA=dataset;
  TABLES variabile;
RUN;
ODS HTML CLOSE;
