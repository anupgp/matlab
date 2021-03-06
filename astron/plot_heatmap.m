%% Plot heatmap
close all
colormap('hot');
%fh=imagesc(1:10,1:20,reshape((yvarfreq),10,20));
%fh=imagesc(maxyall(1:100,1:100));
fh=imagesc(reshape(yvarmax2-yvarmin2,10,16)');
colorbar
%set(gca,'Units','pixels');
%set(gca,'OuterPosition', get(gca,'OuterPosition') + [0,0,50,100]); % [left bottom width height]
%set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
% Remove old axis
%set(gca,'dataAspectRatio',[1 1 1]);
set(gca, 'Color', 'none')
set(gca,'XLim',[1,10])
set(gca,'XTick',[])
set(gca,'XTicklabel',[])
set(gca,'YLim',[1,16])
set(gca,'YTick',[])
set(gca,'YTicklabel',[])
% New axis
ah1 = axes('Position', get(gca,'Position'),'XAxisLocation','bottom','YAxisLocation','left','Color','none');
set(ah1,'FontSize',16);
set(ah1,'XLim',[0.6,6.0]);
set(ah1,'XTick',0.6:0.6:6);
set(ah1,'XTicklabel',0.6:0.6:6)
set(ah1,'YLim',[1,16]);
set(ah1,'YTick',1:1:16);
set(ah1,'YTickLabel',repmat([0.0004,0.004,0.04,0.11],1,4));
set(ah1,'TickDir','out');
set(ah1,'Ydir','reverse');
ylabel(ah1,sprintf('Er\\_leak'),'Fontsize',22);
xlabel(ah1,sprintf('Ip3r\\_yk\\_flux\\_coef'),'Fontsize',22);
title(ah1,'3 parameter sweep','FontSize',18);
%---------
set(gcf,'Units','pixels');
set(ah1,'Position', get(ah1,'Position') + [20,13,10,90]);
set(ah1,'OuterPosition', get(ah1,'OuterPosition') + [0,0,110,10]); % [left bottom width height]
set(gcf,'Units','points')
set(gcf,'PaperUnits','points')
size = get(gcf,'Position')
size = size(3:4);
set(gcf,'PaperSize',size);
set(gcf,'PaperPosition',[0,0,size(1),size(2)])
%xlabel(gca,sprintf('IP3r\\_yk\\_flux\\_coef'),'Fontsize',20);
%---------
% set(hx1,'YLim',[min(x1varmax),max(x1varmax)+(max(diff(x1varmax)))]*1e09);
% set(hx1,'YTick',round([min(x1varmax):max(diff(x1varmax)):(max(x1varmax)+(2*max(diff(x1varmax))))]*1e09));
% set(hx1,'YTickLabel',round([0,min(x1varmax):max(diff(x1varmax)):(max(x1varmax)+(2*max(diff(x1varmax))))]*1e09));
%---------------
%title(hx1,'Astrocyte (no PLC_{\delta}) Ca^{2+}_{cyt} oscillation frequency','FontSize',16);
%title(hx1,'Neuron (with PLC_{\delta}) with PMCA (density=250) Ca^{2+}_{cyt} osc frequency','FontSize',16);
%set(gcf,'PaperPositionMode','auto')

fname = {'/mnt/storage/goofy/projects/data/astron/figures/ip3rlr/ip3r_yk_hm.jpeg'};
%print('-djpeg','-r300',fname{1});
%% Plot heatmap amplitude of oscillations
close all
yvarmax2 = reshape(yvarmax,10,16);
yvarmin2 = reshape(yvarmin,10,16);
colormap('hot');
fh=imagesc((yvarmax2-yvarmin2)');
%fh=imagesc(reshape((yvarmax),16,10));
colorbar
%set(gca,'dataAspectRatio',[1 1 1]);
set(gca, 'Color', 'none')
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
% set(ax(1),'XLim',[0,100]);
% set(ax(1),'YLim',[10,10000]);
%figpos=[0.13,0.11,0.68763,0.815];
%hx1 = axes('position',figpos,'color','none');
%set(hx1,'FontSize',16);
% set(hx1,'XLim',[0 2000]);
% set(hx1,'XTick',linspace(0,2000,11));
% set(hx1,'XTickLabel',linspace(0,2000,11));
%set(hx1,'XLim',round([0, max(x2varmax)+max(diff(x2varmax))]*1e09));
%set(hx1,'XTick',round([0,min(x2varmax):max(diff(x2varmax))*2:(max(x2varmax)+(2*max(diff(x2varmax))))]*1e09));
%set(hx1,'XTickLabel',round([0,min(x2varmax):max(diff(x2varmax))*2:(max(x2varmax)+(2*max(diff(x2varmax))))]*1e09));
%set(hx1,'Xdir','reverse');
set(hx1,'TickDir','out');
xlabel(hx1,sprintf('IP_3 concentration (nM)'),'Fontsize',22);
%---------
%set(hx1,'YTick',linspace(0,280,11));
%set(hx1,'YTickLabel',linspace(0,280,11));
set(hx1,'YLim',[min(x1varmax),max(x1varmax)+(max(diff(x1varmax)))]*1e09);
set(hx1,'YTick',round([min(x1varmax):max(diff(x1varmax)):(max(x1varmax)+(2*max(diff(x1varmax))))]*1e09));
set(hx1,'YTickLabel',round([0,min(x1varmax):max(diff(x1varmax)):(max(x1varmax)+(2*max(diff(x1varmax))))]*1e09));
set(hx1,'Ydir','reverse');
ylabel(hx1,sprintf('Serca hill K_d (nM)'),'Fontsize',22);
%------------------
title(hx1,'Astrocyte (with PLC_{\delta}) with PMCA (density=100) Ca^{2+}_{cyt} baseline','FontSize',16);
%title(hx1,'Astrocyte (with PLC_{\delta}) with PMCA (density=100) Ca^{2+}_{cyt} baseline','FontSize',16);
%title(hx1,'Astrocyte (with PLC_{\delta}) with PMCA (density=100) Ca^{2+}_{cyt} low value','FontSize',16);
%title(hx1,'Astrocyte (no PLC_{\delta}) no PMCA Ca^{2+}_{cyt} low amplitude','FontSize',16);
%%
offset=-7;
% get axes position in pixels
set(hx1,'Units','pixels')
posax = get(hx1,'Position');
% move axes
set(hx1,'Position',posax+[0 offset 0 0])
%--------------
% resize figure
% get figure position
posfig = get(gca,'Position');
posfignew = posfig + [0 -offset 0 offset];
set(gca,'Position',posfignew)
%% get label position in pixels
set(get(hx1,'XLabel'),'Units','pixels')
poslab = get(get(hx1,'XLabel'),'Position');
% move label
%set(get(hx1,'XLabel'),'Position',poslab+[0 -offset 0])
set(get(hx1,'XLabel'),'Position',poslab+[0 -3 0])
% set units back to 'normalized' and 'data'
set(hx1,'Units','normalized')
set(get(hx1,'XLabel'),'Units','data')