classdef AhpClass < handle 
    properties (SetAccess = 'private')
        FileName = '';
        GroupName = '';
        BrainRegion = '';
        CellID = ''; 
        ExpDate = 0; % Format: YYYYMMDD
        BirthDate = 0; % Format: YYYYMMDD
        TreatTime = 0; % Format: HHMM in 24Hr
        RecTime = 0; % Format: HHMM in 24Hr
        VRest = 0;        
        FilePath = '';
        Channel = '';
        Sweeps=[];        
    end
    properties (SetAccess = 'private')
        Psv = struct('BT1',0,'BT2',0,'RT2',0,'CmdStep',0);
        Ahp = struct('BT1',0,'BT2',0,'RT1',0,'RT2',0,'CmdStep',0,'WinMed',0.003,'WinSlow',0.010,'OffsetMed',0,'OffsetSlow',0.400)    
    end
    properties (SetAccess = 'private')
        IV = struct('VStart',0,'VDelta',0,'LJP',0);
    end
    properties(SetAccess = 'private')
        t = []; y = []; si = 0;
    end
    properties (SetAccess = 'public')
        %folder = '~/DATA/AHP/Blockers/PFC_IL/Plots/';
        folder = '~/DATA/AHP/Blockers/Plots/400/';
        %folder = '~/DATA/AHP/Blockers/OFC/Plots/500/';
        %folder = '~/DATA/AHP/AHP_HC/Plots/400_2/';
        %folder = '~/DATA/AHP/AHP_OFC/Plots/400_2/';
        %folder = '~/DATA/AHP/AHP_PFC_PL/Plots/400_2/';
        %folder = '~/DATA/AHP/AHP_PFC_IL/Plots/400_2/';
    end
    properties(SetAccess = 'private',Dependent)        
        val = struct('Sweep',[],'IClamp',[],...
            'Noise',[],'Count',[],...
            'SeriesRes',[],'InputResf',[],'InputResa',[],'TauMem',[],...
            'ApNum',[],'ApAmp',[],'ApThres',[],...
            'ApRiseTime',[],'ApSlope',[],'ApTime',[],...
            'ApHalfWidth',[],'PeakAhpF',[],...
            'BasePreAhp',[],'BasePostAhp',[],...
            'PeakAhpMa',[],'PeakAhpSa',[],...
            'PeakAhpMaf',[],'PeakAhpSaf',[],...
            'PeakAhpMf',[],'PeakAhpSf',[],...
            'AreaAhpM',[],'AreaAhpS',[],...
            'TauAhpM',[],'TauAhpS',[],...
            'RSqr',[],'PValue',[]);
    end
    methods (Static = true)
        function [tthr,spkthr] = spikethreshold(t,v,threshold)
            % Function computed the phase space of an action potential
            % Numerical derivative with a step size
            if (nargin ==2)
                threshold = 20;
                disp('Threshold calculated from dv/dt = 20, units: V/sec or mv/ms');
            end
            [tx, vx, vd] = AhpClass.diffspike(t,v,2); % a step size of 4 choose to reduce noise
            norm = mean(vd(~isnan(vd)));
            vd = vd-norm;    
            ithr_vd = find(vd > threshold,1,'first'); % index of threshold from dv
            if (ithr_vd ~= 1)
                ithr_vd = ithr_vd-1;
            end
            spkthr = vx(ithr_vd);
            tthr = tx(ithr_vd);
           %disp([tthr,spkthr]);
           %plot(t,v); hold on;
           %plot(tthr,spkthr,'ored');pause;
        end                  
        function [tx,vx,vd] = diffspike(t,v,step) 
                if (nargin <=2)
                    step=1;
                end
                if (rem(step,2) ~= 0)
                    step = step+1;
                    disp(['Step has to be even! Step is now:',num2str(step)]);
                end
                tx = NaN(floor(length(t)/step),1);
                vx = NaN(floor(length(t)/step),1);
                vd = NaN(floor(length(t)/step),1);
                j=0;
                for k = step+1:step: length(t)
                    j = j+1;
                    vd(j) = (v(k)-v(k-step)) / (t(k)-t(k-step));
                    vx(j) = mean(v((k-step):k));
                    tx(j) = mean(t((k-step):k));
                end
            end
        function [mint, miny, maxt, maxy, acco] = AccoSpikes(t,y,delta)
                mint = nan(100);
                miny = nan(100);
                maxt = nan(100);
                maxy = nan(100);
                minval = +Inf; minpos = 0;
                maxval = -Inf; maxpos = 0;
                look4max=1;
                maxcnt=0; mincnt=0;
                for j = 1: length(y)-1
                    if(y(j) > maxval) 
                        maxval = y(j); 
                        maxpos = t(j); 
                    end
                    if(y(j) < minval)
                        minval = y(j);
                        minpos = t(j);
                    end
                    if(look4max)
                        if(y(j) < maxval-delta) 
                            maxcnt = maxcnt+1;
                            maxy(maxcnt)=maxval; 
                            maxt(maxcnt)=maxpos;
                            minval = y(j); 
                            minpos = t(j);
                            look4max=0;
                        end
                    else
                        if(y(j) > minval+delta) 
                            mincnt= mincnt+1;
                            miny(mincnt)=minval; 
                            mint(mincnt)=minpos;
                            maxval = y(j); 
                            maxpos = t(j);
                            look4max=1;
                        end
                    end
                end
                maxt = maxt(1:maxcnt);
                maxy = maxy(1:maxcnt);
%                 if (sum(~isnan(maxy))>=1)
%                     mincnt=mincnt+1;
%                     miny(mincnt)=minval; 
%                     mint(mincnt)=minpos;
%                 end
                mint = mint(1: maxcnt);
                miny = miny(1:maxcnt);
% Adjust the length of mint & miny same as that of maxt & maxy
%                 if(length(miny)<length(maxy))
%                     miny = [miny,0];
%                     mint = [mint,0];
%                 end
% Find the accomodation
                if (length(maxt)<2)
% Accomodation not computed if fewer than 2 spikes
                    acco=NaN;
                elseif (length(maxt)==2) 
% If no.of spiked = 2 
                    acco = (maxt(2)-maxt(1))/(maxt(1)-t(1));
                elseif (length(maxt)>2) % 
                    acco = (maxt(end)-maxt(end-1))/(maxt(2)-maxt(1));
                end
        end        
        function [tout,yout] = sweepsfilter(tin,yin,type,length,sigma)
                yout=yin;
                tout=tin;
                if (nargin<4) && strcmp(type,'gauss')
                    message('Not enough parameters for Gaussian filter!')
                    abort;
                end
                x = linspace(-length/2,length/2,length);
                if strcmp(type,'movingavg')
                    coeff = ones(length);
                elseif strcmp(type,'gauss')
                    coeff = 1/sqrt((2*pi)*sigma)*exp(- x .^ 2 / (2 * sigma ^ 2));
                end
                coeff = coeff / sum (coeff); % normalize filter coefficients
                for k = 1: size(yout,2)
                    yout(:,k) = conv(yout(:,k), coeff, 'same');  
% no delay by using convolution
                end
% less of (len/2-1) points from front & len/2 point from rear
                yout = yout(ceil(length/2): end-(ceil(length/2)),:);  
% same as above; total reduction of points  = (len-1) points
                tout = tout(ceil(length/2): end-(ceil(length/2)),:); 
        end
        function psv = PsvCClampMeasure(t,y,psv,fname,gname,iclamp)
            %[t,y]= AhpClass.sweepsfilter(t,y,'movingavg',30);
            y = smooth(t,y,5,'lowess'); % non-linear regression smooth 
            base = mean(y(t >=psv.BT2-0.001 & t <= psv.BT2)); 
            y1 = y(t >=psv.BT2-0.025 & t < psv.RT2);
            t1 = t(t >=psv.BT2-0.025 & t < psv.RT2); 
            y3 = y(t >=psv.BT2-0.025 & t < psv.RT2+0.2);
            t3 = t(t >=psv.BT2-0.025 & t < psv.RT2+0.2); 
            y3 = y3-base;
            yavglast50 = mean(y1(t1 >=psv.RT2-0.01 & t1 < psv.RT2)); %average the last 10 msec
            inputres = abs(((yavglast50-base) *1E-03)/psv.CmdStep);
            y1 = y1-base;
            %inputres = ((mean((y(t >=psv.RT2-0.01 & t <= psv.RT2)))-base)
            %*1E-03)/psv.CmdStep;
            % Find the ymin value
            [ymin,Imin] = min(y1);
            y2 = y1(1:Imin);
            t2 = t1(1:Imin);
            options = optimset('Display','off','MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-10000);
            initial_psv = [15E06,inputres, 0.1,0.025]; % [rp rm taum delay]
            LB = [10E06, inputres*0.50, 0, 0.024];
            UB = [50E06, inputres*1.5, 0.1, 0.026];
            % input y & base in mV to fminsearch
            %[params, ~, fitok, ~] = fminsearchbnd(@(initial_psv) fit_passive_charge(t,y/1000,initial_psv,base/1000,psv.CmdStep),initial_psv,LB,UB,options);
            [params, ~, fitok, ~] = fminsearchbnd(@(initial_psv) fit_passive_charge(t2,y2/1000,initial_psv,0,psv.CmdStep),initial_psv,LB,UB,options);
            % ------------- Plotings  Psv with fit
            %[tf,yf] = vp_passive_charge(t,params,base/1000,-20E-12);
            [tf,yf] = vp_passive_charge(t2,params,0,-20E-12);
            hold off;
            plot(t3,y3,'Color',[0.7,0.7,0.7]);
            hold on;
            xlim([t3(1), t3(end)]);
            ylim([min(y2)*1.25,max(y2)+1]);
            title([fname,'-',gname,'-',num2str(iclamp)],'Interpreter','none');
            text(t(1)+(t(end)-t(1))/1.8 ,(max(y)+(min(y)-max(y))*0.2)/1000,['Actual InputRes = ',num2str(inputres/1E06)]);  
            if (fitok)
                 %disp('Passive fit ok');
                 text(t(1)+(t(end)-t(1))/1.8 ,(max(y)+(min(y)-max(y))*0.3)/1000,['Fit InputRes = ',num2str(params(2)/1E06)]);
                 text(t(1)+(t(end)-t(1))/1.8 ,(max(y)+(min(y)-max(y))*0.4)/1000,['Fit SeriesRes = ',num2str(params(1)/1E06)]);
                 text(t(1)+(t(end)-t(1))/1.8 ,(max(y)+(min(y)-max(y))*0.5)/1000,['Fit TauMem = ',num2str(params(3))]);
                 plot(tf,yf*1000,'black','LineWidth',2);
            else
                %disp('No Fitting performed');
                text(t(1)+(t(end)-t(1))/1.8 ,(max(y)+(min(y)-max(y))*0.3)/1000,'No Fitting performed');
                params(1)=0; params(2)=inputres; params(3)= 0; params(4)=0;
            end
            psv.seriesres = params(1);psv.inputresa = inputres;psv.inputresf = params(2);
            psv.taum = params(3);
            % ------------- Draw scalebar
            set(gca,'XColor','w');
            set(gca,'XTick',[]);
            set(gca,'YColor','w');
            set(gca,'YTick',[]);
            xlimits=xlim;ylimits=ylim;
            plot([xlimits(2)*0.9,(xlimits(2)*0.9-0.05)],[ylimits(1)*0.8,ylimits(1)*0.8],'black','LineWidth',2); % 0.05 ms scalebar
            text(xlimits(2)*0.9-0.04,ylimits(1)*0.84,'50 ms','FontSize',12,...
            'HorizontalAlignment','left')
            plot([(xlimits(2)*0.9-0.05),(xlimits(2)*0.9-0.05)],[ylimits(1)*0.8+1,ylimits(1)*0.8],'black','LineWidth',2);  % 1 mV
            text(xlimits(2)*0.9-0.065,ylimits(1)*0.75,'1 mV','FontSize',12,'Rotation',90,...
            'HorizontalAlignment','left')
            % -----------
            hold off;
        end
        function [curval,sto,syo,postval] = AhpMeasure(t,y,sti,syi,ahp,fname,gname,iclamp,preval)
            %[t,y] = AhpClass.sweepsfilter(t,y,'gauss',5000,5000/6);
            %[t,y] = AhpClass.sweepsfilter(t,y,'movingavg',11);
            
            %base = mean(y(t >=ahp.RT2-0.1 & t <= ahp.RT2)); % average the trace to the last 0.1s value of trace
            % If the size of y is == 500000, has only one column and the mean is not zero then execute 
            if ( (size(y,1) == 500000) && (size(y,2) == 1) && (mean(y,1) ~= 0))
                y = smooth(t,y,5,'lowess'); % non-linear regression smooth 
                evalraw = 1;% Checks of the measurement is on a raw trace
                count = preval.count+1;
                pvalue = 0;
                %------------------- for plotting only
                    y3 = y(t >=ahp.BT1-0.1 & t <= ahp.RT2);
                    t3 = t(t >=ahp.BT1-0.1 & t <= ahp.RT2);
                    y3 = smooth(t3,y3,5,'lowess'); % non-linear regression smooth 
                    y3= y3 - mean(y3(t3 >=ahp.RT2-0.05 & t3 <= ahp.RT2)); 
                    y3= y3 - mean(y3(t3 >=ahp.BT1 & t3 <= ahp.BT2)); 
                % -----------------        
                basepre = mean(y(t >=ahp.BT1 & t <= ahp.BT2)); % average the trace to the baseline of the ahp step
                noise = mean(y(t >=ahp.BT1 & t <= ahp.BT2));
                basepost = mean(y(t >=ahp.RT2-0.05 & t <= ahp.RT2)); % average the trace to the end of the ahp step
                y = y-basepost;
                %base=mean(y(t >=ahp.RT2-0.05 & t <= ahp.RT2)); % average the trace to the end of the ahp step
                y = y-mean(y(t >=ahp.BT1 & t <= ahp.BT2));
                % y values more than 1 is equated to random value between
                % -0.01 and 0
                y(y>0.01) = (-0 + (-0.01-0).*rand(1,1));
                %y = medfilt1(y,100); % median filter with 2 ms span
                %y = smooth(t,y,3000,'lowess'); % non-linear regression smooth 
                y = y(t >=ahp.RT1-0.015 & t < ahp.RT2); 
                t = t(t >=ahp.RT1-0.015 & t < ahp.RT2);
                % Cut the trace from zero cross ------------------
                Izero = find(y<0,1,'first'); 
                y = y(Izero:end); t = t(Izero:end);
                % Make the scaled wave assuming no previous one given
                sto = t; 
                syo = y;
            else
                % if the input t,y is zero then load the input scaled traces: sti, syi;
                basepre=0;basepost=0;
                evalraw = 0;
                noise=0;
                count = preval.count;
                t = sti; y = syi;
                t3 = sti;y3=syi;
                sto = t; 
                syo = y;
            end
            % Find the medium AHP  & slow AHP actual peaks  -------------------
            [ymin,Imin] = min(y(t<=t(1)+0.2)); 
            tmin = t(Imin); 
            ymahpa = mean(y(t > tmin-ahp.WinMed & t < tmin+ahp.WinMed));
            ttail=tmin+ahp.OffsetSlow;
            ysahpa = mean(y(t > ttail-ahp.WinSlow & t < ttail+ahp.WinSlow));
            % Find the time at which ahp values reach ahpend  --------------------
            t2 = t(t >=tmin+0.01); y2 = y(t>= tmin+0.01);
            Imed = find(y2<=ymin*0.67,1,'last'); tmed = t2(Imed)-t2(1);
            Islow = find(y2<=ysahpa*0.67,1,'last'); tslow = t2(Islow)-tmed;
            % Check if there is an input non-zero scaled wave more than
            % 4 sec in length, one column only with non-zero mean &
            % scale is non-zero
            if ( (size(syi,1) > 200000) && (size(syi,2) == 1) && (mean(syi,1) ~= 0) && (preval.scale ~=0))
                % Thus there exists a scaled wave with a non-zero scale
                % value. 
                scale = mean([preval.scale,ymahpa]);
                syo = (syo ./ ymahpa ) .* scale;
                syi = (syi ./ preval.scale) .* scale;
                syo = mean([syi(1: min([size(syi,1), size(syo,1)])), syo(1: min([size(syi,1), size(syo,1)]))],2);
                sto = mean([sti(1: min([size(sti,1), size(sto,1)])), sto(1: min([size(sti,1), size(sto,1)]))],2);
            else
                 scale = ymahpa;
            end
            t21 = t2(1);
            t2 = t2-t2(1);
            % Bi-exponential fit by non-lin optimization  ---------------------------------------           
            options = optimset('Display','off');%,'MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-10,'TolX',1e-10);
            ahpfit = @(x,q) (q(1)*exp(-x./q(2)) + q(3)*exp(-x./q(4))); 
            errahpfit = @(q,x,y) sum((y(:)-ahpfit(x(:),q)).^2);
            % [ymahpa-ysahpa, tmed, ysahpa, tslow] 
            %initials_ahpfit = [ymahpa-ysahpa,tmed,ysahpa,tslow]; 
            %initials_ahpfit = [ymahpa-ysahpa,0.1,ysahpa/2,2]; 
            initials_ahpfit = [ymahpa-ysahpa,0.300,ysahpa,2]; 
            UB = [ymahpa*0.2,ahp.OffsetSlow, 0, 9];
            LB = [ymahpa, 0, ysahpa*1.5,ahp.OffsetSlow];
            if (isempty(tmed) || isempty(ysahpa) || isempty(tslow))
                disp('initials not found, aborting');
                %return;
            end
            [params_ahpfit, ~, ~, ~] = fminsearchbnd(errahpfit,initials_ahpfit,LB,UB,options,t2,y2);
            ymahpf = params_ahpfit(1); mahp_tau = params_ahpfit(2);
            ysahpf = params_ahpfit(3); sahp_tau = params_ahpfit(4);
            yfit = ahpfit(t2,params_ahpfit); tfit = t2+t21;
            % Compute R-square for the fit ---------------------------------
            SSE = sum((y2-yfit).^2);
            SST = sum((y2-mean(y2)).^2);
            Rsqr = 1 - SSE/SST;
            if (evalraw == 0)
                % Compute pvalue if no raw trace given: evalraw == 0;
                tvalue = sqrt(abs(Rsqr)) * sqrt(abs((count-2)/(1- Rsqr)));
                pvalue = 1-tcdf(tvalue,count-2);
            end;
            % Compute the points for fit mAHP, sAHP peaks
            efit = @(x,q) ( q(1)*exp(-x./q(2)) );
            ymf = efit(t2,[ymahpf, mahp_tau]);
            ysf = efit(t2,[ysahpf, sahp_tau]);
            % Compute the area for medium and slow ahp from fits
            mahparea = trapz(t2,ymf);
            sahparea = trapz(t2,ysf);
            % assigining values to curval
            curval.basepre  = basepre; curval.basepost = basepost; 
            curval.ymahpa  = ymahpa; curval.ysahpa = ysahpa; 
            curval.ymahpf = ymahpf; curval.ysahpf = ysahpf;
            curval.mahptau = mahp_tau; curval.sahptau = sahp_tau;
            curval.mahparea = mahparea; curval.sahparea = sahparea;
            curval.Rsqr = Rsqr; curval.pvalue = pvalue; curval.count = count;
            curval.scale = scale;
            curval.noise= noise;
            % assigining values to postval
            if (preval.scale ~= 0)
                postval. ymahpa = mean([curval.ymahpa,preval.ymahpa]); 
                postval. ysahpa = mean([curval.ysahpa,preval.ysahpa]); 
                postval. ymahpf = mean([curval.ymahpf,preval.ymahpf]); 
                postval. ysahpf = mean([curval.ysahpf,preval.ysahpf]); 
                postval.mahptau = mean([curval.mahptau,preval.mahptau]);
                postval.sahptau = mean([curval.sahptau,preval.sahptau]);
                postval.mahparea = mean([curval.mahparea,preval.mahparea]);
                postval.sahparea = mean([curval.sahparea,preval.sahparea]);
                postval.Rsqr = mean([curval.Rsqr,preval.Rsqr]);
                postval.pvalue = pvalue;
                postval.count = count;
                postval.scale = scale;
            else
                postval = curval;
            end
            % Ploting the traces
            hold off;
            plot(t3,y3,'Color',[0.7,0.7,0.7],'LineWidth',1);
            hold on;
            %ylim([-8,1]);% fixed scaling for rep traces
            ylim([min(yfit)-0.5,1]); % variable scaling
            xlim([tmin-1,t3(end)]);
            plot(tfit,yfit,'Color',[0.5,0.5,0.5],'LineStyle','-','LineWidth',6); 
            plot(t2+t21,ymf,'Color',[0,0,0],'LineStyle','--','LineWidth',2);
            plot(t2+t21,ysf,'Color',[0,0,0],'LineStyle','-','LineWidth',1); 
            plot(tmin,ymahpa,'Color',[0,0,0],'Marker','s','Markersize',10,'MarkerFaceColor',[0.7,0.7,0.7],'LineWidth',2);
            plot(ttail,ysahpa,'Color',[0,0,0],'Marker','O','Markersize',10,'MarkerFaceColor',[0.7,0.7,0.7],'LineWidth',2);
            plot(t21,ymahpf,'Color',[0,0,0],'Marker','s','Markersize',10,'MarkerFaceColor',[0,0,0],'LineWidth',2);
            plot(t21,ysahpf,'Color',[0,0,0],'Marker','O','Markersize',10,'MarkerFaceColor',[0,0,0],'LineWidth',2);
            plot([t21,t21],[0, ymahpa],'Color','black','LineStyle',':','Linewidth',0.5); % Plot the dotted zero line
            % ------------- Draw scalebar
            set(gca,'XColor','w');
            set(gca,'XTick',[]);
            set(gca,'YColor','w');
            set(gca,'YTick',[]);
            xlimits=xlim;ylimits=ylim;
            plot([xlimits(2)*0.9,(xlimits(2)*0.9-1)],[ylimits(1)*0.8,ylimits(1)*0.8],'black','LineWidth',2); % 1s scalebar
            text(xlimits(2)*0.9-0.9,ylimits(1)*0.83,'1 sec','FontSize',12,...
            'HorizontalAlignment','left')
            plot([(xlimits(2)*0.9-1),(xlimits(2)*0.9-1)],[ylimits(1)*0.8+1,ylimits(1)*0.8],'black','LineWidth',2);  % 1 mV
            text(xlimits(2)*0.9-1.2,ylimits(1)*0.75,'1 mV','FontSize',12,'Rotation',90,...
            'HorizontalAlignment','left')
            % -----------                
            title([fname,'-',gname,'-',num2str(iclamp)],'Interpreter','none');
            %text(6,ymahpa-ymahpa*0.5,['Rsqr = ',num2str(Rsqr)]);
            %text(6,ymahpa-ymahpa*0.4,['mAhp Tau = ',num2str(mahp_tau)]);
            %text(6,ymahpa-ymahpa*0.3,['sAhp Tau = ',num2str(sahp_tau)]);
            %text(6,ymahpa-ymahpa*0.2,['BasePreAhp = ',num2str(basepre)]);
            %text(6,ymahpa-ymahpa*0.1,['BasePostAhp = ',num2str(basepost)]);
            hold off;
        end
        function apvalues = ApMeasure(t,y,ahp,fname,gname,iclamp)
            %y = AhpClass.sweepsfilter(y,'movingavg',3);
            ya = y(t > ahp.BT2 & t <= ahp.RT1);
            ta = t(t > ahp.BT2 & t <= ahp.RT1);
            [mint,miny,maxt,maxy,acco] = AhpClass.AccoSpikes(ta,ya,40); %delta voltage  = 40 mV, for spike detection
            ythres = NaN(length(maxy),1);
            tthres = NaN(length(maxy),1);
            thwidth = NaN(length(maxy)*3,1);
            yhwidth = NaN(length(maxy)*3,1);
            trt = NaN(length(maxy)*3,1);
            yrt = NaN(length(maxy)*3,1);
            halfwidth = NaN(length(maxy),1);
            risetime = NaN(length(maxy),1);
            slope = NaN(length(maxy),1);
            for i = 1: length(maxt)
                idxpre1 = find(t>= (maxt(i)-0.0015) & t <= (maxt(i)+0.0003),1,'first');
                idxpost1 = find(t>= (maxt(i)-0.0015) & t <= (maxt(i)+0.0003),1,'last');
                t1 = t(idxpre1:idxpost1);y1=y(idxpre1:idxpost1);
                if (~isempty(AhpClass.spikethreshold(t1,y1./1000,20)))
                    [tthres(i), ythres(i)] = AhpClass.spikethreshold(t1,y1./1000,20);% Spike Threshold slope = 20 V/s
                    ythres(i) = ythres(i)*1000; % convert threshold back to mv
                    idxpre2 = find(t>= (maxt(i)-0.0015) & t <= (maxt(i)+0.0015),1,'first');
                    idxpost2 = find(t>= (maxt(i)-0.0015) & t <= (maxt(i)+0.0015),1,'last');
                    t2 = t(idxpre2:idxpost2);y2=y(idxpre2:idxpost2);
                    halfmax = ythres(i)+(maxy(i)-ythres(i))/2;
                    idxhalfmax1 = find(y2>= halfmax,1,'first'); idxhalfmax2 = find(y2>= halfmax,1,'last');
                    halfwidth(i) = (t2(idxhalfmax2)-t2(idxhalfmax1));
                    thwidth(i+(2*(i-1))) = t2(idxhalfmax1);    yhwidth(i+(2*(i-1))) = halfmax;
                    thwidth(i+1+(2*(i-1))) = t2(idxhalfmax1)+halfwidth(i);     yhwidth(i+1+(2*(i-1))) = halfmax;
                    thwidth(i+2+(2*(i-1))) = NaN;   yhwidth(i+2+(2*(i-1))) = NaN;
                    % 20-80  RiseTime and Slope
                    max20 = ythres(i) + (maxy(i)-ythres(i))*0.2;
                    max80 = ythres(i) + (maxy(i)-ythres(i))*0.8;
                    idxmax20 =  find(y1 > max20,1,'first');
                    idxmax80 =  find(y1 > max80,1,'first');
                    risetime(i) = t1(idxmax80)-t1(idxmax20);
                    slope(i) = (y1(idxmax80)-y1(idxmax20))/risetime(i);
                    trt(i+(2*(i-1))) = t1(idxmax20);    yrt(i+(2*(i-1))) = y1(idxmax20);
                    trt(i+1+(2*(i-1))) = t1(idxmax80);     yrt(i+1+(2*(i-1))) = y1(idxmax80);
                    trt(i+2+(2*(i-1))) = NaN;   yrt(i+2+(2*(i-1))) = NaN;
                end                             
            end           
            apvalues.maxy = maxy;
            apvalues.miny = miny;
            apvalues.maxt = maxt;
            apvalues.mint = mint;
            apvalues.tthres = tthres;
            apvalues.ythres = ythres;
            apvalues.halfwidth = halfwidth;
            apvalues.risetime = risetime;
            apvalues.slope = slope;
            apvalues.maxy(isnan(apvalues.maxy)) = 0;
            apvalues.miny(isnan(apvalues.miny)) = 0;
            hold off;
            plot(ta,ya,'Color',[0.5,0.5,0.5],'LineWidth',1);
            hold on;
            ylim([-90,80]);
            if(~isempty(maxt))
                %apfigt = maxt(min([length(maxt),10]))+0.002; % Only if you need the first 10 spikes to be displayed
                %xlim([maxt(1)-0.01,apfigt]); % Only if you need the first 10 spikes to be displayed
                xlim([maxt(1)-0.01,maxt(end)+0.01]);
                scatter(maxt,maxy,'Marker','o','SizeData',100,'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[0,0,0],'LineWidth',2);
                %plot(mint,miny,'oyellow');
                scatter(tthres,ythres,'Marker','x','SizeData',100,'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[0,0,0],'LineWidth',2);
                plot(thwidth,yhwidth,'Color',[0,0,0],'LineStyle','-','LineWidth',8);
                %plot(trt,yrt,'magenta');
                title([fname,'-',gname,'-',num2str(iclamp)],'Interpreter','none');
                % ------------- Draw scalebar
                set(gca,'XColor','w');
                box off
                set(gca,'Visible','off')
                set(gca,'XTick',[]);
                set(gca,'YColor','w');
                set(gca,'YTick',[]);
                xlimits=xlim;ylimits=ylim;
                plot([maxt(1),maxt(1)],[-85,-75],'black','LineWidth',2); % 10 mV
                %text(xlimits(2)*0.9-0.9,ylimits(1)*0.83,'1 sec','FontSize',12,...
                %'HorizontalAlignment','left')
                plot([maxt(1),maxt(1)+0.02],[-85,-85],'black','LineWidth',2); % 20 msec 
                %text(xlimits(2)*0.9-1.2,ylimits(1)*0.75,'1 mV','FontSize',12,'Rotation',90,...
                %'HorizontalAlignment','left')
                % -----------                
                hold off;
            end
        end
    end
    methods
        function A = AhpClass(cellinfo)
            fname = char(cellinfo.FileName);
            fn_idxstart = max(regexp(fname,'\/','end'));
            fn_idxend = regexp(fname,'.abf','end');
            A.FileName = fname(fn_idxstart+1:fn_idxend-4);
            A.FilePath = fname(1:fn_idxstart);
            A.GroupName = char(cellinfo.GroupName);
            A.BrainRegion = char(cellinfo.BrainRegion);
            A.ExpDate = cellinfo.ExpDate;
            A.BirthDate = cellinfo.BirthDate;
            A.TreatTime = cellinfo.TreatTime;
            A.RecTime = cellinfo.RecTime;
            A.VRest = cellinfo.VRest;
            A.Channel = cellinfo.Channel;
            A.Sweeps = sort(cellinfo.Sweeps);
            A.CellID = [fname(regexp(fname,'[A-Z,1-9]{2}_'):regexp(fname,'[A-Z,1-9]{2}_')+1),num2str(A.ExpDate)];
            [A.y A.si] = abfload([A.FilePath, A.FileName, '.abf'],'channels',{A.Channel},'sweeps',A.Sweeps);
            A.y = reshape(A.y,size(A.y,1),size(A.y,3))/ cellinfo.ScaleFactor;
            A.si=A.si*1E-06;
            A.t = (0:A.si:(size(A.y,1)-1)*A.si)';
            A.Psv.BT1 = cellinfo.PsvBT1; A.Psv.BT2 = cellinfo.PsvBT2; A.Psv.RT2 = cellinfo.PsvRT2; A.Psv.CmdStep = cellinfo.CmdStepPsv;
            A.Ahp.BT1 = cellinfo.AhpBT1; A.Ahp.BT2 = cellinfo.AhpBT2; A.Ahp.RT1 = cellinfo.AhpRT1;A.Ahp.RT2 = cellinfo.AhpRT2;
            A.Ahp.CmdStep = cellinfo.CmdStepAhp;
        end
        function val = get.val(A)           
        % -Initialize Passive
            val.SeriesRes = zeros(length(A.Sweeps)*50,1); % 
            val.InputResf = zeros(length(A.Sweeps)*50,1); %
            val.InputResa = zeros(length(A.Sweeps)*50,1); %
            val.TauMem = zeros(length(A.Sweeps)*50,1); % 
        % -Initialize Other params
            val.Sweep = zeros(length(A.Sweeps)*50,1); % 
            val.IClamp = zeros(length(A.Sweeps)*50,1);% 
            val.Count = zeros(length(A.Sweeps)*50,1);% 
        % -Initialize Actoion potential params    
            val.ApNum = zeros(length(A.Sweeps)*50,1); % 
            val.ApAmp = zeros(length(A.Sweeps)*50,1); % 
            val.ApThres = zeros(length(A.Sweeps)*50,1); % 
            val.ApRiseTime = zeros(length(A.Sweeps)*50,1); % 
            val.ApSlope = zeros(length(A.Sweeps)*50,1); % 
            val.ApTime = zeros(length(A.Sweeps)*50,1); % 
            val.ApHalfWidth = zeros(length(A.Sweeps)*50,1); % 
            val.PeakAhpF = zeros(length(A.Sweeps)*50,1); % 
        % -Initialize Ahp params  
            val.Noise = zeros(length(A.Sweeps)*50,1);% 
            val.BasePreAhp = zeros(length(A.Sweeps)*50,1); % 
            val.BasePostAhp = zeros(length(A.Sweeps)*50,1); %
            val.PeakAhpMa = zeros(length(A.Sweeps)*50,1); % 
            val.PeakAhpMf = zeros(length(A.Sweeps)*50,1); % 
            val.PeakAhpSa = zeros(length(A.Sweeps)*50,1); % 
            val.PeakAhpSf = zeros(length(A.Sweeps)*50,1); % 
            val.AreaAhpM = zeros(length(A.Sweeps)*50,1); % 
            val.AreaAhpS = zeros(length(A.Sweeps)*50,1); %
            val.TauAhpM = zeros(length(A.Sweeps)*50,1); %
            val.TauAhpS = zeros(length(A.Sweeps)*50,1); %
            val.RSqr =  zeros(length(A.Sweeps)*50,1); %
            val.PValue = zeros(length(A.Sweeps)*50,1); %
            
            totincr = 0; 
            previ=1; totahpiclamp=0;ahpevalcount=0;
            preval.scale=0;preval.count=0; sti =0; syi=0;
            %fh=figure; % generate a figure window once
            fh = gcf;
            for i = 1: length(A.Sweeps)
                iclamp = (A.Sweeps(i)-1)*A.Ahp.CmdStep;  
                if (iclamp >= 125)
                    %fprintf('Processing File %s Sweep: %d\n',A.FileName,A.Sweeps(i));
                    % -Compute Ap values
                    set(0,'CurrentFigure',fh);% clf reset; % select the figure and clear it
                    apvalues=A.ApMeasure(A.t,A.y(:,i),A.Ahp,[num2str(A.ExpDate),...
                        '-',A.FileName],A.GroupName,iclamp);
                    plotname = [A.folder,'AP',A.BrainRegion,A.CellID,'_',A.FileName,'_',A.GroupName,'_',num2str(iclamp),'.jpeg'];   
                    print(fh,'-djpeg',['-r','300'],plotname);
                    set(0,'CurrentFigure',fh); %clf(gcf,'reset'); % select the figure and clear it
                    iincr  = length(apvalues.maxy);
                    if (iincr ~= 0)
                        val.ApNum(previ:(previ+iincr-1),1) = 1:iincr;
                        val.ApAmp(previ:(previ+iincr-1),1) = apvalues.maxy;
                        val.ApTime(previ:(previ+iincr-1),1) = apvalues.maxt;
                        val.ApThres(previ:(previ+iincr-1),1) = apvalues.ythres;
                        val.ApRiseTime(previ:(previ+iincr-1),1) = apvalues.risetime;
                        val.ApSlope(previ:(previ+iincr-1),1) = apvalues.slope;
                        val.ApHalfWidth(previ:(previ+iincr-1),1) = apvalues.halfwidth; 
                        val.PeakAhpF(previ:(previ+iincr-1),1) = apvalues.miny;
                    else              
                        iincr = 1;
                    end
                    val.Sweep(previ: (previ+iincr-1),1) = A.Sweeps(i);             
                    val.IClamp(previ: (previ+iincr-1),1) = iclamp;
                    val.Count(previ:(previ+iincr-1),1) = 1:iincr;
                    % -Compute Passive psvvalues = [Offset,SeriesRes,InputRes,TauMem]
                    psv = A.PsvCClampMeasure(A.t,mean(A.y(:,i),2),A.Psv,[num2str(A.ExpDate),...
                        '-',A.FileName],A.GroupName,iclamp);
                    plotname = [A.folder,'PSV',A.BrainRegion,A.CellID,'_',A.FileName,'_',A.GroupName,'_',num2str(iclamp),'.jpeg'];   
                    print(fh,'-djpeg',['-r','300'],plotname);
                    set(0,'CurrentFigure',fh); %clf(gcf,'reset'); % select the figure and clear it
                    % [rp rm taum delay]
                    val.SeriesRes(previ: (previ+iincr-1),1) =  psv.seriesres;
                    val.InputResa(previ: (previ+iincr-1),1) = psv.inputresa;
                    val.InputResf(previ: (previ+iincr-1),1) = psv.inputresf;
                    val.TauMem(previ: (previ+iincr-1),1) = psv.taum;
                    % -Compute Ahp values
                    totahpiclamp = totahpiclamp+iclamp;
                    ahpevalcount = ahpevalcount+1;
                    [curval,sto,syo,postval] = A.AhpMeasure(A.t,A.y(:,i),sti,syi,A.Ahp,[num2str(A.ExpDate),'-',A.FileName],...
                    A.GroupName,iclamp,preval);
                    plotname = [A.folder,'AHP',A.BrainRegion,A.CellID,'_',A.FileName,'_',A.GroupName,'_',num2str(iclamp),'.jpeg'];   
                    print(fh,'-djpeg',['-r','300'],plotname);
                    set(0,'CurrentFigure',fh); %clf(gcf,'reset'); % select the figure and clear it
                    %----------------------------
                    preval = postval;
                    sti=sto; syi = syo;
                    val.Noise(previ: (previ+iincr-1),1) =  curval.noise;
                    val.BasePreAhp(previ: (previ+iincr-1),1) =  curval.basepre;
                    val.BasePostAhp(previ: (previ+iincr-1),1) =  curval.basepost;
                    val.PeakAhpMa(previ: (previ+iincr-1),1) =  curval.ymahpa;
                    val.PeakAhpSa(previ: (previ+iincr-1),1) =  curval.ysahpa;
                    val.PeakAhpMf(previ: (previ+iincr-1),1) =  curval.ymahpf;
                    val.PeakAhpSf(previ: (previ+iincr-1),1) =  curval.ysahpf;
                    val.AreaAhpM(previ: (previ+iincr-1),1) =  curval.mahparea;
                    val.AreaAhpS(previ: (previ+iincr-1),1) =  curval.sahparea;
                    val.TauAhpM(previ: (previ+iincr-1),1) =  curval.mahptau;
                    val.TauAhpS(previ: (previ+iincr-1),1) =  curval.sahptau;
                    val.RSqr(previ: (previ+iincr-1),1) = curval.Rsqr;
                    val.PValue(previ: (previ+iincr-1),1) = curval.pvalue;
                    previ = previ+iincr;
                    totincr = totincr+iincr; 
                end                        
            end
            % cumpute Ahp values for the averaged scaled trace
            disp('Processing the avg trace');
            iincr = 1;
            val.Sweep(previ: (previ+iincr-1),1) = 0;  
            iclamp = totahpiclamp/ahpevalcount;
            val.IClamp(previ: (previ+iincr-1),1) = iclamp;
            [curval,sto,syo,postval] = A.AhpMeasure(0,0,sti,syi,A.Ahp,[num2str(A.ExpDate),'-',A.FileName,'-AVG'],...
                    A.GroupName,iclamp,preval);
            plotname = [A.folder,'AHP',A.BrainRegion,A.CellID,'_',A.FileName,'_',A.GroupName,'_',num2str(iclamp),'.jpeg'];   
            print(fh,'-djpeg',['-r','300'],plotname);
            set(0,'CurrentFigure',fh); %clf reset; % select the figure and clear it
            %-------------------------------------------
            val.Noise(previ: (previ+iincr-1),1) = curval.noise;
            val.BasePreAhp(previ: (previ+iincr-1),1) =  curval.basepre;
            val.BasePostAhp(previ: (previ+iincr-1),1) =  curval.basepost;
            val.PeakAhpMa(previ: (previ+iincr-1),1) =  curval.ymahpa;
            val.PeakAhpSa(previ: (previ+iincr-1),1) =  curval.ysahpa;
            val.PeakAhpMf(previ: (previ+iincr-1),1) =  curval.ymahpf;
            val.PeakAhpSf(previ: (previ+iincr-1),1) =  curval.ysahpf;
            val.AreaAhpM(previ: (previ+iincr-1),1) =  curval.mahparea;
            val.AreaAhpS(previ: (previ+iincr-1),1) =  curval.sahparea;
            val.TauAhpM(previ: (previ+iincr-1),1) =  curval.mahptau;
            val.TauAhpS(previ: (previ+iincr-1),1) =  curval.sahptau;
            val.RSqr(previ: (previ+iincr-1),1) = curval.Rsqr;
            val.PValue(previ: (previ+iincr-1),1) = curval.pvalue;
             % -----------------------------------------
            totincr = totincr+iincr;
            % -----------------------------------------
            val.ApAmp = val.ApAmp(1:totincr,1);
            val.ApNum = val.ApNum(1:totincr,1);
            val.ApTime = val.ApTime(1:totincr,1);
            val.ApThres = val.ApThres(1:totincr,1);
            val.ApRiseTime = val.ApRiseTime(1:totincr,1);
            val.ApSlope = val.ApSlope(1:totincr,1);
            val.ApHalfWidth = val.ApHalfWidth(1:totincr,1);
            val.PeakAhpF = val.PeakAhpF(1:totincr,1);
            val.SeriesRes = val.SeriesRes(1:totincr,1);
            val.InputResa = val.InputResa(1:totincr,1);
            val.InputResf = val.InputResf(1:totincr,1);
            val.TauMem = val.TauMem(1:totincr,1);
            % ----------------------------------------
            val.Sweep = val.Sweep(1:totincr,1);
            val.IClamp = val.IClamp(1:totincr,1);
            val.Count = val.Count(1:totincr,1);
            val.Noise = val.Noise(1:totincr,1);
            val.BasePreAhp = val.BasePreAhp(1:totincr,1);
            val.BasePostAhp = val.BasePostAhp(1:totincr,1);
            val.PeakAhpMa = val.PeakAhpMa(1:totincr,1);
            val.PeakAhpSa = val.PeakAhpSa(1:totincr,1);
            val.PeakAhpMf = val.PeakAhpMf(1:totincr,1);
            val.PeakAhpSf = val.PeakAhpSf(1:totincr,1);
            val.AreaAhpM = val.AreaAhpM(1:totincr,1);
            val.AreaAhpS = val.AreaAhpS(1:totincr,1);
            val.TauAhpM = val.TauAhpM(1:totincr,1);
            val.TauAhpS = val.TauAhpS(1:totincr,1);
            val.RSqr = val.RSqr(1:totincr,1);
            val.PValue = val.PValue(1:totincr,1);
            
            %print(fig1,'-djpeg',['-r','300'],plotname);
            %print(gcf,'-djpeg',['-r','300'],plotname);
            %close all;
        end
    end
end
    
    