function [SlopeR] = RecorteSlope(Slope,R)
%RECORTESLOPE Summary of this function goes here
%   R, VA EN FRAMES
[row colum]=size(Slope);
for ii=1:colum
   SlopeR(1:length(R),ii) = Slope(R,ii);
end 
end

