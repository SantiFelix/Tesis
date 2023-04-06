function [entropyMAV] = calc_entropyMAV(precios, window, window_entropy, nq)
MAVprice = movmean(str2double(precios(:,1)),[0,window-1]); %moving mean for the price
retMAV = (MAVprice(2:end) ./ MAVprice(1:end-1) -1);  %returns over the MAV prices
%entropyMAV=calc_entropy(window_entropy, retMAV, nq);
entropyMAV=calc_entropy_KDE(window_entropy, retMAV, nq);

end