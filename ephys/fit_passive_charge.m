function sse = fit_passive_charge(t,y,params,offset,i_inj)
%---------------Obtain the simulated v and t
    [tf, yf] = vp_passive_charge(t,params,offset,i_inj);
    sse = sum((y-yf).^2);
end