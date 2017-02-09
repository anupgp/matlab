function expinfo = Csv2Struct(filename)
% Warning: it is expected that the first row contains the field names!
disp('Warning: it is expected that the first row contains the field names!');
fid = fopen(filename);
expinfo = cell(100,100);
% files = fscanf(fid,'%s\n');
% Read the file containing the list of files
% tline = char(0);
idxLine=1;
while ~feof(fid)
    tline = fgetl(fid);
    comas = regexpi(tline,',','start');
    idxComa=1;
    idxLeft=1;
    while (idxComa<=length(comas)&& ischar(tline))
        expinfo{idxLine,idxComa} = {tline(idxLeft:comas(idxComa)-1)};
         text = char(expinfo{idxLine,idxComa});
         braces = regexpi(text,'[()]','start');
         if(length(braces)>1 )
            expinfo{idxLine,idxComa} = str2double(regexpi(text(braces(1)+1:braces(2)-1),' ', 'split'));
            if ( isnan(str2double(regexpi(text(braces(1)+1:braces(2)-1),' ', 'split')))) 
                expinfo{idxLine,idxComa} = [];
            end
         end
         if(~isnan(str2double(text)))
            expinfo{idxLine,idxComa} = str2double(text);
         end
        idxLeft=comas(idxComa)+1;
        idxComa=idxComa+1;    
    end
%     disp({tline(1:10)});
        idxLine = idxLine+1;
end
fclose(fid);
%Get the variable names in the first line
fieldnames = expinfo(1,1:length(comas));
fieldnames = [fieldnames{:}];
expinfo =expinfo(2:idxLine-1,1:length(comas));
fprintf('No. of files in the text file: %d\n',length(expinfo));
expinfo = cell2struct(expinfo,fieldnames,2);
end