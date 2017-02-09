function [locs] = templatematch(trace,template,step,thres)
% if (nargin < 3), step = length(template); end;
template = reshape(template,1,length(template));
templatenorm = abs(template./template(1));
incr=1;
for i = 1:step:length(trace)
    if (i+length(template)-1 > length(trace)),disp('prog. excited before the end of trace'); break; end
    block = trace(i:(i+length(template)-1));
    block = reshape(block,1,length(block));
    blocknorm= abs(block./block(1));
    if (length(block)~=length(template)), disp('unequal matrix prog. excited!'); break; end
    cv(incr) = sqrt(sum((blocknorm-templatenorm).^2,2))/(length(template)*(mean(templatenorm)*mean(blocknorm)));
    loc(incr) = i;
    incr = incr+1;
end
 deltacv = (cv([end 1:end-1])-cv).*(1./cv); % averaged difference between successive values of cv is nomalized with each cv
 locs = loc(deltacv>thres);
