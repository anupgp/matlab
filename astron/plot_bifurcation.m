%% Get data for bifurcation plot
var1name = 'n0ca_cyt';
var2name = 'n0ca_er';
var3name = 'n0ip3_cyt';
% --------
mintime = 75;
maxtime = 125;
num_trials = 200;
for i = 1 : num_trials
    var1max(i,1) = max( d(d(:,1,i) > mintime & ...
                          d(:,1,i) < maxtime, ...
                              ~cellfun(@isempty,strfind(colnames,var1name)),i),[],1);
    var1min(i,1) = min( d(d(:,1,i) > mintime & ...
                          d(:,1,i) < maxtime, ...
                              ~cellfun(@isempty,strfind(colnames,var1name)),i),[],1);
    %---------
    var2max(i,1) = max( d(d(:,1,i) > mintime & ...
                          d(:,1,i) < maxtime, ...
                              ~cellfun(@isempty,strfind(colnames,var2name)),i),[],1);
    var2min(i,1) = min( d(d(:,1,i) > mintime & ...
                          d(:,1,i) < maxtime, ...
                              ~cellfun(@isempty,strfind(colnames,var2name)),i),[],1);
    %---------
    var3max(i,1) = max( d(d(:,1,i) > mintime & ...
                          d(:,1,i) < maxtime, ...
                              ~cellfun(@isempty,strfind(colnames,var3name)),i),[],1);
    var3min(i,1) = min( d(d(:,1,i) > mintime & ...
                          d(:,1,i) < maxtime, ...
                              ~cellfun(@isempty,strfind(colnames,var3name)),i),[],1);                          
end
%% plot bifurcation minmax
close all;
set(0,'DefaultFigureWindowStyle','docked');
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,35,25,60]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
%[ax,h1,h2] = plotyy(xvarmax*1e09,yvarmin*1e09,xvarmax*1e09,yvarmax*1e09,@plot,@plot); 
% -------------
% plot ca_cyt
ah1 = gca;
hold(ah1,'on');
fh1 = plot(ah1,xvarmax*1e09,yvar1min*1e09);
fh2 = plot(ah1,xvarmax*1e09,yvar1max*1e09);
set(fh1,'LineWidth',3,'Color',[0 0 0],'Linestyle','-');
set(fh2,'LineWidth',3,'Color',[0 0 0],'Linestyle','-');
set(ah1,'XLim',[0,2000]);
set(ah1,'XTick',0:500:2000);
set(ah1,'YLim',[0,2500]);
set(ah1,'YTick',0:500:2500);
set(ah1,'LineWidth',2,'Color','none','Linestyle','-');
set(ah1,'TickDir','out');
set(ah1,'FontSize',18);
set(ah1,'XColor','k');
box(ah1,'off');
ylabel(ah1,sprintf(' Ca_{cyt}^{2+} (\\muM)'),'Fontsize',18);
xlabel(ah1,sprintf('\n\nIP_3 concentration (nM)'),'Fontsize',18);
title(ah1,sprintf('Astrocyte Ca_{cyt / er}^{2+} oscillations'),'FontSize',20);
% -------------
% plot ca_er
ah2 = axes;
hold(ah2,'on');
set(ah2,'Units','pixels','YAxisLocation','right','Color','none');
set(ah2,'Position',get(ah1,'Position'));
fh3 = plot(ah2,xvarmax*1e09,yvar2min*1e06);
fh4 = plot(ah2,xvarmax*1e09,yvar2max*1e06);
set(fh3,'LineWidth',3,'Color',[0.9,0.2,0.1],'Linestyle','-');
set(fh4,'LineWidth',3,'Color',[0.9,0.2,0.1],'Linestyle','-');
set(ah2,'XLim',[0,2000]);
set(ah2,'XTick',[]);
set(ah2,'YLim',[225,275]);
set(ah2,'YTick',225:10:275);
set(ah2,'TickDir','out');
box(ah2,'off');
set(ah2,'LineWidth',2,'Color','none','Linestyle','-');
set(ah2,'YColor',[0.9,0.2,0.1]);
set(ah2,'FontSize',18);
ylabel(ah2,sprintf('\nCa_{er}^{2+} (\\muM)'),'Fontsize',18);
% ------
set(gcf,'Units','normal')
htb = annotation('textbox',[0.16 0.73 0.4 .15]); % [x y w h]
set(htb,'string',sprintf('N_{ip3rlr} = 1m, Ca_{er}^{2+} = 250 \\muM, er_{leak} = 0.02\n\nflux_{ip3rlr} = 1.2, flux_{serca} = 2\\muM'),'FontSize',12);
set(htb,'FitBoxToText','off');
set(htb,'LineStyle','none');
set(htb,'FitHeightToText','off');
%print(gcf,'-djpeg',['-r','300'],'/home/anup/goofy/projects/data/astron/figures/ip3rlr/astrocyte5_erca250_n1m_ca_bif.jpeg');