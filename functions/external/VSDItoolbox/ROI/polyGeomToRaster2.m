function [rasterInner,rasterOuter] = polyGeomToRaster2(polyInner,polyOuter,regionLinesCVL,D,combineRegions_TrueFalse)
% given polygonal regions defined in the cell arrays POLYINNER and
% POLYOUTER, POLYGEOMTORASTER2 returns 2D raster plots, where rows
% correspond to signals averaged across each polygon, and columns
% correspond to time points.  
%
% We're using 'combineRegions_TrueFalse' to choose the appropriate strategy
% for finding the polygon that corresponds to the anatomical transition
% point.  If 'combineRegions_TrueFalse' is '0', then the hatch mark will
% intersect the polygon we are looking for.  However, if
% 'combineRegions_TrueFalse' is '1', then we will look for a polygon that
% encloses the 2D coordinate of the intersection of the hatch mark and the
% region centerline (in this case, the hatch mark does not necessarily
% intersect with the outer boundaries of the polygon).

userSettings; % load user settings

if combineRegions_TrueFalse==0,
    % find the polygon that intersects with the region boundary lines
    if length(regionLinesCVL)>1, % if there are hatch mark lines
        intLinePoly = zeros(length(regionLinesCVL)-1,1); % preallocate
        for i = 2:length(regionLinesCVL),
            intLinePoly(i-1) = intLinePolyList(polyInner,regionLinesCVL{i});% find which boxes are intersected by the boundary lines
        end
    else % if there are no anatomical dividing lines, set intLinePoly to be empty
        intLinePoly=[];
    end
else % if combineRegions_TrueFalse==1,
    if length(regionLinesCVL)>1, % if there are hatch mark lines
        intLinePoly = zeros(length(regionLinesCVL)-1,1); % preallocate
        for i = 2:length(regionLinesCVL),
            intLinePoly(i-1) = encircledPointPolyList(polyInner,regionLinesCVL{i},regionLinesCVL{1});% find which box contains the intersection of the hatch mark and the region midline
        end
    else % if there are no anatomical dividing lines, set intLinePoly to be empty
        intLinePoly=[];
    end
end

nFrames = size(D,3); % number of movie frames (time samples) in the dataset

% preallocate
rasterInner = zeros(length(polyInner),nFrames); %  array for storing a temporal signal for each chunk of polyInner
rasterOuter = zeros(length(polyOuter),nFrames); % array for storing a temporal signal for each chunk of polyOuter

% assemble the raster plot RASTERINNER, by averaging temporal traces across each region defined in polyInner
for i=1:length(polyInner),
    rasterInner(i,:) = mean( maskedSigs(D,polyInner{i},[]) ); % POLYINNER defines valid polygons to process, whether regions were combined or not
end
    
if combineRegions_TrueFalse, % if the regions were combined, then rasterOuter won't contain anything
    rasterOuter=[]; 
else % if the regions weren't combined, then create rasterOuter from POLYOUTER
    for i=1:length(polyOuter),
        rasterOuter(i,:) = mean( maskedSigs(D,polyOuter{i},[]) ); % get signals from all pixels enclosed by the polygon polyOuter{i}, and then average the signals to get a single signal rasterOuter{i,:}
    end
end

rasterInner = insertConstantRows(rasterInner,intLinePoly,0); % insert rows into the matrix to indicate the bounaries between anatomical regions
if ~isempty(rasterOuter),
    rasterOuter = insertConstantRows(rasterOuter,intLinePoly,0); % insert rows into the matrix to indicate the bounaries between anatomical regions
end



