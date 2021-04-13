function [centroid] = findSpotCentroid(mask,subim)
% FINDSPOTCENTROID(MASK) returns the double precision centroid of the
% binary image MASK.  CENTROID is [ROW_COORDINATE COL_COORDINATE]
%
% FINDSPOTCENTROID(MASK,SUBIM) finds the intensity-weighted centroid of 
% the spot/donut in SUBIM. The boundaries of the spot/donut in SUBIM 
% are specified by MASK.

if nargin==1,
    subim=mask;
end

% set parts of subim =0 if they aren't part of the mask
%subim(find(~mask))=0;
subim(mask==0)=0;

% get intensity weighted spot centroid
p=regionprops(double(mask),'PixelList');
% w=subim(find(mask));
w=subim(mask~=0);

wsum=sum(w);
x=p.PixelList(:,1);
y=p.PixelList(:,2);
cbar = sum(x.*w)/wsum; %column average
rbar = sum(y.*w)/wsum; %row average

centroid=[rbar cbar];
