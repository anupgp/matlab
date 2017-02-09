close all;
[pret,prey] = asciload('/home/goofy/DATA/PhD_Work/Proj_Tianeptine/New_analysis_NPP/Ih_TIA/MAR0208_1_TIA_Ih_pre.asc',23000,12);
[postt,posty] = asciload('/home/goofy/DATA/PhD_Work/Proj_Tianeptine/New_analysis_NPP/Ih_TIA/MAR0208_1_TIA_Ih_post.asc',23000,12);
[preft,prefy] = gaussfilt2d(pret,prey,1000,1000/3);
[postft,postfy] = gaussfilt2d(postt,posty,1000,1000/3);
postft = postft+mean(preft(end,:),2)+0.2;

prefy = (prefy-mean(prefy(preft<0.05),1)-0.07).*1000;
postfy = (postfy-mean(postfy(postft<postft(1)+0.05),1)-0.07).*1000;
plot(preft,prefy,'k','Linewidth',1)
hold on;
plot(postft,postfy,'b','Linewidth',1)
xlim([0,postft(end)])
ylim([-180,-40])
line([0.65,1.15],[-160,-160],'Color','k','LineWidth',1)
line([1.15,1.15],[-160,-140],'Color','k','LineWidth',1)
set(gca,'xcolor',[1 1 1])
set(gca,'XTick',[]);
set(gca,'ycolor',[1 1 1])
set(gca,'YTick',[]);
set(gca,'box','off')
set(get(gca,'xlabel'),'Color',[1 1 1]);
set(gca,'Visible','off')
set(gcf, 'PaperUnits','inches','PaperPosition', [0 0 2 2]);
plotname = ['~/DATA/PhD_Work/Proj_Tianeptine/New_analysis_NPP/','TIA_Ih_Rep','.jpeg'];
print(gcf,'-djpeg',['-r','400'],plotname);