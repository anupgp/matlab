function [tx,vx,vd] = diffspike(t,v,step) % Numerical derivative with a step size
            if (nargin <=2)
                step=1;
            end
            if (rem(step,2) ~= 0)
                step = step+1;
                disp(['Step has to be even! Step is now:',num2str(step)]);
            end
            tx = NaN(floor(length(t)/step),1);
            vx = NaN(floor(length(t)/step),1);
            vd = NaN(floor(length(t)/step),1);
            j=0;
            for k = step+1:step: length(t)
                j = j+1;
                vd(j) = (v(k)-v(k-step)) / (t(k)-t(k-step));
                vx(j) = mean(v((k-step):k));
                tx(j) = mean(t((k-step):k));
            end
        end % End diffspike