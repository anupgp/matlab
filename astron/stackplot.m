function fh = stackplot(mymat,lw)
% check if the given matrix is a 2d matrix
% Find the maximum value for each column starting from the 2nd
% store those maximum values in a vector
close all;
set(0,'DefaultFigureWindowStyle','docked');
fh=figure;
hold on;
s = zeros(size(mymat,2),1);
for i = 1:size(mymat,2)
    s(i) = max(mymat(:,i));
end
s_cum = cumsum(s); % specifies the gap for each subsequent plot
s_cum(1,1) = 0;
extra_gap = 0; % extra gap for the last plot
colormap = hsv(size(s,1));
for j = 2:size(mymat,2) 
    if(j+1 >= lw)
        lwidth = 2;
    else
        lwidth = 1;
    end
    plot(mymat(:,1),mymat(:,j) + 0 + extra_gap,'color',colormap(j-1,:),'Linewidth',lwidth);
end
%xlim([0, max(mymat(:,1))]);
%ylim([s(1), max(s) +  extra_gap]);
disp(size(s));
end

