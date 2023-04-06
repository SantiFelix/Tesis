function [n_intersection] = entropy_comparisons(entropy, entropyMAV, q)
%calculate moving means

%% Calculate quartile and entropy

[threshold_entropy, min_entropyMAV] = mahal_min_entropy(entropyMAV);

[threshold_entropy, min_entropy] = mahal_min_entropy(entropy);

%similarity=sum(abs(min_entropy-min_entropyMAV));
%calculates the number of intersection betwen two entropies
interval_sim=min_entropy+min_entropyMAV;
[n_intersection]=check_intervals(interval_sim);


% calculates the number of entropies detected
min_entropyMAV(entropyMAV<quantile(entropyMAV, q))=2;
[n_intersection]=check_intervals(min_entropyMAV);

end
