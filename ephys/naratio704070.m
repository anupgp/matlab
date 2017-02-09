function [cells, pre,mid1,mid2,post] = naratio704070(expfile)
pre= nan(50,100);
mid1 = nan(50,100);
mid2 = nan(50,100);
post= nan(50,100);
cells = cell(1);
expinfo = getfiles(expfile);
fnames = [expinfo{:,1}];
ispost=0;
precnt=0;midcnt=0;postcnt=0;
for i = 1: length(fnames)
     fn = char(fnames{i});
     full = expinfo{i,4}:expinfo{i,5};
     select = full(~ismember(full,[expinfo{i,6}]));
     [y si] = abfload(fn,'channels',expinfo{i,2},'sweeps',select);
     y = reshape(y,size(y,1),size(y,3));
     fn_idxstart = regexp(fn,'[\/JU| \/MA | \/FE | \/JA]{3}','start')+1;
     fn_idxend = max(regexp(fn,'[\/]{1}','end'));
     cells{precnt+1} = fn(fn_idxstart:fn_idxend-1);
     fprintf('#%d: %s, sweeps: %d - %d, r = %d, c = %d, si = %d \n', ...
         i,char(cells{precnt+1}), expinfo{i,4}, expinfo{i,5}, size(y,1),size(y,2),si);   
     t = (0:si*1E-06:(size(y,1)-1)*si*1E-06)';
     t = repmat(t,1,size(y,2));
     disp(expinfo{i,3});
     baset1 = expinfo{i,3} -0.060;
     baset2 = expinfo{i,3} -0.010;
     epsct1 = expinfo{i,3};
     epscts = expinfo{i,3}+0.020;
     epsct2 = expinfo{i,3}+0.1;
     % Low Gaussian filter on the raw trace:  size = 100, sigma = 100/3
    [t y] = gaussfilt2d(t,y,100,100/3);
     % Normalize the waves
    [br, bc] = find(t>=baset1 & t<=baset2);
    y = bsxfun(@minus,y,mean(y(br(1):br(end),bc(1):bc(end)),1)); 
     % Just get epsc part from start to end
    [er, ec] = find(t>=epsct1 & t<=epsct2);
    t = t(er(1):er(end),ec(1):ec(end));
    y = y(er(1):er(end),ec(1):ec(end));
    [er, ec] = find(t>=epsct1 & t<=epscts);
    t2 = t(er(1):er(end),ec(1):ec(end));
    y2 = y(er(1):er(end),ec(1):ec(end));
    % Find the time of peak from the highly filtered y
    ay2 = abs(y2); % abosulte of y
    [~, idx] = max(ay2,[],1);  % peak
    peaktay = t2(sub2ind(size(t2),idx,1:size(t2,2))); % peak time
    peaky = y2(sub2ind(size(t2),idx,1:size(t2,2))); % peak
    close all;
%     plot(t,y); hold on;
%     xlim([epsct1,epsct2]);
%     plot(peaktay,peaky,'sk','markersize',6,'markerfacecolor','b');
    if (mean(peaky) > 0)
        midcnt=midcnt+1
        mid1(end-length(peaky)+1:end,midcnt) = peaky;
        peakdy= nan(1,size(y,2));
        for j = 1: size(y,2)
            [r1,~,~] = find(t(:,j)>=peaktay(j)+0.04,1,'first');
            peakdy(j)= y(r1,j);
            plot(t(r1,j),y(r1,j),'sk','markersize',6,'markerfacecolor','r');
        end
        mid2(end-length(peaky)+1:end,midcnt) = peakdy;
        ispost=1;
    elseif(ispost)
        postcnt=postcnt+1
        post(end-length(peaky)+1:end,postcnt) = peaky;
        ispost=0;
    else
        precnt=precnt+1
        pre(end-length(peaky)+1:end,precnt) = peaky;
    end
%     waitforbuttonpress;
end
 pre = pre(:,1:precnt);
 mid1 = mid1(:,1:midcnt);
 mid2 = mid2(:,1:midcnt);
 post = post(:,1:postcnt);
end