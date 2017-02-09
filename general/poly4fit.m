function y = poly4fit(coeffs,x)
% y = a(x^4)+b(x^3)+c(x^2)+d(x)+e
a = coeffs(1); b = coeffs(2); c = coeffs(3); d = coeffs(4); e = coeffs(5);
y = a .* (x.^4)+ b .* (x.^3) + c .* (x.^2) + d .*(x) + e;