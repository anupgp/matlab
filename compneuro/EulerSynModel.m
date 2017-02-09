%% Synaptic conductance model to simulate an EPSP
 clear; clf; hold on;

%% Setting some constants and initial values
 c_m=1; g_L=1; tau_syn=1; E_syn=10; delta_t=0.01;  
 g_syn(1)=0; I_syn(1)=0; v_m(1)=0; t(1)=0; 

%% Numerical integration using Euler scheme
 for i=2:10/delta_t
   t(i)=t(i-1)+delta_t;
   if abs(t(i)-1)<0.001; g_syn(i-1)=1; end
    g_syn(i)= g_syn(i-1) - delta_t/tau_syn * g_syn(i-1);
    I_syn(i)= g_syn(i) * (v_m(i-1)-E_syn);
    v_m(i) = v_m(i-1) - delta_t/c_m *g_L* v_m(i-1) ...
               - delta_t/c_m * I_syn(i);
 end

%% Plotting results
 plot(t,v_m); plot(t,g_syn*5,'r--'); plot(t,I_syn/5,'k:') 