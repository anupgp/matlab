yvarmat2 = maxtall;
%%
close all;
set(0,'DefaultFigureWindowStyle','docked');
%%
ncol = 30;
mintime = 99;
maxtime = 150;
edgevec = mintime:0.050:maxtime;
histcomplete1 = zeros(length(edgevec),ncol);
histcomplete2 = zeros(length(edgevec),ncol);
for i = 1 : ncol
    histcomplete1(:,i) = histc(yvarmat1(:,i),edgevec);
    histcomplete2(:,i) = histc(yvarmat2(:,i),edgevec);
end
%histcomplete1 = mean(histcomplete1,2);
%histcomplete2 = mean(histcomplete2,2);
%%
close all;
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [40,35,25,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
exploop = [100:50:950,1000:1000:12000];
vs1 = textscan(num2str(exploop),'%s')';
vs2 = cell(1,length(exploop));
vs2(:) = {'nM'};
vs3 = strcat(vs1{1}',vs2);
ncol = 15;
fh1 = bar(edgevec,histcomplete2(:,ncol),1);
hold on
fh2 = bar(edgevec,histcomplete1(:,ncol),1);
%fch = get(fh,'Children');
set(fh1,'FaceColor','blue');
set(fh1,'EdgeColor','blue');
set(fh2,'FaceColor','red');
set(fh2,'EdgeColor','red');
set(gca,'XLim',[100,150]);
xlabel(gca,sprintf('Time (sec)'),'Fontsize',20);
ylabel(gca,sprintf('Release count'),'Fontsize',20);
title(gca,['Histogram releases: [Ca^{2+}]_{i}: ',strrep(sprintf('%s',vs3{ncol}),sprintf('\n'),'')],'Fontsize',20);
set(gca,'FontSize',18);
figname = ['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/cacyt',vs3{ncol},'_','histogram_spon_asyn_flag.jpeg'];
%print(gcf,'-djpeg',['-r','200'],figname);
%% Plot histogram of releases in a matrix
varname = 'n0gluves_asyn_flag';
varid = ~cellfun(@isempty,strfind(colnames,varname));
datmat = [sumd(:,1,1),reshape(sumd(:,varid,:),size(sumd,1),size(sumd,3))];
%% Plot cumulative histogram of releases for each calcium concentration
close all;
% print settings
set(gca,'Units','pixels');
set(gca,'OuterPosition', get(gca,'OuterPosition') + [0,35,0,40]); % [left bottom width height]
set(gca,'Position', get(gca,'Position') + [0,0,50,0]);
exploop = [100:50:950,1000:1000:12000];
vs1 = textscan(num2str(exploop),'%s')';
vs2 = cell(1,length(exploop));
vs2(:) = {'nM'};
vs3 = strcat(vs1{1}',vs2);
fh1 = plot(edgevec,cumsum(histcomplete2),'LineWidth',2);
set(gca,'XLim',[90,150]);
set(gca,'FontSize',18);
title(gca,'Cumulative asynchronous releases (1 sec)','Fontsize',20);
lgd1 = legend(vs3,'Position',[650, 270, 0.2, 0.2],'FontSize',8);
figname = ['/home/anup/goofy/projects/data/astron/figures/astrocyte/atprelease/','asynrelease1s_cumhist','.jpeg'];
%print(gcf,'-djpeg',['-r','200'],figname);
