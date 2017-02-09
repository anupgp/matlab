function ahpstruct2csv(fname,s)
sFields = fieldnames(s)';
c = [sFields; struct2cell(s)'];
fid = fopen(fname,'w');
[nrow, ~] = size(c);
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r\n',c{1,:});
for row = 2: nrow
    fprintf(fid,'%s,%d,%s,%f,%f,%f,%f,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f \r\n',c{row,:});
end
fclose (fid);
end


