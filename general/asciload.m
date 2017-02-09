function [t,y] = asciload(fname,trcLen,numTrc)
fprintf('Reading file: %s',char(fname));
t= nan(trcLen,numTrc);
y=nan(trcLen,numTrc);
fid = fopen(fname);
cntTrc=0;
numStart=0;
while (~feof(fid))
    fields = regexpi(fgetl(fid),',','split');
    if ( isequal(str2double(fields{1}),0) )
        cntTrc=cntTrc+1;
        fseek(fid,numStart,'bof');
        data=textscan(fid,'%d %f %f',trcLen,'Delimiter',',','HeaderLines',0);
%         data=textscan(fid,'%d %f %f',trcLen,'Delimiter',',','HeaderLines',0);
        disp(size(data{3}));
        t(:,cntTrc)=data{2};
        y(:,cntTrc)=data{3};
    end
    numStart = ftell(fid);
end
    
    