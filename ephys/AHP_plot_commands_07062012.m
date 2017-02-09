% CC_i_hyp=avgahp([CC.t_no]',[CC.i_hyp]');
% CC_r_in=avgahp([CC.t_no]',[CC.r_in]');
% CC_ctau=avgahp([CC.t_no]',[CC.ctau]');
% CC_sub_peak=avgahp([CC.t_no]',[CC.sub_peak]');
% CC_raw_peak=avgahp([CC.t_no]',[CC.raw_peak]');
% CC_sub_peak_delay=avgahp([CC.t_no]',[CC.sub_peak_delay]');
% CC_raw_peak_delay=avgahp([CC.t_no]',[CC.raw_peak_delay]');
% CC_sub_area_tot=avgahp([CC.t_no]',[CC.sub_area_tot]');
% CC_sub_area_delay=avgahp([CC.t_no]',[CC.sub_area_delay]');
% CC_raw_area_tot=avgahp([CC.t_no]',[CC.raw_area_tot]');
% CC_raw_area_delay=avgahp([CC.t_no]',[CC.raw_area_delay]');
% 
% CV_i_hyp=avgahp([CV.t_no]',[CV.i_hyp]');
% CV_r_in=avgahp([CV.t_no]',[CV.r_in]');
% CV_ctau=avgahp([CV.t_no]',[CV.ctau]');
% CV_sub_peak=avgahp([CV.t_no]',[CV.sub_peak]');
% CV_raw_peak=avgahp([CV.t_no]',[CV.raw_peak]');
% CV_sub_peak_delay=avgahp([CV.t_no]',[CV.sub_peak_delay]');
% CV_raw_peak_delay=avgahp([CV.t_no]',[CV.raw_peak_delay]');
% CV_sub_area_tot=avgahp([CV.t_no]',[CV.sub_area_tot]');
% CV_sub_area_delay=avgahp([CV.t_no]',[CV.sub_area_delay]');
% CV_raw_area_tot=avgahp([CV.t_no]',[CV.raw_area_tot]');
% CV_raw_area_delay=avgahp([CV.t_no]',[CV.raw_area_delay]');

eb1=errorbar(CC_i_hyp(:,1),CC_ctau(:,1),CC_ctau(:,2),'r')
hold on;
eb2=errorbar(CV_i_hyp(:,1),CV_ctau(:,1),CV_ctau(:,2),'b')
% eb3=errorbar(CC_i_hyp(:,1),CC_raw_peak_delay(:,1),CC_raw_peak_delay(:,2),'r')
% eb4=errorbar(CV_i_hyp(:,1),CV_raw_peak_delay(:,1),CV_raw_peak_delay(:,2),'b')
xlabel('Current injection (pA)','FontSize',12);
ylabel(' Membrane time constant (sec)','FontSize',12);
set(eb1,'LineWidth',2);
set(eb2,'LineWidth',2);
% set(eb3,'LineWidth',2);
% set(eb4,'LineWidth',2);
% eb1group = hggroup;
% set(eb1,'Parent', eb1group);
% set(get(get(eb1,'Annotation'),'LegendInformation'),...
%     'IconDisplayStyle','on'); 
legend(['CC','  ', '20'],['CV','  ','21']);
plotname = ['~/AHP_HC/Matlab_ahpPlots/','HC_AHP_ctau_07062012','.jpeg'];
print(gcf,'-djpeg',['-r','200'],plotname);

%------------------------------------------------------------

CV_i_hyp_all = avgahp([CV.t_no]',[CV.i_hyp]');
CV_i_hyp_all = avgahp([CV.t_no]',[CV.i_hyp]');

%--------------- Plot R_in individual
CC_r_in_all = avgahp([CC.t_no]',[CC.r_in]');
CV_r_in_all = avgahp([CV.t_no]',[CV.r_in]');
eb1=errorbar(CV_i_hyp_all(:,23),CV_r_in_all(:,23),CV_r_in_all(:,26),'b');
hold on;
eb2=errorbar(CC_i_hyp_all(2:end,21),CC_r_in_all(2:end,21),CC_r_in_all(2:end,24),'r');
set(eb1,'LineWidth',2)
set(eb2,'LineWidth',2)
legend(['CV','  ', '21'],['CC','  ', '19']);
ylabel(' Input resistance (Ohms)','FontSize',14)
xlabel('Current injection (pA)','FontSize',14);
plot(CV_i_hyp_all(:,1:21),CV_r_in_all(:,1:21))
plot(CC_i_hyp_all(2:end,1:19),CC_r_in_all(2:end,1:19))
print(gcf,'-djpeg',['-r','200'],['~/AHP_HC/Matlab_ahpPlots/','HC_AHP_all_r_in_07062012','.jpeg'])

%----------------Plot Ctau individual
CC_i_hyp_all = avgahp([CC.t_no]',[CC.i_hyp]');
CV_i_hyp_all = avgahp([CV.t_no]',[CV.i_hyp]');
CC_ctau_all = avgahp([CC.t_no]',[CC.ctau]');
CV_ctau_all = avgahp([CV.t_no]',[CV.ctau]');
% eb1=errorbar(CV_i_hyp_all(:,23),CV_ctau_all(:,23),CV_ctau_all(:,26),'b');
hold on;
eb2=errorbar(CC_i_hyp_all(2:end,21),CC_ctau_all(2:end,21),CC_ctau_all(2:end,24),'r');
% set(eb1,'LineWidth',2)
set(eb2,'LineWidth',2)
% legend(['CV','  ', '21'],['CC','  ', '19']);
legend(['CC','  ', '19']);
ylabel(' Membrane time constant (sec)','FontSize',14)
xlabel('Current injection (pA)','FontSize',14);
% plot(CV_i_hyp_all(:,1:21),CV_ctau_all(:,1:21))
plot(CC_i_hyp_all(2:end,1:19),CC_ctau_all(2:end,1:19))
print(gcf,'-djpeg',['-r','200'],['~/AHP_HC/Matlab_ahpPlots/','Ctau_CC_AHP_HC','.jpeg'])

%-----------------Plot Sub AHP individuals
CC_i_hyp_all = avgahp([CC.t_no]',[CC.i_hyp]');
CC_sub_area_tot_all = avgahp([CC.t_no]',[CC.sub_area_tot]');
CC_sub_area_tot_all(CC_sub_area_tot_all==0)=NaN;
CV_i_hyp_all = avgahp([CV.t_no]',[CV.i_hyp]');
CV_sub_area_tot_all = avgahp([CV.t_no]',[CV.sub_area_tot]');
CV_sub_area_tot_all(CV_sub_area_tot_all==0)=NaN;


eb1=errorbar(CV_i_hyp_all(:,23),CV_sub_area_tot_all(:,23),CV_sub_area_tot_all(:,26),'b');
hold on;
eb2=errorbar(CC_i_hyp_all(2:end,21),CC_sub_area_tot_all(2:end,21),CC_sub_area_tot_all(2:end,24),'r');
set(eb1,'LineWidth',2)
set(eb2,'LineWidth',2)
legend(['CV','  ', '21'],['CC','  ', '19']);
ylabel(' AHP peak area tot (mv.msec)','FontSize',14)
xlabel('Current injection (pA)','FontSize',14);
% plot(CV_i_hyp_all(:,1:21),CV_sub_peak_all(:,1:21),'--b','LineWidth',1)
% plot(CC_i_hyp_all(2:end,1:19),CC_sub_peak_all(2:end,1:19),'--r','LineWidth',1)
% print(gcf,'-djpeg',['-r','200'],['~/AHP_HC/Matlab_ahpPlots/','Peak_Sub_all_AHP_HC2','.jpeg'])

%-----------------Plot Raw AHP  individuals
CC_i_hyp_all = avgahp([CC.t_no]',[CC.i_hyp]');
CC_raw_area_tot_all = avgahp([CC.t_no]',[CC.raw_area_tot]');
CC_raw_area_tot_all(CC_raw_area_tot_all==0)=NaN;
CV_i_hyp_all = avgahp([CV.t_no]',[CV.i_hyp]');
CV_raw_area_tot_all = avgahp([CV.t_no]',[CV.raw_area_tot]');
CV_raw_area_tot_all(CV_raw_area_tot_all==0)=NaN;


eb1=errorbar(CV_i_hyp_all(:,23),CV_raw_area_tot_all(:,23),CV_raw_area_tot_all(:,26),'b');
hold on;
eb2=errorbar(CC_i_hyp_all(2:end,21),CC_raw_area_tot_all(2:end,21),CC_raw_area_tot_all(2:end,24),'r');
set(eb1,'LineWidth',2)
set(eb2,'LineWidth',2)
% legend(['CV','  ', '21'],['CC','  ', '19']);
% ylabel(' AHP peak (V)','FontSize',14)
% xlabel('Current injection (pA)','FontSize',14);
% plot(CV_i_hyp_all(:,1:21),CV_raw_peak_all(:,1:21),'--b','LineWidth',1)
% plot(CC_i_hyp_all(2:end,1:19),CC_raw_peak_all(2:end,1:19),'--r','LineWidth',1)
print(gcf,'-djpeg',['-r','200'],['~/AHP_HC/Matlab_ahpPlots/','Area_tot_all_AHP_HC','.jpeg'])