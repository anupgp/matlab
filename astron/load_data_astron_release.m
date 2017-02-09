%% Function to read n files in steps and save specific columns in matrices
%  fnameprefix: prefix to generate the filename
%  fnamesuffix:   suffix to generate the filename
%  startfileindex: first filename index
%  stopfileindex:  last filename index
%  colnames:   a string vector of column names
%  maxloadnum: Maximum files to load in one go.
% ------------------------------------------------------------------------
function d = load_data_astron_release(fnameprefix,fnamesuffix,startfileindex,stopfileindex,colnames,maxloadnum)
% Read all column names from first file
filename = strcat(fnameprefix,num2str(startfileindex),fnamesuffix);
fid = fopen(filename);
allcolnames = textscan(fid,'%s',1);
fclose(fid);
allcolnames = char(allcolnames{:});
allcolnames = strsplit(allcolnames,',');
if(isempty(allcolnames))
    fprintf('Could not find column names from the first row\n');
    return;
end
% Find column indexes
colids = nan(1,length(colnames));
for i = 1:length(colnames)
    colid = find(cellfun('length',regexp(allcolnames,colnames(i))) == 1);
    if(isempty(colid))
        fprintf('Could not find a given column name in the file');
        return;
    end
    colids(i) = colid;
end
% display(colids);
startindex = startfileindex;
loadingcomplete = 0;
numcpucores = min([10,maxloadnum]);
% matlabpool('local',8); % For matlab2010b
%POOL = parpool('local',numcpucores); % For matlab2015b
while (~loadingcomplete)
    stopindex = startindex + maxloadnum - 1;
    if(stopindex >= stopfileindex)
        stopindex = stopfileindex;
        loadingcomplete = 1;
    end
    %parfor (i = startindex:stopindex,numcpucores)
    for i = startindex:stopindex
        filename = strcat(fnameprefix,num2str(i),fnamesuffix);
        fprintf('%s\n',filename);
        [dd,~] = swallow_csv(filename,'"',',','\');
        d(1:size(dd,1)-1,1:length(colids),i) = dd(2:end,[colids]);
    end
    startindex = stopindex + 1;
end
% matlabpool close; % For matlab2010b
%delete(POOL); % For matlab2015b
end
