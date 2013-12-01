PROC REG DATA=dataset;
  MODEL vary=varx;
  PLOT PREDICTED.*varx;
RUN;
