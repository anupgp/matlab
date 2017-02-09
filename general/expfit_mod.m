function z = expfit(params,x)
offset = params(1);
delay = params(2);
tau1 = params(3);
sfactor = params(4);
for i = 1:1:length(x)
    if (x(i) <= delay)
        z(i) = offset;
    end
    if (x(i) > delay)
        z(i) = offset + (sfactor*exp((delay-x(i))/tau1));
    end
end
z = z';
end