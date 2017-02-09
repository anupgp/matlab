function [xd,yd] = diffanup(x,y,step) % Numerical derivative with a step size
            if (nargin <=2)
                step=1;
            end
            if (rem(step,2) ~= 0)
                step = step+1;
                disp(['Step has to be even! Step is now:',num2str(step)]);
            end
            xd = NaN(floor(length(x)/step),1);
            yd = NaN(floor(length(x)/step),1);
            j=0;
            for i = step+1:step: length(x)
                j = j+1;
                yd(j) = (y(i)-y(i-step)) / (x(i)-x(i-step));
                xd(j) = mean(x((i-step):i));
            end
        end