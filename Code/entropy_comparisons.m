function [entropyMAV, n_intersection] = entropy_comparisons(precios, entropy, window, window_entropy, q, nq)
%calculate moving means
MAVprice = movmean(str2double(precios(:,1)),[0,window-1]);
retMAV = (MAVprice(2:end) ./ MAVprice(1:end-1) -1);

%% Calculate quartile and entropy

entropyMAV=calc_entropy(window_entropy, retMAV, nq);
min_entropyMAV=zeros(size(entropy));
min_entropyMAV(entropyMAV<quantile(entropyMAV, q))=1;

min_entropy=zeros(size(entropyMAV));
min_entropy(entropy<quantile(entropy, q))=1;

%similarity=sum(abs(min_entropy-min_entropyMAV));
%calculates the number of intersection betwen two entropies
interval_sim=min_entropy+min_entropyMAV;
[n_intersection]=check_intervals(interval_sim);


% calculates the number of entropies detected
min_entropyMAV(entropyMAV<quantile(entropyMAV, q))=2;
[n_intersection]=check_intervals(min_entropyMAV);

end

function [n_intersection]=check_intervals(interval_sim)
debut=[];
fin=[];
j=0;
k=0;
for i=1:length(interval_sim)-1
    if interval_sim(i)==2 & interval_sim(i+1)~=2
       j=j+1;
       fin(j)=i;
    end
    if interval_sim(i)~=2 & interval_sim(i+1)==2
       k=k+1;
       debut(k)=i+1;
    end
end
n_intersection=j;
end