% Time-stamp: <2016-02-12 10:48:47 anup>
% AVGFILES Function will apply produce a single matrix averaged
% from all the matrices from each file. It will return a single matrix with the same dimension as the matrix
% from a single file
%
% Usage: avgfiles(fname,start_index,stop_index,fun_hand)
function avgfiles(fname,start_index,stop_index)
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
    for i = start_index : stop_index
        % Load one file at a time
        dfname = [path_name,file_name,num2str(i),extn_name];
        fprintf('Reading file: %s\n',dfname);
        [d,~] = swallow_csv(dfname,'"',',','\');
        colnames=textscan(fopen(dfname),'%s',1);fclose('all');
        col_names = char(colnames{:});col_names = strsplit(col_names,',');
        % d = magic(size(col_names,2));
        if(i == start_index)
            outmat = zeros(size(d));
        end
        outmat = outmat + d;
    end
    outmat = outmat/((stop_index-start_index)+1);
    % Writes the new matrix into a csv file 
    out_fname = [path_name,file_name,'_avg',extn_name];
    fid = fopen(out_fname, 'w','native','UTF-8');
    for i = 1 : size(col_names,2);
        fprintf(fid,'%s,',col_names{i});
    end
    fprintf(fid,'\n');
    fclose(fid);
    dlmwrite(out_fname,d,'-append');
end