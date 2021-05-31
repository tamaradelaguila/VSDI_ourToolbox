function [Slope]  = DerivativeVSDI(BloqueWaves)
%DERIVATIVEVSDI Summary of this function goes here
%   Detailed explanation goes here
[row colum]=size(BloqueWaves);
for ii=1:colum
    for iii=1:row-1
    Slope(iii,ii)=(BloqueWaves(iii+1,ii)-BloqueWaves(iii,ii))/5;%(BloqueWaves(2,1)-BloqueWaves(1,1));
    end 
end 
end
