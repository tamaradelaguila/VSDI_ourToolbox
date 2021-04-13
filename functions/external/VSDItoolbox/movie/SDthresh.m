function [out, thresh] = SDthresh(s,STDframes,sdUserFactor)

% given a voltage signal S, SDTHRESH computes the standard deviation of
% the STDFRAMES samples in the signal, then returns a signal that contains
% voltage values for all time points where the voltage is greater than 
% SDUSERFACTOR standard deviations 


sd = std(s(STDframes)); % get standard deviation of first 10 points in signal
s=s-mean(s(STDframes)); % y-shift the signal so the measured standard deviation can be used as a threshold

s(abs(s)<sdUserFactor*sd) = 0; % points where |s| is less than SDUSERFACTOR*SD are "sub-threshold" and we set them to zero.

out=s;

thresh = sdUserFactor*sd; % return the actual threshold used