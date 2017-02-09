%%load PClamp data
[a,b] = abfload('~/AHP_HC/SEP132011_C6_CC.abf','channels',{'10 Vm'},'sweeps',1:5);
a = reshape(a,size(a,1),size(a,3));
t = 0:20E-06:499999*20E-06;
t = t';
%----------------------------------------------
bln = a(t>=0.63600 & t<=0.67600,:); % 40ms of baseline just before the depol pulse
ahp = a(t>=1.27622 & t<=9,:); % ahp traces only till 9 sec after the protocol start
blhp = [bln;ahp];
blhp = medfilt1(blhp,11);
at = 0:20E-06:(size(blhp,1)-1)*20E-06;
blhp = blhp(1:end-3); at = at(1:end-3); % remove last lines because of median

%-----------------------------------------------
j = a(t>=0.17622 & t<=0.37622,:);
jt = t(t>=0.17622 & t<=0.37622);
j = medfilt1(j,11);
ja = mean(j,2);
ja = ja(1:end-3); jt = jt(1:end-3); % remove last lines because of median
% filter atrifacts.
clear a;

