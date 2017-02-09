% Time-stamp: <2016-02-11 12:14:35 anup>
% COUNT_SPIKES Function to count the spikes in a given column of
% values that are above the given threshold (delta)
% 
% Usage: count_spikes(times,values,threshold)
% times: a column vector of times
% values: a column vector of the values from which the spikes are
% to be found
% threshold: a threshold to detect spikes
function [nspk,mint,miny,maxt,maxy] = count_spikes(t,y,delta)
    mint = nan(100);
    miny = nan(100);
    maxt = nan(100);
    maxy = nan(100);
    minval = +Inf; minpos = 0;
    maxval = -Inf; maxpos = 0;
    look4max=1;
    maxcnt=0; mincnt=0;
    for j = 1: length(y)-1
        if(y(j) > maxval)
            maxval = y(j);
            maxpos = t(j);
        end
        if(y(j) < minval)
            minval = y(j);
            minpos = t(j);
        end
        if(look4max)
            if(y(j) < maxval-delta)
                maxcnt = maxcnt+1;
                maxy(maxcnt)=maxval;
                maxt(maxcnt)=maxpos;
                minval = y(j);
                minpos = t(j);
                look4max=0;
            end
        else
            if(y(j) > minval+delta)
                mincnt= mincnt+1;
                miny(mincnt)=minval;
                mint(mincnt)=minpos;
                maxval = y(j);
                maxpos = t(j);
                look4max=1;
            end
        end
    end
    maxt = maxt(1:maxcnt);
    maxy = maxy(1:maxcnt);
    %                 if (sum(~isnan(maxy))>=1)
    %                     mincnt=mincnt+1;
    %                     miny(mincnt)=minval;
    %                     mint(mincnt)=minpos;
    %                 end
    mint = mint(1: maxcnt);
    miny = miny(1:maxcnt);
    % Adjust the length of mint & miny same as that of maxt & maxy
    %                 if(length(miny)<length(maxy))
    %                     miny = [miny,0];
    %                     mint = [mint,0];
    %                 end
    % Find the accomodation
    if (length(maxt)<2)
        % Accomodation not computed if fewer than 2 spikes
        acco=NaN;
    elseif (length(maxt)==2)
        % If no.of spiked = 2
        acco = (maxt(2)-maxt(1))/(maxt(1)-t(1));
    elseif (length(maxt)>2) %
        acco = (maxt(end)-maxt(end-1))/(maxt(2)-maxt(1));
    end
    nspk = length(maxt);
end