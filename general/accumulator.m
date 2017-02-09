function counter = accumulator(value)
    function counter(k)
        assignin('caller','value',value+k); 
    end
end