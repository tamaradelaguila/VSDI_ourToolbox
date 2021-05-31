function [Decision,ValorS] = StatisticalAnalysis(B)
%STATISTICALANALYSIS Summary of this function goes here
%   Detailed explanation goes here

for i=2:size(B,2)
   [h,p] = ttest2(B(:,1),B(:,i));
   Decision(i-1)=h;
   ValorS(i-1)=p;
end 
end

