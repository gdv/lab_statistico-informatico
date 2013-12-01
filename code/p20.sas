PROC SORT DATA=data set;
    BY variabile;
    BY DESCENDING variabile2;
    BY variabile1 DESCENDING variabile2;
RUN;
