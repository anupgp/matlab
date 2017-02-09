function C = chopandcombine(A,B)
% A and B are mtrices that need to be combined to C
% A and B are of type: A.t, A.y, time and response respectively. 
% All elements of B whose values are equal to lower than mean(A) are
% combined to A to create the resultant vector C
if (size(A.y,2) ~= size(B.y,2))
    disp('sorry the columns of the input matrices have to be equal');
    abort;
end
C.t = NaN(size(B.t));
C.y = NaN(size(B.y));
for i = 1: size(B.y,2)
    pos = find(B.y(:,i) <= mean(A.y(:,i)),'first',1);
    C.y(:,i) = [A.y(:,i),B.y(pos:end,i)];
    
end