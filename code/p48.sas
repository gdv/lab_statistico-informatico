%MACRO ordina_se(ds=,p=,campo=);
%IF &p eq 1 %THEN
  proc sort data=&ds;
    by &campo;
  run;
%END;
%MEND ordina_se;
