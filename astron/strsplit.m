function str_out = strsplit(str_in,delim)
delim_pos = strfind(str_in,delim);
count=0;
pre_pos = 1;
cur_pos = 1;
while cur_pos <= delim_pos(end-1)
    count = count+1;
    cur_pos = delim_pos(count); 
    str_out{count} = str_in(pre_pos:cur_pos-1);
    pre_pos = cur_pos + 1;
    cur_pos = delim_pos(count);
end
if (length(str_in)>delim_pos(end))
    str_out{count+1} = str_in(pre_pos:end);
end
end