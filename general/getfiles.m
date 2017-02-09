% Last Change 20131018
% Reads a CSV file and outputs a structure
% Commas seperate values
% What is ignored: anything after # until the end of line, spaces within line, spaces b/w lines
% Special characters and meanings: '[' or '(' indicates start of an array, '[' end of the array
%===========================================================
function expinfo = getfiles(file)
fid = fopen(file);
expinfo = cell(200,200);
idxline=0;
while ~feof(fid)
    tline = strtrim(fgetl(fid));
    hashloc = strfind(tline,'#');
    if(~isempty(hashloc) && hashloc(1)~=1)
        tline = tline(1:hashloc(1)-1);
    elseif(~isempty(hashloc) && hashloc(1)==1)
        tline=[];
    end
    if (length(tline)>1)
         idxline=idxline+1; 
        % get the values separated by comma, space
        valsall = strtrim(regexpi(tline,'[,]','split'));
        % remove values that are empty
        vals = valsall(~cellfun(@isempty,valsall));
        % get all the open and close bracket positions
        braces = find(~cellfun(@isempty,regexpi(vals,'[\[|\]|(|)]','match')));
        % get all values within first and last bracket
        if(~isempty(braces))
            valarray = str2double(vals((braces(1)+1): (braces(end)-1)));
            % replace the values in val that are within braces with a single value at the location of the first brace
            % adjoin the rest of the values 
            valsnew = {vals{(1:braces(1)-1)},{valarray},vals{(braces(end)+1:end)}};
        else
            valsnew = vals;
        end
        for i = 1: length(valsnew)
            if(iscell(valsnew{i}))
                %fprintf('found a cell array yeah');
                expinfo{idxline,i} = cell2mat(valsnew{i});
            elseif(~isempty(str2num(valsnew{i}))) % use str2num here! str2double returns NaN if Char not empty
                %fprintf('found a numeric value yeah');
                expinfo{idxline,i} = str2double(valsnew{i});
            else
                %fprintf('found a string yeah');
                expinfo{idxline,i} = valsnew{i};
                %fprintf('%d \n',i);
            end
        end        
    end
    fprintf('idxline=%d\n',idxline);
end
fclose(fid);
%Get the variable names in the first line
fieldnames={expinfo(1,1:length(valsnew))};
expinfo = cell2struct(expinfo(2:idxline,1:length(valsnew)),fieldnames{:},2);
fprintf('No. of files in the text file: %d\n',length(expinfo));
end