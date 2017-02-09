%%
[d, si] = abfload('~/DATA/ELS/data/20120127/C2/C1_0004.abf','channels',{'Im Scaled'},'sweeps',1:5);
d = reshape(d,200000,5);
t = (0:20E-06:199999*20E-06)';
s.t=t;s.y=d;
%s.y = mean(s.y,2);
s2 = signalfilter(s,'gauss',10,10/6,2);
%%
s3.t = s2.t(s2.t >= 2.4 & s2.t <= 3.9);
s3.y = s2.y(s2.t >= 2.4 & s2.t <= 3.9,:);
s3.y = bsxfun(@minus,s3.y,mean(s3.y(s3.t<2.5,:),1));
s3.y = mean(s3.y,2);
[mint miny maxt maxy] = simplepeak(s3.t,s3.y(:,1),10);
%fig=figure;
plot(s3.t,s3.y); hold on;
plot(maxt,maxy,'Oblack','Linewidth',2);
plotpath = ['~/Matlab_supersumPlots','','.jpeg'];
%print(fig,'-djpeg',['-r','150'],plotpath);
%%
epsc_start = 3.067;
clear all; %close all;
[d, si] = abfload('/media/New Volume/EPDATA/2012/201201/JAN312012/C1/C1_0003.abf','channels',{'Im Scaled'},'sweeps','a');
d = reshape(d,size(d,1),size(d,3));
t = (0:20E-06:199999*20E-06)';
s.t=t;s.y=d;
s2 = signalfilter(s,'gauss',100,100/6,2);
s3.t = s2.t(s2.t >= 2.9 & s2.t <= 3.5);
s3.y = s2.y(s2.t >= 2.9 & s2.t <= 3.5,:);
s3.y = bsxfun(@minus,s3.y,mean(s3.y(s3.t<3,:),1));
s4.t = s3.t(s3.t >= epsc_start);
s4.y = s3.y(s3.t >= epsc_start,:);

plot(s3.t,s3.y);

