function y = biexpfit(params,x)
y = zeros(length(x),1);
offset = params(1);
delay = params(2);
tau1 = params(3);
sfactor = params(4);
tau2 = params(5);

for i = 1:1:length(x)
    if (x(i) <= delay)
        y(i) = offset;
    end
    if (x(i) > delay)
        y(i) = offset + (sfactor*exp((delay-x(i))/tau1))-(sfactor*exp((delay-x(i))/tau2));
    end
end
y = y';
end
