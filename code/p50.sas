DATA _NULL_;
    SET nascar;
    IF statusgara = 'Running' THEN
        CALL SYMPUT("durata", girigara);
RUN;

DATA nascar;
    SET nascar;
    percentuale = girig/&durata*100;
run;
