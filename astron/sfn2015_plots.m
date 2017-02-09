% Load data
%d = csvread('/mnt/storage/goofy/DATA/SCRIPTS/CPP/astron/insilico/outfiles/tripartite_test.csv',1,0); % row offset = 1, col offset = 0

% Get column names
%colnames=textscan(fopen('/mnt/storage/goofy/DATA/SCRIPTS/CPP/astron/insili
%co/outfiles/tripartite_test.csv'),'%s',1);fclose('all');colnames = char(colnames{:});colnames = strsplit(colnames,',');

% Start ploting a figure with one inset
set(0,'DefaultFigureWindowStyle','docked');
close all;
% Place axes at (0.1,0.1) with width and height of 0.8
fig = figure;
handaxes1 = axes('position', [0.155 0.15 0.8 0.8]);

% get some other parameters not used for now!
pos = get(fig,'Position');
outer_pos = get(fig,'OuterPosition');
%set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
%pos = get(fig,'Position');
%outer_pos = get(fig,'OuterPosition');
%set(fig,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);

% plotting
%------------------
hold off;
plot(d(:,1),d(:,3)*1E06,'Color',[1,0,0],'LineWidth',3); hold on;
plot(d(:,1),d(:,4)*1E06,'Color',[0,0,1],'LineWidth',2); hold on;    
%plot([5,60,150,300,600,900,1800],[2.1E-0,0.125E-0,0,0,0,0,0],'Color',[1,0,0],'Marker','o','MarkerSize',10,'MarkerFaceColor',[1,0,0]);
%plot([5,60,150,300,600,900,1800],[0.05E-0,1E-0,1.5E-0,1.25E-0,0.75E-0,0.5E-0,0.2E-0],'Color',[0,0,1],'Marker','o','MarkerSize',10,'MarkerFaceColor',[0,0,1]);
%plot([60,70,80,90,100],[-81,-81,-81,-81,-81],'o','MarkerSize',7,'MarkerFaceColor',[0,0,0]);
%title(gca,' Postsynaptic potentials','FontSize',22);
%-------------------

% Display legends
lgd=legend(handaxes1,'ATP','Adenosine','Location','NorthEast');
legend(handaxes1,'boxoff');
set(lgd,'FontSize',14); 

% Set axis range and other stuff
axis(handaxes1,[0,5,0, 20]);  
set(handaxes1,'FontSize',20);
xlabel(handaxes1,'Time (sec)','Fontsize',18);
ylabel(handaxes1,'Concentration (\muM)','Fontsize',18);
set(handaxes1, 'box', 'off');

% Place second set of axes on same plot
handaxes2 = axes('position', [0.7 0.5 0.2 0.2]);hold off;
plot(d(:,1)*1E03,d(:,16)*1E06,'Color',[1,0,0],'LineWidth',2); hold on;
plot(d(:,1)*1E03,d(:,18)*1E06,'Color',[0,0,1],'LineWidth',2); hold on; 
axis(handaxes2,[0,50,0, 20]); 
set(handaxes2,'FontSize',14);
xlabel(handaxes2,'Time (msec)','Fontsize',14);
ylabel(handaxes2,'Concentration (\muM)','Fontsize',14);
set(handaxes2, 'box', 'off');

%print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/fi
%gures/sfn2015/atp_adenosine_conc_synapse.jpeg');
%% Histogram poisson spikes interspike intervals
close all;
fig = figure;
handaxes1 = axes('position', [0.155 0.15 0.8 0.7]);

% get some other parameters not used for now!
pos = get(fig,'Position');
outer_pos = get(fig,'OuterPosition');
%set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
%pos = get(fig,'Position');
%outer_pos = get(fig,'OuterPosition');
%set(fig,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);


% get data
[nspk, mint, miny, maxt, maxy] = count_spikes(d(:,1),d(:,2),0.03);
hist(diff(maxt),15);

% Set axis range and other stuff
axis(handaxes1,[0,3,0, 5]);  
set(handaxes1,'FontSize',20);
title('Histogram interspike intervals');
xlabel(handaxes1,'Interspike interval','Fontsize',18);
ylabel(handaxes1,'Number of spikes','Fontsize',18);
set(handaxes1, 'box', 'off');
print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/figures/sfn2015/interspike_interval_1hz.jpeg');
%% Correlation of spike times versus calcium concentration
% convolve the spike time data to get continous signal
tts = d(:,1);
tts2 = d(d(:,23)==1,1); 
lds = fliplr(tts2/sum(tts2)); % generate linear decay signal
y1 = d(:,23);
y1conv = conv2(y1,lds,'same'); % convolution with FIR 
[acor,lag] = xcorr(d(:,21),d(:,23));
hold off; plot(lag,acor); hold on;
line([0,0],[-0.01,0.06],'LineStyle','-.');
%% For sfn 2015 single action potential probability of release
%fname = '/mnt/storage/goofy/DATA/SCRIPTS/CPP/astron/insilico/outfiles/neuron_1hz_10s_30s/neuron_10hz_fixed';
fname = '/mnt/storage/goofy/DATA/SCRIPTS/CPP/astron/insilico/outfiles/astrocyte/astrocyte_';
for i = 1 : 1
    fname2 = [fname,num2str(i),'.csv'];
    fprintf([fname2,'\n']);
    if (i == 1)
        colnames=textscan(fopen(fname2),'%s',1);fclose('all');colnames = char(colnames{:});colnames = strsplit(colnames,',');
    end
    [d,~] = swallow_csv(fname2,'"',',','\'); 
    gluves_spon_flag(:,i) = d(d(:,1)<=110,strcmp(colnames,'n0gluves_spon_flag') == 1);
    gluves_asyn_flag(:,i) = d(d(:,1)<=110,strcmp(colnames,'n0gluves_asyn_flag') == 1);
    
    atpves_spon_flag(:,i) = d(d(:,1)<=110,strcmp(colnames,'n0atpves_spon_flag') == 1);
    atpves_asyn_flag(:,i) = d(d(:,1)<=110,strcmp(colnames,'n0atpves_asyn_flag') == 1);
end
%%
close all;
set(0,'DefaultFigureWindowStyle','docked');
fig = figure;
ah1 = axes('position', [0.155 0.15 0.7 0.8],'XAxisLocation','bottom','YAxisLocation','right','Color','white');
set(ah1,'FontSize',20);
%set(ah1,'box', off');
axis(ah1,[0,70,0,4]);
% Place second set of axes on same plot
ah2 = axes('position', [0.155 0.15 0.7 0.8],'XAxisLocation','bottom','YAxisLocation','left','Color','none');
set(ah2,'XTick',[]);
set(ah2,'FontSize',20);
axis(ah2,[0,70,0,4]);
for i = 1 : 1
    line(d(d(:,1)<=110,strcmp(colnames,'time') == 1)-30,gluves_spon_flag(:,i)+i-1,'Color',[1,0,0],'LineWidth',2,'Parent',ah1); hold on;
    line(d(d(:,1)<=110,strcmp(colnames,'time') == 1)-30,gluves_asyn_flag(:,i)+i-1,'Color',[1,0,0],'LineWidth',1,'Parent',ah1); hold on;
    line(d(d(:,1)<=110,strcmp(colnames,'time') == 1)-30,atpves_spon_flag(:,i)+i-1,'Color',[0,0,1],'LineWidth',2,'Parent',ah1); hold on;
    line(d(d(:,1)<=110,strcmp(colnames,'time') == 1)-30,atpves_asyn_flag(:,i)+i-1,'Color',[0,0,1],'LineWidth',1,'Parent',ah1); hold on;
    line([0,70],[i-1,i-1],'Color',[1,1,1],'LineWidth',3,'Parent',ah1);
end
line(d(:,strcmp(colnames,'time') == 1)-30,d(:,strcmp(colnames,'n0ca_cyt') == 1)*1E06,'Color',[0,0,0],'LineWidth',2,'Parent',ah2);
set(ah1,'LineWidth',2);
set(ah2,'LineWidth',2);
set(ah1,'YTick',[]);
xlabel(ah1,sprintf('Time (sec)'),'Fontsize',20);
ylabel(ah2,sprintf('Ca^2^+ concentration (\\muM)'),'Fontsize',20);
%set(ah2,'ycolor','blue','FontSize',12,'LineWidth',2,'Color','white')
% Place second set of axes on same plot
ah3 = axes('position', [0.155 0.15 0.7 0.8],'XAxisLocation','bottom','YAxisLocation','right','color','none');
set(ah3,'FontSize',20,'LineWidth',2,'YTick',[1,2,3,4,5,6,7,8,9,10],'ycolor','r');
set(ah3,'XTick',[]);
axis(ah3,[0,70,0,4]);
ylabel(ah3,sprintf('Trials'),'Fontsize',20,'Color','r');
lgd=legend(ah1,'Spon glu','ASyn glu','Spon ATP','Asyn ATP','Location','NorthEast');
legend(ah1,'boxoff');
set(lgd,'FontSize',14); 
%print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/figures/sfn2015/astrocyte_single_atpves2.jpeg');
%% Print the calcium/ip3 concentration of astrocyte
close all;
set(0,'DefaultFigureWindowStyle','docked');
fig = figure;
ah1 = axes('position', [0.165 0.15 0.67 0.8],'XAxisLocation','bottom','YAxisLocation','left','Color','white');
set(ah1,'FontSize',20,'LineWidth',2,'ycolor',[0,0,0]);
% Place second set of axes on same plot
ah2 = axes('position', [0.165 0.15 0.67 0.8],'XAxisLocation','bottom','YAxisLocation','right','Color','none');
set(ah2,'XTick',[]);
set(ah2,'FontSize',20,'LineWidth',2,'ycolor',[0,0,1]);
line(d(:,1)-10,d(:,strcmp(colnames,'n0ca_cyt') == 1)*1E06,'Color',[0.5,0.5,0.5],'LineWidth',2,'Parent',ah1); hold on;
line(d(:,1)-10,d(:,strcmp(colnames,'n0ip3_cyt') == 1)*1E06,'Color',[0,0,1],'LineWidth',2,'Parent',ah2); hold on;
%line(d(:,1)-10,d(:,strcmp(colnames,'n0a1r_vgcc_fraction') == 1),'Color',[1,0,0],'LineWidth',2,'Parent',ah2); hold on;
line(d(:,1)-10,d(:,strcmp(colnames,'n0gluves_spon_flag') == 1)/20,'Color',[0,1,0],'LineWidth',2,'Parent',ah2); hold on;
line(d(:,1)-10,d(:,strcmp(colnames,'n0gluves_syn_flag') == 1)/20,'Color',[1,0,0],'LineWidth',2,'Parent',ah2); hold on;
line(d(:,1)-10,d(:,strcmp(colnames,'n0gluves_asyn_flag') == 1)/20,'Color',[0,0,1],'LineWidth',2,'Parent',ah2); hold on;
%line(d(:,1)-10,-d(:,strcmp(colnames,'n1atpves_spon_flag') == 1),'Color',[0,0.3,0.8],'LineWidth',2,'Parent',ah2); hold on;
%line(d(:,1)-10,-d(:,strcmp(colnames,'n1atpves_asyn_flag') == 1),'Color',[0,0.7,0.8],'LineWidth',2,'Parent',ah2); hold on;
%line(d(:,1)-10,d(:,strcmp(colnames,'n0a1r_vgcc_fraction') == 1),'Color',[0.8,0,0.8],'LineWidth',2,'Parent',ah2);hold on;
%line(d(:,1)-15,d(:,strcmp(colnames,'n0ip3_cyt') == 1)*1E06,'Color',[1,0,0],'LineWidth',2,'Parent',ah2); hold on;
%line(d(:,1)-15,d(:,strcmp(colnames,'n0ca_er') == 1)*1E03,'Color',[0,0,1],'LineWidth',2,'Parent',ah2); hold on;
axis(ah1,[0,180,0,12]);
axis(ah2,[0,180,0,0.5]);
xlabel(ah1,sprintf('Time (sec)'),'Fontsize',20);
ylabel(ah1,sprintf('Concentration (\\muM)'),'Fontsize',20);
%ylabel(ah2,sprintf('Concentration (\\muM)'),'Fontsize',20);
xlabel(ah1,sprintf('Time (sec)'),'Fontsize',20);
lgd1=legend(ah1,sprintf('Ca_c_y_t^2^+'),'Location','NorthWest');
lgd2=legend(ah2,'IP_3','Spon rel','Syn rel', 'Asyn rel','Location','NorthEast');
legend(ah1,'boxoff');
legend(ah2,'boxoff');
set(lgd1,'FontSize',14);
set(lgd2,'FontSize',14); 
%lgd2=legend(ah2,'Ca_e_r^2^+','Location','NorthEest');
%set(ah1,'LineWidth',1,'YTick',[0,50,100,150,200,250],'ycolor','b')
%set(gca,'Position',[0.13,0.71,0.77,0.2]);%set(ah1,'box', off');
%get(gca,'Position');

% Place second set of axes on same plot
%ah3 = axes('position', [0.5 0.4 0.2 0.2]);hold off;
%ah4 = axes('position', [0.5 0.4 0.2 0.2]);hold off;
%line(d(:,1)-10,d(:,strcmp(colnames,'n1ca_cyt') == 1)*1E06,'Color',[0.5,0.5,0.5],'LineWidth',2,'Parent',ah3); hold on;
%line(d(:,1)-10,d(:,strcmp(colnames,'n1ip3_cyt') == 1)*1E06,'Color',[0,0,1],'LineWidth',2,'Parent',ah2); hold on;
%line(d(:,1)-10,d(:,strcmp(colnames,'n1gluves_rel_flag') == 1),'Color',[1,0,1],'LineWidth',2,'Parent',ah3); hold on;
%line(d(:,1)-10,-d(:,strcmp(colnames,'n1atpves_rel_flag') == 1),'Color',[0,1,1],'LineWidth',2,'Parent',ah3); hold on;
%axis(ah3,[47,49.5,-1,5]); 
%axis(ah4,[50,60,0,5]); 
%set(ah3,'FontSize',14);
%set(ah3,'XTick',[]);
%xlabel(ah3,'Time (sec)','Fontsize',14);
%ylabel(ah3,'Concentration (\muM)','Fontsize',14);
%set(ah3, 'box', 'off');
print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/figures/sfn2015/neuron_1hzlong_1.jpeg');
%-------------------
%% Print the atp/adenosine concentration of astrocyte 
close all;
set(0,'DefaultFigureWindowStyle','docked');
fig = figure;
ah1 = axes('position', [0.165 0.15 0.67 0.8],'XAxisLocation','bottom','YAxisLocation','left','Color','white');
set(ah1,'FontSize',20,'LineWidth',3);
% Place second set of axes on same plot
ah2 = axes('position', [0.165 0.15 0.67 0.8],'XAxisLocation','bottom','YAxisLocation','right','Color','none');
set(ah2,'XTick',[]);
set(ah2,'FontSize',20,'LineWidth',3,'ycolor',[1,0,0]);
line(d(:,1),d(:,strcmp(colnames,'n0ca_cyt') == 1)*1E09,'Color',[0,0,0],'LineWidth',3,'Parent',ah1); hold on;
line(d(:,1),d(:,strcmp(colnames,'n0ip3_cyt') == 1)*1E09,'Color',[1,0,0],'LineWidth',3,'Parent',ah2); hold on;
axis(ah1,[80,300,0.0,600]);
axis(ah2,[80,300,90.0,600]);
%xlabel(gca,sprintf('Time (sec)'),'Fontsize',20);
ylabel(ah1,sprintf('Concentration (\\muM)'),'Fontsize',20);
ylabel(ah2,sprintf('Concentration (mM)'),'Fontsize',20);
xlabel(ah1,sprintf('Time (sec)'),'Fontsize',20);
lgd1=legend(ah1,'ATP','Location','NorthWest');
legend(ah1,'boxoff');
set(lgd1,'FontSize',16);
lgd2=legend(ah2,'IP_3','Location','NorthEast');legend(ah2,'boxoff');
set(lgd2,'FontSize',16);
% set(ah1,'LineWidth',1,'YTick',[0,100,200,300,400],'ycolor','b')
% set(ah2,'LineWidth',1,'YTick',[150,200,300],'ycolor','b')
% set(gca,'Position',[0.13,0.71,0.77,0.2]);%set(ah1,'box', off');
%get(gca,'Position');
fname = '/mnt/storage/goofy/data/writing/Book_chapter/figures/presynapse_p2y_ATP10microM.jpeg';
set(gcf,'PaperPositionMode','auto')
print(gcf,'-djpeg',['-r','300'],fname);
%% Print the calcium/ip3 concentration of astrocyte
% close all;
% set(0,'DefaultFigureWindowStyle','docked');
% fig = subplot(2,1,1);
% %fig = figure;
% %ah1 = axes('position', [0.2 0.15 0.7 0.8],'XAxisLocation','bottom','YAxisLocation','left','Color','white');
% %set(ah1,'FontSize',20);
% % Place second set of axes on same plot
% %ah2 = axes('position', [0.155 0.15 0.7 0.8],'XAxisLocation','bottom','YAxisLocation','right','Color','none');
% %set(gca,'XTick',[]);
% set(gca,'FontSize',20);
% %set(gca,'Position',[0 0.15 0.8/2 1]);
% plot(d(:,1),d(:,strcmp(colnames,'s0glu_ext)') == 1)*1E06,'Color',[1,0,0],'LineWidth',2); hold on;
% axis(gca,[0,200,0,100]);
% %xlabel(gca,sprintf('Time (sec)'),'Fontsize',20);
% ylabel(ah1,sprintf('[Ca^2^+]_e_r (\\muM)'),'Fontsize',20);
% xlabel(ah1,sprintf('Time (sec)'),'Fontsize',20);
% set(gca,'LineWidth',1,'YTick',[0,50,100,150,200,250],'ycolor','b')
% %set(gca,'Position',[0.13,0.71,0.77,0.2]);%set(ah1,'box', off');
% %get(gca,'Position');
% %-------------------
% subplot(2,1,2);
% set(gca,'FontSize',20);
% set(gca,'Position',[0.18 0.15 0.75 0.8/3.2]);
% plot(d(:,1),d(:,strcmp(colnames,'s0_ext') == 1)*1E6,'Color',[0,0,1],'LineWidth',2); hold on;
% axis(gca,[0,200,0,100]);
% xlabel(gca,sprintf('Time (sec)'),'Fontsize',20);
% ylabel(gca,sprintf('Glutamate (\\muM)'),'Fontsize',20);
% set(gca,'LineWidth',1,'YTick',[0,100],'ycolor','b');%set(ah1,'box', off');
% %set(ah2,'LineWidth',2,'YTick',[0,0.5,1],'ycolor','b');
%get(gca,'Position')
%-------------------
% subplot(3,1,3);
% set(gca,'FontSize',20);
% %set(gca,'Position',[0.18 0.15 0.75 0.8/2.2]);
% plot(d(:,1),d(:,strcmp(colnames,'s0glu_ext') == 1)*1E6,'Color',[0,0,1],'LineWidth',2); hold on;
% axis(gca,[0,200,0,100]);
% xlabel(gca,sprintf('Time (sec)'),'Fontsize',20);
% ylabel(gca,sprintf('ATP (\\muM)'),'Fontsize',20);
% set(gca,'LineWidth',1,'YTick',[0,100],'ycolor','b');%set(ah1,'box', off');
% %set(ah2,'LineWidth',2,'YTick',[0,0.5,1],'ycolor','b');
%print(gcf,'-djpeg',['-r','300'],'/mnt/storage/goofy/DATA/IISER_Job/data/figures/sfn2015/astrocyte_release_3.jpeg');