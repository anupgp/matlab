
%% Plot histograms (inter-release intervals & release delay) for book chapter
close all;
set(0,'DefaultFigureWindowStyle','docked');
trialnum = 22;
dat1 = maxyall(:,trialnum)*1e9;
dat1(dat1 == 0) = NaN;
edge_vec = 0:50:2000;
hist1 = histc(dat1,edge_vec);
sum_hist1 = sum(hist1);
%hist2 = histc(d10atp(:,3)*1,edg3_vec)/(200*35);
% [ax,h1,h2] = plotyy(edge_vec,f10,edge_vec,[cumsum(f0),cumsum(f10)],@bar,@plot);
%h1 = plot(edge_vec,hist1);
hold off
fh = bar(edge_vec,hist1/sum_hist1,1);
ax = gca;
set(ax(1),'XLim',[0,2000]);
set(ax(1),'XTick',0:250:2000);
set(ax(1),'XTickLabel',0:250:2000);
set(ax(1),'YLim',[0,1]);
set(ax(1),'TickDir','out');
xlabel(gca,sprintf('[Ca^{2+}] (nM)'),'Fontsize',22);
ylabel(gca,sprintf('# Ca^{2+} peaks'),'Fontsize',20);
set(gca,'FontSize',14);
% Histogram plot with inset
ah_inset1 = axes('position', [0.3, 0.7, 0.5, 0.2]);
fh_inset1 = plot(ah_inset1,d(:,1,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ca_cyt')),trialnum)*1e09...
        ,'color','red','LineWidth',2); 
hold(ah_inset1,'on');
fh_inset2 = plot(ah_inset1, maxtall(:,trialnum)',dat1,'LineStyle','o');    
set(ah_inset1,'XLim',[0,500]);
set(ah_inset1,'XTick',0:100:500);
% -----
ah_inset2 = axes('position', [0.3, 0.7, 0.5, 0.2],'XAxisLocation','bottom','YAxisLocation','right','Color','none');
set(ah_inset2,'XTick',[]);
hold(ah_inset2,'on');
fh_inset3 = plot(ah_inset2,d(:,1,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ip3_cyt')),trialnum)*1e09...
        ,'color','blue','LineWidth',1); 
hold(ah_inset2,'on');

fh_inset4 = plot(ah_inset2,d(:,1,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ca_er')),trialnum)*1e06...
        ,'color','cyan','LineWidth',1); 
    
set(ah_inset2,'YLim',[0,2000]);
set(ah_inset2,'YTick',0:500:2000);
xlabel(ah_inset1,sprintf('Time (sec)'),'Fontsize',14);
ylabel(ah_inset1,sprintf('[Ca^{2+}] (nM)'),'Fontsize',14);
ylabel(ah_inset2,sprintf('[IP_{3}] (nM)'),'Fontsize',14,'Color','blue');
box(ah_inset1,'off');
%
%fname = {['/mnt/storage/goofy/projects/data/astron/figures/ip3rlr/ip3r_yk_n20_det_ip3',num2str(trialnum),'_hist','.jpeg']};
%print('-djpeg','-r300',fname{1}); %['-r','300']
%%
set(ax(1),'FontSize',20);
set(h1,'BarWidth',1,'FaceColor','r','EdgeColor','r','BarLayout','grouped');
set(h3,'BarWidth',1,'FaceColor','b','EdgeColor','b','BarLayout','grouped');
set(h2(1),'LineWidth',2.0,'Color','b','Linestyle','-.','MarkerSize',5);
set(h2(2),'LineWidth',2.0,'Color','r','Linestyle','-.','MarkerSize',5);
set(findobj(h1,'type','Patch'),'FaceAlpha',0.5);
set(findobj(h3,'type','Patch'),'FaceAlpha',0.5);
hold on;
% plot(ax(1),edge_vec,f10,'LineWidth',3,'Color',[0.5,0.5,0.5]);
% plot(ax(1),edge_vec,f0,'LineWidth',3,'Color',[0.5,0.5,0.5]);
s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[-1,-1],...
               'Upper',[1,1],...
               'Startpoint',[0.01,0.1]);
f = fittype('a*(exp(-b*x))','independent','x','coefficients',{'a','b'},'options',s);
x = (edge_vec(4:end))';
y10 = f10(4:end);
y0 = f0(4:end);
[cf10,g10] = fit(x,y10,f);
[cf0,g0] = fit(x,y0,f);
plot(ax(1),x,cf10(x),'LineWidth',2,'Color','r');
plot(ax(1),x,cf0(x),'LineWidth',2,'Color','b');
set(ax(2),'YLim',[0,0.2]);
set(ax(2),'YTick',0:0.1:0.2);
set(ax(2),'FontSize',20);
xlabel(ax(2),sprintf('\nInter-release interval (s)'),'Fontsize',22);
ylabel(ax(1),sprintf('Release probability'),'Fontsize',22);
ylabel(ax(2),sprintf(' Cumulative probability'),'Fontsize',22);
set(gcf,'Units','normal')
set(gca,'Position',[0 0 1 1])
set(gca,'OuterPosition',[.01 .05 0.95 0.95])
set(gca,'Units','normalized');
[hleg1, hobj1] = legend(gca,'With ATP (10 \muM)','Without ATP','Location','Northwest');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
text(22,0.004,'tau_{with ATP} = 5.3s','FontSize',16)
text(22,0.0025,'tau_{without ATP} = 5.8s','FontSize',16)