% Function plots the selected parameter across another selected parameter
% for two groups
%This is modified version of AHP_Plot.m so that it accepts x,y and a
%conditonal parameter z. All given as vectors
function  ahpplot_mod(rawg,rawx,rawy)
close all;
totx =  find(rawx==min(rawx(diff(rawx)<0)), 1 );
fprintf(' no. of parameterx values = %d\n',totx);
[sortg, gindx] = sort(rawg);
sortx = rawx(gindx);
sorty = rawy(gindx);
%Find the border between the two groups (CC & CV)
bordindx=min(strmatch(sortg{end},sortg));
% Split the vectors into two groups
x1 = sortx(1:bordindx-1);
y1 = sorty(1:bordindx-1);
g1 = sortg(1:bordindx-1);
%-----
x2 = sortx(bordindx:end);
y2 = sorty(bordindx:end);
g2 = sortg(bordindx:end);
%Reshape the splitted vectors into a matrix, one column for each cell,
%row for each trace.
x1 = reshape(x1, totx,int32(length(x1)/totx)); % group CC
y1 = reshape(y1, totx,int32(length(y1)/totx));
g1 = reshape(g1, totx,int32(length(g1)/totx));
avgy1 = mean(y1,2);
%-------
x2 = reshape(x2, totx,int32(length(x2)/totx));   % group CV
y2 = reshape(y2, totx,int32(length(y2)/totx));
g2 = reshape(g2, totx,int32(length(g2)/totx));
avgy2 = mean(y2,2);
% Check whether the group splitting went well
if (~isempty(strmatch('sortg{1}',g1)) || ~isempty(strmatch('sortg{end}',g2)))
    disp('Spliting of groups is not right, we abort!');
    return;
end
%Plot the two groups in seperate plots and get their handles
h1= plot(x1,y1,'ro'); hold on;
h2=plot(x2,y2,'bo');
% plot(x1,avgy1);
% plot(x2,avgy2);
%Make hggroup objects
h1group = hggroup;
h2group = hggroup;
%Set groups objects
set(h1,'Parent', h1group);
set(h2,'Parent',h2group);
%Include them in legend
set(get(get(h1group,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); 
set(get(get(h2group,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); 
%Display legend with no.of cells/group
legend([g1{1},'  ',num2str(size(g1,2))],[g2{1},'  ',num2str(size(g2,2))]);
end