% Time-stamp: <2016-02-14 10:41:32 anup>
% GETCOLUMNSFROMFILES Function will subset the columns from a list
% of files. Optionally, it can take a start and end time to select only a
% range of rows defined by the time
%
% Usage: getcolumnsfromfiles(fname,start_index,stop_index,colnames,[start-time,
% stop-time])
function getcolumnsfromfiles(fname,start_index,stop_index,colnames,varargin)
% seperate path and filename from fname_prefix
    slash_indices = strfind(fname,'/');
    path_name = fname(1:slash_indices(end));
    fname2 = fname(slash_indices(end)+1:end);
    % seperate file extension from filename 
    extn_name = fname2(strfind(fname2,'.'):end);
    file_name = fname2(1:strfind(fname2,'.')-1);
    fprintf(['Path = ', path_name,'\n']);
    fprintf(['Filename = ', file_name,'\n']);
    fprintf(['Extn = ', extn_name,'\n']);
    % display(nargin);
    if(nargin >4)
        start_time = varargin{1};
        fprintf('Start_time = %d\n',start_time);  
    end
    if(nargin > 5)
        stop_time = varargin{2};
        fprintf('Stop_time = %d\n',stop_time);  
    end
    for i = start_index : stop_index
        % Load one file at a time
        dfname = [path_name,file_name,num2str(i),extn_name];
        fprintf('Reading file: %s\n',dfname);
        [d,~] = swallow_csv(dfname,'"',',','\');
        % Read the header to get all column names
        allcolnames=textscan(fopen(dfname),'%s',1);fclose('all');
        allcolnames = char(allcolnames{:});allcolnames = strsplit(allcolnames,',');
        % Filename of the extracted columns 
        out_fname = [path_name,file_name,'_sub',num2str(i),extn_name];
        fid = fopen(out_fname, 'w','native','UTF-8');
        % Generate an array containing the indices of the required
        % columns
        col_ids = [];
        for j = colnames
           col_ids = [col_ids,find(~cellfun(@isempty,strfind(allcolnames,char(j))))];
        end
        % Writes the header first
        for k = 1 : size(colnames,2)-1;
            fprintf(fid,'%s,',colnames{k});
        end
        fprintf(fid,'%s\n',colnames{size(colnames,2)});
        fclose(fid);
        % Writes the new matrix into a csv file 
        if(exist('start_time','var') & exist('stop_time','var'))
            dlmwrite(out_fname,d(d(:,1)>=start_time & d(:,1) <=stop_time,col_ids),'roffset',0,'delimiter',',','precision',16,'newline','pc','-append');    
        else
            dlmwrite(out_fname,d(:,col_ids),'roffset',0,'delimiter',',','precision',16,'newline','pc','-append');
        end
    end
end