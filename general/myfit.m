function sse=myfit(params,x,y)
offset = params(1);
delay = params(2);
tau1 = params(3);
sfactor = params(4);
tau2 = params(5);

for i = 1:1:length(x)
    if (x(i) <= delay)
        z(i) = offset;
    end
    if (x(i) > delay)
        z(i) = offset + (sfactor*exp((delay-x(i))/tau1))-(sfactor*exp((delay-x(i))/tau2));
    end
end
z = z'
error = z - y;
% options = optimset('Display','iter')
% Initials = [-250 0.013 0.01 -250 0.01]
% k = fminsearch(@myfit,Initials,options,x,y)
% When curvefitting, a typical quantity to
% minimize is the sum of squares error
sse=sum(error.^2);
%sse=0
% You could also write sse as
% sse=Error_Vector(:)'*Error_Vector(:);
end

