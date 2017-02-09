function linePlot1(pre,post)
avgpre = mean(pre,2)
sempre = std(pre,0,2) ./ sqrt(size(pre,2));
avgpost = mean(post,2)
sempost = std(post,0,2) ./ sqrt(size(post,2));
x = -600:50:-50;
size(x)
x = x';
errorbar(x,avgpre,sempre,'--sk','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'Linewidth',1);
hold on;
errorbar(x,avgpost,sempost,'-sk','MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0.4 0.4 0.4],'Linewidth',1);
set(0,'DefaultAxesFontName', 'Arial')
set(gca,'fontsize',16,'LineWidth',1.4);
ylabh = get(gca,'YLabel');
set(ylabh,'pos',get(ylabh,'pos') - [1 0 0]);
set(gca,'TickDir','out');
set(gca,'XTick',[-600, -300, -50]);
set(gca,'YTick',[1, 1.2, 1.4]);
set(gca,'TickLength',[0.02 0]);
set(gcf, 'PaperUnits','inches','PaperPosition', [0 0 2 3]);
set(gca,'box','off');
ylim([1,1.4]);
xlim([-650,0]);
plotname = ['~/DATA/PhD_Work/Proj_Tianeptine/New_analysis_NPP/','ACSF_Ih_','.jpeg'];
print(gcf,'-djpeg',['-r','400'],plotname);
