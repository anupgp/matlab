%% Matlab generate multi-axis plot
close all
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,30,80,60]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,0,0]);
trialnum = 1;
%for (trialnum = 1:160)
hold off;
% var1 = ~cellfun(@isempty,strfind(colnames,'n0gluves_asyn_relrate'));
% var2 = ~cellfun(@isempty,strfind(colnames,'n0gluves_spon_relrate'));
% var3 = ~cellfun(@isempty,strfind(colnames,'n0gluves_asyn_flag'));
% var4 = ~cellfun(@isempty,strfind(colnames,'n0gluves_spon_flag'));
var1 = ~cellfun(@isempty,strfind(colnames,'n0ca_cyt'));
var2 = ~cellfun(@isempty,strfind(colnames,'n0ca_er'));
var3 = ~cellfun(@isempty,strfind(colnames,'n0ip3_cyt'));
var4 = ~cellfun(@isempty,strfind(colnames,'s0atp_ext'));
% ----------
[ah,fh1,fh2] = plotyy(...
   d(:,1,1),d(:,var1,trialnum)*1e0,d(:,1,1),d(:,var2,trialnum)*1e0,'plot','plot');
% box off;
%-----------
set(fh1,'LineWidth',1,'Color',[0, 0, 0],'Linestyle','-');
set(fh2,'LineWidth',1,'Color',[0, 0, 1],'Linestyle','-');
% set(hp3,'LineWidth',2,'Color',[0, 0, 1],'Linestyle','-');
%-----------
set(ah(1),'XLim',[00,300]);
set(ah(1),'XTick',0:100:300)
%set(ah(1),'YLim',[0,500]);
%set(ah(1),'YTick',0:100:500)
set(ah(1),'FontSize',18);
set(ah(1),'YColor',[0,0,0])
xlabel(ah(1),sprintf('Time (sec)'),'Fontsize',18);
%ylabel(ah(1),[sprintf('[Ca^{2+}]_{i}; '),'\color[rgb]{1,0,0}[IP_{3}] (nM); ','\color{green}ATP (10 \muM)'],'Fontsize',18);
ylabel(ah(1),sprintf('Vesicle sec^{-1}'),'Fontsize',18,'Color',[0,0,0]);
box(ah(1),'off');
% -----------
set(ah(2),'XLim',[0,300]);
set(ah(2),'XTick',[])
%set(ah(2),'YLim',[245,255]);
%set(ah(2),'YTick',245:2:255)
% set(hAx(2),'YTick',5:5:20)
set(ah(2),'FontSize',18);
set(ah(2),'YColor',[0,0,1])
%ylabel(ah(2),sprintf('\n[Ca^{2+}]_{er} (\\muM)'),'Fontsize',18,'Color',[0,0,1]);
ylabel(ah(2),sprintf('\nVesicle sec^{-1}'),'Fontsize',18,'Color',[0,0,1]);
box(ah(2),'off');
% -----------
hold on;
fh3 = plot (ah(1),d(:,1,1),d(:,var3,trialnum)+55,'color',[1,0,0],'LineWidth',1);
fh4 = plot (ah(1),d(:,1,1),d(:,var4,trialnum)+57,'color',[0,0,1],'LineWidth',1);
% fh3 = plot (ah(1),d(:,1,1),d(:,var3,trialnum)*1e9,'color',[1,0,0],'LineWidth',1);
fh5 = plot (ah(1),d(:,1,1),d(:,var5,trialnum)*1e6,'color',[0,1,0],'LineWidth',1);
% -----------
% set(fh1,'LineWidth',2);
% set(hp2,'LineWidth',2);
titletext = ['Trial no.: ',num2str(trialnum)];
title(ah(1),titletext,'Fontsize',16);
% legend
% [hleg1, hobj1] = legend([fh1,fh2],'Spontaneous release','Asynchronous release','Location','NorthEast');
% set(hleg1,'box','off');
% set(hleg1,'FontSize',14);
fname = {['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/relrate_relflag_atppulse2s_',num2str(trialnum),'.jpeg']};
%print('-djpeg','-r300',fname{1}); %['-r','300']
%end
% xlabel('Time (sec)','Fontsize',18)
%ylabel(hAx(1),'{\alpha_h} & {\beta_h}','Fontsize',18); % left y-axis
% ylabel(hAx(1),'[Ca_c_y_t] (nM)','Fontsize',18); % left y-axis
% ylabel(hAx(2),'[Ca_c_e_r] (\muM)','Fontsize',18); % left y-axis
%ylabel(hAx(2),'h-open fraction','Fontsize',18) % right y-axis
% set(get(hAx(2),'Ylabel'),'Position',get(get(hAx(2),'Ylabel'),'Position') + 0.05)
%ylabel(hAx(2),'Release rate (msec^-^1)','Fontsize',18) % right y-axis
%print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/projects/data/astron/figures/ip3rlr/ip3rlr_900nM.jpeg');
