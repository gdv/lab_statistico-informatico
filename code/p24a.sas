PROC MEANS DATA=dataset NWAY N MEAN;
 VAR variabile1 variabile2;
 CLASS variabile3;
 ID variabile3;
 OUTPUT OUT=nuovodat 
  MAXID(variabile1)=massimo
  MEAN(variabile1 variabile2)=media1 m2;
run;
