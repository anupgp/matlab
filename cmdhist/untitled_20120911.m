%%
t = a.data.t;
y = a.data.y;
s.t=t;s.y=y;
s = signalfilter(s,'gauss',1000,1000/6);
% plot(s.t,s.y)
s2.t = [s.t(s.t>=a.AhpProbBaseStart & s.t<=a.AhpProbBaseStop); s.t(s.t>=a.AhpProbStepStop)];
s2.y = [s.y(s.t>=a.AhpProbBaseStart & s.t<=a.AhpProbBaseStop,:); s.y(s.t>=a.AhpProbStepStop,:)];
baseavg = mean(s2.y,2);

%%
a = AHP(expinfo(22));
y = a.data.y;
t = a.data.t;
dt = t(2)-t(1);
y2 = y(t > a.AhpProbStepStop & t <= a.AhpProbDisEnd,:);
% Get the data b/w AhpProbBaseStart & AhpProbBaseStop
y1 = y(t >= a.AhpProbBaseStart & t <= a.AhpProbBaseStop,:);
% Mean of the data b/w AhpProbBaseStart & AhpProbBaseStop
y1mean = mean(mean(y1,1));

% Remove data b/w AhpProbBaseStart & AhpProbBaseStop when more than mean of
% baseline
y2mean = mean(y2,2);
pos = find(y2mean <= y1mean,1,'first');
% Stich the baseline with Ahp data
y3 = [y1;y2(pos:end,:)];
y3 = bsxfun(@minus,y3,mean(y1,1));
t3 = [-size(y1,1)*dt:dt:-dt,0:dt:(size(y2(pos:end,:),1)-1)*dt]';

% Set the time axis from start to finish
            
s.t=t3;
s.y=y3;
s = signalfilter(s,'gauss',500,500/8);
t=s.t;
y=s.y;
mAhpy = NaN(1,size(y,2));
mAhpi = NaN(1,size(y,2));
mAhpt = NaN(1,size(y,2));
sAhpy = NaN(1,size(y,2));
sAhpi = NaN(1,size(y,2));
sAhpt = NaN(1,size(y,2));
for i = 1: size(y,2)
    [mAhpy(i),mAhpi(i)] = min(y(t>0 & t < a.AhpFindDur,i));
    mAhpt(i) = t(mAhpi(i));
    sAhpi(i) = find(t >= (mAhpt(i)+0.300),1,'first');
    sAhpy(i) = y(sAhpi(i),i);
    sAhpt(i) = t(sAhpi(i));
end


%%


fh = @(x,p) p(1) + p(2)*exp(-x./p(3));
errfh = @(p,x,y) sum((y(:)-fh(x(:),p)).^2);
options = optimset('Display','on','MaxFunEvals',2000,'MaxIter',2000);
% params = NaN(size(y,2),3);
fitok = NaN(1,size(y,2));
for i = 1: size(y,2);
    initials = [0, sAhpy(i), 5]; % [offset scale tau]
    [params, ~, fitok(i), ~] = fminsearch(errfh,initials,options,t(sAhpi(i):end),y(sAhpi(i):end,i));
    ysf = fh(t,params);
    yrn = y(t<=mAhpt(i),i)/abs(mAhpy(i));
    tr = t(t<=mAhpt(i));
    ysf2 = ysf;
%     ysf2(sAhpi(i):end) = y(sAhpi(i):end,i);
    ysf2(t<=max(tr)) = yrn*abs(ysf2(mAhpi(i)));
%     close all;
    plot(t,y(:,i)); 
    hold on;
    plot(t,ysf,'blue','Linewidth',1);
    plot(t,ysf2,'red','Linewidth',1);
    plot(t,y(:,i)-ysf2,'black','Linewidth',1);
%     pause
end
    