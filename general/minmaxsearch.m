function [peaks locs] = supersumpeaks(x,y)
% [mnx mny mxx mxy] : x & y values of minimas and maximas on the inout
% vectors (x,y)
if(length(x) ~= length(y)), display('x and y must be equal!'); return; end;
lookformax=1;
mnx=zeros(25,1).*NaN; mny = zeros(25,1).*NaN; mxx = zeros(25,1).*NaN;
mxy = zeros(25,1).*NaN;
mnytemp = +Inf; mxytemp= -Inf;mnxtemp = NaN; mxxtemp= NaN;
rise=0; fall=0;
for i = 1:1:length(x)
    if(y(i) > mxytemp), mxytemp=y(i); mxxtemp=x(i); end;
    if(y(i) < mnytemp), mnytemp=y(i); mnxtemp=x(i); end;
    if(lookformax), 
        if(y(i) < mxytemp-delta),
            mxx = [mxx x(i)]; mxy = [mxy y(i)];
            mnytemp = y(i); 
            lookformax=0; end;
    else
        if(y(i) > mnytemp+delta),
            mnx  = [mnx x(i)]; mny = [mny y(i)];
            mxytemp = y(i);
            lookformax = 1; end;
    end;
              
end