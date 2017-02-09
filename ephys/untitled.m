
%%
clear ahpobj; close all;pfcfiles=getfiles('~/DATA/AHP/AHP_PFC/AHP_PFC_IL/Files_AHP_PFC_IL');
ahpobj = AhpClass(pfcfiles(2));
val = ahpobj.val;
% y = ahpobj.y(:,3);
% coef = ones(20);
% coef = coef/sum(coef);
% y = conv(y, coef, 'same');
% t = ahpobj.t;
% base = mean(y(t >=ahpobj.Psv.BT2-0.01 & t <= ahpobj.Psv.BT2)); 
% 
% y = y(t >=ahpobj.Psv.BT2-0.01 & t < ahpobj.Psv.RT2);
% t = t(t >=ahpobj.Psv.BT2-0.01 & t < ahpobj.Psv.RT2);
% 
% options = optimset('Display','iter','MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-30,'TolX',1e-30);
% initial_psv = [10E06,200E06, 0.1,0.1]; % [rp rm taum delay]
% [params, ~, fitok, ~] = fminsearch(@(initial_psv) fit_passive_charge(t,y/1000,initial_psv,base/1000,-20E-12),initial_psv,options);
% [tf,yf] = vp_passive_charge(t,params,base/1000,-20E-12);
% plot(t,y/1000);hold on
% plot(tf,yf,'red');
%%