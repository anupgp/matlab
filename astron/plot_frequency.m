%% %% Get data for frequency plot
%var1name = 'n0ca_cyt';
%var2name = 'n0ca_er';
vartname = 'time';
varyname = 'n0gluves_asyn_flag';
vartid = ~cellfun(@isempty,strfind(colnames,vartname));
varyid = ~cellfun(@isempty,strfind(colnames,varyname));
dmat = sumd;
% ------
mintime = 100;
maxtime = 101;
ncols = 30;
ntrials = 400;
% ------
nspkall = NaN(1,ncols);
maxtall = NaN(1,ncols);
maxyall = NaN(1,ncols);
mintall = NaN(1,ncols);
minyall = NaN(1,ncols);
for i = 1 : ncols
    instfreq = NaN;
    avgfreq = NaN;
    nspk = NaN;
    dmatsmall = dmat(dmat(:,1,i) > mintime & dmat(:,1,i) < maxtime,[(vartid | varyid)],i);
    dmatsmall(:,2) = dmatsmall(:,2)*ntrials;
    [varmaxy(i,1),maxid] = max(dmatsmall(:,2),[],1);
    [varminy(i,1),minid] = min(dmatsmall(:,2),[],1);
    varmaxt(i,1) = dmatsmall(maxid);
    varmint(i,1) = dmatsmall(minid);
    %delta = (varmax(i,1) - varmin(i,1))/2;
    delta = 0.5;
%     if (delta > 1e-09)
%     if (delta > 0.5)
        [nspk,mint,miny,maxt,maxy] = count_spikes(dmatsmall(:,1),dmatsmall(:,2),delta);
        instfreq = 1/mean(diff(maxt(1:nspk)));
        avgfreq = nspk/(maxtime-mintime);
        nspkall(1:length(nspk),i) = nspk';
        maxtall(1:length(maxt),i) = maxt';
        maxyall(1:length(maxy),i) = maxy';
        mintall(1:length(maxt),i) = mint';
        minyall(1:length(maxy),i) = miny';
        %fprintf('%d',length(nspk));
%   end
    yvarinstfreq(i,1) = instfreq;
    yvaravgfreq(i,1) = avgfreq;
    fprintf('%d\t%d\t%d\n',i,delta,nspk);
end
% remove empty columns/rows
%% plot frequency of calcium oscillations
close all;
set(0,'DefaultFigureWindowStyle','docked');
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,35,25,60]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
ah1 = gca;
hold(ah1,'on');
fh1 = plot(ah1,xvarmax*1e09,yvar1avgfreq,'color',[0 0 0],'LineWidth',2);
set(fh1,'LineWidth',3,'Color',[0 0 1],'Linestyle','-');
fh2 = plot(ah1,xvarmax*1e09,yvar1instfreq,'color',[0 0 0],'LineWidth',2);
set(fh2,'LineWidth',3,'Color',[1 0 0],'Linestyle','-');
set(ah1,'XLim',[0,2000]);
set(ah1,'XTick',0:500:2000);
set(ah1,'YLim',[0,0.2]);
set(ah1,'YTick',0:0.05:0.2);
set(ah1,'LineWidth',2,'Color','none','Linestyle','-');
set(ah1,'TickDir','out');
set(ah1,'FontSize',18);
set(ah1,'XColor','k');
box(ah1,'off');
ylabel(ah1,sprintf(' Frequency (Hz)'),'Fontsize',18);
xlabel(ah1,sprintf('\n\nIP_3 concentration (nM)'),'Fontsize',18);
title(ah1,sprintf('Astrocyte Ca_{cyt}^{2+} oscillations'),'FontSize',20);
[hleg1, hobj1] = legend(ah1,'Average','Instantaneous','Location','NorthEast');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 18);
htb = annotation('textbox',[0.16 0.73 0.4 .15]); % [x y w h]
set(htb,'string',sprintf('N_{ip3rlr} = 1m, Ca_{er}^{2+} = 250 \\muM, er_{leak} = 0.02\n\nflux_{ip3rlr} = 1.2, flux_{serca} = 2\\muM'),'FontSize',12);
set(htb,'FitBoxToText','off');
set(htb,'LineStyle','none');
set(htb,'FitHeightToText','off');
%print(gcf,'-djpeg',['-r','300'],'/home/anup/goofy/projects/data/astron/figures/ip3rlr/astrocyte5_erca250_n1m_cacyt_freq.jpeg');
%%
ax=gca;
set(ax(1),'XLim',[0,1000]);
set(ax(1),'XTick',0:200:100)
set(ax(1),'YLim',[0,0.2]);
set(ax(1),'YColor','k');
set(ax(1),'YTick',0:0.05:0.2);
set(ax(1),'TickDir','out');
set(ax(1),'FontSize',20);
xlabel(ax(1),sprintf('\nSerca K_{half} (nM)'),'Fontsize',22);
ylabel(ax(1),sprintf('\n\n Frequency'),'Fontsize',22);
title(ax(1),sprintf('Frequency of astrocyte calcium oscillations'),'FontSize',22);
[hleg1, hobj1] = legend(gca,'Frequency','Location','NorthEast');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
set(gcf,'Units','normal')
set(gca,'Position',[0 0 1 1])
set(gca,'OuterPosition',[.01 .05 0.95 0.95])
%annotation('textbox',[.65 .2 .3 .3],'string',sprintf('serca-vmax:\t40'),'FitBoxToText','on','FontSize',14)