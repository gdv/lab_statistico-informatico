PROC ANOVA DATA=nascar;
    CLASS sponsor;
    MODEL puntig = sponsor;
    MEANS sponsor /SCHEFFE;
RUN;
