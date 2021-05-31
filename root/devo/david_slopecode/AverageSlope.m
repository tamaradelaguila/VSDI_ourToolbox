function [AverageSlopeR] = AverageSlope(SlopeR)
%AVERAGESLOPE Summary of this function goes here
%   Detailed explanation goes here
[row colum]=size(SlopeR);
for ii=1:colum
    AverageSlopeR(ii)=mean(SlopeR(:,ii));
end 
end

