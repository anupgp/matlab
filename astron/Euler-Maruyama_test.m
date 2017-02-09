fuction [t, y] = Euler_Maruyama_test(tmax,dt,dt_em,lambda,mu,X0)
    % a test for Euler-Maruyama method using a test SDE 
    % Test SDE: dX = lambda*X dt + mu * X * dW
    % Compute the Brownian paths
    Nw = round(tmax/dt);
    dW = cumsum(randn(1,Nw) * sqrt(dt));
    t = dt:dt:tmax;
    y = dW;
end