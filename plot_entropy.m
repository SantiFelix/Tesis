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


%% return and entropy calculation NO MAV
pricevalues=(str2double(precios(:,1)));

ret1=pricevalues(2:end) ./ pricevalues(1:end-1) -1;
entropy=calc_entropy(window_entropy,ret1);

%% Calculate moving mean and entropy

window=1;   %sliding window size for moving average
window_entropy=50;   %window to calculate entropy shanon
q=0.1;  %percentil to consider a minimum entropy
nq = 3; %default for havin quartile, change to have n+1 quantile
% Calculate similitud between MAV and no MAV entropy
win_similarity=[];
i=1;
for window=5:5:100
    [entropyMAV, similarity] = entropy_comparisons(precios,entropy, window, window_entropy, q, nq);
    win_similarity(i)=similarity;
    i=i+1;
end
%% Calculate similitud between diferent quantile size entropy
q_similarity=[];
window=1;   %sliding window size for moving average
i=1;
for nq=3:1:40
    [entropyMAV, similarity] = entropy_comparisons(precios,entropy, window, window_entropy, q, nq);
    q_similarity(i)=similarity;
    i=i+1;
end



%%  add dates
MAVpricedated=[MAVprice(:),precios(:,2)];
retMAVdated=[retMAV(1:end-50),precios(1:end-51,2)]; %MAV returns dated

ret1dated=[ret1(:),precios(1:end-1,2)]; %normal returns dated

figure
figure_entropy(title, retMAVdated, RetornoMAV,rgb,1)


title=' ';
figure
figure_entropy(title, ret1dated, retorno,rgb,1)
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