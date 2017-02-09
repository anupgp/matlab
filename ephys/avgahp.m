function y = avgahp(g,x)
range = min(g):max(g);
idxRange = 1:length(range);
numcells = sum(diff(g)<0)+1;
y = nan(length(range)+2,numcells+5);
%Filling up y ----------------------------
cellCnt=1;
leftAll = [1, find(diff(g)<0)']+1;
rightAll = [find(diff(g)<0)',length(g)];
while (cellCnt<=length(rightAll))
    yvals = nan(1,length(range));
    gvals = g(leftAll(cellCnt):rightAll(cellCnt))';
    xvals = x(leftAll(cellCnt):rightAll(cellCnt))';
    img=ismember(range,gvals);
    idxg = idxRange(img);
    yvals(idxg)=xvals;
    y(1:length(yvals),cellCnt)=yvals;
    cellCnt=cellCnt+1;
end
%Computing mean, sd, N and sem of  y across cells ----------------------------
row=1;
while (row<= length(range))
    trace = y(row,1: numcells);
    y(row, numcells+2) = mean(trace(~isnan(trace)));
    y(row, numcells+3) = sum((~isnan(trace)));
    y(row, numcells+4) = std(trace(~isnan(trace)));
    y(row, numcells+5) = std(trace(~isnan(trace)))/sqrt(sum(~isnan(trace)));
    row =row+1;
end
%Computing mean of  y across cells-----------------------------
col=1;
while (col <= numcells)
    trace = y(1: length(range),col);
    y(length(range)+2, col) = mean(trace(~isnan(trace)));
    col =col+1;
end
meansem = y(:,[numcells+2,numcells+5]);
end 