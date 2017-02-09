% Files that are to be analyzed.
function supersumdata = analyzeEpscSupersumObj(textfile)
expinfo = getfiles(textfile);
fnames = [expinfo(:).FileName];
fprintf('Total no. of cells in the file: %d\n',length(fnames));
cnt=1;
while (cnt <=length(fnames))
    fprintf('The %d cell in the file: %s \n',cnt,char(fnames(cnt)));
    supersumobj = EpscSupersumClass(expinfo(cnt));
    org = supersumobj.val;
%-------------------- contruct the AHPobj data database
    if(cnt==1)
        orgnames = fieldnames(org); % Get fieldnames of the structure 'org';
        objnames = fieldnames(supersumobj); % Get fieldnames of the ahpobj
        objnames = objnames(1:9); % Reduce objnames to just the first nine
        datanames = [objnames',orgnames'];
        supersumdata = cell2struct(cell(length(fnames),length(datanames)),datanames,2);
    end    
%---------------------Copy from obj properties to ahpdata
    for i = 1: length(objnames)
        supersumdata(cnt).(char(objnames(i))) = supersumobj.(char(objnames(i)));
    end
%---------------------Copy all the org fields to ahpdata
    for i = 1: length(orgnames)
        supersumdata(cnt).(char(orgnames(i))) = org.(char(orgnames(i)));
    end
    cnt = cnt+1;
end
supersumdata = supersumdata(1:cnt-1);
end