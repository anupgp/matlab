% Files that are to be analyzed.
function s = analyzeahp(textfile)
allTraces = 1:20;
expinfo = getfiles(textfile);
fnames = [expinfo{:,1}];
fprintf('Total no. of cells in the file: %d\n',length(fnames));
% cellselect = [expinfo{:,4}];
% sfnames = fnames(cellselect==1);
% fprintf('Total no. of cells selected for anlalysis: %d\n',length(sfnames));
s = makeahpdb(length(fnames)*20);
%stemp = makeahpdb(20);
cntAll=1; left=1; right=0; cntSelect=0;
while (cntAll <=length(fnames))
    fprintf('The %d cell in the file: %s \n',cntAll,char(fnames(cntAll)));
    select = double([expinfo{cntAll,4}]);
    badTraces = expinfo{cntAll,5};
    goodTraces = allTraces(~ismember(allTraces,badTraces));
    disp(goodTraces);
    if (select==1)
        cntSelect=cntSelect+1;
        [stemp, ~, ~] = ahp1(char(fnames(cntAll)), '10 Vm', goodTraces);
        right = right+length(stemp);
        s(left:right) = stemp;
        left=right+1;
    end
    cntAll = cntAll+1;
end
s = s(1:right);
end