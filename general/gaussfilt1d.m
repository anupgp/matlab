function [t,o] = gaussfilt1d(t,i,size,sigma)
x = linspace(-size/2,size/2,size);
gaussFilter = 1/sqrt((2*pi)*sigma)*exp(- x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
% plot(x,gaus2)sFilter); 
o = conv (i, gaussFilter, 'same');  % no delay by using convolution
t = t(ceil(size/2): end-(ceil(size/2)));  % less of (size/2-1) points from front & size/2 point from rear 
o = o(ceil(size/2): end-(ceil(size/2))); % same as above; total reduction of points  = (size-1) points