% Function plots the selected parameter across another selected parameter
% for two groups
function  ahpplot(s, group, paramx,paramy)
close all;

%Check if the given structure has met the conditions
if ( ~isstruct(s) || ~(isfield(s,paramx) && isfield(s,paramy) && isfield(s,group)))
    fprintf(' s has to be a structure with fields %s & %s as params \n',paramx, paramy);
    return;
end
totx =  sum(strcmpi(s(1).fname,{s.fname}));
fprintf(' no. of parameterx values = %d\n',totx);
rawx = [s.(paramx)];
rawy = [s.(paramy)];
rawg = {s.(group)};
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
x1 = reshape(x1, totx,length(x1)/totx); % group CC
y1 = reshape(y1, totx,length(y1)/totx);
g1 = reshape(g1, totx,length(g1)/totx);
avgy1 = mean(y1,2);
%-------
x2 = reshape(x2, totx,length(x2)/totx);   % group CV
y2 = reshape(y2, totx,length(y2)/totx);
g2 = reshape(g2, totx,length(g2)/totx);
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