close all;
% data
%xvar = var1max * 1e09;
%xvar = tvar - 100;
xvar = exploop;
%yvar = nspkall(1,:);
%yvar = avgdat*1e9;
yvar = nspkall;
% display settings
set(0,'DefaultFigureWindowStyle','docked');
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,35,25,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
% plot settings
ah1 = gca;
hold(ah1,'on');
fh1 = plot(ah1,(xvar),(yvar),'color',[0 0 0],'LineWidth',1);
% plot properties
set(fh1,'LineWidth',2,'MarkerSize',8,'LineStyle','-');
%set(ah1,'XLim',[0,12000]);
%set(ah1,'XTick',0:2:12000);
%set(ah1,'YLim',[0,1000]);
%set(ah1,'YTick',0:200:1000);
set(ah1,'LineWidth',2,'Color','none','Linestyle','-');
set(ah1,'TickDir','out');
set(ah1,'FontSize',18);
set(ah1,'XColor','k');
box(ah1,'off');
%ylabel(ah1,sprintf('Calcium (nM)'),'Fontsize',18);
ylabel(ah1,sprintf('No. of releases'),'Fontsize',18);
xlabel(ah1,sprintf('\n[Ca^{2+}]_{i}'),'Fontsize',18);
%xlabel(ah1,sprintf('\nTime (sec)'),'Fontsize',18);
title(ah1,sprintf('Ca^{2+} pulse duration: 50 sec \nAsynchronous release duration: 50 sec'),'FontSize',20);
% annotations
%htb = annotation('textbox',[0.6, 0.7,0.1,0.1]); % [x y w h]
%boxtext = sprintf('ATP pulse: 10 \\muM; 2 sec\nNo. of trials: 200');
%set(htb,'string',boxtext,'FontSize',12);
%set(htb,'FitBoxToText','on');
%set(htb,'LineStyle','none');
%set(htb,'FitHeightToText','on');
% printing
figname = '/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/cacyt50s_asynrelflag50s_linear.jpeg';
print(gcf,'-djpeg',['-r','300'],figname);
%%
% [hleg1, hobj1] = legend(ah1,'Average','Instantaneous','Location','NorthEast');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 18);