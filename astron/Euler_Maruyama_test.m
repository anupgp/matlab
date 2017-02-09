function [tem, Xem, t, Xsol] = Euler_Maruyama_test(tmax,dt,lambda,mu,X0)
    % a test for Euler-Maruyama method using a test SDE 
    % Test SDE: dX = lambda*X dt + mu * X * dW
    % Solution for test SDE: X(0) * exp( (lambda-0.5*mu*mu)*t + mu*W(t) )
    % Compute the Brownian paths
    Nw = round(tmax/dt);
    dW = randn(1,Nw) * sqrt(dt);
    W = cumsum(dW); 
    t = dt:dt:tmax;
    R = 1;
    Nem = Nw/R;
    dt_em = dt*R;
    Xtemp = X0;
    Xem = zeros(1,Nem);
    dW_em = zeros(1,Nem);
    tem = dt_em:dt_em:tmax;
    for i = 1:Nem
        dW_em(i) = sum(dW(R*(i-1) + 1: R*i));
        dX = lambda*Xtemp*dt_em + mu*Xtemp*dW_em(i);
        Xem(i) = Xtemp + dX;
        Xtemp = Xem(i);
    end
    Xsol = X0 * exp( ((lambda - (0.5 * mu^2)) * t) + (mu * W));  
end