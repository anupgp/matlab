function [mAHPp,mAHPpt, mAHPa,sAHPp,sAHPpt, sAHPa] = getAHPs_Phd(t,y)
    ahpStart = 1.1; % end of the depolarizing pulse
    ahpEnd =  t(end); % end of the AHP trace
    delay= 1; % delay = 500 msec 
    ahpLast = mean(y(t>ahpEnd-0.01));
    areaLeftT = t(find(y<=ahpLast,1,'first'));
    y = y-ahpLast;
    y(y>0) = 0;
    mAHPp = min(y(t>ahpStart)); % find the mAHP peak
    mAHPpt = t((find(y==mAHPp)));
    mAHPp = mean(y((t> mAHPpt-0.005) & (t< mAHPpt+0.005))); % average within a box of 10 msec
    sAHPpt = mAHPpt+delay;
    sAHPp = mean(y((t> sAHPpt-0.01) & (t< sAHPpt+0.01))); % average within a box of 20 msec
    areaTot = trapz(t(t>areaLeftT),y(t>areaLeftT));
    mAHPa = trapz(t((t>areaLeftT)& (t<sAHPpt)),y((t>areaLeftT)& (t<sAHPpt)));
    sAHPa = areaTot-mAHPa;
end