function sse = expfitsse(params,t,y)
offset = params(1);
delay = params(2);
tau = params(3);
sfactor = params(4);
z = zeros(size(t,1),size(t,2));
for i = 1:1:length(t)
    if (t(i) <= delay)
        z(i) = offset;
    end
    if (t(i) > delay)
        z(i) = offset + (sfactor*exp((delay-t(i))/tau));
    end
end
sse = sum((y-z).^2);
end