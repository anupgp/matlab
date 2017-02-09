function [mint, miny, maxt, maxy] = simplepeak(t,y,delta)
mint = nan(100);
miny = nan(100);
maxt = nan(100);
maxy = nan(100);
min = +Inf; minpos = 0;
max = -Inf; maxpos = 0;
look4max=0;
maxcnt=0; mincnt=0;
for i = 1: length(y)-1
    if(y(i) > max) 
        max = y(i); 
        maxpos = t(i); 
    end
    if(y(i) < min)
        min = y(i);
        minpos = t(i);
    end
    if(look4max)
        if(y(i) < max-delta) 
            maxcnt = maxcnt+1;
            maxy(maxcnt)=max; 
            maxt(maxcnt)=maxpos;
            min = y(i); 
            minpos = t(i);
            look4max=0;
        end
    else
        if(y(i) > min+delta) 
            mincnt= mincnt+1;
%             try
                 miny(mincnt)=min;
%             catch err
%                 printf('ERROR!');
%             end
            
            mint(mincnt)=minpos;
            max = y(i); 
            maxpos = t(i);
            look4max=1;
        end
    end
end
maxt = maxt(1:maxcnt);
maxy = maxy(1:maxcnt);
% if (sum(~isnan(maxy))>=1)
%     mincnt=mincnt+1;
%     miny(mincnt)=min; 
%     mint(mincnt)=minpos;
% end
mint = mint(1:maxcnt);
miny = miny(1:maxcnt);
end