% Time-stamp: <2016-02-14 12:34:55 anup>
% GET_IRI_RRI_FROMFILES This function will produce a single
% matrix containing histogram of inter-release-intervals (IRI) and
% relative-release-intervals (RRI) from files. 
% Format of the input-file: COl1: Time, COL2: release-inducing
% stimulus, COL3: releases
%
% Usage:
% get_iri_rri_fromfiles(fname,start_index,stop_index,colnames,y1_thrs,y2_thrs)
% y1_thrs/y2_thrs: threshold for detecting y1, y2 spikes
% 
function outmat = get_iri_rri_fromfiles(fname,start_index,stop_index, ...
                                    colnames,y1_thrs,y2_thrs)
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
    outmat = [];
    for i = start_index : stop_index
        % Load one file at a time
        dfname = [path_name,file_name,num2str(i),extn_name];
        fprintf('Reading file: %s\n',dfname);
        [d,~] = swallow_csv(dfname,'"',',','\');
        % Read the header to get all column names
        allcolnames=textscan(fopen(dfname),'%s',1);fclose('all');
        allcolnames = char(allcolnames{:});allcolnames = strsplit(allcolnames,',');
        t_id = find(~cellfun(@isempty,strfind(allcolnames,colnames{1})))
        y1_id = find(~cellfun(@isempty,strfind(allcolnames,colnames{2})))
        y2_id = find(~cellfun(@isempty,strfind(allcolnames, ...
                                               colnames{3})))
        if(isempty(t_id) | isempty(y1_id) | isempty(y2_id))
            fprintf(['Required columns not found. Please check the ' ...
                     'matrix and/or column names']);
            return;
        end
        % Compute y2 absolute and relative spike times
        y2_rri = relspktimedist(d(:,t_id),d(:,y1_id),y1_thrs,d(:,y2_id),y2_thrs);
        y2_iri = [NaN;diff(y2_rri(:,1))];
        disp(size(y2_rri));
        disp(size(y2_iri));
        outmat = vertcat(outmat,[y2_rri,y2_iri]);
end




