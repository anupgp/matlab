% This program opens opens the Clampfit file on the selected channel and
% sweeps
% Baseline subtract the individual traces
% Chope each trace into two parts. Part 1.: (vstep) contains the voltage
% jump. Part 2.: (epsc) contains the epsc without the stim. artifact and 
% until the time. Delete the orginal traces.
% at which the epsc (ampa or nmda-mediated) has decayed completely.
% ampa: 100ms, nmda: 300 ms
% 1. Do nonlinear curve fitting on the each epsc using the 'biexp' 
% function
% 2. Do nonlinear curve fitting on the decay of the epsc fit using a 
% the 'monoexp' function.
% The results for each epsc are strored in a cell array
% 10 figures are generated from a random selection of 10 epscs with the
% fits

function result = process_epsc(fname,chname,sweeps)
fields_result = {'fname','id','offset_be','delay_be','tau1_be','sfact_be',...
    'tau2_be','ci1o_be','ci2o_be','ci1d_be','ci2d_be','ci1t1_be',...
    'ci2t1_be','ci1s_be','ci2s_be','ci1t2_be','ci2t2_be','peak','area',...
    'risetime','offset_me','sfact_me','tau_me','ci1o_me','ci2o_me',...
    'ci1s_me','ci2s_me','ci1t_me','ci2t_me'};
values = cell(1,29); % create an empty cell array with 29 cells
result = cell2struct(values,fields_result,2);
fprintf('%s %d','no of traces = ',size(result,1));
traceinfo = struct('vsstart',nan,'vsstop',nan,'vstep',nan,'epscstart',...
nan,'epscstop',nan,'stimtime',nan,'SI',0);
display(sweeps);
[traces,traceinfo.SI] = abfload(fname,'channels',{chname},'sweeps',sweeps);
traceinfo.stimtime = 3.063
traceinfo.epscstart = 3.065
traceinfo.epscstop = traceinfo.epscstart+0.300;
traceinfo.vsstart = 0.08
traceinfo.vsstop = 0.18
traceinfo.vstep = 0.005 % voltage step = 5 mv 
traces = reshape(traces,size(traces,1),size(traces,3))
result(1).offset_be = traceinfo.SI
result(1).tau1_be = size(traces,1)
result(1).tau2_be = size(traces,2)
time = 0:traceinfo.SI*1E-06:(size(traces,1)-1)*traceinfo.SI*1E-06; time = time'
traces = traces-repmat(mean(traces(find((time >= traceinfo.stimtime-0.125)&(time<=traceinfo.epscstart-0.025)),:)),size(traces,1),1)
traces = traces(find((time >= traceinfo.stimtime-0.010)&(time<=traceinfo.epscstop)),:);
time = time(find((time >= traceinfo.stimtime-0.010)&(time<=traceinfo.epscstop)));
time = time-time(1);

options = struct('Display','iter','Robust','off') % options for calling 'nlinfit' function
plot(time,traces); hold on;
axis([0.01,0.2,-300,25]);
[epscdelay,epscbaseline] = ginput(1) % input: delay
[epscpeaktime,epscpeak] = ginput(1) % input: sfactor

initials1 = [0, epscdelay, (epscpeaktime-epscdelay) (epscpeak*10) 0.01] % [offset delay tau1 sfactor tau2]

for i = 1: size(traces,2)
    [coeff1 resid1 jac1 cov1 mse1] = nlinfit(time,traces(:,i),@biexp,initials1,options)
    biexpfit = biexp(coeff1,time)
    ci1 = nlparci(coeff1,resid1,'J',jac1)
%     display(num2str(coeff1));display(ci1)
    plot(time,biexpfit,'r')
    biexppeak = min(biexpfit)
    biexppeaktime = time(find(biexpfit == biexppeak))
    initials2 = [initials1(1),biexppeaktime,coeff1(5),biexppeak] % [offset delay tau1 sfactor]
    [coeff2 resid2 jac2 cov2 mse2] = nlinfit(time,biexpfit,@monoexp,initials2,options)
    monoexpfit = monoexp(coeff2,time)
    ci2 = nlparci(coeff2,resid2,'J',jac2)
    plot(time,monoexpfit,'g')
%     display(biexppeak);display(biexppeaktime)
end
end
    
    