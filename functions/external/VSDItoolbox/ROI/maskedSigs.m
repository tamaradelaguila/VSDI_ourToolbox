function data = maskedSigs(D,poly1,poly2,debug)
%
% given a movie D and polygonal masks POLY1 and POLY2, MASKEDSIGS returns
% the 2D data array DATA, which contains fluorescence traces for all
% the pixels enclosed by the POLYs in the form [channel_number, time].
% Optionally, an empty array ("[]") can be provided for POLY2, so that the 
% mask will be generated from a single polygon.

if nargin==3,
    debug=0;
end

szD = size(D);

mask1 = poly2mask(poly1(:,1),poly1(:,2),szD(1),szD(2)); % convert the polygon to a binary image mask

if ~isempty(poly2),
    mask2 = poly2mask(poly2(:,1),poly2(:,2),szD(1),szD(2)); % convert the polygon to a binary image mask
else
    mask2 = zeros(szD(1),szD(2)); % if only 1 polygon was provided (POLY1), then mask2 will be an empty array of the size of one movie frame
end

mask = mask1+mask2; % combine masks

if debug,
    fig = figure(2);
    imagesc(mask)
    axis equal
    h=roiDrawPoly(poly,'y');
    setVerticesDraggable(h,0)
    drawnow
    %pause(.01)
    delete(h)
end

num_channels=sum(sum(mask>0)); % num_channels equals the number of pixels in the mask with value > 0.
data = zeros(num_channels,szD(3)); % preallocate.

ind = find(mask); % IND is a linear list of indices of valid pixels
[ri,ci] = ind2sub(size(mask),ind); %get [ri,ci] coordinates for all the valid pixels

% put temporal traces from each pixel in the DATA array
for i=1:length(ri),
    data(i,:) = D(ri(i),ci(i),:);
end
