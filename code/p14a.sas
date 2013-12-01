DATA personealteemagre;
 SET persone;
 IF altezza GE 180 AND peso LE 70 THEN
      TIPO = 'A';
 ELSE IF altezza LT 170 THEN
      TIPO = 'B';
 ELSE IF peso GT 90 THEN
      TIPO = 'C';
RUN;
