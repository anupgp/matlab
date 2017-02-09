% Genrate a passive neural response with the following parameters
% Time of pulses:  t1. Time starts at zero (t=0)
% Durations of pulses:  d1
% Intensity of pulses: ie1
% Input resistance: rin
% Membrane tau: tau
% Membrane baseline voltage: v0
% Total duration of the pulse: durpulse
% No.of pulses: npulse
% Time step: dt
% Reversal potential for leak currents: el
function [t,vm] = nresponse(dur,v0,el,rin,rseries,tau,dt,t1,d1,ie1,t2,d2,ie2,nf)
npnts = ceil(dur/dt);
vm = zeros(npnts,1);
vjmp = zeros(npnts,1);
v = zeros(npnts,1);
noise = randn(1,npnts)*v0*nf;
ic = zeros(npnts,1);
t = zeros(npnts,1);
vm(1)= v0; t(1)=0; ic(1)=0;
for step=2:npnts
    if ((step*dt) < t1); ie = 0;
    elseif (((step*dt) >= t1) && ((step*dt)<= (t1+d1))); ie = ie1; 
    elseif (((step*dt) >= t2) && ((step*dt)<= (t2+d2))); ie = ie2; 
    else ie = 0;
    end
    vm(step) = vm(step-1)+ dt * (el - vm(step-1) + (rin+rseries)*ie ) / tau;
    ic(step) = (rin*ie-vm(step)+el)/rin;
    t(step) = t(step-1)+dt;
end
vjmp = ic*rseries;
v = vm+vjmp+transpose(noise);
% close(gcf);
hold on;
plot(t,v);
    