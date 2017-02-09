% Files that are to be analyzed.
function ahpdata = analyzeAHPIVObj(textfile)
expinfo = getfiles(textfile);
fnames = [expinfo(:).FileName];
fprintf('Total no. of cells in the file: %d\n',length(fnames));
cnt=1;
while (cnt <=length(fnames))
    fprintf('The %d cell in the file: %s \n',cnt,char(fnames(cnt)));
    ahpobj = AHPIVClass(expinfo(cnt));
    org = ahpobj.val;
%-------------------- contruct the AHPobj data database
    if(cnt==1)
        orgnames = fieldnames(org); % Get fieldnames of the structure 'org';
        objnames = fieldnames(ahpobj); % Get fieldnames of the ahpobj
        objnames = objnames(1:8); % Reduce objnames to just the first eight
        datanames = [objnames',orgnames'];
        ahpdata = cell2struct(cell(length(fnames),length(datanames)),datanames,2);
    end    
%---------------------Copy from obj properties to ahpdata
    for i = 1: length(objnames)
        ahpdata(cnt).(char(objnames(i))) = ahpobj.(char(objnames(i)));
    end
%---------------------Copy all the org fields to ahpdata
    for i = 1: length(orgnames)
        ahpdata(cnt).(char(orgnames(i))) = org.(char(orgnames(i)));
    end
    cnt = cnt+1;
end
ahpdata = ahpdata(1:cnt-1);
end