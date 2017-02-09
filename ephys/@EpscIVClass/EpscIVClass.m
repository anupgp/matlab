classdef EpscIVClass < EvokedEpscClass 
    methods(Static=true)
        function [vclamp,noise,peak,tail,rt,slopedirect,slopefit,areapeak,areatail,taupeak,tautail,stimnum,stiminterval,revpeak,revtail] = EpscMeasure(t,y,nSA,psvRT2,BT1,BT2,RT2,epsclag,rtlim1,rtlim2,taildelay,avgdurP,avgdurT,col,lw,peaks,vstart,vdelta,ljp,sweep)
% --------- t & y are raw whole EPSC trace. nSA = number of Stimulations in the given EPSC trace
            y1 = y-mean(y(t >= BT1 & t <= BT2)); % Do a simple baseline substraction
            noiseSD = std(y1(t >= BT1 & t <= BT2)); % Get noise Standard deviation
% --------- Chop the waves to have the response alone for finding the SAs            
            y1 = y1(t >= BT2 & t <= RT2); % Chop the y wave 
            t1 = t(t >= BT2 & t <= RT2); % Chop the t wave              
% --------- Find all the Stimulus Artifact (SAs) positions 
            [tSA, ySA] = EvokedEpscClass.findSA(t1,y1,noiseSD,nSA);
            orgtSA = tSA;
% --------- Initialize all the vectors
            peak = zeros(nSA,1);tpeak = zeros(nSA,1);tail = zeros(nSA,1);ttail = zeros(nSA,1);
            base = zeros(nSA,1);taupeak = zeros(nSA,1);tautail = zeros(nSA,1);rt = zeros(nSA,1);
            areapeak = zeros(nSA,1);areatail = zeros(nSA,1);
            slopefit = zeros(nSA,1);slopedirect = zeros(nSA,1);
            revpeak = zeros(nSA,1);revtail=zeros(nSA,1);            
% --------- Computing the values for stimnum & stiminterval
            stimnum = 1:length(tSA);stiminterval = repmat(mean(diff(tSA)),length(tSA),1);            
            noiseall = sort(y1(t1 <= orgtSA(1))-0.001,'ascend'); % Get noise Amplitude
            noise(1:length(tSA)) = median(noiseall);
% --------  Risetime fit function
            fhrt = @(x,p) p(1) + p(2)*x;
            errfhrt = @(p,x,y) sum((y(:)-fhrt(x(:),p)).^2);
% --------  Tau fit function
            fhdecay = @(x,q) q(1) + q(2)*exp(-x./q(3));
            errfhdecay = @(q,x,y) sum((y(:)-fhdecay(x(:),q)).^2);
            options = optimset('Display','on','MaxFunEvals',5000,'MaxIter',5000);
% --------- Loop for each Stimulus Artifact (nSA)            
            for j = 1:nSA
                vclamp = vstart+(vdelta*(sweep-1));
                fprintf('VClamp = %d\n',vclamp);  
                y1 = y(t >= psvRT2+1 & t <= RT2);
                t1 = t(t >= psvRT2+1 & t <= RT2);
% Normalize time axis with the first tSA(1), which become t = 0 
                t1 = t1-tSA(1);
% Normalize tSA to take into account of normalizing the time axis
                tSA = tSA-tSA(1);
% --------- Generate two vectors to hold the left and right of each EPSC in the wave            
                epsclim1 = tSA; 
                epsclim2 = [tSA(2:end),RT2-orgtSA(1)];                   
% --------- Set values for Baseline fit substraction
                leftstart=t1(1);leftdelta=0.025;leftn=0;leftend=tSA(1)-0.002;
                rightstart=t1(end);rightdelta=-0.025;rightn=0;rightend=tSA(end)+0.3;
                [t2,y2] = EvokedEpscClass.BFS(t1,y1,leftstart,leftdelta,leftn,leftend,rightstart,rightdelta,rightn,rightend); 
                y2 = y2-mean( y2(t2 >= (BT1-orgtSA(1)) & t2 <= (BT2-orgtSA(1))) ); % average baseline substraction
                base(j) = mean(y2(t2 >= (BT1-orgtSA(1)) & t2 <= (BT2-orgtSA(1))));
                y2 = y2(t2 >= (BT2-orgtSA(1)) & t2 <= epsclim2(end)); % Chop the y wave 
                t2 = t2(t2 >= (BT2-orgtSA(1)) & t2 <= epsclim2(end)); % Chop the t wave
% --------- Find the maximum and minimum values
                [ymax imax] = max(y2(t2 > epsclim1(j) + epsclag & t2 <= epsclim1(j) + 0.015));
                [ymin,imin] = min(y2(t2 > epsclim1(j) + epsclag & t2 <= epsclim1(j) + 0.015));
% --------- Assign peak value = maximum(abs(ymax),abs(ymin))
                if (abs(ymin)>abs(ymax))
                    tpeak(j) = t2(imin)+(epsclim1(j)-t2(1))+epsclag;
                    peak(j) = mean(y2(t2 >= (tpeak(j)-avgdurP) & t2 <= (tpeak(j)+avgdurP)));
                else
                    tpeak(j) = t2(imax)+(epsclim1(j)-t2(1))+epsclag;
                    peak(j) = mean(y2(t2 >= (tpeak(j)-avgdurP) & t2 <= (tpeak(j)+avgdurP)));
                end
                tail(j) = mean(y2(t2 >= (tpeak(j)+taildelay-avgdurT) & t2 <= (tpeak(j)+taildelay+avgdurT)));
                ttail(j) = tpeak(j)+taildelay;
                yrt = y2((t2 > epsclim1(j) + epsclag) & (t2 <= tpeak(j)));
                xrt = t2((t2 > epsclim1(j) + epsclag) & (t2 <= tpeak(j)));
                Irt1 = find(abs(yrt) <= (rtlim1 * abs(peak(j)-base(j))),1,'last');
                Irt2 = find(abs(yrt) <= (rtlim2 * abs(peak(j)-base(j))),1,'last');
                if (isempty(Irt1) || isempty(Irt2))
                    disp('Error: Risetime bounderies could not be found');
                    return;
                end
                rt(j) = xrt(Irt2)-xrt(Irt1);
                slopedirect(j) = (yrt(Irt2)-yrt(Irt1))/rt;
                yIntercept = yrt(Irt1)-slopedirect*(xrt(Irt1)-xrt(1));
                t1_pktau = tpeak(j);
                t1_tltau = ttail(j);
                t2_tau = tpeak+0.250;
                xlim([-0.01,t2_tau]); %min(peaks)-10,max(peaks)+50]);                       
% --------- Find the Peak Area = area from the start of EPSC to tail 
%           AreaPeak,AreaTail & Risetime for AMPA(pre70) & NMDA(pre40) checked with ClampFit result
%           perfect match. Date: 30.01.2013
                ta = t2(t2 > epsclim1(j) + epsclag & t2 <= ttail(j)); ta = ta-ta(1);
                ya = y2(t2 > epsclim1(j) + epsclag & t2 <= ttail(j));
                areapeak(j) = trapz(ta,ya)*1000;
% --------- Find the Tail Area = area from the tail of EPSC to end (50 ms for AMPA & 400 ms for NMDA) 
                ta = t2(t2 >= ttail(j) & t2 <= t2_tau); ta = ta-ta(1); % t2_tau = xpeak+0.05 for AMPA & t(end) for NMDA
                ya = y2(t2 >= ttail(j) & t2 <= t2_tau);
                areatail(j) = trapz(ta,ya)*1000; % Area units = pA*msec
% Compute risetime                           
                initials_rt = [yIntercept, slopedirect(j)]; % [yintercept, slope]
                [params_rt, ~, ~, ~] = fminsearch(errfhrt,initials_rt,options,xrt(Irt1:Irt2),yrt(Irt1:Irt2));
                slopefit(j) = params_rt(2);
                frt = fhrt(xrt(Irt1:Irt2),params_rt);
%               Peak Tau & Tail Tau is matching b/w ClampFit & Matlab for
%               NMDA & AMPA EPSCs. Date: 30.01.2013
% Compute PeakTau            
                
                % [offset scale tau] Better fit obtained for AMPA with offset = 0
                initials_pktau = [0, peak(j), (t2_tau-t1_pktau)]; 
                t2pk = t2((t2 >= t1_pktau) & (t2 <= t2_tau));t21pk = t2pk(1);t2pk = t2pk-t21pk;    
                [params_pktau, ~, ~, ~] = fminsearch(errfhdecay,initials_pktau,options,t2pk,y2((t2 >=t1_pktau) & (t2 <= t2_tau)));
% Compute TailTau 
                initials_tltau = [0, tail(j), (t2_tau-t1_tltau)]; % [offset scale tau]
                t2tl = t2((t2 >= t1_tltau) & (t2 <= t2_tau));t21tl = t2tl(1);t2tl = t2tl-t21tl;    
                [params_tltau, ~, ~, ~] = fminsearch(errfhdecay,initials_tltau,options,t2tl,y2((t2 >= t1_tltau) & (t2 <= t2_tau)));        
                fyPk3 = fhdecay(t2pk,params_pktau); 
                ftPk3 = t2pk+t21pk;                
                fyTl3 = fhdecay(t2tl,params_tltau); 
                ftTl3 = t2tl+t21tl;            
                taupeak(j) = params_pktau(3);
                tautail(j) = params_tltau(3);
% Ploting the waves with peak, tail, rt & Tau
                plot(t2,y2,'Color',[0.4,0.4,0.4],'LineWidth',2); % Plot the trace
                plot(tpeak,peak,'Color',[0,0,0],'Marker','o','Markersize',10,'MarkerFaceColor',[1,1,1],'LineWidth',2);
                plot(ttail,tail,'Color',[0,0,0],'Marker','s','Markersize',10,'MarkerFaceColor',[1,1,1],'LineWidth',2);
                
                %plot(xrt(Irt1:Irt2),frt,'blue','LineWidth',lw); % Plot the risetime fit
                %plot(ftPk3,fyPk3,'green','LineWidth',lw); % Plot the peak decay fit
                %plot(ftTl3,fyTl3,'yellow','LineWidth',lw); % Plot the peak decay fit
                plot([-0.01,epsclim2(j)],[0,0],'--black','LineWidth',2); % Plot the dotted zero line
                % Axes scaling
                xlim([-0.02, 0.150]); % reptrace ss70100PPF
                ylim([min(peaks), max(peaks)+40]); % reptrace ss70100PPF
                % Draw scalebar
                plot([0.12,0.14],[50,50],'black','LineWidth',2); % 40 ms Evoked Evoked Epsc reptrace +40
                plot([0.12,0.12],[50,70],'black','LineWidth',2);  % 20 pA Evoked,20],'black','LineWidth',2);  % 20 pA Evoked
            end  
        end
    end
    methods
        function A = EpscIVClass(cellinfo)
            A = A@EvokedEpscClass(cellinfo);
            A.NumStimulus = 1;
            A.avgyes = 0;
            A.folder = '~/DATA/ELS/ELS_Matlab_Plots/IV/';
        end
    end
end