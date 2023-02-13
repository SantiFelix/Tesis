function [signals,avgFilter,stdFilter] = ThresholdingAlgo(y,lag,threshold,influence)
% Initialise signal results
signals = zeros(length(y),1);
% Initialise filtered series
filteredY = y(1:lag+1);
% Initialise filters
avgFilter(lag+1,1) = mean(y(1:lag+1));
stdFilter(lag+1,1) = std(y(1:lag+1));
% Loop over all datapoints y(lag+2),...,y(t)
for i=lag+2:length(y)
    % If new value is a specified number of deviations away
    if abs(y(i)-avgFilter(i-1)) > threshold*stdFilter(i-1)
        if y(i) > avgFilter(i-1)
            % Positive signal
            signals(i) = 1;
        else
            % Negative signal
            signals(i) = -1;
        end
        % Make influence lower
        filteredY(i) = influence*y(i)+(1-influence)*filteredY(i-1);
    else
        % No signal
        signals(i) = 0;
        filteredY(i) = y(i);
    end
    % Adjust the filters
    avgFilter(i) = mean(filteredY(i-lag:i));
    stdFilter(i) = std(filteredY(i-lag:i));
end
% Done, now return results
endhistogram(entropyMAV)

pf_truncpoiss = @(x1,lambda) poisspdf(x1,lambda)./(1-poisscdf(0,lambda));

%%
pdf_truncnorm = @(x2,mu,sigma,xTrunc) ...
    normpdf(x2,mu,sigma)./normcdf(xTrunc,mu,sigma);
%%
[paramEsts2,paramCIs2] = mle(entropyMAV,'Distribution','Normal', ...
    'TruncationBounds',[1.35 2.4])
xTrunc=3
histogram(entropyMAV,'Normalization','pdf')
xgrid = min(entropyMAV):0.03:max(entropyMAV);
pdfgrid = pdf_truncnorm(xgrid,paramEsts2(1),paramEsts2(2),xTrunc);
hold on
plot(xgrid,pmfgrid,'-')
xlabel('x1')
ylabel('Probability')
legend('Sample Data','Fitted pmf','Location','best')
hold off


