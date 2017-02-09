function [t,y] = biexpahp(params,t)
y = zeros(length(t),1);
peak_f = params(1);
peak_s = params(2);
tau_f = params(3);
tau_s = params(4);
valley = params(5);
%--------------------------------------------
y = valley + (peak_f*(exp(-t ./ tau_f)))+ (peak_s.*(exp(-t ./ tau_s)));
% y = y';
end