function scatterbar1(pre,post)
if (size(pre,1) > size(pre,2))
    pre = pre';
end
if (size(post,1)>size(post,2))
    post = post';
end
grp1 = [pre;post];
x = [repmat(1.2,size(pre));repmat(2.2,size(post))]

means = [mean(pre,2);mean(post,2)];
sems = [std(pre,0,2)/sqrt(length(pre));std(post,0,2)/sqrt(length(post))];
bar_h=bar([1.2;2.2],means);
bar_childs = get(bar_h,'Children');
set(bar_childs,'Edgecolor','black');
set(bar_childs,'Linewidth',1.4);
set(bar_childs,'CData', means);
barcolors = [0,0,0; 0,0,1];
colormap(barcolors);
hold on;
set(0,'DefaultAxesColorOrder',[1, 0,0])
plot(x,grp1,'--O','Linewidth',1);
errorbar([1.2;2.2],means,sems,'.black','Linewidth',1);
set(0,'DefaultAxesFontName', 'Arial')
set(gca,'fontsize',18,'LineWidth',1.4);
ylabh = get(gca,'YLabel');
set(ylabh,'pos',get(ylabh,'pos') - [1 0 0])
set(gca,'XTick',[]);
set(gca,'TickDir','out');
set(gca,'TickLength',[0.02 0]);
set(gca,'XColor','w')
set(gcf, 'PaperUnits','inches','PaperPosition', [0 0 2 3]);
set(gca,'box','off');
set(gcf,'color','w');
ylim([-10,0]);
xlim([0.6,2.8]);
plotname = ['~/DATA/PhD_Work/Proj_Tianeptine/New_analysis_NPP/','TIA_mAHPp_','.jpeg'];
print(gcf,'-djpeg',['-r','400'],plotname);
end


