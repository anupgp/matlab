function signalout = signalfilter(signalin,type,length,sigma,pad)
    signal=signalin;
    if (nargin<4) && strcmp(type,'gauss')
        message('Not enough parameters for Gaussian filter!')
        abort;
    end
    x = linspace(-length/2,length/2,length);
    if strcmp(type,'movingavg')
        coeff = ones(length);
    elseif strcmp(type,'gauss')
        coeff = 1/sqrt((2*pi)*sigma)*exp(- x .^ 2 / (2 * sigma ^ 2));
    end
    coeff = coeff / sum (coeff); % normalize filter coefficients
    for k = 1: size(signal.y,2)
        signal.y(:,k) = conv(signal.y(:,k), coeff, 'same');  % no delay by using convolution
    end
    if(exist('pad','var')) 
        signalout.t = signalin.t;
        signalout.y = signalin.y;
        signalout.y(ceil(length/2): end-(ceil(length/2)),:) = signal.y(ceil(length/2): end-(ceil(length/2)),:);
    else
        signalout.t = signal.t(ceil(length/2): end-(ceil(length/2)),:);  % less of (len/2-1) points from front & len/2 point from rear 
        signalout.y = signal.y(ceil(length/2): end-(ceil(length/2)),:); % same as above; total reduction of points  = (len-1) points
    end
end % FUNCTION: signalfilter