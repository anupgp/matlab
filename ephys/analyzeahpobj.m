% Files that are to be analyzed.
function ahpdata = analyzeahpobj(textfile)
expinfo = getfiles(textfile);
fnames = char(expinfo(:).FileName);
fprintf('Total no. of cells in the file: %d\n',size(fnames,1));
cntAll=1; cntSelect=0;
figure('Visible','off'); % generate a figure window once
%drawnow;
%set(fh, 'Visible', 'Off');
while (cntAll <= size(fnames,1))
    fprintf('The %d cell in the file: %s \n',cntAll,fnames(cntAll,:));
    select = double([expinfo(cntAll).Select]);
    if (select==1)
        cntSelect=cntSelect+1;
        ahpobj = AhpClass(expinfo(cntAll));
        %plot(ahpobj.t,ahpobj.y(:,ahpobj.Sweeps>9));
        %pause;
        %close all;
        org = ahpobj.val;
        if(cntSelect==1)
            %-------------------- contruct the AHPobj data database
            orgnames = fieldnames(org); % Get fieldnames of the structure 'org';
            objnames = fieldnames(ahpobj); % Get fieldnames of the ahpobj
            objnames = objnames(1:9); % Reduce objnames to just the first nine
            datanames = [objnames',orgnames'];
            ahpdata = cell2struct(cell(length(fnames),length(datanames)),datanames,2);
        end
        %---------------------Copy from obj properties to ahpdata
        for i = 1: length(objnames)
            ahpdata(cntSelect).(char(objnames(i))) = ahpobj.(char(objnames(i)));
        end
        %---------------------Copy all the org fields to ahpdata
        for i = 1: length(orgnames)
            ahpdata(cntSelect).(char(orgnames(i))) = org.(char(orgnames(i)));
        end
    end
    cntAll = cntAll+1;
end
 ahpdata = ahpdata(1:cntSelect);
end