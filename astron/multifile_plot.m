function ddall = multifile_plot(base_fname,nruns,col_id)
set(0,'DefaultFigureWindowStyle','docked');
close all;
colormap = hsv(nruns);
for i = 0:nruns-1
    fname = strcat(base_fname,'_',num2str(i))
    dd = load(fname);
    if(i == 0)
        size(dd)
        ddall = zeros(size(dd));
    end
    ddall = ddall + dd;
    plot(dd(:,1),dd(:,col_id),'Color',colormap(i+1,:) );
    hold on;
    if (~isempty(find(dd(:,6)>0,1,'first')))
        loc = find(dd(:,6)>0,1,'first')
        display(loc);
    end
end
ddall = ddall ./ nruns;
    