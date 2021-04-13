function polyPlot(polyIn,imBg,plotColorStr,axHandle)
% plots closed polygons for the list of vertices defined in each cell of
% POLYIN.

if nargin<4, % if no axis handle is provided, create one
    figure
    axHandle=axes;
end

for i=1:length(polyIn), % plot each ith polygon
    
    currPoly = polyIn{i}; % make a copy of the current polygon
    
    if (currPoly(1,1)~=currPoly(end,1)) && (currPoly(1,2)~=currPoly(end,2)), % if the polygon isn't closed (and it usually isn't), close it
        currPoly = [currPoly; currPoly(1,:)]; %#ok<AGROW>
    end
    
    plot(axHandle,currPoly(:,1),currPoly(:,2),plotColorStr,'LineWidth',2)
    hold on
    
    if ~strcmp(plotColorStr,'k'), % if the polygons are black, we won't number them.  otherwise we will number them.  (black polygons are only drawn when creating new ROIs)
        szD = size(imBg); % size of camera frame
        mask = poly2mask(currPoly(:,1),currPoly(:,2),szD(1),szD(2)); % convert the polygon to a binary image mask
        
        if sum(mask(:)), % if the mask has some pixels that are nonzero, find the center of the mask
            centerPt = findSpotCentroid(mask); % find the center of the polygon
        else
            centerPt = fliplr(currPoly(1,:)); % in this case the region is smaller than a pixel.  use the first vertex of the polygon as the approximate center of this tiny region
            disp('polyPlot: tiny region found; approximating centroid for number label (not a big deal).')
        end
        
        hTxt = text(centerPt(2)-.5,centerPt(1),num2str(i)); % write the text on the figure
        set(hTxt,'FontSize',7)
        
        if i==length(polyIn), % for the last polygon, italicize & gray the text to indicate that this polygon isn't regularly sized and will be excluded from rasters
            set(hTxt,'FontAngle','italic','Color',[.4 .4 .4])
        end
    end
    
end