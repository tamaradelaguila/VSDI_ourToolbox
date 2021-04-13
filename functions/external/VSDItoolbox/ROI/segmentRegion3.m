function [polyInner, polyOuter] = segmentRegion3(vertList,centerLine,imBg,segLen,pixLen,combineRegions_TrueFalse,debug)
% vertList is the user-drawn outline of the CA region.
% centerLine is the user-drawn line that identifies the pyramidal cell layer curve
% imBg is a frame of VSD video (used for plotting results)
% segLen is the width of segments to draw along the CA region, in mm
% pixLen is the width (or height) of a pixel in mm (pixels are assumed to be square)
% combineRegions_TrueFalse dictates if regions should be combined
% across the centerline (==1), or if regions should be kept separate at the
% centerline boundary (==0)
% debug, when ==1, plots the perpendicular lines created by
% segmentRegion2.  when >1, debug additionally plots dotted lines
% surrounding each polygonal region.  odd-numbered polys are yellow, even-
% numbered lines are magenta.
% 

if nargin==6,
    debug=0;
end

vertList(end+1,:)=vertList(1,:); % add the first value of the vert list to the end of the vert list, to include the line that closes the polygon

% smooth centerLine
centerLineResam = zeros(size(centerLine,1)*4,2); % preallocate
centerLineResam(:,1)=interp(centerLine(:,1),4); % resample line at higher resolution, so that FINDNORMSPACEDPTS can find points that are as close as possible to the correct spacing
centerLineResam(:,2)=interp(centerLine(:,2),4);

centerLineResam=convRepEdge(centerLineResam,ones(99,1)/99); % smooth the line
centerLineResam = [centerLine(1,:) ; centerLineResam ; centerLine(end,:)]; % occasionally, line smoothing causes us to lose intersection between centerLine and vertList.  ensure this doesn't happen by adding the original centerline endpoints to centerLineResam (so centerLineResam has the same span as centerLine)

centerLine=centerLineResam;
centerLine=flipud(centerLine); % assumes the line was drawn from CA1 up through CA3 and into the hilus - we want to draw polygons starting in the hilus


[ci ri] = polyIntPoly(centerLine(:,2),centerLine(:,1),vertList(:,2),vertList(:,1)); % find where the line intersects the polygon.  coordinates are listed in the direction of the end of the line.

pt1rc = [ri(1) ci(1)]; % intersection points between CENTERLINE and VERTLIST polygon
pt2rc = [ri(2) ci(2)];

keepLinePts = inpolygon(centerLine(:,2),centerLine(:,1),vertList(:,2),vertList(:,1)); % identify points on CENTERLINE that fall outside of the polygon VERTLIST
centerLine(~keepLinePts,:)=[]; % discard line points outside of the polygon

if pdist2(pt1rc,centerLine(1,:)) < pdist2(pt1rc,centerLine(end,:)) % if the first intersection point, PT1RC, is closer to the first end of centerLine
    centerLine = [pt1rc; centerLine; pt2rc]; % add the endpoints to the appropriate ends of the line
else
    centerLine = [pt2rc; centerLine; pt1rc]; % add the endpoints to the appropriate ends of the line
end

indEvenlySpacedPts = findNormSpacedPts(centerLine,segLen/pixLen); % identify points along CENTERLINE that are spaced MINDIST apart.  2nd argument is MINDIST, which is a distance in pixels: segLen (in mm) / pixLen (mm/pixel) = pixels

innerVrc = cell(length(indEvenlySpacedPts)-2,1);% preallocate
outerVrc = cell(length(indEvenlySpacedPts)-2,1);

% step along line at indices in INDEVENLYSPACEDPTS, and find the intersections of a line normal to the interpolated line with the VERTLIST polygon 
indEvenlySpacedPts(end)=indEvenlySpacedPts(end)-1; % boundary condition so that the segment for the last point falls on the line (and not off the line)
for i=2:length(indEvenlySpacedPts)-1, % for each of the evenly spaced points, excluding boundary points, draw a normal vector
    % find the normal vector
    
    [ci, ri, originPt] = normVintersectPts(centerLine(indEvenlySpacedPts(i),:),centerLine(indEvenlySpacedPts(i)+1,:),vertList,pythagoras(size(imBg,1),size(imBg,2)));% find intersection of a normal vector with the region polygon VERTLIST.  the 4th input is the length of the perpendicular vector to draw initially--PYTHAGORAS is used to determine the longest possible vector that we can fit in imBg
    
    rightTurnBool = isItARightTurn(centerLine(indEvenlySpacedPts(i),:),originPt,[ri(1) ci(1)]); % is the first segment [ri(1) ci(1)] a "right turn"?  (i.e., is the normal vector 90 degrees to the right of the centerline vector.)  if so, we'll use it as the "inner" normal vector.  if not, we'll use [ri(2) ci(2)] as the "inner" normal vector, and [ri(1) ci(1) will be the "outer" normal vector
    
    if rightTurnBool, % if the segment [ri(1) ci(1)] consitutes a right turn from the centerline, use it as the inner normal segment
        innerVrc{i-1} = [originPt; ri(1) ci(1)]; % use the coordinates of intersection with the VERTLIST as the bounds of the normal vector
        outerVrc{i-1}= [originPt; ri(2) ci(2)];
    else
        innerVrc{i-1} = [originPt; ri(2) ci(2)]; % use the coordinates of intersection with the VERTLIST as the bounds of the normal vector
        outerVrc{i-1}= [originPt; ri(1) ci(1)];
    end

end

polyInner=cell(length(innerVrc)+1,1); % preallocate
polyOuter=cell(length(outerVrc)+1,1);

% now that all the perpendicular lines are drawn, create polygons for
% each segment

if combineRegions_TrueFalse,
    polyInner{1} = getThreeSidedRegion(vertList,flipud(innerVrc{1}),outerVrc{1});
%     plot(polyInner{1}(:,1),polyInner{1}(:,2),'y.-')
%     pause
    polyOuter{1} = [];
    
    for i=1:length(innerVrc)-1, % starting with the first pair of orthogonal line segments, get each polyInner region
        lineSeg1 = [innerVrc{i}(2,:); outerVrc{i}(2,:)];
        lineSeg2 = [innerVrc{i+1}(2,:); outerVrc{i+1}(2,:)];
        polyInner{i+1} = getFourSidedRegion(vertList,lineSeg1,vertList,lineSeg2);
%         plot(polyInner{i+1}(:,1),polyInner{i+1}(:,2),'y.-')
%         pause
    end
    
    for i=1:length(outerVrc)-1, % starting with the first pair of orthogonal line segments, get each polyOuter region
        polyOuter{i+1} = [];
    end
    
    % draw the regions at the finishing end of the VERTLIST polygon
    polyInner{end} = getThreeSidedRegion(vertList,flipud(innerVrc{end}),outerVrc{end});
%     plot(polyInner{end}(:,1),polyInner{end}(:,2),'y.-')
%     pause
    polyOuter{end} = [];
    
else
    % draw the regions at the beginning end of the VERTLIST polygon
    polyInner{1} = getThreeSidedRegion(vertList,centerLine,innerVrc{1});
    polyOuter{1} = getThreeSidedRegion(vertList,centerLine,outerVrc{1});
    
    for i=1:length(innerVrc)-1, % starting with the first pair of orthogonal line segments, get each polyInner region
        polyInner{i+1} = getFourSidedRegion(vertList,innerVrc{i},centerLine,innerVrc{i+1});
        %plot(polyInner{i+1}(:,1),polyInner{i+1}(:,2),'y.-')
    end
    
    for i=1:length(outerVrc)-1, % starting with the first pair of orthogonal line segments, get each polyOuter region
        polyOuter{i+1} = getFourSidedRegion(vertList,outerVrc{i},centerLine,outerVrc{i+1});
        %plot(polyOuter{i+1}(:,1),polyOuter{i+1}(:,2),'y.-')
    end
    
    % draw the regions at the finishing end of the VERTLIST polygon
    polyInner{end} = getThreeSidedRegion(vertList,flipud(centerLine),innerVrc{end});
    polyOuter{end} = getThreeSidedRegion(vertList,flipud(centerLine),outerVrc{end});
end

if debug,
    figure(111)
    hold off
    imagesc(imBg),axis equal, colormap gray, axis off
    hold on
    plot(centerLine(:,1),centerLine(:,2))
    plot(vertList(:,1),vertList(:,2))
    
    for i=1:length(innerVrc), % plot the perpendicular lines in red and green
        plot([innerVrc{i}(:,1); innerVrc{i}(1,1)],[innerVrc{i}(:,2); innerVrc{i}(1,2)],'r','LineWidth',2)
        plot([outerVrc{i}(:,1); outerVrc{i}(1,1)],[outerVrc{i}(:,2); outerVrc{i}(1,2)],'g','LineWidth',2)
    end
    
    if debug>1,
        for i=1:2:length(polyInner), % plot every other polygon in yellow
            plot([polyInner{i}(:,1); polyInner{i}(1,1)],[polyInner{i}(:,2); polyInner{i}(1,2)],'y:')
            if ~combineRegions_TrueFalse, plot([polyOuter{i}(:,1); polyOuter{i}(1,1)],[polyOuter{i}(:,2); polyOuter{i}(1,2)],'y:'),end
        end
        
        for i=2:2:length(polyInner), % plot every other polygon in yellow
            plot([polyInner{i}(:,1); polyInner{i}(1,1)],[polyInner{i}(:,2); polyInner{i}(1,2)],'m--')
            if ~combineRegions_TrueFalse, plot([polyOuter{i}(:,1); polyOuter{i}(1,1)],[polyOuter{i}(:,2); polyOuter{i}(1,2)],'m--'),end
        end
    end
    
    hold off
end


%%%%%%%%%%%%%% various functions used by segmentRegion2 defined below



function indOut = findNormSpacedPts(lineIn,minDist)
% return indices of normally spaced points in input vector LINEIN

indOut=1; % init output with a value that we want to keep (we want to keep both endpoints of the line)

i=1;
while i<size(lineIn,1),
    estimated_arclength = sum(sqrt( sum((diff(lineIn(i:end,:)).*diff(lineIn(i:end,:))),2) ),2); % arc length of all points along the line
    indNextPt = find(cumsum(estimated_arclength)>minDist,1) + i -1; % find the next point that is farther away than MINDIST
    if ~isempty(indNextPt), % if there is a point on the line that is farther away than minDist
        indOut=[indOut indNextPt]; % add the point INDNEXTPT to the output list
        i=indNextPt;
    else
        indOut=[indOut size(lineIn,1)];
        i=size(lineIn,1);
    end
end



function vertListOut = getThreeSidedRegion(longSeg1,longSeg2,seg3)
% the polygon must be connected in the order LONGSEG1 LONGSEG2 SEG3.
% the first point of LONGSEG2 MUST be a vertex of the resulting region.
% SEG3 MUST be oriented to connect from LONGSEG2 to LONGSEG1.
%
% I intend to define LONGSEG1 as the vertList (polygon),
% LONGSEG2 as the centerline (starting at an intersection with LONGSEG1,
% and SEG3 as the line segment perpendicular to LONGSEG2 (centerline).
% 

path1 = getPolyPathBetweenPts(longSeg1,seg3(2,1),seg3(2,2),longSeg2(1,1),longSeg2(1,2));
path2 = getPolyPathBetweenPts(longSeg2,longSeg2(1,1),longSeg2(1,2),seg3(1,1),seg3(1,2));
%path3 = seg3;

if pdist2(path1(end,:),path2(1,:)) > pdist2(path1(end,:),path2(end,:)), % if the last point of path1 is closer to the last point of path2 than it is to the first point of path 2
    path2 = flipud(path2); % reverse path2
end

% if pdist2(path2(end,:),path3(1,:)) > pdist2(path2(end,:),path3(end,:)),
%     path3 = flipud(path3);
% end


%vertListOut = [path1; path2; path3];
vertListOut = [path1; path2];



function vertListOut = getFourSidedRegion(longSeg1,seg2,longSeg3,seg4)
% the polygon must be connected in the order LONGSEG1 SEG2 LONGSEG3 SEG4.
% SEG2 MUST connect from LONGSEG1 to LONGSEG3.  SEG4 MUST be oriented 
% to connect from LONGSEG3 to LONGSEG1.
%
% I intend to define LONGSEG1 as the vertList (polygon),
% LONGSEG3 as the centerline, and SEG 3 and SEG 4 are the orthogonal
% vectors running from LONGSEG3 (centerLine) toward LONGSEG1 (vertList).

path1 = getPolyPathBetweenPts(longSeg1,seg2(2,1),seg2(2,2),seg4(2,1),seg4(2,2));
path2 = getPolyPathBetweenPts(longSeg3,seg2(1,1),seg2(1,2),seg4(1,1),seg4(1,2));

% make sure the paths are ordered so that points travel around the region
% find the end of LONGSEG1 (centerLine) that is closest to SEG2 

if pdist2(path1(1,:),seg2(2,:)) < pdist2(path1(end,:),seg2(2,:)), % if the beginning of path1 is closer to the start of seg2, flip path1
    path1 = flipud(path1);
end

if  pdist2(path2(end,:),seg2(1,:)) < pdist2(path2(1,:),seg2(1,:)), % if the end of path2 is closer to the end of seg2, flip path2
    path2 = flipud(path2); % reverse path2
end

vertListOut = [path1; path2];



function c = pythagoras(a,b)
% Calculates the hypotenuse of a right triangle
c = sqrt(a^2 + b^2);



function [ciValid, riValid, originPt] = normVintersectPts(midLinePt1,midLinePt2,vertList,normVlen)
% our strategy for finding the appropriate points of intersection of a
% normal vector with the polygon described by VERTLIST is as follows:
% (1) draw a long perpendicular vector to the line defined by 

[normVrc,originPt] = findPerpVect(midLinePt1,midLinePt2,normVlen); % draw a perpendicular line to the segment defined by two successive points along the center line.  the length of the line was chosen to be the longest line we can fit on the image, using PYTHAGORAS (defined below)
[ci ri] = polyIntPoly(normVrc(:,2),normVrc(:,1),vertList(:,2),vertList(:,1)); % find intersection of normal vector with the region polygon VERTLIST (the vector we drew before was too long)
% ci
% ri
% distance = sqrt( (ci(2)-ci(1)).^2 + (ri(2)-ri(1)).^2 )

distances = zeros(length(ci),1); % preallocate
for i=1:length(ci), % for each intersection point found, measure the distance to the centerline
    distances(i) = sqrt( (ri(i)-originPt(1)).^2 + (ci(i)-originPt(2)).^2 );
end
% distances

% the point closest to the centerline is assumed to be a good one
indValidPt1 = find(distances==min(distances),1);
ciValid(1) = ci(indValidPt1);
riValid(1) = ri(indValidPt1);

ci(indValidPt1) = []; % remove the valid point from the list.
ri(indValidPt1) = []; 

% next, we will find the closest point to [riValid(1) ciValid(1)] that is 
% on the opposite side of the center line
for i=length(ci):-1:1, % count backwards and remove items from the list if they don't meet our criteria
    pointOnSameSide = ~doSegsOverlap(midLinePt1,midLinePt2,[riValid(1) ciValid(1)],[ri(i) ci(i)]); % the points are on the same side of the centerline if there is no overlap between the midline segment  and the segment drawn between the already found valid point [riValid(1) ciValid(1)] and the current point of interest [ri(i) ci(i)]
    if pointOnSameSide,
        ci(i)=[];
        ri(i)=[];
    end
end

distances = zeros(length(ci),1); % preallocate
for i=1:length(ci), % for each point that remains on the other side of the centerline, measure the distance to the centerline
    distances(i) = sqrt( (ri(i)-originPt(1)).^2 + (ci(i)-originPt(2)).^2 );
end

indValidPt2 = find(distances==min(distances),1); % the closest point to the centerline is the one we want
ciValid(2) = ci(indValidPt2);
riValid(2) = ri(indValidPt2);



function overlapTrue = doSegsOverlap(seg1start,seg1end,seg2start,seg2end)
% segments AB and CD overlap if dot(cross(AB,AC),cross(AB,AD))<0 .
% this can also be used to determine if two points, C and D, are on
% opposite sides of a line segment AB.

ab = seg1end-seg1start;
ac = seg2start-seg1start;
ad = seg2end-seg1start;

overlapTrue = dot(cross([ab 0],[ac 0]),cross([ab 0],[ad 0])) < 0; % true if the point is on the opposite side of the centerline



function rightTurnBool = isItARightTurn(pt1,pt2,pt3)
% determine if the path through the three input points consitutes a turn to
% the right

% shift the points so that the first point is at the origin
% pt1shift = [0 0]; % same as pt1-pt1 (not used)
pt2shift = pt2-pt1;
pt3shift = pt3-pt1;

anglePt2 = atan2(pt2shift(2),pt2shift(1)); % measure the angle formed by pt2shift relative to the origin

% rotate pt3shift by the angle of pt2
rotMat = [cos(anglePt2) -sin(anglePt2); ...
          sin(anglePt2)  cos(anglePt2)];
pt3shiftRot = pt3shift*rotMat;
            
rightTurnBool = pt3shiftRot(2)<0; % if the "y" coordinate of the shifted & rotated point pt3shiftRot is negative, then the line segment pair is a right turn.


