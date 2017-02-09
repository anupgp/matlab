function [t, io] = VClampPsv(t,params,offset,v_inj)
% Function returns the simulated current output for the given parameters
rp = params(1);
rm = params(2);
taup = params(3);
taum = params(4);
delay = 0;
io = nan(length(t),1); % output current
for j = 1 :  length(t)
    if (t(j) < t(1)+delay);
        vp = 0; % voltage pulse is 0 if time is less than delay
    else
        vp = v_inj;
    end
       io(j,1) = offset+(vp/(rp)*(exp(-(t(j)-delay-t(1))/taup) )) + (vp/(rp)*(exp(-(t(j)-delay-t(1))/(taum)) )+ (vp/(rm+rp)));
end
%plot(t,io);hold on;
end