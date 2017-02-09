% Files that are to be analyzed.
function objdata = analyzeEpscIVObj(textfile)
expinfo = getfiles(textfile);
fnames = [expinfo(:).FileName];
fprintf('Total no. of cells in the file: %d\n',length(fnames));
cnt=1;
while (cnt <=length(fnames))
    fprintf('The %d cell in the file: %s \n',cnt,char(fnames(cnt)));
    obj = EpscIVClass(expinfo(cnt));
    org = obj.val;
%-------------------- contruct the AHPobj data database
    if(cnt==1)
        orgnames = fieldnames(org); % Get fieldnames of the structure 'org';
        objnames = fieldnames(obj); % Get fieldnames of the ahpobj
        objnames = objnames(1:17); % Reduce objnames to just the first seven
        datanames = [objnames',orgnames'];
        objdata = cell2struct(cell(length(fnames),length(datanames)),datanames,2);
    end    
%---------------------Copy from obj properties to ahpdata
    for i = 1: length(objnames)
        objdata(cnt).(char(objnames(i))) = obj.(char(objnames(i)));
    end
%---------------------Copy all the org fields to ahpdata
    for i = 1: length(orgnames)
        objdata(cnt).(char(orgnames(i))) = org.(char(orgnames(i)));
    end
    cnt = cnt+1;
end
objdata = objdata(1:cnt-1);
end