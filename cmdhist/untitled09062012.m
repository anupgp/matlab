load('~/AHP_HC/Matlab_analysis/CV_AHP_06062012.dat','-mat')
vrest = num2cell([CV.vrest] .*1000);
r_in = num2cell([CV.r_in] .*1E-06);
r_se = num2cell([CV.r_se] .*1E-06);
ctau = num2cell([CV.ctau] .*1E03);
delay = num2cell([CV.delay] .*1E03);
sub_peak = num2cell([CV.sub_peak] .*1000);
sub_peak_lat = num2cell([CV.sub_peak_lat] .*1000);
sub_peak_delay = num2cell([CV.sub_peak_delay] .*1000);
raw_peak = num2cell([CV.raw_peak] .*1000);
raw_peak_lat = num2cell([CV.raw_peak_lat] .*1000);
raw_peak_delay = num2cell([CV.raw_peak_delay] .*1000);
[CV.vrest] = deal(vrest{:});
[CV.r_in] = deal(r_in{:});
[CV.r_se] = deal(r_se{:});
[CV.ctau] = deal(ctau{:});
[CV.delay] = deal(delay{:});
[CV.sub_peak] = deal(sub_peak{:});
[CV.sub_peak_lat] = deal(sub_peak_lat{:});
[CV.sub_peak_delay] = deal(sub_peak_delay{:});
[CV.raw_peak] = deal(raw_peak{:});
[CV.raw_peak_lat] = deal(raw_peak_lat{:});
[CV.raw_peak_delay] = deal(raw_peak_delay{:});
ahpstruct2csv('~/AHP_HC/Matlab_analysis/AHP_CV_09062012.csv',CV)