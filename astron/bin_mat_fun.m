% Time-stamp: <2016-02-11 12:12:59 anup>
% BIN_MAT_FUN Apply the specified function (with the fun_hand) to the given
% matrix to the range of time specified by the bin_interval
% 
% Usage: bin_mat_fun(mymat,20,@sum)
% mymat:   a matrix with time as first column
% 20:      bin interval
% @sum:    function handle 
function outmat = bin_mat_fun(inmat,bin_interval,fun_hand)
% First column is assumed time and start with 0.0
    dt = inmat(2,1)-inmat(1,1);
    maxt = inmat(end,1);
    if (dt <= 0) 
        disp('dt is negative! ... aborting.');
        return;
    end
    step = round(bin_interval/dt);
    outmat_size = [round(size(inmat,1)/step),size(inmat,2)]
    outmat = zeros(outmat_size);
    for rows = 1 : size(outmat,1)
        left = ((rows-1) * step) + 1;
        right = left + step;
        if(right > size(inmat,1));
            right = size(inmat,1);
        end
        outmat(rows,2) = fun_hand(inmat(left:right,2),1);
        %         outmat(rows,1) = round(median(inmat(left:right,1),1));
        outmat(rows,1) = inmat(left,1);
    end
end
