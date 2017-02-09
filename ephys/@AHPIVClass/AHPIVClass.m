classdef AHPIVClass < handle 
    properties (SetAccess = 'private')
        FileName = '';
        GroupName = '';
        BrainRegion = '';
        ExpDate = 0; % Format: YYYYMMDD
        BirthDate = 0; % Format: YYYYMMDD
        TreatTime = 0; % Format: HHMM in 24Hr
        RecTime = 0; % Format: HHMM in 24Hr
        VRest = 0;
        FilePath = '';
        Channel = '';
        Sweeps=[];
        AnimalID = '';
        CellID = ''; 
    end
    properties (SetAccess = 'private')
        Psv = struct('BT1',0,'BT2',0,'RT2',0,'CmdStep',0);
        Ahp = struct('BT1',0,'BT2',0,'RT2',0)    
    end
    properties (Constant)
        AvgDur = struct('Pk',0.002,'Tl',0.002); 
        AhpFind = 1.35;
        AhpTailDelay = 0.350;
        AhpTailStop = 5;
    end
    properties(SetAccess = 'private')
        t = []; y = []; si = 0;
    end
    properties(SetAccess = 'private',Dependent)
        val = struct('Sweep',[],'SeriesRes',[],'InputRes',[],'mTau',[],...
            'Peak',[],'Tail',[],'TotalArea',[],'TailArea',[],...
            'PeakMedium',[],'AreaMedium',[],'TauMedium',[],...
            'PeakSlow',[],'AreaSlow',[],'TauSlow',[]);
    end
    methods
        function A = AHPIVClass(cellinfo)
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
            [A.y A.si] = abfload([A.FilePath, A.FileName, '.abf'],'channels',{A.Channel},'sweeps',A.Sweeps);
            A.y = reshape(A.y,size(A.y,1),size(A.y,3)) * cellinfo.ScaleFactor;
            A.si=A.si*1E-06;
            A.t = (0:A.si:(size(A.y,1)-1)*A.si)';
            A.Psv.BT1 = cellinfo.PsvBT1; A.Psv.BT2 = cellinfo.PsvBT2; A.Psv.RT2 = cellinfo.PsvRT2; A.Psv.CmdStep = cellinfo.CmdStep;
            A.Ahp.BT1 = cellinfo.AhpBT1; A.Ahp.BT2 = cellinfo.AhpBT2; A.Ahp.RT2 = cellinfo.AhpRT2;
        end
        function val = get.val(A)
            val.Sweep = zeros(length(A.Sweeps),1);
% -Initialize Passive
            val.SeriesRes = zeros(length(A.Sweeps),1);
            val.InputRes = zeros(length(A.Sweeps),1);
            val.mTau = zeros(length(A.Sweeps),1);
% -Initialize Total                        
            val.Peak = zeros(length(A.Sweeps),1);
            val.Tail = zeros(length(A.Sweeps),1);
            val.TotalArea = zeros(length(A.Sweeps),1);
% -Initialize Medium            
            val.PeakMedium = zeros(length(A.Sweeps),1);
            val.AreaMedium = zeros(length(A.Sweeps),1);
            val.TauMedium = zeros(length(A.Sweeps),1);
% -Initialize Slow 
            val.PeakSlow = zeros(length(A.Sweeps),1);
            val.AreaSlow = zeros(length(A.Sweeps),1);
            val.TauSlow = zeros(length(A.Sweeps),1);
% ----------            
            fh = @(x,p) p(1) + p(2)*exp(-x./p(3));
            errfh = @(p,x,y) sum((y(:)-fh(x(:),p)).^2);
            options = optimset('Display','on','MaxFunEvals',2000,'MaxIter',2000);
            for i = 1: length(A.Sweeps)
                val.Sweep(i,1) = A.Sweeps(i);
                
% ------------- Compute Passive
                x= A.t;d = A.y(:,i);
                d = d-mean(d(x>=A.Psv.BT1 & x<=A.Psv.BT2));
                d2 = d(x > A.Psv.BT2 & x <= A.Psv.RT2);
                x2 = x(x > A.Psv.BT2 & x <= A.Psv.RT2);
                [ymin, IminRev] = min(d2(end:-1:1)); 
                ymaxAvg = mean(d2(x2 > A.Psv.RT2-0.1 & x2 < A.Psv.RT2));
                x3 = x2(x2 > x2(end-IminRev));
                d3 = d2(x2 > x2(end-IminRev));
                x31 = x3(1);
                x3 = x3-x3(1);
                initials0 = [ymaxAvg, ymin, 0.01]; % [offset scale tau]
                [params0, ~, ~, ~] = fminsearch(errfh,initials0,options,x3,d3);
                fd3 = fh(x3,params0);
% ------------- Set Total values
                val.SeriesRes(i,1) = abs(A.Psv.CmdStep/(ymin*1E-06));
                val.InputRes(i,1) = abs(A.Psv.CmdStep/(ymaxAvg*1E-06));
                val.mTau(i,1) =  params0(3);
% ------------- Plotings  Psv
                close all; fig2 = figure;
                plot(x3+x31,d3,'black',x3+x31,fd3,'red','LineWidth',2);
                plotname2 = ['~/DATA/AHP_OFC/Psv_plots/','Psv_',num2str(A.ExpDate),'_',A.FileName,'_',num2str(val.Sweep(i,1)),'.jpeg'];
                print(fig2,'-djpeg',['-r','150'],plotname2);
% ------------- Compute AHPI
                s.y = A.y(:,i);s.t = A.t;
                s = signalfilter(s,'gauss',500,500/6);
                d= s.y;x = s.t;
                d = d-mean(d(x>=A.Ahp.BT1 & x<=A.Ahp.BT2));
                d = d(x>=A.AhpFind & x<=A.AhpTailStop);
                x = x(x>=A.AhpFind & x<=A.AhpTailStop);
                [~, I_dmin] = min(d); 
                [~, I_dpeak] = max(d(I_dmin:end));
                I_dpeak = I_dpeak+I_dmin-1;
% ------------- Total sweep                
                dtotal = d(x>=x(I_dpeak));
                xtotal = x(x>=x(I_dpeak));                
                Ilast_totalN = find(dtotal<0,1,'first');
                xtotal = xtotal-xtotal(1);
% ------------- Slow sweep                 
                dslow = dtotal(xtotal>=A.AhpTailDelay & xtotal<=xtotal(Ilast_totalN));
                xslow = xtotal(xtotal>=A.AhpTailDelay & xtotal<=xtotal(Ilast_totalN));  
% ------------- Set Total values               
                val.Peak(i,1)= mean(d(x > x(I_dpeak)-A.AvgDur.Pk/2 & x < x(I_dpeak)+A.AvgDur.Pk/2));
                val.Tail(i,1)= mean(d(x > x(I_dpeak)+A.AhpTailDelay-A.AvgDur.Tl/2 & x < x(I_dpeak)+A.AhpTailDelay+A.AvgDur.Tl/2));
                val.TotalArea(i,1) = trapz(xtotal,dtotal);
% -------------                 
                initials1 = [0, val.Tail(i,1), 0.5]; % [offset scale tau]
                [params1, ~, ~, ~] = fminsearch(errfh,initials1,options,xslow,dslow);
                dslowExtra = fh(xtotal,params1); 
%                 dmedium=dtotal-dslowExtra;
%                 initials2 = [0, val.Peak(i,1)-val.Tail(i,1), 0.1]; % [offset scale tau]
%                 [params2, ~, ~, ~] = fminsearch(errfh,initials2,options,xtotal,dmedium);
%                 dmediumExtra = fh(xtotal,params2);  
% %  ------------ Set Slow values
%                 val.PeakSlow(i,1) = max(dslowExtra);
%                 val.AreaSlow(i,1) = trapz(xtotal,dslowExtra);
%                 val.TauSlow(i,1) = params1(3);
% %  ------------ Set Medium values
%                 val.PeakMedium(i,1) = max(dmediumExtra);
%                 val.AreaMedium(i,1) = trapz(xtotal,dmediumExtra);
%                 val.TauMedium(i,1) = params2(3);               
%  ------------ Plotings                
                close all; fig2 = figure;hold on; 
%                 plot(x,d,'black');
                plot(xtotal,dtotal,'red','LineWidth',2);
                plot(xslow,dslow,'green','LineWidth',1);
                plot(xtotal,dslowExtra,'blue','LineWidth',2);    
                plot(0,val.Peak(i),'ored','LineWidth',2,'MarkerSize',10); 
                plot(A.AhpTailDelay,val.Tail(i),'ocyan','LineWidth',2,'MarkerSize',10);
                plot([0,5],[0,0],'--black');
%                 xlim([A.AhpFind,5]);
%                 ylim([-10,val.Peak(i)+20]);
                title([num2str(A.ExpDate),'_',A.FileName,'_',num2str(val.Sweep(i,1))],'Interpreter','none');
                h = xlabel('Time (s)');
                set(h, 'FontSize', 30);              
                plotname2 = ['~/DATA/AHP_OFC/AHPI_plots/',num2str(A.ExpDate),'_',A.FileName,'_',num2str(val.Sweep(i,1)),'.jpeg'];
                print(fig2,'-djpeg',['-r','150'],plotname2);
            end           
        end
    end
end