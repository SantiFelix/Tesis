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

dataMAVr=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/dataMAVr.csv');
dataMAVs=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/dataMAVs.csv');

[MDataMAVSimulada]=read_plot_data(dataMAVs);
[MDataMAVReal]=read_plot_data(dataMAVr);

RetornoMAV=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/retornoConMAVr.csv');
retorno=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/retornoSinMAVr.csv');
retorno=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/retornos.csv');
retornoestandarizado=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/retornoEstandarizado.csv');

[RetornoMAV]=read_plot_data(RetornoMAV);
[retorno]=read_plot_data(retorno);
[retornoestandarizado]=read_plot_data(retornoestandarizado);

precios=importdata('/Users/Manzanita/Tesis_felix/Tesis/Code/ficheroscsv/precios.csv');
[precios]=read_plot_data(precios);


%% returns calculation
pricevalues=(str2double(precios(:,1)));

ret1=pricevalues(2:end) ./ pricevalues(1:end-1) -1;

ret1dated=[ret1(:),precios(1:end-1,2)];

title=' ';
figure
figure_entropy(title, ret1dated, retorno,rgb,1)


%% Calculate moving mean 

k=50;
MAVprice = movmean(str2double(precios(:,1)),[0,k-1]);

retMAV=(MAVprice(2:end) ./ MAVprice(1:end-1) -1);

MAVpricedated=[MAVprice(:),precios(:,2)];
retMAVdated=[retMAV(1:end-50),precios(1:end-51,2)];

figure
figure_entropy(title, retMAVdated, RetornoMAV,rgb,1)


N=0;

%% Calculate quartile and entropy

window=50;
q=0.1;

entropyMAV=calc_entropy(window,retMAV);
entropy=calc_entropy(window,ret1);
min_entropyMAV=zeros(size(entropy));
min_entropyMAV(entropyMAV<quantile(entropyMAV, q))=1;

min_entropy=zeros(size(entropyMAV));
min_entropy(entropy<quantile(entropy, q))=1;

similarity=sum(abs(min_entropy-min_entropyMAV));

%%%%%%
%% plot entropy for DJJA data into matlab
%%%%%%


N=N+1;
title='Entropia con real y simulada del mercado DJJA ';
figure_entropy(title, MDataSimulada, MDataReal,rgb,N)
filename=[topdir,'figures/onlyentropy','eps'];
saveas(gca,filename,'epsc');

%%
N=N+1;
title='Entropia con MAV real y simulada del mercado DJJA';
figure_entropy(title, MDataMAVSimulada, MDataMAVReal,rgb,N)
filename=[topdir,'figures/MAVentropy','eps'];
saveas(gca,filename,'epsc');


%% Comparison betwen entropies
subMDataReal=MDataReal(datetime(MDataReal(:,2))> datetime('01-Jan-2002') & datetime(MDataReal(:,2))< datetime('01-Jan-2004'),:);
subMDataMAVReal=MDataMAVReal(datetime(MDataMAVReal(:,2))> datetime('01-Jan-2002') & datetime(MDataMAVReal(:,2))< datetime('01-Jan-2004'),:);
subprecios=precios(datetime(precios(:,2))> datetime('01-Jan-2002') & datetime(precios(:,2))< datetime('01-Jan-2004'),:);
MAVprice=MAVprice(datetime(MAVprice(:,2))> datetime('01-Jan-2002') & datetime(MAVprice(:,2))< datetime('01-Jan-2004'),:);
N=0
N=N+1;
title='Entropia real y entropia MAV DJJA';
figure(N)
subplot(2,1,1) % 2 rows, 1 column, first position

figure_entropy(title, subMDataReal, subMDataMAVReal,rgb,N)
filename=[topdir,'figures/normalentropyvsMAVentropy','eps'];
saveas(gca,filename,'epsc');

subplot(2,1,2) % 2 rows, 1 column, first position
hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(subprecios(:,2)),str2double(subprecios(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
plot(datetime(MAVprice(:,2)),str2double(MAVprice(:,1)),'LineWidth',1.5,'Color',rgb(5,:))
title(['Precios mercado DJJA ']);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Precio','FontSize',20);
grid on


%% Plot returns
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
%%
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


%%