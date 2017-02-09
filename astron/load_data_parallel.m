%% Matlab parellel jobs - only a maximum of 8 cores supported (R2010b)!
function [d] = load_data_parallel(d,fnameprefix,first,last)
try
   fname = strcat(fnameprefix,num2str(first),'.csv');
   [~,~] = swallow_csv(fname,'"',',','\');
catch ME
   fprintf('Could not load file: %s\n',fname);
   fprintf('Exiting the function\n');
   return;
end
matlabpool('local',8);
%poolobj = parpool('local',20);
parfor (i = first:last,8)
   fname = strcat(fnameprefix,num2str(i),'.csv');
   fprintf('%s\n',fname);
   %d(:,:,i) = csvread(fname,1,0); % row offset = 1, col offset = 0
   [d(:,:,i),~] = swallow_csv(fname,'"',',','\');
end
matlabpool close;
%delete(poolobj);
end
%% Matlab parellel jobs - only a maximum of 8 cores supported! (R2010b)
%matlabpool('local',8)
fname_prefix = '/mnt/temp1/data/astron/raw/astrocyte/release/cacyt12000nM_';
d = [];
parfor (i = 201:400,8)
    fname = strcat(fname_prefix,num2str(i),'.csv');
    fprintf('%s\n',fname);
    %d(:,:,i) = csvread(fname,1,0); % row offset = 1, col offset = 0
    [d(:,:,i),~] = swallow_csv(fname,'"',',','\');
end

parfor (i = 101:200,8)
    fname = strcat(fname_prefix,num2str(i),'.csv');
    fprintf('%s\n',fname);
    d(:,:,i) = csvread(fname,1,0); % row offset = 1, col offset = 0
    %[d(:,:,i),~] = swallow_csv(fname,'"',',','\');
end
Matlab close parellel jobs
matlabpool close


