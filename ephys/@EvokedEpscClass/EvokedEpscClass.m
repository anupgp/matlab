classdef EvokedEpscClass < handle 
    properties (SetAccess = 'private')
        FileName = '';
        GroupName = '';
        BrainRegion = '';
        CellID = ''; 
        RecMode = '';
        ExpType='';
        AnimalSource = '';
        CortStock = -1;
        AnimalBatch = -1;
        AnimalAlone = -1;
        IntSolBatch = -1;
        KConc = -1;
        CaConc = -1;
        MgConc = -1;
        ExpDate = 0; % Format: YYYYMMDD
        BirthDate = 0; % Format: YYYYMMDD
        TreatTime = 0; % Format: HHMM in 24Hr
        RecTime = 0; % Format: HHMM in 24Hr
        VRest = 0;
        CortLevel = 0;
        FilePath = '';
        Channel = '';
        Sweeps=[];        
    end
    properties (SetAccess = 'private')
        Psv = struct('BT1',0,'BT2',0,'RT2',0,'CmdStep',0);
        Epsc = struct('BT1',0,'BT2',0,'RT2',0);      
    end
    properties (Constant)
        AvgDur = struct('Pk',0.0001,'Tl',0.002); 
        TailDelay = 0.045;
    end
    properties (SetAccess = 'private')
        IV = struct('VStart',0,'VStep',0,'LJP',0);
    end
    properties(SetAccess = 'private')
        t = []; y = []; si = 0;
    end
    properties (SetAccess = 'public')
        NumStimulus = 1;
        InterStim=0;
        StimPos1 = 0;
        StimPos2 = 0;
        EpscLag = 0.002;
        avgyes = 1;
        PrintFolder = '~/DATA/ELS/ELS_Matlab_Plots/Evoked/MgFreeTest/RepTraces/';
    end
    properties(SetAccess = 'private',Dependent)        
        val = struct('Sweep',[],'VClampA',[],'VClampF',[],...
            'StimNum',[],'InterStimA',[],'InterStimF',[],...
            'Noise',[],'Base',[],...
            'SeriesRes',[],'InputRes',[],'TauMem',[],...            
            'Peak',[],'RiseTime',[],'Tail',[],'AreaTail',[],...
            'SlopeDirect',[],'SlopeFit',[],...
            'AreaPeak',[],'TauPeak',[],...
            'TauTail',[],...
            'TauFull',[],...
            'RevPeakUnCor',[],'RevTailUnCor',[],...
            'RevPeakCor',[],'RevTailCor',[]);
    end
    methods(Static = true)
        function [vclampf,base,noise,peak,tail,rt,slopedirect,slopefit,areapeak,areatail,taupeak,tautail,taufull,interstimf] = EpscMeasure(t,y,nSA,StimPos1,StimPos2,interstim,psv,epsc,epsclag,rtlim1,rtlim2,taildelay,avgdurP,avgdurT,peaks,sweep)
            % --------- Initialize all the vectors
            peak = zeros(nSA,1);tpeak = zeros(nSA,1);tail = zeros(nSA,1);ttail = zeros(nSA,1);
            taufull = zeros(nSA,1);vclampf = zeros(nSA,1);
            base = zeros(nSA,1);taupeak = zeros(nSA,1);tautail = zeros(nSA,1);rt = zeros(nSA,1);
            areapeak = zeros(nSA,1);areatail = zeros(nSA,1);
            slopefit = zeros(nSA,1);slopedirect = zeros(nSA,1); 
            % Get noise Standard deviation
            noiseSD = std(y(t >= epsc.BT1 & t <= epsc.BT2)-mean(y(t >= epsc.BT1 & t <= epsc.BT2))); 
            base(1:nSA) = mean(y(t >= epsc.BT1 & t <= epsc.BT2));
            % t & y are raw whole EPSC trace. nSA = number of Stimulations in the given EPSC trace
            % --------- Chop the waves to have the response alone for finding the SAs            
            y1 = y(t >= epsc.BT2 & t <= epsc.RT2); % Chop the y wave 
            t1 = t(t >= epsc.BT2 & t <= epsc.RT2); % Chop the t wave         
            % --------- Find all the Stimulus Artifact (SAs) positions
            [tSA, ~] = EvokedEpscClass.findSA(t1,y1-base(1),noiseSD,nSA,StimPos1,StimPos2,interstim);
            % --------- Call the baseline-fit function here 
            leftstart=psv.RT2+1;leftdelta=0.025;leftn=0;leftend=tSA(1)-0.001;
            rightstart=epsc.RT2;rightdelta=-0.025;rightn=0;rightend=tSA(end)+0.2;
            [t1,y1] = EvokedEpscClass.BFS(t(t>=leftstart & t<=rightstart),y(t>=leftstart & t<=rightstart),leftstart,leftdelta,leftn,leftend,rightstart,rightdelta,rightn,rightend); 
            y1 = y1-mean(y1(t1 >= epsc.BT1 & t1 <= epsc.BT2)); % Do a simple baseline substraction                          
            % --------- Computing the values interstim interval
            if (length(tSA)>1)
                interstimf = repmat(mean(diff(tSA)),length(tSA),1);
            else
                interstimf=0;
            end
            noiseall = sort(y1(t1 <= tSA(1))-0.001,'ascend'); % Get noise Amplitude
            noise(1:length(tSA)) = median(noiseall);
            % Generate two vectors to hold the left and right of each EPSC in the wave            
            epsclim1 = tSA; 
            epsclim2 = [tSA(2:end),epsc.RT2];
            % Determine if the EPSC is -ve (like at -70 mV for AMPA) or +ve (+40 mV for NMDA) from the first SA
            [ymin, ~] = min(y1(t1>tSA(1)+epsclag & t1<=tSA(1)+epsclag+0.01));
            [ymax, ~] = max(y1(t1>tSA(1)+epsclag & t1<=tSA(1)+epsclag+0.01));
            yavg = mean(y1(t1>tSA(1)+epsclag & t1<=tSA(1)+epsclag+0.01));
            % Loop for each Stimulus Artifact (nSA)            
            for j = 1:nSA
                % Normalize time axis with the first tSA(1), which become t = 0 
                t2 = t1(t1>=epsclim1(j) & t1<=epsclim2(j));
                t2 = t2-t2(1);
                y2 = y1(t1>=epsclim1(j) & t1<=epsclim2(j));
                t3 = t2(t2 >= (t2(1)+epsclag) & t2 <= (t2(1)+epsclag+0.03) );
                y3 = y2(t2 >= (t2(1)+epsclag) & t2 <= (t2(1)+epsclag+0.03) );
                if (abs(ymin)>abs(ymax) || yavg < 0 )
                    vclampf(j) = 1;
                    [ypeak, Ipeak] = min(y3);% Find minimum for negative EPSC
                else
                    vclampf(j) = -1;
                    [ypeak, Ipeak] = max(y3); % Find maximum for positive EPSC   
                end
                tpeak(j) = t3(Ipeak);
                peak(j) = mean(y3(t3 >= (tpeak-avgdurP) & t3 <= (tpeak+avgdurP)));
                ttail(j) = tpeak(j)+taildelay;
                tail(j) = mean(y2(t2 >= (tpeak(j)+taildelay-avgdurT) & t2 <= (tpeak(j)+taildelay+avgdurT)));
                foundrt1=0;foundrt2=0;findrtloop=0;
                while(~(foundrt1))
                    Irt1 = find(abs(y3(1:Ipeak)) <= rtlim1*abs(ypeak),1,'last'); 
                    if (isempty(Irt1)); rtlim1=rtlim1+0.01; fprintf('New rtlim1 = %d\n',rtlim1); else foundrt1=1; end;
                    findrtloop=findrtloop+1;
                    if (findrtloop>80); 
                        return; 
                    end;
                end
                findrtloop=0;
                while(~(foundrt2))
                    Irt2 = find(abs(y3(1:Ipeak)) <= rtlim2*abs(ypeak),1,'last');
                    if (isempty(Irt2)); rtlim2=rtlim2-0.01; fprintf('New rtlim2 = %d\n',rtlim2); else foundrt2=1; end; 
                    findrtloop=findrtloop+1;
                    if (findrtloop>80); 
                        return; 
                    end;
                end       
                % Compute risetime
                options = optimset('Display','off','MaxFunEvals',5000,'MaxIter',5000);
                if (~isempty(Irt1) && ~isempty(Irt2))
                    rt = t3(Irt2)-t3(Irt1);
                    slopedirect(j) = (y3(Irt2)-y3(Irt1))/rt;
                    yIntercept = y3(Irt2);  
                    fhrt = @(x,p) p(1) + p(2)*x;
                    errfhrt = @(p,x,y) sum((y(:)-fhrt(x(:),p)).^2);
                    initials_rt = [yIntercept, slopedirect]; % [yintercept, slope]
                    yrt = y3(Irt1:Irt2);
                    trt = t3(Irt1:Irt2);
                    trt = trt-trt(1);
                    [params_rt, ~, ~, ~] = fminsearch(errfhrt,initials_rt,options,trt,yrt);
                    slopefit(j) = params_rt(2);
                    frt = fhrt(trt,params_rt); 
                end 
                %======================================================
                % Compute decaytime
                % Peak Tau & Tail Tau is matching b/w ClampFit & Matlab for
                % NMDA & AMPA EPSCs. Date: 30.01.2013    
                fhexpdecaysingle = @(x,q) q(1) + q(2)*exp(-x./q(3));
                errfhexpdecaysingle = @(q,x,y) sum((y(:)-fhexpdecaysingle(x(:),q)).^2);
                fhexpdecaydouble = @(x,q) q(1) + q(2)*exp(-x./q(3)) + q(4)*exp(-x./q(5));
                errfhexpdecaydouble = @(q,x,y) sum((y(:)-fhexpdecaydouble(x(:),q)).^2);
                % --------
                initials_dkP = [0, peak(j), ( ttail(j)-tpeak(j) )]; % [offset scale tau]
                %LB = [-1, peak(j)*0.01, ( ttail(j)-tpeak(j) )*0.01]; % [offset scale tau]
                %UB = [1, peak(j)*10, ( ttail(j)-tpeak(j) )*1.5]; % [offset scale tau]
                [params_dkP, ~, ~, ~] = fminsearch(errfhexpdecaysingle,initials_dkP,options,t2(t2>=tpeak(j) & t2<=ttail(j))-tpeak(j) ,y2(t2>=tpeak(j) & t2<=ttail(j)));    
                %[params_dkP, ~, ~, ~] = fminsearchbnd(@(initials_dkP) errfhexpdecaysingle(initials_dkP,t2(t2>=tpeak(j) & t2<=ttail(j))-tpeak(j) ,y2(t2>=tpeak(j) & t2<=ttail(j))),initials_dkP,LB,UB,options);
                % ---------
                initials_dkT = [0, tail(j), ( t2(end)-ttail(j) )]; % [offset scale tau]
                %LB = [-1, tail(j)*0.01, ( t2(end)-ttail(j) )*0.01]; % [offset scale tau]
                %UB = [1, tail(j)*10, ( t2(end)-ttail(j) )*1.5]; % [offset scale tau]
                [params_dkT, ~, ~, ~] = fminsearch(errfhexpdecaysingle,initials_dkT,options,t2(t2>=ttail(j))-ttail(j) ,y2(t2>=ttail(j) ) );
                %[params_dkT, ~, ~, ~] = fminsearchbnd(@(intials_dkT) errfhexpdecaysingle(initials_dkT,t2(t2>=ttail(j))-ttail(j) ,y2(t2>=ttail(j))),initials_dkT,LB,UB,options);
                % ---------
                initials_dkF = [0,peak(j),( ttail(j)-tpeak(j) ),tail(j), ( t2(end)-ttail(j) )];% [offset scale1 tau1 scale2 tau2] 
                %LB = [-1, peak(j)*0.01, ( ttail(j)-tpeak(j) )*0.01,tail(j)*0.01,( t2(end)-ttail(j) )*0.01]; % [offset scale tau]
                %UB = [1, peak(j)*10, ( ttail(j)-tpeak(j) )*1.5,tail(j)*1.5,( t2(end)-ttail(j) )*1.5]; % [offset scale tau]           
                [params_dkF, ~, ~, ~] = fminsearch(errfhexpdecaydouble,initials_dkF,options,t2(t2>=tpeak(j))-(tpeak(j)) ,y2(t2>=tpeak(j)));
                %[params_dkF, ~, ~, ~] = fminsearchbnd(@(initials_dkF) errfhexpdecaydouble(initials_dkF,t2(t2>=tpeak(j))-tpeak(j) ,y2(t2>=tpeak(j))),initials_dkF,LB,UB,options);
                fdkP = fhexpdecaysingle(t2(t2>=tpeak(j) & t2<=ttail(j))-tpeak(j),params_dkP); 
                fdkT = fhexpdecaysingle(t2(t2>=ttail(j))-ttail(j),params_dkT);
                fdkF = fhexpdecaydouble(t2(t2>=tpeak(j))-(tpeak(j)+0.001),params_dkF);    
                taupeak(j) = params_dkP(3);
                tautail(j) = params_dkT(3);
                taufull(j) = params_dkF(3)+params_dkF(5);
                %===========================================
                % Find the Peak Area = area from the start of EPSC to tail 
                % AreaPeak,AreaTail & Risetime for AMPA(pre70) & NMDA(pre40) checked with ClampFit result
                % and found a perfect match. Date: 30.01.2013
                ta = t2(t2 > (t2(1) + epsclag) & t2 <= ttail(j) ); 
                ta = ta-ta(1);
                ya = y2(t2 > (t2(1) + epsclag) & t2 <= ttail(j));
                areapeak(j) = trapz(ta,ya)*1000;
                % Find the Tail Area = area from the tail of EPSC to end (50 ms for AMPA & 400 ms for NMDA) 
                ta = t2(t2 >= ttail(j) ); 
                ta = ta-ta(1);
                ya = y2(t2 >= ttail(j) ); 
                areatail(j) = trapz(ta,ya)*1000; % Area units = pA*msec                    
                %===========================================
                % Ploting the waves 
                %axis([-0.005,t2(end),min([min(peaks),min(peak),0])-20,max([max(peaks),min(peak),0])+20]);% for analysis
                axis([-0.005,0.25,min([min(peaks),min(peak),0])+(mean(peaks)*0.2),max([max(peaks),min(peak),0])+abs(mean(peaks)*0.2)]);% for rep figure
                if (sweep == -1) % for the average trace
                    %col = [0.25,0.25,0.25]; % for analysis
                    col = [0.55,0.55,0.55]; % for rep figure
                    lw = 7;
                    ls='-';
                    plot(t2,y2,'Color',col,'LineWidth',lw); % Plot the trace for rep figure
                    hold on;
                    if(exist('frt','var'))
                        plot(t3(Irt1:Irt2),frt,'Color',[0,0,0],'LineWidth',1.5); % Plot for rep figure: the risetime fit 
                    end
                    plot(t2(t2>=(tpeak(j))),fdkF,'Color',[0,0,0],'LineStyle',ls,'LineWidth',1.5); % Plot for rep figure: Peak epsc decay
                else
                    col = [0.8,0.8,0.8];
                    lw = 1;
                    ls='-';
                    plot(t2,y2,'Color',col,'LineWidth',lw); % Plot the trace for rep figure
                end;
                
                
                hold on;
                %plot(tpeak,peak,'Color',[0,1,0],'Marker','o','Markersize',10,'MarkerFaceColor',[0,1,0],'LineWidth',2);% for analysis
                plot(tpeak,peak,'Color',[0,0,0],'Marker','o','Markersize',5,'MarkerFaceColor',[1,1,1],'LineWidth',1);% for rep figure
                %plot(ttail,tail,'Color',[1,0,0],'Marker','s','Markersize',10,'MarkerFaceColor',[1,0,0],'LineWidth',2);% for analysis
                %plot(ttail,tail,'Color',[0,0,0],'Marker','s','Markersize',10,'MarkerFaceColor',[1,1,1],'LineWidth',1);% for rep figure  
                %plot(t2,y2,'Color',[0,0,0],'LineWidth',2); % Plot the trace
                %plot(tpeak,peak,'Color',[0.4,0.4 0.4],'Marker','s','Markersize',6,'MarkerFaceColor',[0.4,0.4 0.4]);
                %plot(ttail,tail,'Color',[0.4,0.4,0.4],'Marker','v','Markersize',10,'MarkerFaceColor',[0.4,0.4,0.4]);
                if(exist('frt','var'))
                    %plot(t3(Irt1:Irt2),frt,'Color',[1,1,0],'LineWidth',1); % Plot for analysis: the risetime fit with yellow 
                end
                %plot(t2(t2>=tpeak(j) & t2<=ttail(j)),fdkP,'Color',[1,0,1],'LineStyle',ls,'LineWidth',1); %Peak decay magenta
                %plot(t2(t2>=ttail(j)),fdkT,'Color',[1,0,0],'LineStyle',ls,'LineWidth',1); %Tail decay red
                %plot(t2(t2>=tpeak(j)),fdkF,'Color',[0,0,1],'LineStyle',ls,'LineWidth',1); %Full epsc decay blue
                plot([-0.01,epsclim2(j)],[0,0],'Color',[0,0,0],'LineStyle','--','LineWidth',1); % Dotted zero line balck
                %set(gca,'XColor','w');set(gca,'XTick',[]);set(gca,'YColor','w');set(gca,'YTick',[]);
                % Draw scalebar
                %plot([0.08,0.1],[peak-20-(peak/4),peak-20-(peak/4)],'black','LineWidth',2); % 20 ms Evoked Epsc reptrace -70
                %plot([0.1,0.1],[peak-20-(peak/4),peak-(peak/4)],'black','LineWidth',2);  % 20 pA 
            end 
        end
        function [tSA ySA] = findSA(t,y,sdev,nSA,stimpos1,stimpos2,interstim) % Detect Stimulus Artifact           
            % --------- Get all peaks > 3*sdev
            [~, allminy, allmaxt, allmaxy] = simplepeak(t,y,(1*sdev)); %1*sdev
            tSA = zeros(nSA,1); ySA = zeros(nSA,1);     
            % ---------- Get all the peak within the stimulus positions 
            pos1 = stimpos1;pos2 = stimpos2;
            for i = 1: nSA
                maxt = allmaxt(allmaxt>pos1 & allmaxt<pos2);
                maxy = allmaxy(allmaxt>pos1 & allmaxt<pos2);
                miny=allminy(allmaxt>pos1 & allmaxt<pos2);
                % ----------- Find the maximum stimulus
                maxmins = abs(maxy-miny);
                idxPmaxmins = find(maxmins==max(maxmins));
                tSA(i) = maxt(idxPmaxmins(1));
                ySA(i) = maxy(idxPmaxmins(1));
                pos1 = pos1+interstim; pos2 = pos2+interstim;
            end
            %plot(t,y,'black');hold on;     
        end
        function [t4,ysub] = BFS(t1,y1,leftstart,leftdelta,leftn,leftend,rightstart,rightdelta,rightn,rightend) % BaselineFitSubstract
            % Using the polyfit function a 5 degree polynomial is fit to the sampled points
            % The fitted polynomial is evaluated for the entire time trace from the orginal wave.
            % Then y2 = y1-y1fit; t2=t1;            
            % --------- Generate t3,y3,the subsampled wave from t1,y1
            leftall = (leftstart:leftdelta:leftend);
            if (leftn <= length(leftall) && leftn ~= 0) 
                leftall  = leftall(1:leftn);
            end                
            rightall = (rightstart:rightdelta:rightend);
            if (rightn <= length(rightall) && rightn ~=0)
                rightall = rightall(1:rightn);
            end
            t3 = [sort(leftall),sort(rightall)];
            y3 = zeros(size(t3));
            for i = 1:length(t3)
                y3(i) = y1(find(t1>=t3(i),1,'first'));
            end
% --------- 5 degree langrange-polynomial fit to the new wave
            pfit = polyfit(t3,y3,5);
% --------- Evaluate the fit on the orginal wave t1
            t4 = t1;
            yfit = polyval(pfit,t4);
% --------- Substract the orginal y from the fit
            ysub = y1-yfit;
        end
        function [revpeak,revtail] = findreversal(vclamp,peak,tail)
            % --------  IV reversal function
            fhIVrv = @(x,p) p(1) + p(2)*x; 
            errfhIVrv = @(p,x,y) sum((y(:)-fhIVrv(x(:),p)).^2);
            options = optimset('Display','on','MaxFunEvals',5000,'MaxIter',5000);
            % voltage values for IV fit:. Add one point before and one
            % point aftet zero cross
            peak=peak/max(peak);
            tail=tail/max(tail);
            vIVp = vclamp((find(peak<0,1,'last')): (find(peak<0,1,'last')+1),1); % voltage values for IV fit
            iIVp = peak((find(peak<0,1,'last')): (find(peak<0,1,'last')+1),1); % peak values for IV fit
            [IVFp,~,~,~] = fminsearch(errfhIVrv,[iIVp(1),mean(diff(iIVp)/diff(vIVp))],options,iIVp,vIVp);
            vIVRp = fhIVrv(0,IVFp);
            vIVt = vclamp((find(tail<0,1,'last')): (find(tail<0,1,'last')+1),1); % voltage values for IV fit
            iIVt = tail((find(tail<0,1,'last')): (find(tail<0,1,'last')+1),1); % tail values for IV fit
            [IVFt,~,~,~] = fminsearch(errfhIVrv,[iIVt(1),mean(diff(iIVt)/diff(vIVt))],options,iIVt,vIVt);
            vIVRt = fhIVrv(0,IVFt);
            %-----------Ploting IV
            plot(vclamp,peak,'Color',[0,0,0],'Marker','s','Markersize',10,'LineWidth',1.5,'MarkerFaceColor',[1,1,1]);
            hold on;
            plot(vclamp,tail,'Color',[0,0,0],'Marker','v','Markersize',10,'LineWidth',1.5,'MarkerFaceColor',[1,1,1]);
            plot(vIVp,iIVp,'Color',[0,0,0],'LineStyle','-','LineWidth',3); % plots the linear fit for peak               
            plot(vIVt,iIVt,'Color',[0.4,0.4,0.4],'LineStyle','-','LineWidth',3); % plots the liner fit for tail    
            plot(vIVRp,0,'Color',[0,0,0],'Marker','s','Markersize',10,'MarkerFaceColor',[0.5,0.5,0.5]);
            plot(vIVRt,0,'Color',[0,0,0],'Marker','v','Markersize',10,'MarkerFaceColor',[0.5,0.5,0.5]);
            axis([-100, 40, min([peak;tail])/max(peak),1]);
            set(gca,'XTick',-100:20:40)
            %opt.fontsize=20;
            %opt.fontname='Arial';
            set(gca,'FontName','Arial','Fontsize',20,'LineWidth',2);
            centeraxes(gca); 
            revpeak=vIVRp;
            revtail=vIVRt;
                       
        end
        function psv = PsvVClampMeasure(t,y,psv)
            % ------------- Compute Passive
            base = mean(y(t >=psv.BT2-0.001 & t <= psv.BT2)); 
            y1 = y(t >=psv.BT2-0.001 & t < psv.RT2);
            t1 = t(t >=psv.BT2-0.001 & t < psv.RT2); 
            y1= y1-base;
            [y1min, Iy1min] = min(y1); 
            %[~, Iy1RT2] = find(t1 >=psv.RT2,1,'first');
            t1 = t1(Iy1min:end);
            y1 = y1(Iy1min:end);
            InputRes = abs(psv.CmdStep/(mean(y1(t1 > psv.RT2-0.1 & t1 < psv.RT2)) * 1E-12) ); % I in pA, R in ohm
            SeriesRes = abs(psv.CmdStep/(y1min * 1E-12) ); % I in pA, R in ohm
            % ------------ Function to fit the decay
            % errfh = @(p,x,y) sum((y(:)-VClampPsv(x(:),p)).^2);
            function sse = Fit_VClampPsv(t,y,params,offset,v_inj)
            %---------------Obtain the simulated v and t
                [~, yf] = VClampPsv(t,params,offset,v_inj);
                sse = sum((y-yf).^2);
            end
            options = optimset('Display','off','MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-10);
            initial_psv = [SeriesRes, InputRes, 0.0001, 0.01]; % [rp rm taup taum]
            LB = [SeriesRes*0.75, InputRes*0.75,0.00005, 0.001];
            UB = [SeriesRes*1.25, InputRes*1.25,0.01, 0.05];
            [params, ~, fitok, ~] = fminsearchbnd(@(initial_psv) Fit_VClampPsv(t1,y1*1E-12,initial_psv,0,psv.CmdStep),initial_psv,LB,UB,options);
            [tf,yf] = VClampPsv(t1,params,0,psv.CmdStep);
            plot(t1,y1*1E-12,'red');
            if (fitok)
                %disp('Passive fit ok');
                plot(tf,yf,'black','LineWidth',1);
                hold on;
                psv.MTau = params(3)+params(4);
            else
                disp('No Fitting performed');
                psv.MTau = 0;
            end
            psv.SeriesRes = SeriesRes;
            psv.InputRes = InputRes;
        end
    end
    methods
        function A = EvokedEpscClass(cellinfo)
            fname = char(cellinfo.FileName);
            fn_idxstart = max(regexp(fname,'\/','end'));
            fn_idxend = regexp(fname,'.abf','end');
            A.FileName = fname(fn_idxstart+1:fn_idxend-4);
            A.FilePath = fname(1:fn_idxstart);
            A.GroupName = char(cellinfo.GroupName);
            A.BrainRegion = char(cellinfo.BrainRegion);
            A.AnimalSource = char(cellinfo.AnimalSource);
            A.CortStock = cellinfo.CortStock;
            A.AnimalBatch = cellinfo.AnimalBatch;
            A.AnimalAlone = cellinfo.AnimalAlone;
            A.IntSolBatch = cellinfo.IntSolBatch;
            A.KConc = cellinfo.KConc;
            A.CaConc = cellinfo.CaConc;
            A.MgConc = cellinfo.MgConc;
            A.ExpDate = cellinfo.ExpDate;
            A.BirthDate = cellinfo.BirthDate;
            A.TreatTime = cellinfo.TreatTime;
            A.RecTime = cellinfo.RecTime;
            A.VRest = cellinfo.VRest;
            A.Channel = cellinfo.Channel;
            A.NumStimulus = cellinfo.NStim;
            A.StimPos1 = cellinfo.StimPos1;
            A.StimPos2 = cellinfo.StimPos2;
            A.InterStim = cellinfo.InterStim;
            A.RecMode = cellinfo.RecMode;
            A.ExpType = cellinfo.ExpType;
            A.Sweeps = sort(cellinfo.Sweeps);
            A.CellID = [num2str(A.ExpDate),fname(regexp(fname,'[A-Z,1-9]{2}_'):regexp(fname,'[A-Z,1-9]{2}_')+1)];
            A.CortLevel = cellinfo.CortLevel;
            [A.y A.si] = abfload([A.FilePath, A.FileName, '.abf'],'channels',{A.Channel},'sweeps',A.Sweeps);
            A.y = reshape(A.y,size(A.y,1),size(A.y,3)) * cellinfo.ScaleFactor;
            A.si=A.si*1E-06;
            A.t = (0:A.si:(size(A.y,1)-1)*A.si)';
            A.Psv.BT1 = cellinfo.PsvBT1; A.Psv.BT2 = cellinfo.PsvBT2; A.Psv.RT2 = cellinfo.PsvRT2; A.Psv.CmdStep = cellinfo.CmdStep;
            A.Epsc.BT1 = cellinfo.EpscBT1; A.Epsc.BT2 = cellinfo.EpscBT2; A.Epsc.RT2 = cellinfo.EpscRT2;
            A.IV.VStart = 0;
            A.IV.VStep = 0;
            A.IV.LJP = 0;
            if (isfield(cellinfo,'IVStart'))
                A.IV.VStart = cellinfo.IVStart;
            end
            if (isfield(cellinfo,'IVStep'))
                A.IV.VStep = cellinfo.IVStep;
            end
            if (isfield(cellinfo,'LJP')) % LJP: Liquid Junction Potential
                A.IV.LJP = cellinfo.LJP;
            end
        end
        function val = get.val(A)            
% -Initialize Passive
            val.SeriesRes = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.InputRes = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.TauMem = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
% -Initialize Supersum params
            val.Sweep = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.VClampA = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1);% The sweep (-1) is the averaged sweep
            val.VClampF = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1);% The sweep (-1) is the averaged sweep
            val.Noise = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1);% The sweep (-1) is the averaged sweep  
            val.Base = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1);% The sweep (-1) is the averaged sweep  
            val.Peak = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.RiseTime = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.Tail = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.AreaPeak = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.AreaTail = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.TauPeak = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.TauTail = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.TauFull = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.SlopeDirect = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.SlopeFit = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.StimNum = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.InterStimA = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.InterStimF = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.RevPeakUnCor = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.RevTailUnCor = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.RevPeakCor = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
            val.RevTailCor = zeros((length(A.Sweeps)+A.avgyes)*A.NumStimulus,1); % The sweep (-1) is the averaged sweep
% ----------            
            fhand = gcf; %fhand=figure; % generate a figure window once
            set(0,'CurrentFigure',fhand); %clf(gcf,'reset'); % select the figure and clear it
            for i = 1: length(A.Sweeps)               
                psv= A.PsvVClampMeasure(A.t,A.y(:,i),A.Psv);
                % ------------- Set passive values
                val.SeriesRes(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = psv.SeriesRes;
                val.InputRes(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = psv.InputRes;
                val.TauMem(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) =  psv.MTau;
            end
% --------- Compute average Passive
            if (A.avgyes)
                i = i+1;
                yavg = sum(A.y,2)./length(A.Sweeps);
                psv= A.PsvVClampMeasure(A.t,yavg,A.Psv);
% ------------- Set passive values
                val.SeriesRes(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = psv.SeriesRes;
                val.InputRes(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = psv.InputRes;
                val.TauMem(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) =  psv.MTau;
            end            
            plotname = [num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_PSV.jpg'];
            title([num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_PSV'],'Interpreter','none');
            print(fhand,'-djpeg',['-r','300'],[A.PrintFolder,plotname]);
            set(0,'CurrentFigure',fhand); %clf(gcf,'reset'); % select the figure and clear it
            hold off;
% ----------  Processing Evoked EPSCs  
            %set(gca,'box','off');
            %axis off;
            epsclag = A.EpscLag;
            for i = 1: length(A.Sweeps)
                fprintf('The Sweep = %d\n',A.Sweeps(i));
                [vclampf,base,noise,peak,tail,rt,slopedirect,slopefit,areapeak,areatail,taupeak,tautail,taufull,interstim] = A.EpscMeasure(A.t,A.y(:,i),A.NumStimulus,A.StimPos1,A.StimPos2,A.InterStim,A.Psv,A.Epsc,epsclag,0.2,0.8,A.TailDelay,A.AvgDur.Pk,A.AvgDur.Tl,val.Peak,A.Sweeps(i));                  
% - Set values
                val.Sweep(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.Sweeps(i);   
                val.VClampF(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = vclampf;
                val.VClampA(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.IV.VStart+(A.IV.VStep*(i-1));
                val.StimNum(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.NumStimulus;
                val.InterStimF(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = interstim;
                val.InterStimA(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.InterStim;
                val.Peak(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = peak;
                val.Noise(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = noise;
                val.Base(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = base;
                val.RiseTime(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = rt;               
                val.Tail(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = tail;
                val.AreaPeak(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = areapeak;
                val.AreaTail(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = areatail;
                val.TauPeak(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = taupeak;
                val.TauTail(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = tautail;
                val.TauFull(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = taufull;
                val.SlopeDirect(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = slopedirect;
                val.SlopeFit(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = slopefit;                 
            end 
            if (A.avgyes == 1)
                i = i+1;
                 disp('The Averaged Sweep');
% - Generate the averaged trace            
                yavg = sum(A.y,2)./length(A.Sweeps);
% - Process the averaged trace
                [vclampf,base,noise,peak,tail,rt,slopedirect,slopefit,areapeak,areatail,taupeak,tautail,interstim] = A.EpscMeasure(A.t,yavg,A.NumStimulus,A.StimPos1,A.StimPos2,A.InterStim,A.Psv,A.Epsc,epsclag,0.2,0.8,A.TailDelay,A.AvgDur.Pk,A.AvgDur.Tl,val.Peak,-1);
% - Set values for the averaged trace
                val.Sweep(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) =  -1; % Sweep -1 is the averagred trace
                val.VClampF(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = vclampf;
                val.VClampA(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.IV.VStart+(A.IV.VStep*(i-1));
                val.StimNum(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.NumStimulus;
                val.InterStimF(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = interstim;
                val.InterStimA(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = A.InterStim;
                val.Peak(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = peak;
                val.Noise(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = noise;
                val.Base(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = base;
                val.RiseTime(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = rt;               
                val.Tail(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = tail;
                val.AreaPeak(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = areapeak;
                val.AreaTail(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = areatail;
                val.TauPeak(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = taupeak;
                val.TauTail(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = tautail;
                val.TauFull(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = taufull;
                val.SlopeDirect(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = slopedirect;
                val.SlopeFit(A.NumStimulus*(i-1)+1:A.NumStimulus*i,1) = slopefit;
            end
            plotname = [num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_EPSC.jpg'];
            title([num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_EPSC'],'Interpreter','none');
            print(fhand,'-djpeg',['-r','300'],[A.PrintFolder,plotname]);
            set(0,'CurrentFigure',fhand); %clf(gcf,'reset'); % select the figure and clear it
            hold off;
            % --------- Compute the reversal potential
            if (A.IV.VStep ~= 0 && A.IV.VStart ~=0)
                [revpeakuncor,revtailuncor] = A.findreversal(val.VClampA(1:length(A.Sweeps)),val.Peak(1:length(A.Sweeps)),val.Tail(1:length(A.Sweeps)));
                val.RevPeakUnCor = repmat(revpeakuncor,size(val.RevPeakUnCor));
                val.RevTailUnCor = repmat(revtailuncor,size(val.RevPeakUnCor));
                plotname = [num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_EPSCIVUnCor.jpg'];
                title([num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_EPSCIVUnCor'],'Interpreter','none');
                print(fhand,'-djpeg',['-r','300'],[A.PrintFolder,plotname]);
                set(0,'CurrentFigure',fhand); %clf(gcf,'reset'); % select the figure and clear it
                hold off;
                % Whole cell LJP correction: VClamp = VClamp-LJP  
                [revpeakcor,revtailcor] = A.findreversal(val.VClampA(1:length(A.Sweeps))-A.IV.LJP,val.Peak(1:length(A.Sweeps)),val.Tail(1:length(A.Sweeps)));
                val.RevPeakCor = repmat(revpeakcor,size(val.RevPeakCor));
                val.RevTailCor = repmat(revtailcor,size(val.RevPeakCor));
                plotname = [num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_EPSCIVCor.jpg'];
                title([num2str(A.ExpDate),A.FileName(1:regexpi(A.FileName,'[[A-Z]1-9]_{1}')),'_',A.GroupName,'_',A.RecMode,'_EPSCIVCor'],'Interpreter','none');
                print(fhand,'-djpeg',['-r','300'],[A.PrintFolder,plotname]);
                set(0,'CurrentFigure',fhand); %clf(gcf,'reset'); % select the figure and clear it
                hold off;
            end
        end
    end
end
