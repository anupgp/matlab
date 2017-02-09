function [t sp] = simulateAHPpassive(t0,vrest,dt,delay,hjdur,hjdisdur,bldur,djvmax,djdisdur,i_inj,r_sr,r_in,tau)
% generate capacitance charging phase
% vhc = zeros(ceil((hjdur+delay)/dt)+1,1);
% tvhc = zeros(ceil((hjdur+delay)/dt)+1,1);
[tvhc vhc] = vp_passive_charge(dt,t0,delay,hjdur,vrest,i_inj,r_sr,r_in,tau);
% generate capacitance discharging phase
% vhd = zeros(ceil((hjdisdur+bldur)/dt)+1,1);
% tvhd = zeros(ceil((hjdisdur+bldur)/dt)+1,1);
[tvhd vhd] = vp_passive_charge(dt,tvhc(end),0,hjdisdur+bldur,vhc(end),-i_inj,r_sr,r_in,tau);
i_dep = abs(djvmax-vrest)/(r_in+r_sr);
[tvdd vdd] = vp_passive_charge(dt,tvhd(end),0,djdisdur,djvmax,-i_dep,r_sr,r_in,tau);
t = [tvhc;tvhd;tvdd];
sp = [vhc;vhd;vdd];