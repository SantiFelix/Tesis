function [Data]=read_plot_data(variable)
values=string(variable.data);

variable=string(variable.textdata);
dates=strings(length(variable),1);

for k=1:length(variable)
     a=strsplit(variable(k,1),{'{','}','"'})';
     dates(k,:)=datetime(a(2),'InputFormat','yyyy,MM,dd');
end

Data=[values(:),dates(:)];

%plot(datetime(Data(:,2)),str2double(Data(:,1)))
end