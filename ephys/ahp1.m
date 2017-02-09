function [s, ahpnotoktraces, r2] = ahp1(fname, channel, traces)
% function [s, ahp1t, p, sse] = ahp1(fname, channel, traces)
close all;
s = makeahpdb(length(traces));
stept=1; 
ahpnotoktraces=NaN(100);
ahpnotokindx=1;
sse = zeros(length(traces),1);
% r2 = zeros(length(traces),1);
sub = NaN(500000,length(traces));
raw=NaN(500000,length(traces));
scap=NaN(25000,length(traces));
rcap=NaN(25000,length(traces));
sahpdelay = 0.2;
%-------------------- Constants
j1Delay = 0.010; % Baseline before the hyp jump 
hJStart= 0.17622; % Start of hyp jump
hJStop=0.37622; % End of hyp jump
hJDStart=0.37622; % Start of hyp depolarization
hJDStop=0.57622; % End of hyp depolarization: 0.37622+0.200s; width = 0.200s
aBStart=0.63600; % Start of baseline before the ahp inducing depolarization
aBLength=0.010; % Length of the baseline before the ahp ,,,
aBStop = aBStart+aBLength; % End of the baseline,,,
aStart=1.27622; % Start of ahp
aStop=9; % End of ahp
while (stept <= length(traces))
    ahpok=true;
    %load the sweep  ----------------------------------
    [trc si] = abfload(fname,'channels',{channel},'sweeps',traces(stept));
    si = si*1E-06;
    [r c] = size(trc);
    if (r < 100) 
        fprinf('not enough samples rows=%d, col = %d \n',r,c); return;
    end
    trc = reshape(trc,size(trc,1),size(trc,3));
    t = 0:si:(r-1)*si;
    t = t';
    %scale the sweep 
    if( (mean(trc(t<0.02)) < -300) && strcmpi('10 vm',channel))
        trc = trc/10000;
    elseif( (mean(trc(t<0.02)) < -3) && strcmpi('10 vm',channel))
        trc = trc/100;
    end
    %----------------------------------------
    %Gaussian filter:  size = 30, sigma = 4
    gFSize=30; gFSigma=4;
    [t trc] = gaussfilt1d(t,trc,gFSize,gFSigma);
    %chop sweeps: chop hyperpolarizing jump
    %first half 
    j1 = trc(t>=hJStart-j1Delay & t<=hJStop); 
    jt1 = t(t>=hJStart-j1Delay & t<=hJStop);
    %second half 
    jd1 = trc(t>=hJDStart & t<=hJDStop); 
    jdt1 = t(t>=hJDStart & t<=hJDStop);
    %pre AHP baseline 10ms
    b = trc(t>=aBStart & t< aBStop); % 10ms of baseline just before the depol pulse
    bt = t(t>=aBStart & t< aBStop);
%chop sweeps: ahp from the end of depol. pulse to 9th sec of sweep 
    a = trc(t>=aStart & t<=aStop);
    at = t(t>=aStart & t<=aStop);
%Check if the start of ahp is riding on an action potential, if yes mark
%them unsuitable
    if (mean(a(at>= (aStart-0.00005) & at<=aStart+0.001)) > max (a(at>=aStart-0.005 & at<=aStart)) ||...
        mean(trc(t>aStart-0.0001 & t<aStart+0.0001)) > mean(trc(t>=aStart-0.005 & t<aStart)) )
        ahpok=false;
        ahpnotoktraces(ahpnotokindx) = traces(stept); 
        ahpnotokindx=ahpnotokindx+1;
    end
    %stich them all: j1+j2+b+a
    y = [j1;jd1;b;a];
    yt = 0:si:si*(length(y)-1);
    yt=yt';
    clear trc; clear t;
    %---------------------------------------------------
%     plot(yt,y);hold on;
    %get passive params
    options = optimset('Display','off');
    initials1 = [10E06,10E-03,150E06]; % [rseries tau rinput]
    i_inj = -25E-12;
    [params, sse(stept), fitok, ~] = fminsearch(@fit_passive_charge,initials1,options,jt1,j1,j1Delay,i_inj);
    if (~fitok)
        fprintf('fit unsucessful\n');
        break;
    end
    
        %Simulate AHP passive
        [yst ys] = simulateAHPpassive(0,y(1),si,j1Delay,hJStop-hJStart,hJDStop-hJDStart,aBLength,a(1),aStop-aStart-si-si,i_inj,params(1),params(3),params(2));
       %------------------------------- 
        fn_idxstart = max(regexp(fname,'\/','end'));
        fn_idxend = regexp(fname,'_C(C|V)\.abf','end');
        s(stept).fname = fname(fn_idxstart+1:fn_idxend-4);
        s(stept).gname = s(stept).fname(end-1:end);
        s(stept).t_no = traces(stept);
        s(stept).r_in = params(3);
        s(stept).r_se = params(1);
        s(stept).ctau = params(2);
        s(stept).vrest= mean(b);
        s(stept).i_hyp= (traces(stept)-1)*25;
        s(stept).sse_pas = sse(stept);
        rcap(1:length(y(yt<aBLength+ (hJDStop-hJStart))),stept) = y(yt<aBLength+ (hJDStop-hJStart));
        scap(1:length(ys(yt<aBLength+ (hJDStop-hJStart))),stept) = ys(yt<aBLength+ (hJDStop-hJStart)); 
        %------------------------------
        %Subtract the similated from real AHP
        ss = y-ys; % added the offset from the real trace
        sst = yst;
        %Filter subtracted trace 
        %median filter: disabled
        ss = medfilt1(ss,25);
        %Gaussian filter:  size = 100, sigma = 4
        %     gFSize2=100; gFSigma2=4;
        %     [ssgft ssgf] = gaussfilt1d(sst,ssmf,gFSize2,gFSigma2);
        % plot(yt,y,ssgft,ssgf,'red','LineWidth',2);
        % fprintf('length of y = %d, ys = %d\n',length(ssgft),length(ssgf));
        ahp1 = ss(sst>j1Delay+(hJStop-hJStart)+(hJDStop-hJDStart));
        ahp1t = sst(sst>j1Delay+(hJStop-hJStart)+(hJDStop-hJDStart));
        ahp1t = ahp1t-ahp1t(1);
        ahp1 = ahp1-mean(ahp1(ahp1t<aBLength));
        lt = 0;
        rt = lt+0.500;
%         ahp2t = ahp1t(ahp1t>=lt & ahp1t<=rt);

              
        if (ahpok)
            s(stept).delay=sahpdelay;
            %---------------------------Sub
            ahp2 = ahp1(ahp1t>=lt & ahp1t<=rt);
            [sub_rmin, sub_cmin] = find(ahp2==min(min(ahp2,1)));
            sub_ahp_p = ahp1(sub_rmin(1),sub_cmin(1));
            sub_ahp_pt = ahp1t(sub_rmin(1),sub_cmin(1));
            s(stept).sub_peak = sub_ahp_p;
            s(stept).sub_peak_lat = sub_ahp_pt-aBLength;
            sub_peak_delay = mean(ahp1(ahp1t(:,1) >=(sub_ahp_pt+sahpdelay)-0.002 &  ahp1t(:,1) <=(sub_ahp_pt+sahpdelay)+0.002));
            s(stept).sub_peak_delay=sub_peak_delay;
            s(stept).sub_area_tot=trapz(ahp1t,ahp1);
            s(stept).sub_area_delay = (s(stept).sub_area_tot-trapz(ahp1t(ahp1t<sahpdelay+sub_ahp_pt),ahp1(ahp1t<sahpdelay+sub_ahp_pt)));
            s(stept).sub_area_tot=s(stept).sub_area_tot*1E06; % from area units V*s -to- mV*ms
            s(stept).sub_area_delay=s(stept).sub_area_delay*1E06;
            %-------------------------Raw
            % Median filter
            y = medfilt1(y,25);
            %-------------------
            ahp_raw = y(yt>j1Delay+(hJStop-hJStart)+(hJDStop-hJDStart));
            ahpt_raw = yt(yt>j1Delay+(hJStop-hJStart)+(hJDStop-hJDStart));
            ahpt_raw = ahpt_raw-ahpt_raw(1);
            ahp_raw = ahp_raw-mean(ahp_raw(ahpt_raw<aBLength));
            ahp2_raw = ahp_raw(ahpt_raw>=lt & ahpt_raw<=rt);
            [raw_rmin, raw_cmin] = find(ahp2_raw==min(min(ahp2_raw,1)));
            raw_ahp_p = ahp_raw(raw_rmin(1),raw_cmin(1));
            raw_ahp_pt = ahpt_raw(raw_rmin(1),raw_cmin(1));
            s(stept).raw_peak = raw_ahp_p;
            s(stept).raw_peak_lat = raw_ahp_pt-aBLength;
            raw_peak_delay = mean(ahp_raw(ahpt_raw(:,1) >=(raw_ahp_pt+sahpdelay)-0.002 &  ahpt_raw(:,1) <=(raw_ahp_pt+sahpdelay)+0.002));
            s(stept).raw_peak_delay=raw_peak_delay;
            s(stept).raw_area_tot=trapz(ahpt_raw,ahp_raw);
            s(stept).raw_area_delay = s(stept).raw_area_tot-trapz(ahpt_raw(ahpt_raw<sahpdelay+raw_ahp_pt),ahp_raw(ahpt_raw<sahpdelay+raw_ahp_pt));
            s(stept).raw_area_tot=s(stept).raw_area_tot*1E06;
            s(stept).raw_area_delay=s(stept).raw_area_delay*1E06;
            %-----------------------
            sub(1:length(ahp1),stept) = ahp1;
            raw(1:length(ahp_raw),stept) = ahp_raw;
            %-----------------------
                 
        end
    stept = stept+1;
end
ahpnotoktraces = ahpnotoktraces(1:ahpnotokindx-1);
sub(length(ahp1)+1:end,:)=[];
raw(length(ahp_raw)+1:end,:)=[];
rcap(length(y( yt<aBLength+ (hJDStop-hJStart)))+1:end,:)=[];
scap(length(ys(yt<aBLength+ (hJDStop-hJStart)))+1:end,:)=[];
size(rcap)
size(scap)
r2=1-sum((rcap-scap).^2,1)./ sum(cell2mat(cellfun(@(x)((x-mean(x)).^2),num2cell(rcap,1),'UniformOutput',false) ),1);
%-------------------------Ploting
set(0,'DefaultAxesColorOrder',jet(length(traces)));
%-------------------------Plot capacitive curve fitting
fig_cap = figure;
plot(yt(yt<aBLength+ (hJDStop-hJStart)),rcap,'Linewidth',2); hold on;
plot(yst(yt<aBLength+ (hJDStop-hJStart)),scap,'Linewidth',2);
title(['Psv_Fit_',s(1).fname],'Interpreter','none');
xlabel('Time (sec)','FontSize',12);
ylabel('Voltage (V)','FontSize',12);
axis([-0.005, 0.41, -0.090, -0.060]);
rinput= ceil([s.r_in]/1E06);
text(0,-0.0854, ['R_m: ',num2str(rinput(1:ceil(end/2)))],'FontSize',12);
text(0,-0.0864, ['       ',num2str(rinput(ceil(end/2)+1:end))],'FontSize',12);
text(0,-0.0876, ['R^2:  ',num2str(r2(1:ceil(end/2)),'%5.1g')],'FontSize',12);
text(0,-0.0890, ['       ',num2str(r2(ceil(end/2)+1:end),'%5.1g')],'FontSize',12);
plotname = ['~/AHP_HC/Matlab_ahpPlots/','CPsvFit_',s(1).fname,'.jpeg'];
print(fig_cap,'-djpeg',['-r','150'],plotname);
%-------------------------Plot sub
fig_sub = figure;
plot(ahp1t,sub,'Linewidth',2); hold on;
plot([s.sub_peak_lat]+aBLength,[s.sub_peak],'sk','markersize',6,'markerfacecolor','b');
plot([s.sub_peak_lat]+[s.delay]+aBLength,[s.sub_peak_delay],'sk','markersize',6,'markerfacecolor','r');
title(['SUB_',s(1).fname],'Interpreter','none');
xlabel('Time (sec)','FontSize',12);
ylabel('Voltage (V)','FontSize',12);
xlim([-0.006,1]);
plotname = ['~/AHP_HC/Matlab_ahpPlots/','SUB_',s(1).fname,'.jpeg'];
print(fig_sub,'-djpeg',['-r','150'],plotname);
%-------------------------Plot raw
fig_raw = figure;
plot(ahpt_raw,raw,'Linewidth',2); hold on;
plot([s.raw_peak_lat]+aBLength,[s.raw_peak],'sk','markersize',6,'markerfacecolor','b');
plot([s.raw_peak_lat]+[s.delay]+aBLength,[s.raw_peak_delay],'sk','markersize',6,'markerfacecolor','r');
title(['RAW_',s(1).fname],'Interpreter','none');
xlabel('Time (sec)','FontSize',12);
ylabel('Voltage (V)','FontSize',12);
xlim([-0.006,1]);
plotname = ['~/AHP_HC/Matlab_ahpPlots/','RAW_',s(1).fname,'.jpeg'];
print(fig_raw,'-djpeg',['-r','150'],plotname);
end
