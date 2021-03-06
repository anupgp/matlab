%% Plot astrocyte release histogram for atp pulse: data of individual runs stored in 3d matrix
% d:  data matrix
% thres: threshold vector for all columns not including the first time column
% startt:   start time
% stopt: stop time
% binsize: bin size for the histogram plot
% plotcol: index of the column to plot histogram
% ------------------------------------------------------------------------

function [bins_maxt,avg_hmaxt] = generate_histogram_plot(d,thres,startt,stopt,binsize,plotcol)
if(length(thres) ~= size(d,2) - 1)
   fprintf('%s\n','Length of threshold vector not matching with the no.of columns');
   return;
end
% Initialize the edge vector for histogram
bins_maxt = startt:binsize:stopt;
% Initialize the time and hist matrices
dmaxt = zeros(size(d,1),size(d,2)-1,size(d,3));
dmaxy = zeros(size(d,1),size(d,2)-1,size(d,3));
hmaxt = zeros(length(bins_maxt),size(d,2)-1,size(d,3));
imaxt = zeros(length(bins_maxt),size(d,2)-1,size(d,3));
% Detect times of spikes
for run = 1:size(d,3)
   for col = 2: size(d,2)
      [nspk,mint,miny,maxt,maxy] = count_spikes(d(:,1,run),d(:,col,run),thres(col-1));
      %fprintf('%d\t',maxt);
      if(~isempty(maxt))
         dmaxt(1:length(maxt),col-1,run) = maxt';
         dmaxy(1:length(maxy),col-1,run) = maxy';
         % Compute histogram
         [hmaxt(:,col-1,run), imaxt] = histc(maxt',bins_maxt);
      end
   end
end
% Mean and standard error of histograms
avg_hmaxt = mean(hmaxt,3);
sem_hmaxt = std(hmaxt,0,3)/sqrt(size(d,3));
% Ploting the histogram
%close all;
hold off
fh = bar(bins_maxt,avg_hmaxt(:,plotcol),1);
% Plot error bars
hold on;
for i = 1: length(bins_maxt)
   eh1 = plot([bins_maxt(i), bins_maxt(i)],[avg_hmaxt(i,plotcol)-sem_hmaxt(i,plotcol),avg_hmaxt(i,plotcol)+sem_hmaxt(i,plotcol)]);
   set(eh1,'Color',[0.5,0.5,0.5],'Linestyle','-');
   set(eh1,'LineWidth',2);
end
%eh2 = plot(bins_maxt,dhavg(:,plotcol)+dhsem(:,plotcol));
end
