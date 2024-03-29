function figure_entropy(thetitle,data1,data2,rgb,N)

hold on
set(gca,'fontsize',15,'LineWidth',2)
plot(datetime(data1(:,2)),str2double(data1(:,1)),'LineWidth',1.5,'Color',rgb(7,:))
plot(datetime(data2(:,2)),str2double(data2(:,1)),'LineWidth',1.5,'Color',rgb(5,:))
title(thetitle);
xl=xlabel('Fechas','FontSize',20);
yl=ylabel('Entropia','FontSize',20);
grid on
hold off

end