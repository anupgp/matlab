format('long');
%!synclient HorizTwoFingerScroll=0
set(0,'DefaultFigureWindowStyle','docked'); %docked
%%
close all;
%hold on;
%clear all;
set(0,'DefaultFigureWindowStyle','docked')
%dd = load('test_det_model_calbindin_run');
set(gca,'FontSize',20);
%plot((dd(:,1)),(dd(:,2)),'Color','blue','Marker','o','MarkerSize',7);
%plot(d(:,1),(d(:,3)*1E09 ),'Color','red','LineWidth',2); hold on;
%plot(d(:,1),(d(:,6) *1E07 ),'Color','blue');
[ax,h1,h2] = plotyy(d(:,1),d(:,3)*1E09,d(:,1),d(:,4)*1E06);
axis(ax(1),[0,300,0,800]);
axis(ax(2),[0,300,0,500]);

%plot(log10(d(:,3)),d(:,7),'Color','blue');
box off;
grid on;
%plot((dd(:,1)),(dd(:,2)),'Color',''blue');
axis([0,300,0,800]);
title(sprintf('Testing P2Y receptor-mediated signaling in Astrocytes'),'Fontsize',16);
xlabel(sprintf('Time (sec)','Fontsize',18));
ylabel('[Ca_c_y_t^2^+] nM','Fontsize',18);
%ylabel('[Ca_c_y_t^2^+] \muM','Fontsize',18);
%ylabel('Open probability','Fontsize',18);
%print(gcf,'-djpeg',['-r','300'],'~/goofy/DATA/IISER_Job/data/figures/Astrocyte_P2YR_testing.jpeg');
%% Check the rate constant unit conversion for VGCC pre-synaptic Ca channel
a1 = @(V) 4.04E03 * exp(V/49.14E-03);
a2 = @(V) 6.70 * exp(V/42.08E-03);
a3 = @(V) 4.39E03 * exp(V/55.31E-03);
a4 = @(V) 17.33E03 * exp(V/26.55E-03);

b1 = @(V) 2.88 * exp(-V/49.14E-03);
b2 = @(V) 6.30E03 * exp(-V/42.08E-03);
b3 = @(V) 8.16E03 * exp(-V/55.31E-03);
b4 = @(V) 1.84E03 * exp(-V/26.55E-03);

V = -80E-03:1E-03:80E-03;
plot(V,b1(V));
%%
% Boltzmann f unction for steady state activation curve   
boltz = @(V)1 ./ (1+exp( (-3.9E-03 - V)/7.1E-03));
% I–V relationship with a modified Goldman – Hodgkin –Katz equation
GHK = @(V)(-3.003E-09 .* V .*( (0.3933-exp(-V /80.36E-03)) ./(1-exp(V/80.36E-03))) .*boltz(V));
volts = -80.03E-03:10E-03:80E-03;
plot(volts,GHK(volts) ./ volts);

%%
nis_colnames = char(nis_colnames{1});
colid=4;
% subplot(1,3,1,'Align');
plot(nis_ca(:,1),nis_ca(:,2));
xlabel(nis_colnames(1,:),'Fontsize',14);
ylabel(colnames(1,1),'Fontsize',14);
hold on;
subplot(1,3,2);
plot(nis_ca(:,1),nis_ca(:,3));
xlabel(nis_colnames(1,:),'Fontsize',14);
ylabel(colnames(1,2),'Fontsize',14);
subplot(1,3,3);
plot(nis_ca(:,1),nis_ca(:,4));
xlabel(nis_colnames(1,:),'Fontsize',14);
ylabel(colnames(1,3),'Fontsize',14);
set(gca,'FontSize',12);
% Fitting ---------
%t = nis_ca(:,1);
t = 0 : 1E-06 : 0.01;
a = 1700; % starting value 4
b = 3; % how long the initial value 2.51
c = 300E-06; % decay time 200E-06
d = 50; % final value 0
delay = 0.0022; % delay 0.0022
y = d + ( (a - d) ./ (1 + (abs(t-delay)/c).^b) );
%plot(t,round(y),'color','black','Linewidth',2);
%%
%close all;
% Load Nishant's data on MCell sim
nis_glu = load('data/data_Nishant/glu');
nis_ampar = load('data/data_Nishant/ampa');
% Load gillespie_stochastic sim data on indivdual AMPARs (130)
%ind_ampar = load('gillespie_ampar/avg_130_open_ampar_individual');
% Load gillespie_stochastic sim data on ensemble AMPARs (130)
%ens_ampar = load('gillespie_ampar/avg_130_open_ampar_ensemble');
% Load gillespie_stochastic sim data on ensemble Glutamate (300)
%ens_glu = load('gillespie_ampar/avg_300_glutamate_ensemble');
%figure;
hold off;
plot(nis_glu(:,1)+0.2,nis_glu(:,4),'color','red','Linewidth',1);
plot(nis_ampar(:,1)+0.2,nis_ampar(:,8),'color',[ 0,1,1],'Linewidth',1);
%plot(ens_glu(:,1),ens_glu(:,2),'color','black','Linewidth',2);
%plot(ind_ampar(:,1),ind_ampar(:,2),'color',[0.5,0.5,0.5],'Linewidth',2);
%plot(ens_ampar(:,1),ens_ampar(:,2),'color','blue','Linewidth',1);
axis([0.18, 0.3, 0, 300]);
% Fitting ---------
t = 0:(1E-06):0.1;
a = 300; % starting value
b = 2; % how long the initial value
c = 185E-06; % decay time
d = 0; % final value
y = d + ( (a - d) ./ (1 + ((t-2.0E-05)/c).^b) );
plot(t,y,'color','black','Linewidth',2);
%%
close all
incr = 100000;
i_init = 0;
for i = 1:17
    plot(dd(((i-1)*incr+1):(i)*incr,1),dd(((i-1)*incr+1):(i)*incr,4));
    hold on;
    pause;
end
%% plotting hh_pre + vgcc + buffers
clear all
close all;
set(0,'DefaultFigureWindowStyle','docked')
dd=load('main_current.out');
plot(dd(:,1),dd(:,5),'color','black','LineWidth',2);
hold on;
plot(dd(:,1),dd(:,7)*1E-03,'color','red','LineWidth',2);
%plot(dd(:,1),ones(size(dd,1),1)*-70);
%hold on; plot(dd(:,1),dd(:,4),'color','blue','LineWidth',2);

%%
% checking the pre-synaptic HH
% Na channel
close all;
v = (-140:10:70);
alpha_m = - 0.1 * (v  + 45) ./ (exp(-(v + 45) / 10) - 1);
beta_m = 4 * exp((- v + 70) / 18);
alpha_h = 0.07 * exp(-(v + 70)/ 20);
beta_h = 1 ./ (exp(-(v + 40) / 10) + 1);
alpha_n = -0.01 * (v + 60.33) ./ (exp(-(v +  60.33) / 10) - 1);
beta_n = 0.125 * exp(-(v + 70) / 80);
%plot(v,alpha_n,'color','red');
plot(v,alpha_h,'color','green');
%%
V = (-140:10:70) * 1E-03;
Alpha_m = - 0.1E03 * (V  + 45E-03) ./ (exp(-(V + 45E-03) / 10E-03) - 1);
Beta_m = 4 * exp((- V + 70E-03) / 18E-03);
Alpha_h = 0.07 * exp(-(V + 70E-03)/ 20E-03);
Beta_h = 1 ./ (exp(-(V + 40E-03) / 10E-03) + 1);
Alpha_n = -0.01E03 * (V + 60.33E-03) ./ (exp(-(V +  60.33E-03) / 10E-03) - 1);
Beta_n = 0.125 * exp(-(V + 70E-03) / 80E-03);
%plot(V,Alpha_n,'color','red');
plot(V,Alpha_h,'color','green');
%%
xlabel('Time (sec)','FontSize',20);
%ylabel('Basal release rate (1/ms) ','FontSize',20);
legend('Probability of release','Current injec','Membrane voltage (0.08 V - 1/5)','Number of Calcium ions #','Location','NorthEast');
set(gca,'FontSize',14);
%text(0.15,1.7E-03,strcat('Pr =  ',num2str(sum(test(:,2:5)),4)),'FontSize',12);
%text(0.15,1.1E-03,'V = 0.1E-06');
%print(gcf,'-djpeg',['-r','300'],'Nishant_MCELL_sim_presynaptic_Calcium.jpeg');
%% load ca_sensor_gillespie_class_vector_test- all states
clear all;
close all;
%fname = '/mnt/storage/goofy/DATA/SCRIPTS/CPP/Astron/ca_sensor_gillespie_class_vector_test_runs/ca_sensor_gillespie_class_vector_test_run_4001';
%fname = '/mnt/storage/goofy/DATA/SCRIPTS/CPP/Astron/ca_sensor_gillespie_class_vector_test_run';
fname = 'main_current_run';
dd = load(fname);
close all;
fh=stackplot(dd,size(dd));
%print(fh,'-djpeg',['-r','300'],'ca_sensor1_conCaIn5.jpeg');
%%
%fname_prefix = '/mnt/storage/goofy/DATA/SCRIPTS/CPP/Astron/ca_sensor_gillespie_class_vector_test_runs/ca_sensor_gillespie_class_vector_test_run';
fname_prefix = '/mnt/storage/goofy/DATA/SCRIPTS/CPP/Astron/main_current_runs/main_current_run';
test=plot_avg_release_rate(fname_prefix,10000,1E-04);
%load('/mnt/storage/goofy/DATA/SCRIPTS/CPP/Astron/ca_sensor_gillespie_class_vector_test_runs/ca_sensor_10000runs_matlab_vars')
%%
close all
plot(test(2:end,1),diff(test(:,11)),'LineWidth',2,'Color',[0.5, 0.5 0.5])
hold on;
plot(test(:,1),test(:,2)/70,'LineWidth',2,'Color','red')
plot(test(:,1),(test(:,3)+0.08)/5,'LineWidth',2,'Color','magenta')
plot(test(:,1),test(:,6)/100,'LineWidth',1,'Color','red')
%% load Nishant Calcium channel data
set(0,'DefaultFigureWindowStyle','docked')
%clear all;
close all;
%nis_ca = dlmread('data_Nishant/ca.dat','',1,0);
nis_ca = csvread('/mnt/storage/goofy/DATA/IISER_Job/data_others/data_Nishant/noER_Calcium_Profile.csv',1,0); % row offset = 1, col offset = 0
%hold on;
plot(nis_ca(:,1),nis_ca(:,5));
%nis_file = 'data_Nishant/ca.dat';
%nis_fid = fopen(nis_file);
%nis_colnames = textscan(nis_fid,'%s',4);
%colnames = {'Ca con. at AZ (micro M)','No. of Ca ions at AZ',' No. of Ca ions at presynaptic terminal'}; 
%fclose(nis_fid);
%%
clear all;
dd = load('test_stoch_euler_run.txt'); 
%close all;
%plot(dd(:,9)*1E12,'blue','LineWidth',2); hold on;
%plot(dd(:,2)*1E3,'black');
%subplot(2,1,1);
plot(dd(:,1),dd(:,5),'red');
%hold on;
%plot(dd(:,1),(dd(:,6))+0.08,'blue');
%subplot(2,1,2);
%plot(dd(:,1),dd(:,2),'blue');
%volts = unique(dd(:,2));
%for i = 1 : 11
%Itail(i) = mean(dd((7000:7900)+(20000*(i-1)),9));
%end;
%%
close all;
clearvars -except dd
hold off;
rowstep = round(2/dd(2,1)-dd(1,1));
start_index = 3;
stop_index = 3;
cacon = unique(dd(:,2));
%colorbar('YTickLabel',cacon);legend(num2str(cacon(start_index:stop_index)),'Location','Best');
colormap = hsv(stop_index-start_index+1);
index = 0;
for i = start_index : stop_index
   index = index+1;
   row1 = ((i-1)*rowstep) +1 ;
   row2 = i * rowstep;
   plot(dd(row1:row2,1),dd(row1:row2,3),'Color','blue','Linewidth',3); 
   hold on;
   plot(dd(row1:row2,1),dd(row1:row2,4),'Color','red','Linewidth',3); 
   plot(dd(row1:row2,1),dd(row1:row2,5),'Color','green','Linewidth',3); 
   plot(dd(row1:row2,1),dd(row1:row2,6),'Color','black','Linewidth',3);
   %plot(dd(row1:row2,1),(dd(row1:row2,3)),'Color',colormap(index,:),'Linewidth',3); 
   %plot(dd(row1:row2,1),dd(row1:row2,6),'Color',colormap(index,:),'Linewidth',3); 
   %plot(dd(row1:row2,1),dd(row1:row2,6),'Linewidth',3); 
   %text(0.45,max(dd(row1:row2,6)),strcat(num2str(dd(row2,2)),' M'),'FontSize',15)
   hold on;
end
hold off;
%legend(num2str(cacon(start_index:stop_index)),'Location','Best');
%legend('Spon','Syn','Asyn','Total','Location','East');
%axis([0.1,0.5,1E-03,1E-04]);    
%set(gca,'FontSize',22);
%xlabel('Time (sec)','Fontsize',22);
%ylabel('Cum no. of rel. vesicles','Fontsize',26);
%ylabel('Release rate (msec)','Fontsize',26);
%print(gcf,'-djpeg',['-r','100'],'Suhitha_Ca_sensor_model_cum_ves_num_400-1000nM.jpeg');
%% Averaged (binned plots)
%close all;
%hold off;
%bin_size=1E-03;
%big_rowstep = round(2/dd(2,1)-dd(1,1));
%start_index = 3;
%stop_index = 3;
%dd2=bin_mat(dd(((start_index-1)*big_rowstep) + 1: (stop_index*big_rowstep),:),bin_size);
%d=dd2;
%cacon = unique(d(:,2));
%colorbar('YTickLabel',cacon);legend(num2str(cacon(start_index:stop_index)),'Location','Best');
colormap = hsv(5);
index = 0;
for i = 1 : 4
    plot(log10(ip3r_end(:,2,i)),ip3r_end(:,5,i).^3,'LineWidth',2,'Color',colormap(i,:),'Marker','o','DisplayName',strcat('[IP3] = ',num2str(ip3r_end(1,4,i)*1e06),'\muM'));
   hold on;
end
hold off;
lgd=legend(gca,'show','Location','NorthEast')
%lgd=legend(num2str(ip3r_end(1,2,i)),'\muM','Location','NorthWest');
set(lgd,'FontSize',14);     
%legend(num2str(cacon(start_index:stop_index)),'Location','Best');

axis([-8, -5,0, 0.7]);    
set(gca,'FontSize',18);
xlabel('log10 [Ca^2^+]','Fontsize',18);
%ylabel('Cum no. of rel. vesicles','Fontsize',26);
ylabel('Open fraction','Fontsize',18);
title('Single IP3R kinetics: Ullah-Jung model','FontSize',18)
%print(gcf,'-djpeg',['-r','300'],'ipclose all;3_receptor_kinetics_ullah_jung_Calcium_vs_open_fraction.jpeg');
%% Matlab read csv file 
set(0,'DefaultFigureWindowStyle','docked');
% Load data
%d = csvread('/mnt/storage/goofy/data/iiser/outfiles/tripartite/test.csv',1,0); % row offset = 1, col offset = 0
%[d,~] = swallow_csv('/home/anup/goofy/data/iiser/outfiles/testing/presynaptic_1hz_0atp20.csv','"',',','\'); % row offset = 1, col offset = 0
colnames = textscan(fopen('/home/anup/goofy/data/iiser/outfiles/testing/presynaptic_1hz_0atp20.csv'),'%s',1);fclose('all');
colnames = char(colnames{:});colnames = strsplit(colnames,',');
% Start ploting
% close all;
% Place axes at (0.1,0.1) with width and height of 0.8
fig = figure;
handaxes1 = axes('position', [0.155 0.15 0.8 0.8]);
%pos = get(fig,'Position');outer_pos = get(fig,'OuterPosition');
%set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
pos = get(fig,'Position');
outer_pos = get(fig,'OuterPosition');
% hold off;
% find(~cellfun(@isempty,strfind(colnames,'n0a1r_vgcc_frac')))
plotcolnames = {'n0V'};scales_vector = 1e0;
plotcolnames = [plotcolnames,'n0ca_cyt'];scales_vector = [scales_vector,1e06];
plotcolnames = [plotcolnames,'s0atp_ext'];scales_vector = [scales_vector,1e06];
plotcolnames = [plotcolnames,'s0ado_ext'];scales_vector = [scales_vector,1e06];
plotcolnames = [plotcolnames,'n0a1r_vgcc_frac'];scales_vector = [scales_vector,10];
plotcolnames = [plotcolnames,'n0gluves_spon_flag'];scales_vector = [scales_vector,2];
plotcolnames = [plotcolnames,'n0gluves_syn_flag'];scales_vector = [scales_vector,2];
plotcolnames = [plotcolnames,'n0gluves_asyn_flag'];scales_vector = [scales_vector,2];
plotcolnames = [plotcolnames,'n0gluves_rrp'];scales_vector = [scales_vector,1];
plotbycolumn(fig,d,colnames,plotcolnames,scales_vector,1);
%title(gca,' Postsynaptic potentials','FontSize',22);
%axis(gca,[0,max(d(:,1)),0,500])
% hold off;
%% % Load Domercq data on ATP-induced vesicular release from astrocytes
reldomercq = load('/home/anup/goofy/projects/data/astron/data_others/astrocyte_release/atprelease_domercq.mat');
reldomercq = struct2cell(reldomercq);
reldomercq = reldomercq{1};
%reldomercq = reldomercq([1,3:21,23:end],:)
hold off;
reldomercq(:,1) = reldomercq(:,1)- 5.32;
plot(reldomercq(:,1),reldomercq(:,2));
%%
hold on;
%plot(reldomercq(reldomercq(:,1)>=0,1),fh_1expd(reldomercq(reldomercq(:,1)>=0,1),fit_1expd),'red')
hold on;
plot(reldomercq(reldomercq(:,1)>=0,1),fh_2expd(reldomercq(reldomercq(:,1)>=0,1),fit_2expd),'cyan')
%% Curvefitting of my data
options = optimset('Display','off','MaxFunEvals',5000,'MaxIter',50000, 'TolFun',1e-10,'TolX',1e-10);
hold off;
%[bins_maxt,avg_hmaxt] = generate_histogram_plot(dd(:,[1,2,11,12,13,14,15,16],:),[120e-9,0.5,0.5,0.5,0.5,0.5,0.5],0,100,50e-3,7);
%hold on;
xf = bins_maxt(bins_maxt>=50.7 & bins_maxt<=55) - 50.7;
yf = avg_hmaxt(bins_maxt>=50.7 & bins_maxt<=55,7);
yf = smooth(yf,3)
plot(xf,yf)
plot(bins_maxt- 50.65,avg_hmaxt(:,7));
fh_2expd = @(x,q) q(1) + q(2)*exp(-x./q(3)) + q(4)*exp(-x./q(5));
efh_2expd = @(q,x,y) sum((y(:)-fh_2expd(x(:),q)).^2);
lb_2expd = [0, 0, 0, 0, 0];
ub_2expd = [100, 100, 100, 100, 100];
init_2expd = [0, 0, 0, 0, 0]; % [offset scale tau]
[mydat_f2expd, ~, ~, ~] = fminsearchbnd(efh_2expd,init_2expd,lb_2expd,ub_2expd,options,xf,yf);
hold on;
plot(xf,fh_2expd(xf,mydat_f2expd),'cyan')
%% Curve fitting
options = optimset('Display','off','MaxFunEvals',5000,'MaxIter',50000, 'TolFun',1e-10,'TolX',1e-10);

% Fit single exponential
fh_1expd = @(x,q) q(1) + q(2)*exp(-x./q(3));
efh_1expd = @(q,x,y) sum((y(:)-fh_1expd(x(:),q)).^2);
lb_1expd = [0, 0, 0];
ub_1expd = [+inf, +inf,+inf];
init_1expd = [0, 0, 0]; % [offset scale tau]
[fit_1expd, ~, ~, ~] = fminsearchbnd(efh_1expd,init_1expd,lb_1expd,ub_1expd,options,reldomercq(reldomercq(:,1)>=0,1),reldomercq(reldomercq(:,1)>=0,2));
%%
% Fit double expotential
fh_2expd = @(x,q) q(1) + q(2)*exp(-x./q(3)) + q(4)*exp(-x./q(5));
efh_2expd = @(q,x,y) sum((y(:)-fh_2expd(x(:),q)).^2);
lb_2expd = [0, 0, 0, 0, 0];
ub_2expd = [+inf, +inf, +inf, +inf, +inf];
init_2expd = [0, 0, 0, 0, 0]; % [offset scale tau]
[fit_2expd, ~, ~, ~] = fminsearchbnd(efh_2expd,init_2expd,lb_2expd,ub_2expd,options,x2fit,y2fit);
%% View data from file
%for i = 1:1000
%close all
% set(gca,'Units','pixels');
% set(gca,'OuterPosition', get(gca,'OuterPosition') + [-10,30,80,60]); % [left bottom width height]
% set(gca,'Position', get(gca,'Position') + [0,0,0,0]);
%[d0,~] = swallow_csv('/mnt/storage/goofy/projects/data/astron/raw/outfiles/testing/presynaptic_1hz_0atp28.csv','"',',','\'); % row offset = 1, col offset = 0
[d,~] = swallow_csv('/home/anup/goofy/projects/data/astron/raw/astrocyte/parsweep1.csv','"',',','\'); % row offset = 1, col offset = 0
%[t10,~] = swallow_csv('/mnt/storage/goofy/projects/codes/astron/test.csv','"',',','\');
%[d10,~] = swallow_csv('/mnt/storage/goofy/projects/data/astron/raw/outfiles/testing/presynaptic_1hz_10atp25.csv','"',',','\'); % row offset = 1, col offset = 0
colnames = textscan(fopen('/home/anup/goofy/projects/data/astron/raw/astrocyte/parsweep1.csv'),'%s',1);fclose('all');
%colnames = textscan(fopen('/mnt/temp1/data/astron/raw/singleApChain_test1.csv.10r'),'%s',1);fclose('all');
colnames = char(colnames{:});colnames = strsplit(colnames,',');
d = d(100:end,:);
hold off;
% plot (d(:,1),...
%     (d(:,~cellfun(@isempty,strfind(colnames,'n0ip3r_lr_h'))).^3)...
%     ,'color','green','LineWidth',2);
% hold on;
fh1 = plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ca_cyt')))*1e9...
    ,'color',[1,0,0],'LineWidth',1);
hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ca_er')))*1e6...
    ,'color',[0,1,0],'LineWidth',1);
hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ip3_cyt')))*1e9...
    ,'color',[0,0,1],'LineWidth',1);
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_x0')))*1e0...
%         ,'color',[1,0,0],'LineWidth',2);
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_x1')))*1e0...
%         ,'color',[0,1,0],'LineWidth',2);
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_x2')))*1e0...
%         ,'color',[0,0,1],'LineWidth',2);
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_y0')))*1e0...
%         ,'color',[0,1,1],'LineWidth',3);    
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_y1')))*1e0...
%         ,'color',[0,1,0],'LineWidth',3);
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_y2')))*1e0...
%         ,'color',[0,0,1],'LineWidth',3);
% hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0serca_higg_ca_er_flux')))*1e0...
%         ,'color',[0,0,0],'LineWidth',3);  
%hold on;
% plot (d(:,1),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0p2yr_hill_dsen_frac')))*1e3...
%     ,'color',[0.5,0.5,0.5],'LineWidth',2);
% hold on;
% plot (d(:,1),...
% d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_spon_relrate')))*1e0...
%         ,'color',[1,0,0],'LineWidth',2);
% hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_slow_relrate')))*1e0...
        ,'color',[0,1,0],'LineWidth',2);
% hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_sslow_relrate')))*1e0...
        ,'color',[0,0,1],'LineWidth',2);
% hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_total_relrate')))*1e0...
        ,'color',[0,1,1],'LineWidth',2);    
% hold on;
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_rrp')))*1e1...
    ,'color','black','LineWidth',2);
% hold on;
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_ff_flag')))*-1.5e2...
    ,'color','blue','LineWidth',1);
hold on;
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_kr_flag')))*-1.5e2...
    ,'color','red','LineWidth',1);
% hold on;
% plot (d(:,1),...
% d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_rel_flag')))*-1e2...
%     ,'color','black','LineWidth',2);
% hold on;
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_spon_flag')))*-1e2...
    ,'color',[0.5,0.5,0.5],'LineWidth',2);
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_slow_flag')))*-1e2...
    ,'color','red','LineWidth',2);
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_sslow_flag')))*-1e2...
    ,'color','blue','LineWidth',2);
hold on;
plot (d(:,1),...
d(:,~cellfun(@isempty,strfind(colnames,'s0atp_ext')))*10e7 ...
    ,'color',[0.5,0.5,0.5],'LineWidth',1);
% plot (d(:,1),...
% d(:,~cellfun(@isempty,strfind(colnames,'n0ip3r_lr_ca_cyt_flux')))...
%     ,'color','yellow','LineWidth',2);
% % plot (d(:,1),...
% % d(:,~cellfun(@isempty,strfind(colnames,'n0voltage')))*1e03...
% %     ,'color','green','LineWidth',2);
% % plot (d(:,1),...
% % d(:,~cellfun(@isempty,strfind(colnames,'n1atpves_rel_rate')))*1e2...
% %     ,'color','black','LineWidth',2);
xlabel(gca,sprintf('Time (sec)'),'Fontsize',18);
ylabel(gca,sprintf('[Ca]^{2+}_{i} (nM), Vesicles sec^{-1}'),'Fontsize',18);
set(gca,'FontSize',18);
%set(gca,'YLim',[-100,500]);
lgd1 = legend('Location','West');
%lgd1 = findobj(gcf,'Tag','legend');
set(lgd1,'FontSize',10);
legend boxoff;
%fname = {['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/.jpeg']};
%print('-djpeg','-r300',fname{1}); %['-r','300']
%% View data in workspace 
%for trialnum = 1:200
%close all;
set(0,'DefaultFigureWindowStyle','docked');
% Place axes at (0.1,0.1) with width and height of 0.8
hold off;
trialnum=100;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0ca_cyt')),trialnum)*1e09...
        ,'color','red','LineWidth',2);
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0ca_er')),trialnum)*1e06...
    ,'color',[1,0,0],'LineWidth',2,'LineStyle','-');
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0ip3_cyt')),trialnum)*1e09...
        ,'color','blue','LineWidth',2);    
% hold on;
% plot (d(:,1,1),...
% d(:,~cellfun(@isempty,strfind(colnames,'s0atp_ext')),trialnum)*10e6 ...
%     ,'color','blue','LineWidth',3);
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_rrp')),trialnum)* 1e1 ...
        ,'color',[0.5,0.5,0.5],'LineWidth',2);
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_spon_relrate')),trialnum) *1e0...
        ,'color',[1,0,0],'LineWidth',2);    
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_syn_relrate')),trialnum) * 1e0...
        ,'color',[0,1,0],'LineWidth',2);  
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_asyn_relrate')),trialnum) *1e0...
        ,'color',[0,0,1],'LineWidth',2);  
hold on;
plot (dd(:,1,1),...
    dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_total_relrate')),trialnum) *1e0...
        ,'color',[0,1,1],'LineWidth',2);  
hold on;
plot (dd(:,1,1),...
dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_ff_flag')),trialnum)*-1.5e2 ...
    ,'color',[0,0,0],'LineWidth',2);
hold on;
plot (dd(:,1,1),...
dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_kr_flag')),trialnum)*-1.5e2 ...
    ,'color',[0.5,0.5,0.5],'LineWidth',2);
hold on;
plot (dd(:,1,1),...
dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_spon_flag')),trialnum)*-1e2 ...
    ,'color',[1,0,0],'LineWidth',1);
hold on;
plot (dd(:,1,1),...
dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_syn_flag')),trialnum)*-1e2 ...
    ,'color',[0,1,0],'LineWidth',1);
hold on;
plot (dd(:,1,1),...
dd(:,~cellfun(@isempty,strfind(colnames,'n0gluves_asyn_flag')),trialnum)*-1e2 ...
    ,'color',[0,0,1],'LineWidth',1);

   
%%
% plot (d(:,1,1),...
% d(:,~cellfun(@isempty,strfind(colnames,'n0ca_er')),trialnum)*1e06...
%     ,'color','cyan','LineWidth',2);
%plot(maxtall(:,trialnum)',maxyall(:,trialnum)' *1e09,'Color',[0,0,1],'LineStyle','o')
%plot(mintall(:,trialnum)',minyall(:,trialnum)' *1e09,'Color',[0,0,0],'LineStyle','o')
ax=gca;
% set(ax(1),'XTick',0:100:500)
% set(ax(1),'XLim',[0,500]);
% set(ax(1),'YLim',[0,600]);
% set(ax(1),'YColor','k');
% set(ax(1),'YTick',0:100:600);
% set(ax(1),'TickDir','out');
% set(ax(1),'FontSize',20);
xlabel(ax(1),sprintf('\nTime (sec)'),'Fontsize',22);
ylabel(ax(1),sprintf('Concentration (nM, \\muM)'),'Fontsize',22);
title(ax(1),sprintf(['IP_{3}R-LR, N = 1000,000, [ip3] = ',num2str(trialnum)]),'FontSize',22);
% [hleg1, hobj1] = legend(gca,'[Ca^{2+}_{cyt}]','IP_3','[Ca^{2+}_{er}]','Location','NorthEast','Orientation','horizontal');
% set(hleg1,'box','off');
% textobj = findobj(hobj1, 'type', 'text');
% set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
% set(gcf,'Units','normal')
% set(gca,'Position',[0 0 1 1])
% set(gca,'OuterPosition',[.01 .05 0.95 0.95])
% line([50,60],[-5,-5],'LineWidth',3,'color',[0,0,0]);
% text(50,-6,'10 sec','FontSize', 16);
% text(47,-5,'2.5 \muM','Rotation',90,'FontSize', 16);
% line([50,50],[-5,-2.5],'LineWidth',3,'color',[0,0,0]);
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
% set(gca,'Box','off');
% set(gca, 'Color', 'none')
% set(gca,'visible','off');
% annotation('textbox',[.65 .2 .3 .3],'string',sprintf('serca-vmax:\t40'),'FitBoxToText','on','FontSize',14)
% text(10,26,['Serca K_{half} = ',num2str(x1varmax(trialnum)*1e09),' nM'],'FontSize', 16,'color',[0.2,0.4,0.2]);
% text(60,26,['IP_{3} = ',num2str(x2varmax(trialnum)*1e09),' nM'],'FontSize', 16,'color',[0.2,0.4,0.2]);
%print(gcf,'-djpeg','-r100',['/home/anup/goofy/projects/data/astron/figures/astro_osc/astro_cacytfreq_noplcdelta',num2str(trialnum),'.jpeg']);
%end
%% Create pictures for movie
% Place axes at (0.1,0.1) with width and height of 0.8
for (trialnum = 1:200)
close all;
set(0,'DefaultFigureWindowStyle','docked');
hold off;
plot (d(:,1,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n1ca_cyt')),trialnum)*1e06...
        ,'color','red','LineWidth',2);
hold on;
plot (d(:,1,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n1ip3_cyt')),trialnum)*1e06...
        ,'color','blue','LineWidth',2);
plot (d(:,1,1),...
d(:,~cellfun(@isempty,strfind(colnames,'n1ca_er')),trialnum)*1e03...
    ,'color','cyan','LineWidth',2);
ax=gca;
set(ax(1),'XTick',0:20:200)
set(ax(1),'XLim',[0,200]);
% set(ax(1),'YLim',[-1,25]);
% set(ax(1),'YColor','k');
% set(ax(1),'YTick',0:2.5:25);
set(ax(1),'TickDir','out');
set(ax(1),'FontSize',20);
xlabel(ax(1),sprintf('\nTime (sec)'),'Fontsize',22);
ylabel(ax(1),sprintf('\nConcentration'),'Fontsize',22);
% title(ax(1),sprintf(['Serca K_{half} =',num2str(x1varmax(trialnum)), ' nM']),'FontSize',22);
[hleg1, hobj1] = legend(gca,'[Ca^{2+}_{cyt}]\muM','[IP_3]\muM','[Ca^{2+}_{er}]mM','Location','NorthEast','Orientation','horizontal');
set(hleg1,'box','off');set(hleg1,'FontSize',16);
% textobj = findobj(hobj1, 'type', 'text');
% set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
set(gcf,'Units','normal')
set(gca,'Position',[0 0 1 1])
set(gca,'OuterPosition',[.01 .05 0.95 0.95])
%line([50,60],[-5,-5],'LineWidth',3,'color',[0,0,0]);
%text(50,-6,'10 sec','FontSize', 16);
%text(47,-5,'2.5 \muM','Rotation',90,'FontSize', 16);
%line([50,50],[-5,-2.5],'LineWidth',3,'color',[0,0,0]);
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
% set(gca,'Box','off');
% set(gca, 'Color', 'none')
% set(gca,'visible','off');
%annotation('textbox',[.65 .2 .3 .3],'string',sprintf('serca-vmax:\t40'),'FitBoxToText','on','FontSize',14)
yaxlim=ylim;
text(10,yaxlim(2)+yaxlim(2)*0.03,['Serca K_{half} = ',num2str(x1varmax(trialnum)*1e09),' nM'],'FontSize', 16,'color',[0.2,0.4,0.2]);
text(120,yaxlim(2)+yaxlim(2)*0.03,['IP_{3} = ',num2str(x2varmax(trialnum)*1e09),' nM'],'FontSize', 16,'color',[0.2,0.4,0.2]);
print(gcf,'-djpeg','-r100',['/home/anup/goofy/projects/data/astron/figures/withplcdelta_pmca/astrocyte/astrocyte_',num2str(trialnum),'.jpeg']);
end
%% Print figures
set(gcf, 'PaperPositionMode', 'auto');
%print(gcf,'-djpeg','-r300',['/home/anup/goofy/projects/data/astron/figures/astrocyte_160ip3_cyt_',num2str(xvar(trialnum)),'serca_khalf.jpeg']);
%print(gcf,'-djpeg','-r300','/home/anup/goofy/projects/data/astron/figures/heatmap_astro_cacytlowamp_withplcdelta_withpmca100.jpeg');
print(gcf,'-djpeg','-r300','/home/anup/goofy/projects/data/astron/figures/heatmap_astro_cacytbaseline_withplcdelta_100pmca.jpeg');
%print(gcf,'-djpeg','-r300','/home/anup/goofy/projects/data/astron/figures/heatmap_astro_cacytbaseline_withplcdelta_250pmca.jpeg');
%saveas(gcf,'test.png');
%%
hold off;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n1ip3_cyt')))...
        ,'color','blue','LineWidth',2);
    hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n1ca_cyt')))...
        ,'color','red','LineWidth',2);
    hold on;
plot (d(:,1),...
    d(:,~cellfun(@isempty,strfind(colnames,'n1ca_er')))*1e-3...
        ,'color','cyan','LineWidth',2);
%%
hold off;
plot (d(:,~cellfun(@isempty,strfind(colnames,'time'))),...
    d(:,~cellfun(@isempty,strfind(colnames,'n0ip3_cyt')))...
        ,'color','blue','LineWidth',2);
% hold on;
% plot (d(:,~cellfun(@isempty,strfind(colnames,'time'))),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0ip3_cyt')))...
%         ,'color','green','LineWidth',2);
% hold on;
% plot (d(:,~cellfun(@isempty,strfind(colnames,'time'))),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0gluves_rrp')))...
%         ,'color','black','LineWidth',2);
% hold on;
% plot (d(:,~cellfun(@isempty,strfind(colnames,'time'))),...
%     d(:,~cellfun(@isempty,strfind(colnames,'n0atpves_rrp')))...
%         ,'color',[0.5,0.5,0.5],'LineWidth',2);
%% Plot RRP and releases for book chapter figure
close all;
set(0,'DefaultFigureWindowStyle','docked');
% Place axes at (0.1,0.1) with width and height of 0.8
fig = figure;
% handaxes1 = axes('position', [0.155 0.15 0.8 0.8]);
%pos = get(fig,'Position');outer_pos = get(fig,'OuterPosition');
%set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
% pos = get(fig,'Position');
% outer_pos = get(fig,'OuterPosition');
t_id = find(~cellfun(@isempty,strfind(colnames,'time')));
y1_id = ~cellfun(@isempty,strfind(colnames,'n0gluves_rrp'));
y2_id = find(~cellfun(@isempty,strfind(colnames,'n0gluves_spon_flag')));
y3_id = find(~cellfun(@isempty,strfind(colnames,'n0gluves_asyn_flag')));
y4_id = find(~cellfun(@isempty,strfind(colnames,'n0ca_cyt')));
[nspk,mint,miny,maxt,maxy] = count_spikes(d10(:,t_id),d10(:,y4_id)*1e06,5);
X2 = d10(:,t_id)';x2 = [X2(X2<min(maxt)-0.001),mint,X2(X2>(max(maxt)+1))];
y2 = (d10(:,y4_id)*1e06)';y2 = [y2(X2<min(maxt)-0.001),miny,y2(X2>(max(maxt)+1))];
[ax,h1,h2] = plotyy([d10(:,t_id),d10(:,t_id),d10(:,t_id)],[d10(:,y1_id),d10(:,y2_id)*3,d10(:,y3_id)*3],x2,y2*1000,@plot,@plot);
set(ax(1),'XTick',0:50:350)
set(ax(1),'XLim',[80,400]);
set(ax(1),'YLim',[2,14]);
set(ax(1),'YColor','k');
set(ax(1),'YTick',2:2:14);
set(ax(1),'TickDir','out');
set(ax(2),'XTick',[]);
set(ax(2),'XLim',[80,400]);
set(ax(2),'YTick',0:250:1000);
set(ax(2),'YLim',[0,1000]);
set(ax(2),'YColor',[0,0.5,0set(ax(1),'XTick',0:50:350)
set(ax(1),'XLim',[80,400]);
set(ax(1),'YLim',[2,14]);
set(ax(1),'YColor','k');
set(ax(1),'YTick',2:2:14);
set(ax(1),'TickDir','out');
set(ax(2),'XTick',[]);
set(ax(2),'XLim',[80,400]);
set(ax(2),'YTick',0:250:1000);
set(ax(2),'YLim',[0,1000]);
set(ax(2),'YColor',[0,0.5,0]);
set(ax(1),'FontSize',20);
set(ax(2),'FontSize',20);
set(h1(1),'LineWidth',2.0,'Color',[0 0 0],'Linestyle','-');
set(h1(2),'LineWidth',2,'Color',[1, 0, 0],'Linestyle','-');
set(h1(3),'LineWidth',2,'Color',[0, 0, 1],'Linestyle','-');
set(h2(1),'LineWidth',3,'Color',[0 0.5 0],'Linestyle','-');
xlabel(ax(2),sprintf('\nTime (s)'),'Fontsize',22);
ylabel(ax(1),sprintf('RRP size'),'Fontsize',22);
ylabel(ax(2),sprintf('Calcium concentration (nM)'),'Fontsize',22);
[hleg1, hobj1] = legend(gca,'RRP size','Spon. rel','Syn. rel','Ca^{2+} base','Location','East');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
set(gcf,'Units','normal')
set(gca,'Position',[0 0 1 1])
set(gca,'OuterPosition',[.01 .05 0.95 0.95])]);
set(ax(1),'FontSize',20);
set(ax(2),'FontSize',20);
set(h1(1),'LineWidth',2.0,'Color',[0 0 0],'Linestyle','-');
set(h1(2),'LineWidth',2,'Color',[1, 0, 0],'Linestyle','-');
set(h1(3),'LineWidth',2,'Color',[0, 0, 1],'Linestyle','-');
set(h2(1),'LineWidth',3,'Color',[0 0.5 0],'Linestyle','-');
xlabel(ax(2),sprintf('\nTime (s)'),'Fontsize',22);
ylabel(ax(1),sprintf('RRP size'),'Fontsize',22);
ylabel(ax(2),sprintf('Calcium concentration (nM)'),'Fontsize',22);
[hleg1, hobj1] = legend(gca,'RRP size','Spon. rel','Syn. rel','Ca^{2+} base','Location','East');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
set(gcf,'Units','normal')
set(gca,'Position',[0 0 1 1])
set(gca,'OuterPosition',[.01 .05 0.95 0.95])
%% Plot calcium concentrations for book chapter figure
close all;
set(0,'DefaultFigureWindowStyle','docked');
% Place axes at (0.1,0.1) with width and height of 0.8
fig = figure;
handaxes1 = axes('position', [0.155 0.15 0.8 0.8]);
%pos = get(fig,'Position');outer_pos = get(fig,'OuterPosition');
%set(gca,'OuterPosition',[outer_pos(1) + 0.07, outer_pos(2) + 0.07, outer_pos(3) - 0.19, outer_pos(4) - 0.05]);
pos = get(fig,'Position');
outer_pos = get(fig,'OuterPosition');
t_id = find(~cellfun(@isempty,strfind(colnames,'time')));
y1_id = find(~cellfun(@isempty,strfind(colnames,'n0ca_cyt')));
[nspk,mint,miny,maxt,maxy] = count_spikes(d10(:,t_id),d10(:,y1_id)*1e06,5);
X2 = d10(:,t_id)';x2 = [X2(X2<min(maxt)-0.001),mint,X2(X2>(max(maxt)+1))];
y2 = (d10(:,y1_id)*1e06)';y2 = [y2(X2<min(maxt)-0.001),miny,y2(X2>(max(maxt)+1))];
[ax,h1,h2] = plotyy(d10(:,t_id),d10(:,y1_id)*1e06,x2,y2*1000,@plot,@plot);
set(ax(1:2),'XTick',0:50:350);
set(ax(1:2),'XLim',[80,400]);
set(ax(1),'YLim',[0,10]);
set(ax(1),'YTick',0:2:10);
set(ax(1),'TickDir','out');
set(ax(2),'XTick',[]);
set(ax(2),'YTick',0:250:1000);
set(ax(2),'YLim',[0,1000]);
set(ax(1),'FontSize',20);
set(ax(2),'FontSize',20);
set(h1(1),'LineWidth',1.0,'Color',[0 0 1],'Linestyle','-');
set(h2(1),'LineWidth',3.0,'Color',[0 0.5 0],'Linestyle','-');
xlabel(ax(2),sprintf('\nTime (s)'),'Fontsize',22);
ylabel(ax(1),sprintf('Calcium concentration (\\muM)'),'Fontsize',22);
ylabel(ax(2),sprintf('Calcium concentration (nM)'),'Fontsize',22);
set(gcf,'Units','normal')
set(gca,'Position',[0 0 1 1])
set(gca,'OuterPosition',[.01 .05 0.95 0.95])
[hleg1, hobj1] = legend(gca,'Ca^{2+} peak','Ca^{2+} base','Location','Northeast');
set(hleg1,'box','off');
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'tex', 'FontSize', 16);
%% Print figures for book chapter
set(gcf, 'PaperPositionMode', 'auto');
print(gcf,'-djpeg','-r600','/home/anup/goofy/projects/data/astron/figures/bifurcation_ca_cyt1_1.jpeg');
%saveas(gcf,'test.png');
%% Load data for plotting figures for book chapter
fname_prefix_0atp = '/home/anup/goofy/data/iiser/outfiles/testing/presynaptic_1hz_0atp_sub.csv';
fname_prefix_10atp = '/home/anup/goofy/data/iiser/outfiles/testing/presynaptic_1hz_10atp_sub.csv';
d0atp = get_iri_rri_fromfiles(fname_prefix_0atp,3,37,{'time','n0ca_cyt','n0gluves_syn_flag'},0.5e-6,0.5);
d10atp = get_iri_rri_fromfiles(fname_prefix_10atp,3,37,{'time','n0ca_cyt','n0gluves_syn_flag'},0.5e-6,0.5);
%% Processing for bifurcation analysis
base_fname = 'astrocyte_pmca_test';
path_fname = '/home/anup/goofy/DATA/SCRIPTS/CPP/astron/insilico/outfiles/testing/';
col_id = 3;
max_time = 50;
for i = 1 :21
    fname = strcat(base_fname,num2str(i),'.csv')
    d= csvread(strcat(path_fname,fname),1,0); % row offset = 1, col offset = 0
    dd(:,:,i) = d; 
    d_highs(i,1) = max(d(d(:,1)>max_time,col_id),[],1);
    d_lows(i,1) = min(d(d(:,1)>max_time,col_id),[],1);
    d_x(i,1) = max(d(d(:,1)>max_time,5),[],1);
    d_freqency(i,1) = 0;    
    delta = d_highs(i,1) - d_lows(i,1)
    if (delta > 0)
        [nspk,mint,miny,maxt,maxy] = count_spikes(d(d(:,1)>max_time,1),d(d(:,1)>max_time,col_id),delta/2);
        d_frequency(i,1) = 1/mean(diff(maxt(1:nspk)));
    end
end
%% check the poisson distribution
d = csvread('/home/anup/goofy/projects/data/astron/data_others/data_Nishant/ca2.csv',1,0); % row offset = 1, col offset = 0
%%
hold off;
v_max = 10e-06;
k_diss_ca = 1e-06;
k_diss_ip3 = 30e-06;
fca = @(ca_conc) v_max * ( ca_conc.^4 ./(ca_conc.^4 + k_diss_ca.^4) );
fip3 = @(ip3_conc) (ip3_conc ./ (ip3_conc + k_diss_ip3) );
ip3_conc = 100e-6:10e-6:600e-6;
for ca_conc = 100e-9: 100e-9: 700e-9;
%     fprintf('%d\n',ca_conc);
    plot(ip3_conc,fip3(ip3_conc).*fca(ca_conc),'-'); hold on;
end
%% calculate the hill equation parameters for a1 receptor inhibition on vgccs
ado_ext = [0,20e-6,50e-6,500e-6,1000e-6,1000e-6];
v_max = 0.45;
k_diss = 1e-03;
a1r_vgcc_frac = @(ado_conc) v_max * ( ado_conc.^0.7 ./(ado_conc.^0.7 + k_diss) );
a1r_vgcc_frac(ado_ext)
plot(ado_ext,a1r_vgcc_frac(ado_ext));
%% check external current injection
d = csvread('/home/anup/goofy/projects/codes/astron/input/external_currents.isfc',1,0); % row offset = 1, col offset = 0
%% Make video from images
imagenames = dir(fullfile('/home/anup/goofy/projects/data/astron/figures/withplcdelta_pmca/astrocyte/','*.jpeg'));
imagenames = {imagenames.name}';
outvideo = VideoWriter('/home/anup/goofy/projects/data/astron/figures/withplcdelta_pmca/astrocyte/astrocyte.avi');
outvideo.FrameRate = 0.02;
open(outvideo);
for i = 1: length(imagenames)
    img = imread(['/home/anup/goofy/projects/data/astron/figures/withplcdelta_pmca/astrocyte/astrocyte_',num2str(i),'.jpeg']);
    writeVideo(outvideo,img);
end
close(outvideo);
%% average data from all trails in a 3d-matrix
numtrials = 400;
starttime = 0;
endtime = 300;
varname = 'n0gluves_asyn_relrate';
%varname = 'n0ca_cyt';
sumdat = zeros(size(d(d(:,1,1) >= starttime & d(:,1,1) <= endtime,1,1)));
tvar = d(d(:,1,1) >= starttime & d(:,1,1) <= endtime,1,1);
for i = 1 : numtrials
    sumdat = sumdat  + d(d(:,1,i) >= starttime & ...
        d(:,1,i) <= endtime,~cellfun(@isempty,strfind(colnames,varname)),i);
end
avgdat = sumdat/numtrials;
%% load all data, average and store in a matrix
fnameprefix1 = '/mnt/temp1/data/astron/raw/astrocyte/atppulse/2sec/atprel';
fstart = 1;
fstop = 400;
exploop = [100:50:950,1000:1000:12000];
d = [];
idx2 = 0;
for idx1 = exploop
   idx2 = idx2 + 1;
   fnameprefix2 = strcat(fnameprefix1,num2str(idx1),'nM_');
   fnameprefix = fnameprefix1;
   d = load_data_parallel(d,fnameprefix2,fstart,fstop);
   if ( (~exist('sumd','var')) || (idx2 == 1))
      sumd = zeros(size(d,1),size(d,2),length(exploop));
   end
   sumd(:,:,idx2) = sumd(:,:,idx2) + (sum(d,3) / (fstop-fstart + 1)) ;
end
%% display all the release rate with different colors in a plot
load('/mnt/temp1/data/astron/raw/astrocyte/release/sumd.mat')
%%
close all;
exploop = [100:50:950,1000:1000:12000];
vs1 = textscan(num2str(exploop),'%s')';
vs2 = cell(1,length(exploop));
vs2(:) = {'nM'};
vs3 = strcat(vs1{1}',vs2);
varname = 'n0gluves_asyn_flag';
varid = ~cellfun(@isempty,strfind(colnames,varname));
datmat = [sumd(:,1,1),reshape(sumd(:,varid,:),size(sumd,1),size(sumd,3))];
mycolormap = jet(length(vs3));
set(0,'DefaultAxesColorOrder',mycolormap)
set(0,'DefaultAxesLineStyleOrder','-|*')
%plotbycolumn(fh1,datmat,['time',vs3],vs3,ones(1,30),1);
fh1 = plot(datmat(:,1),datmat(:,2:end),'*');
xlabel(gca,sprintf('Time (sec)'),'Fontsize',20);
ylabel(gca,sprintf('Release rate (vesicle sec^{-1})'),'Fontsize',20);
title(gca,sprintf('Averaged release rate (400 runs)'),'Fontsize',20);
set(gca,'FontSize',18);
set(gca,'XLim',[99.5,102]);
%lgd1 = legend(fh1,vs3,'Location','West','FontSize',8);
lgd1 = findobj(gcf,'Tag','legend');
legend(lgd1,vs3,'Location','West','FontSize',8);
legend boxoff;
hold on;
%plot(varmaxt,varmaxy,'o','MarkerSize',4,'MarkerFaceColor','w','MarkerEdgeColor','k');
fname = {['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/avg_asynrelrate2.jpeg']};
%print('-djpeg','-r300',fname{1}); %['-r','300']
%% find peaks amp and time from release rate
mintime = 0;
maxtime = 300;
num_trials = 400;
%%
close all
plot(log10(exploop*1e-09),varmaxy,'o','MarkerSize',8,'MarkerFaceColor','w','MarkerEdgeColor','k');
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [5,45,100,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);

xlabel(gca,sprintf('\n[Ca^{2+}]_{i} (\\muM)'),'Fontsize',20);
ylabel(gca,sprintf('Peak release rate (vesicle sec^{-1})'),'Fontsize',20);
title(gca,sprintf('Averaged release rate (400 runs)'),'Fontsize',20);
text(-6.0,55,['\downarrow','\color{red}',num2str(ceil(10^(-6.0)*1e09)),' nM'],'FontSize',8);
text(-6.2,55,['\downarrow','\color{red}',num2str(ceil(10^(-6.2)*1e09)),' nM'],'FontSize',8);
set(gca,'FontSize',18);
fname = {['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/peak_asynrelrate1.jpeg']};
print('-djpeg','-r300',fname{1}); %['-r','300']
%%
close all
%plot(log10(exploop*1e-09),(varmaxt-100) * 1000,'o','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','k');
plot(exploop,(varmaxt-100) * 1000,'o','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','k');
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [15,45,100,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
xlabel(gca,sprintf('\n[Ca^{2+}]_{i} (\\muM)'),'Fontsize',20);
ylabel(gca,sprintf('Time-to-peak release rate (ms)'),'Fontsize',20);
title(gca,sprintf('Averaged (400 runs)'),'Fontsize',20);
set(gca,'FontSize',18);
set(gca,'YLim',[0,400]);
%text(-6.2,925,['\uparrow','\color{red}',num2str(ceil(10^(-6.2)*1e09)),' nM'],'FontSize',8);
%text(-6.2,55,['\downarrow','\color{red},num2str(ceil(10^(-6.2)*1e09)),' nM'],'FontSize',8);
%options = optimset('Display','off','MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-10000);
options = optimset('Display','off');
monoexpfit = @(x,q) (q(1)*exp(-x./q(2))); 
ermonoexpfit = @(q,x,y) sum((y(:)-monoexpfit(x(:),q)).^2);
init_monoexpfit = [1000,]; 
fname = {['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/time2peak_asynrelrate2.jpeg']};
print('-djpeg','-r300',fname{1}); %['-r','300']
%%
asynmat2 = smooth(asynmat(:,15),100,'moving');
%% Power spectrum density using FFT on data
close all;
timename = 'time';   %  colname of data
timeid = ~cellfun(@isempty,strfind(colnames,timename)); %  colid of time
t = d(2:end,timeid);
varname = 'n0ca_cyt';   %  colname of data
varid = ~cellfun(@isempty,strfind(colnames,varname)); %  colid of data  
y = d(2:end,varid);   %  data for FFT
plot(t,y);
degree = 2;
trend = polyfit(t,y,degree);
y2 = y - polyval(trend,t);
plot(t,y);
hold on;
plot(t,y2,'red')
%%
close all;
L = length(y2);  %  Length of the data points
NFFT = 2^nextpow2(L);   %  Next power of 2 from length of data points
Fs = 1000;  %  Sampling frequency
%yfft = fft(y,NFFT)/L;
yfft = fft(y2,NFFT);
P = yfft .* conj(yfft)/NFFT;
P = P(1:NFFT/2 + 1);
P(2:NFFT/2) = 2*P(2:NFFT/2);
f = Fs*(0:NFFT/2)/NFFT;
plot(f,P)
%%
% Obtain the periodogram using fft. 
f = 0:Fs/L:Fs/2;
yfft = yfft(1:NFFT/2 + 1); %  Single sided amplitude spectrum the length of f
psdx = (1/(Fs*NFFT)) * abs(yfft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdx = psdx(1:length(f));
%f = Fs/2*linspace(0,1,NFFT/2+1);
%  The signal is real-valued and has even length. Because the signal is real-valued, 
%  you only need power estimates for the positive or negative frequencies. 
%  In order to conserve the total power, multiply all frequencies that occur in 
%  both sets -- the positive and negative frequencies -- by a factor of 2. 
%  Zero frequency (DC) and the Nyquist frequency do not occur twice. Plot the result.
% Plot single-sided amplitude spectrum.
flow = 1/70;   %  lowest frequency of interest
flowidx = find(f<=flow,1);
fhigh = 1/1;  %  highest frequency of interest
fhighidx = find(f<=fhigh,1);
% plot 
close all;
%fh = plot(f(flowidx:fhighidx),10*log10(psdx(flowidx:fhighidx)));
fh = plot(f,10*log10(psdx));
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [25,45,100,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
xlabel(gca,sprintf('\nTime period (sec)'),'Fontsize',20);
ylabel(gca,sprintf('Power/Frequency (dB/Hz)\n'),'Fontsize',20);
title(gca,sprintf('Power spectral density'),'Fontsize',20);
set(gca,'FontSize',18);
set(gca,'XLim',[2,50]);
fname = {['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/psd_cacyt2m.jpeg']};
%print('-djpeg','-r300',fname{1}); %['-r','300']
