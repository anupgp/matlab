function [s te] = endofcharging(t,y)
if length(y) ~= length(t) 
    fprintf('dimensions of the input waves must match');
    return;
end
% y = medfilt1(y,3);
s = zeros(ceil(length(t)/2),2);
loop=true;
step= floor(10E-03/(t(2)-t(1))); % step every 3 msec
i=1; j=1;

while (loop)
    s(j,2) = max(y(i: i+step))-max(y(i+step: i+2*step));
    s(j,1)=t(i);
%     fprintf('t=%d, s=%d \n',t(i), s(j,2));
    i=i+2*step;
    j=j+1;
    if (i+step > length(y) )
        loop = false;
    end
end
s = s(1:j-1,:);
% plot(s(:,1),s(:,2)); hold on;
te = s(find(s(:,2)<=0, 1,'first' ),1); % time at which the charging has reached maximum


        