% solution of Hodgkin-Huxley (HH) differential equations

%clc;
clear;
close all;

global gNa gK gL;					
global VN VK VL;					
global kT;
global cm ;
global ist0 ;
global Ts ;
global T1start  Tr
global tv V ;


%**********************************************************************
%***********	 constasnts and PARameters for solving HH equations ****
%**********************************************************************
T=6.3;									% [oC] temperature
cm = 1;									% membrane capacitance [uF.cm-2]
% maximum conductances [mS . cm-2]
			   gNa = 120;
	   		gK  = 36;
            gL  = 0.3;
% temperature correction for alfas and betas,scaled with a Q10 of 3
 				kT=3^((T-6.3)/10); 
%**********************************************************************
%***********	initial conditions for solution of HH equations		*****
%***********	(for resting potential Er (V=0))							*****
%**********************************************************************
% rate constants alfas and betas at rest:	
	Amr=2.5/(exp(2.5)-1);	Ahr=0.07;				Anr=0.1/(exp(1)-1);
	Bmr=4;   					Bhr=1/(exp(3)+1);		Bnr=0.125;
   
	  	mr=Amr/(Amr+Bmr);				% activation parameter 'm' at rest
	  	hr=Ahr/(Ahr+Bhr);				% inactivation parameter 'h' at rest
  		nr=Anr/(Anr+Bnr);				% activation parameter 'n' at rest
Er=-70 ; 								% resting potential [mV]
% displacement of Na (K, Cl) equilibrium potential  [mV]:  
				VN = 115;
				VK = -12;
				VL = 10.6;
%*********************************************************************
%*********************************************************************
%*********************************************************************
ist0 = 200;								% amplitude of stimulation [uA/cm2]
Ts = 0.1;								% [ms]	time of stimulation
%***************************************
T1start=0;
%***************************************

Trv = [ 10  ];		istv =  [  200 ];


istN  = length(istv);
%***************************************
t0=0;										% [ms]	begining (start)  time
V0 = 0;
y0 = [V0; mr; hr; nr];
%***************************************
step = 0.1;
%***************************************
TolR = 1e-4;							% Relative error tolerance	
											% 		defaults to 1e-3 (0.1% accuracy)	
TolA = [1e-6 1e-6 1e-6 1e-6];		% Absolute error tolerance
											% 		defaults to 1e-6	
%***************************************
TrN   = length(Trv);
%***************************************
for Trind = 1: TrN
   Tr = Trv(Trind )	;				% Time of Repetition of stimulation impulses
%***************************************
tfinal=Tr + 10;								% [ms]	final (total)  time
%*********************************************************************
for istind = 1: istN
   ist0 = istv(istind);
%***************************************
%***************************************
tspan=[t0 : step :tfinal];
[sizem_t,sizen_t] = size(tspan);			%[a,nt] = size(tspan);
clear sizem_t;
%***************************************
y = zeros(sizen_t,4);
size(V);
tv = tspan;
size(tv);
%***************************************
clock0 = clock;
%*********************************************************************
%*********************************************************************
options = odeset('RelTol',TolR,'AbsTol',TolA );

[tv,y,OutStats]=ode23('HHequations',tspan,y0,options);

OutStats
%*********************************************************************
%*********************************************************************
cas1=etime(clock,clock0)
stri=['yStep',int2str(step*1000),'ist0',int2str(ist0*1000),'Tr',int2str(Tr*1000), ...
   'TolR',int2str(abs(log10(TolR))),'TolAV',int2str(abs(log10(TolA(1))))...
      ,'m',int2str(abs(log10(TolA(2)))),'h',int2str(abs(log10(TolA(3))))...
   ,'n',int2str(abs(log10(TolA(4))))];
%   ,'n',int2str(abs(log10(TolA(4)))),'e'];
save(stri,'y','tv');
%			cd(MyPath)
%***************************************
         

end;										% for istind = 1: istN

%*****************************************************
end;										% for Trind = 1: TrN
%*****************************************************
%*********************************************************************
%*********************************************************************
plot(tv,y(:,1),'r', ...
   'LineWidth',1.5);
grid on
   hold on
xlabel('\rightarrow {\itt}   (ms)','FontSize',[14])
ylabel('\rightarrow {\itV}   (mV)','FontSize',[14])
set(gca,'FontSize', [12])
