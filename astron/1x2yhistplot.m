close all;
% data
%y1var = maxtall(maxtall > 0) - 100;
% y1var = yvarmat1;
% y2var = yvarmat2;
%xvar = 0:0.25:max(y1var);
xvar = 0:0.05:300;
edgevec = xvar;
%y1var = hist(y1var,edgevec);
y1var = histcomplete1/sum(histcomplete1);
%y2var = hist(y2var,edgevec);
y2var = histcomplete2/sum(histcomplete2);
% display settings
set(0,'DefaultFigureWindowStyle','docked');
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,45,25,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
% plot settings
hold off
ah1 = gca;
fh1 = bar(xvar,y1var,1);
hold on
fh2 = bar(xvar,y2var,1);
% plot properties
set(fh1,'LineWidth',2);
set(ah1,'XLim',[50,300]);
xticks = 50:50:300;
set(ah1,'XTick',xticks);
%set(ah1,'YLim',[0,0.05]);
%yticks = 0:0.01:0.05;
%set(ah1,'YTick',yticks);
set(ah1,'LineWidth',2,'Color','none','Linestyle','-');
set(fh1,'FaceColor','black');
set(fh1,'EdgeColor','black');
set(fh2,'FaceColor','blue');
set(fh2,'EdgeColor','blue');
set(ah1,'TickDir','out');
set(ah1,'FontSize',18);
set(ah1,'XColor','k');
box(ah1,'off');
ylabel(ah1,sprintf('Probability'),'Fontsize',18);
xlabel(ah1,sprintf('\nTime (sec)'),'Fontsize',18);
titletext = sprintf('Spontaneous & asynchronous releases');
title(ah1,titletext,'FontSize',20);
% annotations
htb = annotation('textbox',[0.6, 0.75,0.1,0.1]); % [x y w h]
boxtext = sprintf('ATP pulse: 10 \\muM; 2 sec\nNo. of trials: 200');
set(htb,'string',boxtext,'FontSize',12);
set(htb,'FitBoxToText','on');
set(htb,'LineStyle','none');
set(htb,'FitHeightToText','on');
% legend
%[hleg1, hobj1] = legend([fh1,fh2],'Spontaneous release','Asynchronous release','Location','NorthEast');
%set(hleg1,'box','off');
%set(hleg1,'FontSize',12);
% printing
figname = '/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/histogram_spon_asyn_release_prob_full.jpeg';
print(gcf,'-djpeg',['-r','200'],figname);