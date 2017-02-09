%%
[y, si] = abfload('~/DATA/ELS/data/20120726/C3/C3_0010.abf','channels',{'Im_scaled'},'sweeps',1:5);
y = reshape(y,200000,5);
t = (0:20E-06:199999*20E-06)';
y2 = y((t>2.5 & t< 3.9),1);
t2 = t(t>2.5 & t< 3.9);
sdev=std(y2);
[mint miny maxt maxy] = simplepeak(t2,y2,ceil(sdev));
k=1;
for i = 1:length(maxy)-1
    j = find(t2>=maxt(i),1,'first');
    while ((y2(j) >  maxy(i)-(maxy(i)-miny(i+1))/2) )
        j = j-1;
    end
    tl=t2(j);
    j = find(t2>=maxt(i),1,'first');
    while ((y2(j) >  maxy(i)-(maxy(i)-miny(i+1))/2) )
         j = j+1;
    end
    tr=t2(j);
    if ((tr-tl)>80E-06 && (tr-tl)<300E-06)
        SAt(k)=maxt(i);
        SAy(k)=maxy(i);
        k =k+1
    end
    
end
%%