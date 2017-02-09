function allneurons=structobj2csv(fname,s)
fields = fieldnames(s)';
ahp = struct2cell(s);
[nr, nc] = size(ahp); % nr = no. of fields(~24), nc = no.of colums (no. of cells, ~12-19)
allneurons = cell(500,nr); % create an empty cell array to contain all the neurons
allneurons(1,:) = cellstr(fields);
swptop=2; % Start from the second row of the cell,  first row= column names
nstring=0;
nnumeric=0;
    for col = 1: nc
        nsweeps= length(cell2mat(ahp(end,col))); % find the no. of sweeps for a neuron from the length of the last field of the 1st col
        aneuron = cell(nsweeps,nr); % make a cell to contain all data of one field in one cell
        for row = 1: nr % for each row of the cellarray from a particular column
            afield = cell2mat(ahp(row,col)); % get one field for one neuron (particular row, col)
            if(ischar(afield)) % Check if the fied is a character
                aneuroncol(1:nsweeps) = cellstr(afield); %Repeats the field into all columns of the cell array
                if (col==1)
                    nstring = nstring+1;
                end
                elseif (length(afield)==1 && isnumeric(afield)) % Check if the field is numeric with a length of 1
                    aneuroncol(1:nsweeps) = num2cell(afield); %Repeats the field into all columns of the cell array
                if (col ==1)
                    nnumeric = nnumeric+1;
                end
            else
                aneuroncol(1:nsweeps) = num2cell(afield); 
                if (col ==1)
                    nnumeric = nnumeric+1;
                end
            end
            aneuron(1:nsweeps,row) = aneuroncol';
        end
        allneurons(swptop:swptop+nsweeps-1,:) = aneuron;
        clear aneuron; clear aneuroncol;
        swptop = swptop+nsweeps;
    end
    allneurons = allneurons(1:swptop-1,:);
    fid = fopen(fname,'w');
    fprintf(fid,[repmat('%s,',1,nr),'\r\n'],allneurons{1,:}); % print all column names in the first row
    for row = 2: size(allneurons,1)
        fprintf(fid,[repmat('%s,',1,nstring),repmat('%d,',1,nnumeric),'\r\n'],allneurons{row,:});
    end
    fclose (fid);
end
 
