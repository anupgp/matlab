function dydt = HHequations(t,y)

global gNa gK gL;					
global VN VK VL;					
global kT;
global cm ;
global ist0 ;
global Ts ;
global T1start  Tr
global tv V ;

% --------------------------------------------------------------------------
% rate constances alfas and betas:
        		if y(1)~=25
   Am=0.1*(25-y(1))/(exp((25-y(1))/10)-1); 	else	Am=1;		end;
   Ah=0.07*exp(-y(1)/20);
	   		if y(1)~=10
	An=0.01*(10-y(1))/(exp((10-y(1))/10)-1);	else;	An=0.1;	end;
	Bm=4*exp(-y(1)/18);
	Bh=1/(exp((30-y(1))/10)+1);
   Bn=0.125*exp(-y(1)/80);
% --------------------------------------------------------------------------
if 		((t>=T1start) & (t<=(T1start + Ts)))   
   							istim = ist0 ;
elseif   ((t>=T1start+Tr) & (t<=(T1start+Tr + Ts))) 
   							istim = ist0 ;
else 							istim = 0;
end 
% --------------------------------------------------------------------------
iion= gNa * y(2)^3 *y(3) *(y(1)-VN)  + gK * y(4)^4 *(y(1)-VK) + gL*(y(1)-VL);
% --------------------------------------------------------------------------
% 	V' =  (  -iion + istim(t)  ) / cm ;
      
dydt = [ (	(-iion +  istim ) ./ cm)
   		(	( -(Am+Bm).* y(2) + Am)  *  kT	)
   		(  ( -(Ah+Bh).* y(3) + Ah)  *  kT	) 
   		(  ( -(An+Bn).* y(4) + An)	 *  kT 	)];