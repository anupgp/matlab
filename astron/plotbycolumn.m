function plotbycolumn(fig,df,colnames,plotcolnames,scales,legendon)
%PLOTBYCOLUMN    Plot columns in the given matrix whose colnames are in the plotcolnames string vector.
%
%   plotbycolumn(df,colnames,plotcolnames,scales,legendon)
%
%   df: The input matrix of double
%   colnames: A string vector that holds all the column names
%   plotcolnames: A string vector that holds the names of columns to plot
%   scales: A vector of double that scales each plotted column
%   legendon : A boolean describing if a legend is needed

% Check that columns in df == length of colnames
if (size(df,2) ~= length(colnames))
    fprintf('No.of columns in df is not equal to length of colnames \n');
end
% Check if all the names of plotcolnames are in the colnames
for mi = 1: length(plotcolnames)
    if(isempty(find(~cellfun(@isempty,strfind(colnames,char(plotcolnames(mi)))))))
        fprintf('Not all plotcolumns are in the colnames! \n');
        return;
    end
end
% Check if scales vector is provides
if (~exist('scales','var'))
    fprintf('Scales vector not provided - defaults to 1 for all columns \n');
    scales = ones(size(plotcolnames));
end
% Check if the scales vector length is same as plotcolnames
if (length(scales) ~= length(plotcolnames))
    fprintf('Length of scales vector is not equal to length of colnames \n');
    return;
end
% Generate color names for all plotcolumns
%colormap = hsv(length(plotcolnames));
colormap = jet(length(plotcolnames));
% Generate overlayed plots of columns
% close all;
% fig = figure;
% Place axes at (0.1,0.1) with width and height of 0.8
% haxes1 = axes('position', [0.155 0.15 0.8 0.8]);
% pos = get(fig,'Position');
% outer_pos = get(fig,'OuterPosition');
hold off;
for mi= 1 : length(plotcolnames)
    plotcolindex = find(strcmp(colnames,plotcolnames(mi))==1,1);
    plot(df(:,1),df(:,plotcolindex)*scales(mi),'Color',colormap(mi,:),'LineWidth',1); hold on;
end
% Add legends and replace underscore characters with dash
if(exist('legendon','var') && legendon == 1)
%     legend(haxes1,strrep(plotcolnames,'_','-'));
    legend(strrep(plotcolnames,'_','-'));
end
end
