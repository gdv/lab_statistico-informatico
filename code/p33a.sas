PROC REG DATA=dataset;
  MODEL vary=varx;
  PLOT (PREDICTED. vary)*varx /OVERLAY;
RUN;
