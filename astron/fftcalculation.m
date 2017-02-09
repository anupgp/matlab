x=1:111;
Threshold=0;
M=normpdf(x,55,35);
M=M';
spikesPN = diff(PN>Threshold,1);
spikesPN = double(spikesPN==1);
spikesPN = conv2(spikesPN,M,'same');
yy = spikesPN(1:18:end,:)
figure(2);
plot(yy(:,1));

hh=mean(yy(:,:),2);%LFP calculation

figure;plot(hh)
%%
i=1397 %time vector length
n=1;
while n < i
n = n*2
end
%%
display(n)
L =i;
Fs=205;%sampling frequency
var=hh';
NFFT = n; %Next power of two
fvar_1 = fft(var,NFFT)/L; %Amplitude calculation
f = Fs/2*linspace(0,1,NFFT/2+1); %frequency calculation 
% Plot single-sided amplitude spectrum.
figure();
plot(f(100:500),2*abs(fvar_1(100:500)))
title('Single-Sided Amplitude Spectrum of simulated LFP')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
%%
% Find the next power of 2 from length of Y (such that: ceil(2^a) <= length(data))
y = d(:,2);
L = length(d(:,1));     %  Length of the data points
NFFT = 2^nextpow2(L);   %  Next power of 2 from length of data points
Y = fft(d(:,2),
%%
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
y = x + 2*randn(size(t));     % Sinusoids plus noise
%%
%NFFT/2 because half is symmetric corresponding to negative frequency
%we calculate NFFT to pad it so that it is faster

%fac=NFFT/2+1
%step=Fs/(2*fac)
%Startfrequency=Fstart/step
%Endfrequency=Fend/step
%plot(f(startfrequency:Endfrequency),2*abs(fvar_1(starfrequency:Endfrequency))

