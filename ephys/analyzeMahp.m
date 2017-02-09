function ahpdata = analyzeMahp(IV,ahp) % IV and ahp are stuctures 
cellcnt=0;
ExtractIVfields = {'SeriesRes','InputRes','mTau'};
for i = 1: length(ahp)
    IVindx = find([IV.CellID]== ahp(i).CellID, 1);
    if(~isempty(IVindx) && ahp(i).Select ==1 && IV(IVindx).Select ==1)
        fprintf('working on the cellID: %d Select: %d\n', ahp(i).CellID,ahp(i).Select);
        ahpcell = AHPmarloes(IV(IVindx),ahp(i));
        Ahpval = ahpcell.org;
        IVval = ahpcell.IVpsv;
        cellcnt=cellcnt+1;
         if(cellcnt==1)
            %-------------------- contruct the AHPobj data database
            orgnames = fieldnames(Ahpval); % Get fieldnames of the structure 'org';
            objnames = fieldnames(ahpcell.Ahp); % Get fieldnames of the ahpstucture in the ahpobj
            objnames = objnames(1:2); % Reduce objnames to just the first three 
            datanames = [objnames',ExtractIVfields,orgnames'];
            ahpdata = cell2struct(cell(length(ahp),length(datanames)),datanames,2);
         end
        %---------------------Copy from obj properties to ahpdata
        for j = 1: length(objnames)
            ahpdata(cellcnt).(char(objnames(j))) = ahpcell.Ahp.(char(objnames(j)));
        end
        %---------------------Copy all the extracted fields of IVpsv to ahpdata
        for j = 1: length(ExtractIVfields)
            val =  IVval.(char(ExtractIVfields(j)));
            ahpdata(cellcnt).(char(ExtractIVfields(j))) = mean(val(~isnan(val))) ;
        end
        %---------------------Copy all the org fields to ahpdata
        for j = 1: length(orgnames)
            ahpdata(cellcnt).(char(orgnames(j))) = Ahpval.(char(orgnames(j)));
        end
    end
end
ahpdata = ahpdata(1:cellcnt);
end