function outmat = circle_area(N)
    close all;
    figure;
    hold on;
   for i = 1 : N
       x =  rand(1);
       y = rand(1);
       outmat(i,:) = [x, y,(x*x + y*y) > 1,0,0];
       plot(x,y,'o','color',[(x*x + y*y > 1), 0, 0]);
   end
end