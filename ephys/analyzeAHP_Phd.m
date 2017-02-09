% The function analyse the AHP traces from files whos names are given via a
% text file
function [rawpre,rawpost] = analyzeAHP_Phd(expfile)
expinfo = getfiles(expfile);
fnames = [expinfo{:,1}];
rawpre = nan(length(fnames),4); % mAHPp, mAHPa, sAHPp, sAHPa
rawpost = nan(length(fnames),4); % mAHPp, mAHPa, sAHPp, sAHPa
fitpre = nan(length(fnames),4); % mAHPp, mAHPa, sAHPp, sAHPa
fitpost = nan(length(fnames),4); % mAHPp, mAHPa, sAHPp, sAHPa
fprintf('Total no. of cells in the file: %d\n',length(fnames) );
close all;
precnt=1;postcnt=1;
for i = 1:length(fnames)
    tracelength = expinfo{i,2};
    ntraces = expinfo{i,3};
    % Load the data from ASCII files
    [t,y] = asciload(char(fnames(i)),tracelength,ntraces);
    % Filter the data
    [t2,y2] = gaussfilt1d(t,y,1000,1000/3);
    clear t;
    clear y;
    % get raw AHP data 
    [mAHPp,mAHPpt, mAHPa,sAHPp,sAHPpt, sAHPa] = getAHPs(t2,y2);
    if (~isempty(strfind(char(fnames(i)),'pre')) || ~isempty(strfind(char(fnames(i)),'Pre')) || ~isempty(strfind(char(fnames(i)),'PRE')))
        rawpre(precnt,:) = [mAHPp, mAHPa, sAHPp, sAHPa];
        precnt=precnt+1;
    else
        rawpost(postcnt,:) = [mAHPp, mAHPa, sAHPp, sAHPa];
        postcnt=postcnt+1;
    end
    rawpre = rawpre(1:precnt-1,:);
    rawpost = rawpost(1:postcnt-1,:);
    % Fit the AHP with a single exp
%     ahpStart = 1.1; % end of the depolarizing pulse
%     ahpEnd =  t2(end); % end of the AHP trace
%     delay= 1; % delay = 500 msec 
%     ahpLast = mean(y2(t2>ahpEnd-0.01));
%     areaLeftT = t2(find(y2<=ahpLast,1,'first'));
%     options = optimset('Display','on');
%     initials = [ahpLast,areaLeftT,3,mAHPp]; % offset, delay, tau, sfactor
%     [params, ~ , ~, ~] = fminsearch(@expfitsse,initials,options,t2,y2)
%     % get AHP values from the fitted curve
%     yf = expfit(params,t2);
%     hold on;
%     plot(t2,y2,'blue',t2,yf,'red');
% %     waitforbuttonpress;
end