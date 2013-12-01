data  compito.baseball2;
    set  compito.baseball;
    keep city total;
    file 'z:\FileSAS\esportati.csv' dlm=',' dsd;
run;
