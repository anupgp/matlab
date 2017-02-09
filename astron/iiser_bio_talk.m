%% 
close all;
%hold on;
%clear all;
set(0,'DefaultFigureWindowStyle','docked')
%dd = load('test_det_model_calbindin_run');
set(gca,'FontSize',20);
%fig_size = [0.4,0.4,20,22]

%scale = 1;
%pos(2) = pos(2) + scale * pos(4);
%pos(4) = (1 - scale) * pos(4);
%set(gca,'Position',pos);
pos = get(gca,'Position');
outer_pos = get(gca,'OuterPosition');
set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
%set(gcf,'PaperPosition',fig_size);
%plot((dd(:,1)),(dd(:,2)),'Color','blue','Marker','o','MarkerSize',7);
%plot(dd(:,1),(dd(:,2) ),'Color','red'); hold on;
%d = dd(:,:,1);
%d(d(:,9) == -1,9) = 0;
%d(d(:,9) == -1,9) = 0;
%semilogy(dd2(:,1),dd2(:,9),'Color','blue','LineWidth',2);
%hold on;
%semilogy(dd2(:,1),dd2(:,3)*1E06,'Color','red','LineWidth',2);
grid on;
%plot((dd(:,1)),(dd(:,2)),'Color','blue');
[ax,h1,h2] = plotyy(...
    d(:,1),d(:,~cellfun(@isempty,strfind(colnames,'n0ca_cyt')))*1e9,...
    d(:,1),d(:,~cellfun(@isempty,strfind(colnames,'n0ip3r_lr_h'))).^3)
axis(ax(1),[0,500,0,800]);
axis(ax(2),[0,500,0,1]);
set(h1,'color','blue','LineWidth',2);
set(h2,'color','red','LineWidth',2)
set(ax(1),'ycolor','blue','FontSize',22,'LineWidth',2)
set(ax(2),'ycolor','red','FontSize',22,'LineWidth',2)
%title(sprintf('Testing Ryanodine receptor'),'Fontsize',16);
%ylabel(sprintf('Voltage (mV)','Fontsize',18));
%ylabel('[Ca_c_y_t^2^+] \muM','Fontsize',18);
ylabel(ax(1),sprintf('Calcium (\\muM)'),'Fontsize',22,'Color','blue');
ylabel(ax(2),sprintf('IP_3 (nM)'),'Fontsize',22,'Color','red');
xlabel(sprintf('Time (sec)'),'Fontsize',22);
%%
print(gcf,'-dpng',['-r','300'],'/mnt/storage/goofy/data/figures/book_chapter/presynaptic_10atp_calcium_ip3.png');
%%
close all;
%hold on;
%clear all;
set(0,'DefaultFigureWindowStyle','docked')
%dd = load('test_det_model_calbindin_run');
set(gca,'FontSize',20);
%fig_size = [0.4,0.4,20,22]
pos = get(gca,'Position');
%scale = 1;
%pos(2) = pos(2) + scale * pos(4);
%pos(4) = (1 - scale) * pos(4);
%set(gca,'Position',pos);
outer_pos = get(gca,'OuterPosition');
set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
%set(gcf,'PaperPosition',fig_size);
%plot((dd(:,1)),(dd(:,2)),'Color','blue','Marker','o','MarkerSize',7);
%plot(dd(:,1),(dd(:,2) ),'Color','red'); hold on;
%d = dd(:,:,1);
%d(d(:,9) == -1,9) = 0;
%d(d(:,9) == -1,9) = 0;
%semilogy(dd2(:,1),dd2(:,9),'Color','blue','LineWidth',2);
%hold on;
%semilogy(dd2(:,1),dd2(:,3)*1E06,'Color','red','LineWidth',2);
grid on;
%plot((dd(:,1)),(dd(:,2)),'Color','blue');
%[ax,h1,h2] = plotyy(dd(:,1,1),dd(:,2,1)*1E03,dd(:,1,1),dd(:,3,1)*1E06,'plot')
%axis(ax(1),[0.995,1.01,-85,+40]);
%axis(ax(2),[0.995   ,1.01,-0.5,11]);
set(h1,'color','blue','LineWidth',2);
set(h2,'color','red','LineWidth',2)
set(ax(1),'ycolor','blue','FontSize',24,'LineWidth',2)
set(ax(2),'ycolor','red','FontSize',24,'LineWidth',2)
%title(sprintf('Testing Ryanodine receptor'),'Fontsize',16);
%ylabel(sprintf('Voltage (mV)','Fontsize',18));
%ylabel('[Ca_c_y_t^2^+] \muM','Fontsize',18);
ylabel(ax(1),sprintf('Membrane potential (mV)'),'Fontsize',26,'Color','blue');
ylabel(ax(2),sprintf('Ca^2^+ concentration (\\muM)'),'Fontsize',26,'Color','red');
xlabel(sprintf('Time (sec)'),'Fontsize',26);
%print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/figures/iiser_bio/iiser_bio_fig7.jpeg');
%%
hold off
close all;
%hold on;
%clear all;
set(0,'DefaultFigureWindowStyle','docked')
%dd = load('test_det_model_calbindin_run');
set(gca,'FontSize',20);
%fig_size = [0.4,0.4,20,22]
pos = get(gca,'Position');
%scale = 1;
%pos(2) = pos(2) + scale * pos(4);
%pos(4) = (1 - scale) * pos(4);
%set(gca,'Position',pos);
outer_pos = get(gca,'OuterPosition');
set(gca,'OuterPosition',[outer_pos(1) + 0.03, outer_pos(2) + 0.05, outer_pos(3) - 0.08, outer_pos(4) - 0.05]);
%set(gcf,'PaperPosition',fig_size);
%plot((dd(:,1)),(dd(:,2)),'Color','blue','Marker','o','MarkerSize',7);
%plot(dd(:,1),(dd(:,2) ),'Color','red'); hold on;
%d = dd(:,:,1);
%d(d(:,9) == -1,9) = 0;
%d(d(:,9) == -1,9) = 0;
%semilogy(dd2(:,1),dd2(:,9),'Color','blue','LineWidth',2);
%hold on;
%semilogy(dd2(:,1),dd2(:,3)*1E06,'Color','red','LineWidth',2);
grid on;
[ax,h1,h2] = plotyy(d(:,1),d(:,8),d(:,1),d(:,11),'plot')
%plot((d(:,1)),(d(:,5)*1E09),'Color','blue','LineWidth',2); hold on;
%plot((d(:,1)),(d(:,9)+100),'Color','red','LineWidth',2);
%plot((d(:,1)),(d(:,12)+100),'Color','black','LineWidth',2);
%axis(ax(1),[1,1.4,0,2]);
%axis(ax(2),[1,1.4,0,2]);
set(h1,'color','blue','LineWidth',2);
set(h2,'color','red','LineWidth',2)
set(ax(1),'ycolor','blue','FontSize',20,'LineWidth',2)
set(ax(2),'ycolor','red','FontSize',20,'LineWidth',2)
%title(sprintf('Testing Ryanodine receptor'),'Fontsize',16);
%ylabel(sprintf('Voltage (mV)','Fontsize',18));
%ylabel('[Ca_c_y_t^2^+] \muM','Fontsize',18);
ylabel(ax(1),sprintf('Release rate _G_l_u(1/s)'),'Fontsize',26,'Color','blue');
ylabel(ax(2),sprintf('Release rate _A_T_P(1/s)'),'Fontsize',26,'Color','red');
%ylabel(ax(2),sprintf('\nCa_E_R^2^+ concentration (\\muM)'),'Fontsize',26,'Color','red');
xlabel(sprintf('Time (sec)'),'Fontsize',26);
%print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/figures/iiser_bio/iiser_bio_fig12.jpeg');
