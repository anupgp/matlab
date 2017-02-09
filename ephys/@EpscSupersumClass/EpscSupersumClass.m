classdef EpscSupersumClass < EvokedEpscClass         
    methods(Static = true)
        function [vclamp,noise,peak,tail,rt,slopedirect,slopefit,areapeak,areatail,taupeak,tautail,stimnum,stiminterval] = EpscMeasure(t,y,nSA,psvRT2,BT1,BT2,RT2,epsclag,rtlim1,rtlim2,taildelay,avgdurP,avgdurT,col,lw,peaks,vstart,vdelta,sweep)
% --------- t & y are raw whole EPSC trace. nSA = number of Stimulations in the given EPSC trace
            y1 = y-mean(y(t >= BT2-0.01 & t <= BT2)); % Do a simple baseline substraction
            noise(1:nSA,1) = mean(y1(t >= BT1 & t <= BT2)); % Get noise Amplitude and Standard deviation
            noiseSD = std(y1(t >= BT2-0.01 & t <= BT2));
% --------- Chop the waves to have the response alone for finding the SAs            
            y1 = y1(t >= BT2 & t <= RT2); % Chop the y wave 
            t1 = t(t >= BT2 & t <= RT2); % Chop the t wave                          
% --------- Find all the Stimulus Artifact (SAs) positions 
            [tSA, ySA] = EvokedEpscClass.findSA(t1,y1,noiseSD,nSA);
            orgtSA = tSA;
% --------- Determine quickly if the EPSC is an AMPA (-70 mV) for NMDA (+40 mV)
%           from the first SA
            [ymin imin] = min(y1(t1>tSA(1)+epsclag & t1<=tSA(1)+epsclag+0.01));
            [ymax imax] = max(y1(t1>tSA(1)+epsclag & t1<=tSA(1)+epsclag+0.01)); 
            yavg = mean(y1(t1>tSA(1)+epsclag & t1<=tSA(1)+epsclag+0.01)); 
            
% --------- Tag the EPSC as either AMPA or NMDA
            if(yavg<0 && (abs(ymin) > abs(ymax))) 
                vclamp=-70;
            else 
                vclamp=40;
            end
% --------- Initialize all the vectors
            peak = zeros(nSA,1);tpeak = zeros(nSA,1);tail = zeros(nSA,1);ttail = zeros(nSA,1);
            base = zeros(nSA,1);taupeak = zeros(nSA,1);tautail = zeros(nSA,1);rt = zeros(nSA,1);
            areapeak = zeros(nSA,1);areatail = zeros(nSA,1);
            slopefit = zeros(nSA,1);slopedirect = zeros(nSA,1);
% --------- Computing the values for stimnum & stiminterval
            stimnum = 1:length(tSA);stiminterval = repmat(mean(diff(tSA)),length(tSA),1);
            
% --------- Loop for each Stimulus Artifact (nSA)            
            for j = 1:nSA
                foundrt = 1;
                if (vclamp == -70)
                    fprintf('AMPA EPSC StimNum = %d\n',j);                   
% Normalize time axis with the first tSA(1), which become t = 0 
                    t1 = t1-tSA(1);
% Normalize tSA to take into account of normalizing the time axis
                    tSA = tSA-tSA(1);
% --------- Generate two vectors to hold the left and right of each EPSC in the wave            
                    epsclim1 = tSA; 
                    epsclim2 = [tSA(2:end),RT2-orgtSA(1)];
% --------- Process the AMPA EPSC                
% --------- Baseline Substration different for AMPA is already done on t1,y1
                    t2 = t1(t1 > epsclim1(j)-0.01 & t1 < epsclim2(j)-0.002);
                    y2 = y1(t1 > epsclim1(j)-0.01 & t1 < epsclim2(j)-0.002);
                    [ymin imin] = min(y2(t2 > epsclim1(j)+epsclag & t2 <= epsclim1(j)+epsclag+0.01));
                    [ymax ~] = max(y2(t2 > epsclim1(j)+epsclag & t2 <= epsclim1(j)+epsclag+0.01));
                    tpeak(j) = t2(imin)+(epsclim1(j)-t2(1))+epsclag;
                    peak(j) = mean(y2(t2 >= (tpeak(j)-avgdurP) & t2 <= (tpeak(j)+avgdurP)));
                    base(j) = ymax;
                    tail(j) = mean(y2(t2 >= (tpeak(j)+taildelay-avgdurT) & t2 <= (tpeak(j)+taildelay+avgdurT)));
                    ttail(j) = tpeak(j)+taildelay;
                    yrt = y2((t2 > epsclim1(j)+epsclag) & (t2 <= tpeak(j)));
                    xrt = t2((t2 > epsclim1(j)+epsclag) & (t2 <= tpeak(j)));
                    Irt1 = find(yrt >= (base(j)-rtlim1*abs(ymin-base(j))),1,'last');
                    Irt2 = find(yrt >= (base(j)-rtlim2*abs(ymin-base(j))),1,'last');
                    if (isempty(Irt1) || isempty(Irt2))
                        display('Error: Risetime bounderies could not be found');
                        return;
                    end
                    rt(j) = xrt(Irt2)-xrt(Irt1);
                    slopedirect(j) = (yrt(Irt2)-yrt(Irt1))/rt(j);
                    yIntercept = yrt(Irt1)-slopedirect(j)*(xrt(Irt1)-xrt(1));
                    t1_pktau = tpeak(j);
                    t1_tltau = ttail(j);
                    t2_tau = (epsclim1(j)+stiminterval(j)-0.002);               
                    axis([-0.01,epsclim1(j)+0.1,min([peaks;peak])-10,10]);
                else
                    fprintf('NMDA EPSC StimNum = %d\n',j);
                    if (j == 1)
% --------- Process the NMDA EPSC
                        y1 = y(t >= psvRT2+1 & t < RT2-0.001);
                        t1 = t(t >= psvRT2+1 & t < RT2-0.001);
% Normalize time axis with the first tSA(1), which become t = 0 
                        t1 = t1-tSA(1);
% Normalize tSA to take into account of normalizing the time axis
                        tSA = tSA-tSA(1);
% --------- Generate two vectors to hold the left and right of each EPSC in the wave            
                        epsclim1 = tSA; 
                        epsclim2 = [tSA(2:end),RT2-orgtSA(1)];                   
% --------- Call the baseline-fit function here for NMDA EPSC
                        leftstart=t1(1);leftdelta=0.001;leftn=0;leftend=tSA(1)-0.005; % for ss100             
%                        rightstart=t1(end);rightdelta=-0.001;rightn=0;rightend=tSA(end)+0.05; % for ss50              
                        rightstart=t1(end);rightdelta=-0.001;rightn=0;rightend=tSA(end)+0.1; 
                        [t1,y1] = EvokedEpscClass.BFS(t1,y1,leftstart,leftdelta,leftn,leftend,rightstart,rightdelta,rightn,rightend);                     
                        baseavg = mean(y1(t1 >= (BT1-orgtSA(1)) & t1 <= (BT2-orgtSA(1)))); % average baseline
                        y1 = y1-baseavg; % average baseline substraction   
                    end
                    
                    y2 = y1(t1 > epsclim1(j)-0.01 & t1 < epsclim2(j)-0.001); % Chop the y wave 
                    t2 = t1(t1 > epsclim1(j)-0.01 & t1 < epsclim2(j)-0.001); % Chop the t wave
                    [ymax imax] = max(y2(t2 > epsclim1(j) + epsclag & t2 <= epsclim1(j) + 0.03));
                    [ymin, ~] = min(y2(t2 > epsclim1(j) + epsclag & t2 <= epsclim1(j) + 0.03));
                    tpeak(j) = t2(imax)+(epsclim1(j)-t2(1))+epsclag;
                    peak(j) = mean(y2(t2 >= (tpeak(j)-avgdurP) & t2 <= (tpeak(j)+avgdurP)));
                    base(j) = ymin;                    
                    if (tpeak(j)+taildelay < epsclim2(j)-0.001)
                        tail(j) = mean(y2(t2 >= (tpeak(j)+taildelay-avgdurT) & t2 <= (tpeak(j)+taildelay+avgdurT)));
                        ttail(j) = tpeak(j)+taildelay;
                    end
                    yrt = y2((t2 > epsclim1(j) + epsclag) & (t2 <= tpeak(j)));
                    xrt = t2((t2 > epsclim1(j) + epsclag) & (t2 <= tpeak(j)));
                    Irt1 = find(yrt <= base(j) + (rtlim1 * abs(ymax-base(j))),1,'last');
                    Irt2 = find(yrt <= base(j) + (rtlim2 * abs(ymax-base(j))),1,'last');
                    if (isempty(Irt1) || isempty(Irt2))
                        disp('Error: Risetime bounderies could not be found');
                        foundrt = 0;
                        %return;
                    end
                    if (foundrt)
                        rt(j) = xrt(Irt2)-xrt(Irt1);
                        slopedirect(j) = (yrt(Irt2)-yrt(Irt1))/rt(j);
                        yIntercept = yrt(Irt1)-slopedirect(j)*(xrt(Irt1)-xrt(1));
                    end
                    t1_pktau = tpeak(j);
                    t1_tltau = ttail(j);
                    t2_tau = (epsclim1(j)+stiminterval(j)-0.001);  
                    axis([-0.01,epsclim2(j),-10,max(peaks)+10]);
                end
                options = optimset('Display','on','MaxFunEvals',5000,'MaxIter',5000);
                if (ttail(j)~= 0)
% --------- Find the Peak Area = area from the start of EPSC to tail 
%           AreaPeak & AreaTail for AMPA(post70) checked with ClampFit result
%           perfect match. Date: 20.01.2013
                    ta = t2(t2 > epsclim1(j) + epsclag & t2 <= ttail(j)); ta = ta-ta(1);
                    ya = y2(t2 > epsclim1(j) + epsclag & t2 <= ttail(j));
                    areapeak(j) = trapz(ta,ya)*1000;
% --------- Find the Tail Area = area from the tail of EPSC to end (50 ms for AMPA & 400 ms for NMDA)
                    ta = t2(t2 >= ttail(j) & t2 <= (epsclim1(j)+stiminterval(j)-0.001)); 
                    ya = y2(t2 >= ttail(j) & t2 <= (epsclim1(j)+stiminterval(j)-0.001));
                    if (length(ta) > 2 && length(ya) > 2)
                       ta = ta-ta(1); % t2_tau = xpeak+0.05 for AMPA & t(end) for NMDA
                       areatail(j) = trapz(ta,ya)*1000; % Area units = pA*msec
% --------- Compute PeakTau            
                        fhdecay = @(x,q) q(1) + q(2)*exp(-x./q(3));
                        errfhdecay = @(q,x,y) sum((y(:)-fhdecay(x(:),q)).^2);
% [offset scale tau] Better fit obtained for AMPA with offset = 0
                        initials_pktau = [0, peak(j), (t2_tau-t1_pktau)]; 
                        t2pk = t2((t2 >= t1_pktau) & (t2 <= t2_tau));t21pk = t2pk(1);t2pk = t2pk-t21pk;    
                        [params_pktau, ~, ~, ~] = fminsearch(errfhdecay,initials_pktau,options,t2pk,y2((t2 >=t1_pktau) & (t2 <= t2_tau)));
% --------- Compute TailTau 
                        initials_tltau = [0, tail(j), (t2_tau-t1_tltau)]; % [offset scale tau]
                        t2tl = t2((t2 >= t1_tltau) & (t2 <= t2_tau));t21tl = t2tl(1);t2tl = t2tl-t21tl;    
                        [params_tltau, ~, ~, ~] = fminsearch(errfhdecay,initials_tltau,options,t2tl,y2((t2 >= t1_tltau) & (t2 <= t2_tau)));
        
                        fyPk3 = fhdecay(t2pk,params_pktau); % Change here from pk to tl tvclamp=-70;
                        ftPk3 = t2pk+t21pk;
                
                        fyTl3 = fhdecay(t2tl,params_tltau); % Change here from pk to tl tvclamp=-70;
                        ftTl3 = t2tl+t21tl;
            
                        taupeak(j) = params_pktau(3);
                        tautail(j) = params_tltau(3);
                
%                        plot(ttail(j),tail(j),'ored','Markersize',5,'MarkerFaceColor','red');
                
%                        plot(ftPk3,fyPk3,'green','LineWidth',lw); % Plot the peak decay fit
%                       plot(ftTl3,fyTl3,'yellow','LineWidth',lw); % Plot the peak decay fit

                    end
                    
                end
% Compute risetime
                fhrt = @(x,p) p(1) + p(2)*x;
                errfhrt = @(p,x,y) sum((y(:)-fhrt(x(:),p)).^2);
                
                if (foundrt)
                    initials_rt = [yIntercept, slopedirect(j)]; % [yintercept, slope]
                    [params_rt, ~, ~, ~] = fminsearch(errfhrt,initials_rt,options,xrt(Irt1:Irt2),yrt(Irt1:Irt2));
                    slopefit(j) = params_rt(2);
                    frt = fhrt(xrt(Irt1:Irt2),params_rt);
                    hold on;
     %               plot(xrt(Irt1:Irt2),frt,'blue','LineWidth',lw); % Plot the risetime fit
                end
% Ploting the waves with peak, tail, rt & Tau
                plot(t2,y2,'Color',[0,0,0],'LineWidth',2); % Plot the trace
                plot(tpeak(j),peak(j),'ok','Markersize',7,'MarkerFaceColor','white');                
                plot([-0.01,epsclim2(j)],[0,0],'--black','Linewidth',1.5); % Plot the dotted zero line
                xlim([-0.02, 0.195]); % reptrace ss70100PPF
                ylim([-20, max(peak)+20]); % reptrace ss70100PPF
                % Draw scalebar
%                plot([0.03,0.05],[-100,-100],'black','LineWidth',2); % 20 ms Evoked Epsc reptrace -70
%                plot([0.05,0.05],[-60,-100],'black','LineWidth',2);  % 40 pA
                plot([0.12,0.14],[10,10],'black','LineWidth',2); % 40 ms Evoked Evoked Epsc reptrace +40
                plot([0.12,0.12],[10,20],'black','LineWidth',2);  % 20 pA Evoked
%            Evoked Epsc reptrace -70
            end       
        end
    end
    methods
        function A = EpscSupersumClass(cellinfo)
            A = A@EvokedEpscClass(cellinfo);
            A.NumStimulus = 10;
            A.avgyes = 0;
            A.folder = '~/DATA/ELS/ELSPlots/ss7050/new/';
        end
    end
end