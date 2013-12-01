PROC SORT DATA=nuovometeo;
    BY provincia;
RUN;
DATA primo;
    SET nuovometeo;
    BY provincia;
    IF FIRST.provincia;
RUN;
