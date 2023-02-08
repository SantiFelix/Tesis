function [entropy]=calc_entropy(window,returns)

Q = quantile(returns,3);
Y = discretize(returns,[-inf,Q,inf]);
entropy=[];
for i=1:length(Y)-window
    B=zeros(window,1);
    n=window; %Shift units
    B(1:end)=Y(1+i:n+i);
    s=0;
    for j=1:4
        P=sum(B==j)/window;
        if P>0
            s=(s+(P*log(P)));
        end
    end
    entropy(i)=-1*s;
end  
end