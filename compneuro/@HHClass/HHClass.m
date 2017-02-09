classdef HHClass < handle
    properties (SetAccess = 'private')
        % Reversal potentials in mV
        ENa = 55.0; % Reversal potential for Sodium channel
        EK = -72.0;   % Reversal potential for Pottasium channel
        EL = -49.4;     % Reversal potential for Leak channel
        % Maximum conductances 
        GNa = 1.20;    % Maxium conductance Na channel in S/cm^2
        GK = 0.36;        % Maximum conductance K channel
        GL = 0.003;       % Maximum conductance Leak channel
        % Passive membrane properties
        Cm = 0.01;         % Membrane capacitance in F/cm^2
        % External injected current in A
        Iext = 0.1;      
    end
    properties (SetAccess = 'private')
        tstart=0.1;
        tstop=50;
        dt =0.1;
        vstart=-70;
    end
    properties(SetAccess = 'private',Dependent)
        YY = 0; 
    end
    methods (Static = true)
        function alphaN = An(v)
            % Computes alphaN
           
                alphaN = 0.01*(v+50)/(1-exp(-(v+50)/10));
           
        end
        function betaN = Bn(v)
            % Computes BetaN
           
                betaN = 0.125*exp(-(v+60)/80);
            
            
        end
        function alphaM = Am(v)
            % Computes alphaM
             
                alphaM = 0.1*(v+35)/(1-exp(-(v+35)/10));
             
             
        end
        function betaM = Bm(v)
            % Computes BetaN
           
                betaM = 4.0*exp(-(v+60)/18);
            
          
        end
        function alphaH = Ah(v)
            % Computes alphaN
             
                alphaH = 0.07*exp(-(v+60)/20);
            
             
        end
        function betaH = Bh(v)
            % Computes BetaN
           
                betaH = 1/(1+exp(-(v+30)/10));% 
    
            
        end
    end
    methods
        function YY = get.YY(hh)
            function dydt = HHeq(t,y,prm) % Here each column of 'y' represents one of the unknown variables excluding 't'
                % Assign the columns of 'y' to the variables of the HH equation
                %prm(1,2,3,4,5,6,7,8)=GNa,GK,GL,ENa,EK,EL,Istart,Istop
                V = y(1);
                n = y(2);
                m = y(3);
                h = y(4);
                % Define variables for instantaneous conductances for each channel
                gNa = prm(1)*(m^3)*h;
                gK = prm(2)*(n^4);
                gL = prm(3);
                % Define variables for Total current through each channel
                INa = gNa*(V-prm(4));
                IK = gK*(V-prm(5));
                IL = gL*(V-prm(6));
                %t = hh.tstart:hh.dt:hh.tstop;
                if ( (t >= 50))
                    IExt = hh.Iext;
                else
                    IExt=0;
                end
                dydt = [(1/hh.Cm)*(IExt-(INa+IK+IL));hh.An(V)*(1-n)-hh.Bn(V)*n;hh.Am(V)*(1-m)-hh.Bm(V)*m;hh.Ah(V)*(1-h)-hh.Bh(V)*h];
            end
            % Solve HHequation using ODE45 method
            tspan = [hh.tstart,hh.tstop];
            V0 = hh.vstart;
            n0 = hh.An(V0)/(hh.An(V0)+hh.Bn(V0));
            m0 = hh.Am(V0)/(hh.Am(V0)+hh.Bm(V0));
            h0 = hh.Ah(V0)/(hh.Ah(V0)+hh.Bh(V0));
            Y0 = [V0;n0;m0;h0];
            prm = [hh.GNa,hh.GK,hh.GL,hh.ENa,hh.EK,hh.EL];
            [T,Y] = ode23(@HHeq,tspan,Y0,[],prm);
            YY = [T,Y];
        end
        function Ap = HHClass(initials)
            Ap.tstart = initials(1);
            Ap.dt = initials(2);
            Ap.tstop = initials(3);
            Ap.vstart = initials(4);
        end
    end
end
