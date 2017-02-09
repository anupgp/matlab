function [t vp] = vp_passive_charge(t,params,offset,i_inj)
%---------------------
rp = params(1);
rm = params(2);
%taup = params(3);
taup = 0.0001;
taum = params(3);
%taum2 = params(4);
delay = params(4);
vp = nan(length(t),1);
for i = 1 :  length(t)
    if (t(i) < t(1)+delay);
        ip = 0;
    else
        ip = i_inj;
    end
    %vp(i) = offset+(ip*rp)+ (ip*rm)*(1-exp(-(t(i)-delay-t(1))/taum1) )+ (ip*rm)*(1-exp(-(t(i)-delay-t(1))/taum2) );
    vp(i) = offset+(ip*rp)*(1-exp(-(t(i)-delay-t(1))/taup) )+ (ip*rm)*(1-exp(-(t(i)-delay-t(1))/taum) );
    %vp(i) = offset+(ip*rp)* (1-exp(-(t(i)-delay-t(1))/taup) ) + (ip*rm)*(1-exp(-(t(i)-delay-t(1))/taum1)) + (ip*rm) * (1-exp(-(t(i)-delay-t(1))/taum2));
end
end