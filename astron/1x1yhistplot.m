close all;
% data
%y1var = maxtall(maxtall > 0) - 100;
y1var = var1max * 1e09;
%xvar = 0:0.25:max(y1var);
xvar = 0:200:2000;
edgevec = xvar;
y2var = hist(y1var,edgevec);
y2var = y2var/sum(y2var);
% display settings
set(0,'DefaultFigureWindowStyle','docked');
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,45,25,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
% plot settings
hold off
ah1 = gca;
fh1 = bar(xvar,y2var,1);
% plot properties
set(fh1,'LineWidth',2);
set(ah1,'XLim',[min(xvar),max(xvar)]);
xticks = min(xvar):round((max(xvar)-min(xvar))/5):max(xvar);
set(ah1,'XTick',xticks);
set(ah1,'YLim',[min(y2var),max(y2var)]);
yticks = min(yvar):round((max(y2var)-min(y2var))*10)/100:max(y2var);
set(ah1,'YTick',yticks);
set(ah1,'LineWidth',2,'Color','none','Linestyle','-');
set(fh1,'FaceColor','white');
set(fh1,'EdgeColor','black');
set(ah1,'TickDir','out');
set(ah1,'FontSize',18);
set(ah1,'XColor','k');
box(ah1,'off');
ylabel(ah1,sprintf('Probability'),'Fontsize',18);
xlabel(ah1,sprintf('\nCalcium concentration (nM)'),'Fontsize',18);
titletext = sprintf('Histogram: calcium concentration');
title(ah1,titletext,'FontSize',20);
% annotations
htb = annotation('textbox',[0.6, 0.7,0.1,0.1]); % [x y w h]
boxtext = sprintf('ATP pulse: 10 \\muM; 2 sec\nNo. of trials: 200');
set(htb,'string',boxtext,'FontSize',12);
set(htb,'FitBoxToText','on');
set(htb,'LineStyle','none');
set(htb,'FitHeightToText','on');
% printing
figname = '/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/histogram_atpcacyt.jpeg';
print(gcf,'-djpeg',['-r','200'],figname);