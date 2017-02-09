% Time-stamp: <2016-02-11 14:56:20 anup>
% RELSPKTIMEDIST Find the relative time of ocurrance of each spike
% in y2 with respect to the nearest spike in y1
% Additionally, a cutoff_delay can be provided to select only those
% spikes of y2 which occur not more than the cutoff_delay

function reltime = relspktimedist(t,y1,y1_thr,y2,y2_thr,varargin)
% Find the times of spk1
    [nspk1,~,~,tspk1,yspk1] = count_spikes(t,y1,y1_thr);
    % Find the times of spk2
    [nspk2,~,~,tspk2,yspk2] = count_spikes(t,y2,y2_thr);
    % Print out the spike counts
    fprintf('Spikes1:%d\tSpikes2:%d\n',nspk1,nspk2);
    for i = 1:nspk2
        reltime(i,1) = tspk2(i);
        reltime(i,2) = tspk2(i)-tspk1(find(tspk1<=tspk2(i),1,'last'));
    end
    display(nargin);
    if(nargin >5)
        cutoff_delay = varargin{1};
        fprintf('Filtering with cutoff_delay = %d\n',cutoff_delay);  
        reltime=reltime(reltime(:,2)<=cutoff_delay,:);
    end
end