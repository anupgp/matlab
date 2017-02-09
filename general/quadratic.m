function y = quadratic(coeffs,x)
% y = ax^2 + bx + c
a = coeffs(1); b = coeffs(2); c = coeffs(3);
y = a*x.^2 + b*x+c; 