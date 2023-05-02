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
window_entropy=50;   %window to calculate entropy shanon
nq = 3; %default for havin quartile, change to have n+1 quantile

pricevalues=(str2double(precios(:,1)));

ret1=pricevalues(2:end) ./ pricevalues(1:end-1) -1;
entropy=calc_entropy(window_entropy,ret1,nq);

%% Calculate MAV moving mean and entropy

window=1;   %sliding window size for moving average
window_entropy=20;   %window to calculate entropy shanon
nq = 23; %default for havin quartile, change to have n+1 quantile

[entropyMAV] = calc_entropyMAV(precios, window, window_entropy, nq);

%calculate similarities

%% calculate mahalanobis distance for min entropy
dmahal=mahal(entropyMAV',entropyMAV');
t = 1:numel(dmahal);               
[threshold_entropy, min_entropyMAV,min_entropyMAV_l] = SNR_entropy(entropyMAV);
figure
plot(dmahal)
hold on
plot(t(min_entropyMAV_l), dmahal(min_entropyMAV_l),'x')
ylabel('SNR'); xlabel('value');
title(['SNR ', string(window(i)), 'NQ ',string(nq(i)) ]);

figure
hold on
plot(entropyMAV)
plot(t(min_entropyMAV_l), entropyMAV(min_entropyMAV_l),'x')
[n_minE]=check_intervals(min_entropyMAV);
ylabel('Entropy'); xlabel('value');
title(['Entropy ', string(window(i)), 'NQ ',string(nq(i)) ]);

%% Calculate nunmber of MIN entropy with different MAV sizes
window_entropy=50;   %window to calculate entropy shanon
q=0.1;  %percentil to consider a minimum entropy
nq = 19;

win_similarity=[];
i=1;
for window=5:5:100
    [entropyMAV] = calc_entropyMAV(precios, window, window_entropy, nq);
    [threshold_entropy, min_entropyMAV] = mahal_min_entropy(entropyMAV);
    [n_minE]=check_intervals(min_entropyMAV, entropyMAV, window);
    win_similarity(i)=n_minE;
    i=i+1;
end

%% Calculate similarity between diferent quantile size entropy
q_similarity=[];
window=1;   %sliding window size for moving average
i=1;
for nq=3:2:40
    entropy=calc_entropy(window_entropy,ret1,nq);
    [entropyMAV] = calc_entropyMAV(precios, window, window_entropy, nq);
    [threshold_entropy, min_entropyMAV] = mahal_min_entropy(entropyMAV);
    [n_minE]=check_intervals(min_entropyMAV);
    q_similarity(i)=n_minE;
    i=i+1;
end


%% Calculate nq, MAV and windowS
figdir = [topdir,'figures_matlab/'];
hypermatrix=[];
hypermatrix_snr=[];
k = 1;
SNR_level=5;
for window_entropy = 60:10:150
    j = 1;
    for nq = 3:10:150
        i=1;
        for window=[1, 10, 50, 100]
            [entropyMAV] = calc_entropyMAV(precios, window, window_entropy, nq);
            [min_entropyMAV,min_entropyMAV_l,max_snr] = SNR_entropy(entropyMAV,SNR_level);
            [n_minE]=check_intervals(min_entropyMAV);
            dmahal=mahal(entropyMAV',entropyMAV');
            t = 1:numel(dmahal); 
            hypermatrix(i, j, k)=n_minE;
            hypermatrix_snr(i, j, k)=max_snr;
figure
plot(dmahal)
hold on
plot(t(min_entropyMAV_l), dmahal(min_entropyMAV_l),'x')
ylabel('SNR'); xlabel('value');
title(['SNR with window ', num2str(window), '  NQ ',num2str(nq), '  entropyW ',num2str(window_entropy)]);
filename=[figdir,'SNR_window_', num2str(window), '_NQ_',num2str(nq), '_entropyW_',num2str(window_entropy),'.pdf'];
saveas(gca,filename,'pdf');
filename=[figdir,'SNR_window_', num2str(window), '_NQ_',num2str(nq), '_entropyW_',num2str(window_entropy),'.jpg'];
saveas(gca,filename,'jpg');

figure
hold on
plot(entropyMAV)
plot(t(min_entropyMAV_l), entropyMAV(min_entropyMAV_l),'x')
[n_minE]=check_intervals(min_entropyMAV);
ylabel('Entropy'); xlabel('value');
title(['Entropy with window ', num2str(window), '  NQ ',num2str(nq), '  entropyW ',num2str(window_entropy)]);
filename=[figdir,'Entropy_window_', num2str(window), '_NQ_',num2str(nq), '_entropyW_',num2str(window_entropy),'.pdf'];
saveas(gca,filename,'pdf');
filename=[figdir,'Entropy_window_', num2str(window), '_NQ_',num2str(nq), '_entropyW_',num2str(window_entropy),'.jpg'];
saveas(gca,filename,'jpg');
close all
            
            i=i+1;
        end
        j=j+1;
    end
    k = k+1;
end

%%
figure
hold on
window_entropy = 10:10:150;
nq = 3:10:150;
window=[1, 10, 50, 100];
% (window, nq, window_entropy)
for i = 1:4
subplot(1,4,i)
imagesc(window_entropy,nq,reshape(hypermatrix_snr(i,:,:),[15 15]))
ylabel('nq'); xlabel('W entropy ');
title(['W return', string(window(i))]);

end
hold off

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