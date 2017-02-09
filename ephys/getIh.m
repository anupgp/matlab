function Ihsag = getIh(t,y)
IhStart = 0.05;
IhEnd = 0.6499;
[rBaseEnd,~] = find(t<IhStart,1,'last'); % find the row for t at which the baseline ends.
avgRest = mean(y(1:rBaseEnd,:),1); % find the mean baseline voltage
delayPkHyp = 0.100; % maxminum time (s) after pulse to search for the peak hyperpolarization
[rHypStart, ~] = find(t> IhStart,1,'first');
[rPkHyp, ~] = find(t > IhStart+delayPkHyp,1,'first');
yPkHyp = y(rHypStart:rPkHyp,:);
PkHyp = min(yPkHyp); % all the peak hyperpolarizations with in the maximum delay after hyp start
[rHypEnd,~] = find(t<IhEnd,1,'last'); % find the row for t at which the Ih pulse ends.
delayMinHyp = 0.01; % time to average the end of Ih Hyp pulse 
[rHypPreEnd,~] = find(t<IhEnd-delayMinHyp,1,'last'); % find the row for t delayMinHyp before Ih pulse ends.
avgHypEnd = mean(y(rHypPreEnd:rHypEnd,:),1);
Ihsag = PkHyp ./avgHypEnd;
end