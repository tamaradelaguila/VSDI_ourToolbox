function [position,time,centroids,fitLine] = rasterConductionVelocity(Din,poly,imBg,halfwinSz,debug)
% RASTERCONDUCTIONVELOCITY measures the velocity of the spread of activity
% across rows of the input raster "Din".  Velocity is computed by linear
% regression to a distance-versus-time plot.  Distance is defined by the
% Euclidean distance between the measurement sites (i.e., the centroid of 
% each polygon in POLY).  Activation time is measured as the peak in the 
% first derivative of the VSD signal in each row of the raster plot.
%
% INPUTS:
% 
% Din: a raster containing activation evoked by a single stimulus.
%
% poly: the polygonal geometry that was used to generate the raster rows of
% Din.  the number of cells in POLY must equal the number of rows in Din.
%
% halfwinSz: half the size of the sliding window (in sample numbers), used
% for peak detection.  
% 
% debug: when set to 1, RASTERCONDUCTIONVELOCITY will generate a plot of
% the polygon centers and the distance-versus time plot and fit line that 
% were used to compute conduction velocity.
%
% OUTPUTS:
%
% position: cumulative distance between the centroids of the measurement
% sites (i.e., polygon centroids), in sequential order
% 
% time: activation times measured at each measurement site
% 
% centroids: the 2D coordinates of the centroid of each polygon
%
% fitLine: discretized line of position values (from linear regression)
%



if nargin==4,
    debug=0;
end

% strip spacer rows from Din
[rowIndZeros] = rasterFindZeroRows(Din); % find zero rows (anatomical boundaries)
if ~isempty(rowIndZeros),
    Din(rowIndZeros,:)=[]; % remove zero rows
end

% if the number of rows in Din is not equal to the number of polygons in
% POLY, the user needs to fix this, so that position and time data line up.
if length(poly) ~= size(Din,1),
    error(['rasterConductionVelocity inputs Din and poly do not have the same number of region segments!' ...
    'Hint: you can leave rows of zeros in the input, and they will be removed.'])
end


userSettings; % load constants (we need is GLO_VARS.pixLen to convert from pixels to distance)

szIm = size(imBg); % size of the camera frame (poly2mask uses this to know how big the grid is)

centroids = zeros(length(poly),2); % preallocate array for storing poly centroids
for i=1:length(poly) % for each polygon 
    mask = poly2mask(poly{i}(:,1),poly{i}(:,2),szIm(1),szIm(2)); % convert the polygon to a binary image mask
    p=regionprops(mask,'Centroid'); % find the geometric centroid of the region
    centroids(i,:)=p.Centroid;
end

distances = zeros(length(poly),1); % preallocate
% compute distance between each point
for i=2:length(poly), % starting with the second point (position of first point is zero)
    vect = centroids(i,:) - centroids(i-1,:); % subtract the previous point from the current point to get sides of the triangle
    distances(i) = sqrt(vect(1)^2+vect(2)^2); % pythagorean theorem to measure hypotenuse 
end

position = cumsum(distances * GLO_VARS.pixLen); % convert from pixel units to mm, and add up distances to get 1D arc length

frAct = rasterFindTdepol(Din,halfwinSz,debug>1); % get activation times for each site.  only send debug=1 if a value larger than 1 was used for debug
time =frAct * GLO_VARS.frameInterval_ms; % convert from sample numbers to time (ms)

[p,~] = polyfit(time,position,1); % fit a straight line to the data
tEval = time; % [time(1)-1:.61:time(end)+1]; % time vector, for evaluating the fit polynomial
fitLine=polyval(p,tEval);


disp(['     Conduction velocity is ' num2str(p(1)) ' mm/ms (conventionally, ' num2str(p(1)/10*1000) ' cm/s)']);

% measure goodness of fit (R^2); http://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
yresid = position - fitLine;
SSresid = sum(yresid.^2);
SStotal = (length(position)-1) * var(position);
% Rsq = 1 - SSresid/SStotal;
Rsq_adj = 1 - SSresid/SStotal * (length(position)-1)/(length(position)-length(p)-1); % adjust for degrees of freedom and order of polynomial

disp(['     R^2 = ' num2str(Rsq_adj)])

if debug,
    figure(1985)
    imagesc(imBg),colormap gray, axis equal, axis off
    hold on
    for i=1:length(poly),
        plot([poly{i}(:,1); poly{i}(1,1)],[poly{i}(:,2); poly{i}(1,2)],'k')
        plot(centroids(:,1),centroids(:,2),'b.')        
    end
    
    figure(1986)
    plot(time,position,'.k')
    hold on
    plot(tEval,fitLine,'r')
    hold off
end








