function plot_entropy()

topdir='/Users/Manzanita/Tesis_felix/Tesis/';

set(groot, ...
'DefaultFigureColor', 'w', ...
'DefaultAxesLineWidth', 0.5, ...
'DefaultAxesXColor', 'k', ...
'DefaultAxesYColor', 'k', ...
'DefaultAxesFontUnits', 'points', ...
'DefaultAxesFontSize', 10, ...
'DefaultAxesFontName', 'Helvetica', ...
'DefaultLineLineWidth', 2, ...
'DefaultTextFontUnits', 'Points', ...
'DefaultTextFontSize', 10, ...
'DefaultTextFontName', 'Helvetica', ...
'DefaultAxesBox', 'off', ...
'DefaultAxesTickLength', [0.02 0.025]);
set(groot, 'DefaultAxesTickDir', 'out');
set(groot, 'DefaultAxesTickDirMode', 'manual');
rgb=[[1 0 0];[0 0 1];[0, 0.65, 0];[1 0 1];[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.6350, 0.0780, 0.1840];];



%% import data to matlab
datareal=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/datareal.csv');
dataSSimulada=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/dataSSimulada.csv');

[MDataSimulada]=read_plot_data(dataSSimulada);
[MDataReal]=read_plot_data(datareal);
%% plot data into matlab
figure
hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(MDataSimulada(:,2)),str2double(MDataSimulada(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
plot(datetime(MDataReal(:,2)),str2double(MDataReal(:,1)),'LineWidth',1.5,'Color',rgb(5,:))
title(['Entropia real y simulada del mercado DJJA ']);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Entropia','FontSize',20);
grid on
hold off

filename=[topdir,'figures/onlyentropy','eps'];
saveas(gca,filename,'epsc');

%% import MAV data to matlab
dataMAVr=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/dataMAVr.csv');
dataMAVs=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/dataMAVs.csv');

[MDataMAVSimulada]=read_plot_data(dataMAVs);
[MDataMAVReal]=read_plot_data(dataMAVr);

%%
figure
hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(MDataMAVSimulada(:,2)),str2double(MDataMAVSimulada(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
plot(datetime(MDataMAVReal(:,2)),str2double(MDataMAVReal(:,1)),'LineWidth',1.5,'Color',rgb(5,:))
title(['Entropia con MAV real y simulada del mercado DJJA ']);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Entropia','FontSize',20);
grid on
hold off

filename=[topdir,'figures/MAVentropy','eps'];
saveas(gca,filename,'epsc');


%%
RetornoMAV=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/retornoConMAVr.csv');
retorno=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/retornoSinMAVr.csv');

[RetornoMAV]=read_plot_data(RetornoMAV);
[retorno]=read_plot_data(retorno);

%%
figure
hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(RetornoMAV(:,2)),str2double(RetornoMAV(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
title(['Retornos con MAV mercado DJJA ']);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Valor de retorno','FontSize',20);
grid on
hold off

filename=[topdir,'figures/MAVreturns','eps'];
saveas(gca,filename,'epsc');

figure
hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(retorno(:,2)),str2double(retorno(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
title(['Retornos del mercado DJJA ']);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Valor de retorno','FontSize',20);
grid on
hold off

filename=[topdir,'figures/onlyreturns','eps'];
saveas(gca,filename,'epsc');

%%
precios=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/precios.csv');

[precios]=read_plot_data(precios);

%%
figure
hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(precios(:,2)),str2double(precios(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
title(['Precios mercado DJJA ']);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Precio','FontSize',20);
grid on
hold off

filename=[topdir,'figures/precios','eps'];
saveas(gca,filename,'epsc');

end