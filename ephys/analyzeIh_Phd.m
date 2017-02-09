% The function to analyze all the Ih sag voltage ratios from each cell
function [pre, post] = analyzeIh_Phd(expfile)
expinfo = getfiles(expfile);
fnames = [expinfo{:,1}];
pre = nan(12,length(fnames)); % 12 current injections from high to low
post = nan(12,length(fnames)); % 12 current injections from high to low
fprintf('Total no. of cells in the file: %d\n',length(fnames) );
precnt=1;postcnt=1;
for i = 1:length(fnames)
    tracelength = expinfo{i,2};
    ntraces = expinfo{i,3};
    % Load the data from ASCII files
    disp(fnames(i));
    [t,y] = asciload(char(fnames(i)),tracelength,ntraces);
    % Filter the data
    [t2,y2] = gaussfilt2d(t,y,1000,1000/3);
    clear t;
    clear y;
    sagratios = getIh(t2,y2);
%     get raw AHP data 
       if (~isempty(strfind(char(fnames(i)),'pre')) || ~isempty(strfind(char(fnames(i)),'Pre')) || ~isempty(strfind(char(fnames(i)),'PRE')))
           pre(:,precnt)= sagratios;
           precnt=precnt+1;
       else
           post(:,postcnt)= sagratios;
           postcnt=postcnt+1;
       end
end
    pre = pre(:,1:precnt-1);
    post = post(:,1:postcnt-1);
disp(precnt);
disp(postcnt);
end