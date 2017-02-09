function [t,o] = gaussfilt2d(t,y,len,sigma)
x = linspace(-len/2,len/2,len);
gaussFilter = 1/sqrt((2*pi)*sigma)*exp(- x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
% plot(x,gaussFilter); 
for i=1:size(y,2)
    o(:,i) = conv(y(:,i), gaussFilter, 'same');  % no delay by using convolution
end
t = t(ceil(len/2): end-(ceil(len/2)));  % less of (len/2-1) points from front & len/2 point from rear 
o = o(ceil(len/2): end-(ceil(len/2)),:); % same as above; total reduction of points  = (len-1) points
