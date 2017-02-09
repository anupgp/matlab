function [mat,matavg,matsem] = laserplot(lasertimes,velocity,n)
    mat = zeros(2*n,length(lasertimes));
    i = 1;
    for i = 1: length(lasertimes)
        mat(:,i) = velocity([find(velocity(:,1) >= lasertimes(i) - n & velocity(:,1) <= lasertimes(i) ),...
                find(velocity(:,1) <= lasertimes(i) + n & velocity(:,1) >= lasertimes(i) )],2);
    end
    matavg = mean(mat,2);
    matsem = std(mat,0,2)/sqrt(size(mat,2));
    %mat = [mat;matavg;matsem];
end
    
    