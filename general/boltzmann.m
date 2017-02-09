function y = boltzmann(coeffs,x)
% y = (A1-A2)/(1+exp((x-x0)/dx))+ A2, A1 & A2: Low and high Y limits, x0: x at half amplitude, dx: width of x 
a1 = coeffs(1); a2 = coeffs(2); x0= coeffs(3); dx = coeffs(4);
y = ((a1-a2)./(1+exp((x-x0)./dx))) + a2;