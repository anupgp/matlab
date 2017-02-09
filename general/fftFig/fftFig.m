function outFile = fftFig(handle,inFile,qualLevel)
% This function takes in a figure and saves it 
% to a jpeg file. You can specify the filename,
% quality level and a file handle to your figure.
% The function returns the current filename. If no parameters
% are specified the function creates a dummy file using default settings.
% 
% EX: 
% >> handle = figure;
% >> plot([1:5]);
% >> fftFig(handle,'afile1',100)
% ans =
% afile1
%

figSettings = '-r75'; %default quality level
outFile = 'afile'; %default filename
if nargin == 0
    x=0:.001:4*pi;
    freq = 4;
    amp= 1;
    phase=1;
    z=amp*sin((freq*x)/phase);
    handle = figure;
    a=fft(z);
    plot(a);
%elseif nargin == 1
    % do nothing
elseif nargin == 2
    outFile = inFile;
elseif nargin == 3 
    if qualLevel > 0 && qualLevel <= 600 % increase this if you want
        qual = int2str(qualLevel);
        figSettings = ['-r',qual];
    else
        error('Incorrect quality level')
    end
    outFile = inFile;
end
print(handle,'-djpeg',figSettings,outFile);
