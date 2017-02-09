function gc = glucon(t,rels)
    gc = zeros(size(t));
    sf = 0.0;
    relcount = 0;
    delay = 0.0
for i = 1 : length(t)
    gc(i) = (2.7E-03*sf*(1-exp(-(t(i)-delay)/0.22E-03)) - 2.7E-03*sf*(1-exp(-(t(i)-delay)/2E-03)));
    if(relcount+1 <= length(rels))
    if (t(i) >= rels(relcount+1))
        sf = 1.0;
        relcount = relcount +1;
        delay = t(i);
    end
    end
end
end


