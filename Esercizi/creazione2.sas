libname compito 'z:\FileSAS';

data compito.baseball;
    infile 'z:\FileSAS\attend.dat';
    input city $   League $ Div $     Year   Total       Index1  Index2 Index3 Index4  Rate;
run;

data compito.wheat
    infile 'z:\FileSAS\wheat.txt';
    input A B C d1-d15
run;

data compito.palloni
    infile 'z:\FileSAS\balloon' firstobs=30 obs=2001;
    input A B C d1-d15
run;

data turismo
    infile 'z:\FileSAS\braziltourism.csv.' dlm=',' dsd firstobs=2;
    input Age Sex Income TravelCost AccessRoad Active Passive LoggedIncome Trips;
run;
