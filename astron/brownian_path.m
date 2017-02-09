function [t,y,U] = brownian_path(maxt,dt,nruns)
    t = 0:dt:maxt;
    y = cumsum( randn(length(t)- 1,nruns) * sqrt(dt) );
    y = [zeros(1,nruns); y];
    U = exp(repmat(t',1,nruns) + y * 0.5);
%     y = zeros(length(t),nruns);
%     for j = 1 : nruns
%         random = randn(length(t)-1);
%         dw = sqrt(dt) * random(1);
%         y(1,j) = 0; % First value of the brownian motion is zero
%         y(2,j) = dw; % Second value of the brownian motion is set outside the
%                    % loop
%         for i = 3 : length(t)
%             dw = sqrt(dt) * random(i-1);
%             y(i,j) = y(i-1,j) + dw;
%         end
%     end
end