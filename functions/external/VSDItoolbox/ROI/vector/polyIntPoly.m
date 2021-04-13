function [xOut,yOut] = polyIntPoly(x1,y1,x2,y2)
%
% x1 and y1 define the [x,y] coordinates of the vertices of polygon #1.
% x2 and y2 define the [x,y] coordinates of the vertices of polygon #2.
% xOut and yOut give the intersection(s) of the two polygons

% Ensure that inputs are all column vectors
x1=x1(:); y1=y1(:);
x2=x2(:); y2=y2(:);

% Find all intersections
[xOut,yOut] = segIntersectAllCombos(x1, y1, x2, y2);

% Remove duplicate intersections?
% [xOut, yOut] = dedupeIntersections(xOut,yOut);



%%%


function [xi,yi] = segIntersectAllCombos(x1,y1,x2,y2)
% SEGMENTINTERSECTIONS finds intersections between a line or poly (defined 
% by the coordinate pairs [x1 y1]) and a second line or poly (defined by
% the coordinate pairs [x2 y2].

TOL = eps*100000;

[x1segs,y1segs,x2segs,y2segs] = polyLinesToSegLists(x1,y1,x2,y2); % convert the 2 polys/lines to segment lists

%%%%% REMOVE SEGMENTS WHERE EITHER X OR Y COORDS HAVE NO OVERLAP

% the motivation of the folowing lines is to remove segments where we know
% there can be no intersection, because the segments do not overlap in
% either x or y directions.  first, a list is created for each segment
% pair, as in xOverlapTestMat.  In xOverlapTestMat, segment 1 coordinates
% are represented by real numbers and segment 2 coordinates are represented
% by imaginary numbers.  we sort each row using SORT, which gives us the
% coordinates in ascending order of their absolute value.  then, we check
% to see if there is alternation in the order of real and imaginary values
% in each row.  if there is no alternation, i.e. if either the first two or
% the last two values in the row are real valued, then the x coordinates of
% the segments do not overlap.  a further test is implemented to ensure
% that, in the event of non-overlapping segments, the end points of the two
% segments are not close enough to each other (within TOL) to be regarded
% as overlapping at a point.

% we need to shift the x and y coordinates so that there are no
% negative or zero values
xMin = min([min(x1segs) min(x2segs)]);
yMin = min([min(y1segs) min(y2segs)]);

xOverlapTestMat = sort([x1segs+1-xMin (x2segs+1-xMin)*1i],2);
xRowsToRemove = (( imag(xOverlapTestMat(:,1))==0 & imag(xOverlapTestMat(:,2))==0 ) ...
    | ( imag(xOverlapTestMat(:,3))==0 & imag(xOverlapTestMat(:,4))==0 )) ...
    & abs( real(xOverlapTestMat(:,2))+imag(xOverlapTestMat(:,2)) -real(xOverlapTestMat(:,3)) - imag(xOverlapTestMat(:,3))  )>TOL;

yOverlapTestMat = sort([y1segs+1-yMin (y2segs+1-yMin)*1i],2);
yRowsToRemove = (( imag(yOverlapTestMat(:,1))==0 & imag(yOverlapTestMat(:,2))==0 ) ...
    | ( imag(yOverlapTestMat(:,3))==0 & imag(yOverlapTestMat(:,4))==0 )) ...
    & abs( real(yOverlapTestMat(:,2))+imag(yOverlapTestMat(:,2)) -real(yOverlapTestMat(:,3)) - imag(yOverlapTestMat(:,3))  )>TOL;

rowsToRemove = logical(xRowsToRemove+yRowsToRemove);

clear xOverlapTestMat yOverlapTestMat yRowsToRemove xRowsToRemove


% % szXbeforeReduce = size(x1segs)
% % szYbeforeReduce = size(y1segs)

x1segs(rowsToRemove,:)=[];
y1segs(rowsToRemove,:)=[];
x2segs(rowsToRemove,:)=[];
y2segs(rowsToRemove,:)=[];

% % szXafterReduce = size(x1segs)
% % szYafterReduce = size(y1segs)


% compute slope of each segment
slopes1 = (y1segs(:,1)-y1segs(:,2))./(x1segs(:,1)-x1segs(:,2));
slopes2 = (y2segs(:,1) - y2segs(:,2)) ./ (x2segs(:,1) - x2segs(:,2));
slopes1(abs(slopes1)>1/TOL) = inf;  slopes2(abs(slopes2)>1/TOL) = inf;

% compute y-intercept of each segment.  if the slope is a divide by zero
% (inf), then the y intercept will be imaginary
b1 = y1segs(:,1) - slopes1.*x1segs(:,1); % compute b = y - mx
b2 = y2segs(:,1) - slopes2.*x2segs(:,1);

b1(b1==-inf) = x1segs(b1==-inf)*1i;
b2(b2==-inf) = x2segs(b2==-inf)*1i;

% preallocate intersection coordinate arrays
xi = zeros(size(x1segs,1),1);  yi = zeros(size(x1segs,1),1);

% determine if parallel lines are overlapping


indPARorOVER = find( abs(slopes1-slopes2)<TOL | isnan(abs(slopes1)-abs(slopes2)) ); % identify lines with the same slope (parallel or overlapping lines)
if ~isempty(indPARorOVER), % if potential overlapping lines are found (lines that are at least parallel)
    % determine if the parallel lines have the same y intercept.
    % if the parallel lines don't have the same y intercept, then they 
    % aren't overlapping.  for vertical lines, we use the x intercept 
    % (stored as the imaginary component of the y intercept) to determine 
    % if the lines are overlapping.  if the segment pair are both vertical 
    % lines but their "y intercept" is different, then they don't overlap.
    
    %%%% deal with parallel lines that don't overlap
    parallelSegs_NoIntersect = indPARorOVER(abs(b1(indPARorOVER)-b2(indPARorOVER))>TOL); % if the intercepts are different, then the segments don't overlap
    xi(parallelSegs_NoIntersect) = NaN;
    yi(parallelSegs_NoIntersect) = NaN;
    
    %%%% deal with parallel lines that do overlap (separately address vertical
    %%%% overlapping lines and non-vertical overlapping lines)
   
    %%%% deal with vertical lines that do overlap
    % keep the beginning and ending points of the overlapping region
    indVO = indPARorOVER(abs(b1(indPARorOVER)-b2(indPARorOVER))<TOL & slopes1(indPARorOVER)==inf);
    if ~isempty(indVO),
        % find the first (lowest on the y-axis) point of overlap
        yStartCoordList = [min(y1segs(indVO,:),[],2) min(y2segs(indVO,:),[],2)];
        yStartCoordList = max(yStartCoordList,[],2); 
        
        % find the last (highest on the y-axis) point of overlap
        yEndCoordList = [max(y1segs(indVO,:),[],2) max(y2segs(indVO,:),[],2)];
        yEndCoordList = min(yEndCoordList,[],2); 
        
        % store the output.  here, 2 y values are obtained for a single x
        % value; store the 2 y values as a real + imaginary pair.
        yi(indVO) = yStartCoordList + 1i*yEndCoordList;
        xi(indVO) = x1segs(indVO) + 1i*x1segs(indVO);
    end
    
    %%%% deal with non-vertical lines that do overlap
    % first, identify the non-vertical overlapping lines
    indNVO = indPARorOVER(abs(b1(indPARorOVER)-b2(indPARorOVER))<TOL & slopes1(indPARorOVER)~=inf);
    if ~isempty(indNVO),
        % for the set of segments that have the same slope and the same
        % y-intercept but aren't vertical, we'll keep the beginning and ending
        % points of the overlapping region.
        
        % find the first (leftmost) x coordinate that is shared between the two segments.
        xStartCoordList = [min(x1segs(indNVO,:),[],2) min(x2segs(indNVO,:),[],2)];
        xStartCoordList = max(xStartCoordList,[],2);
        
        % find the last (rightmost) x coordinate that is shared between the two segments.
        xEndCoordList = [max(x1segs(indNVO,:),[],2) max(x2segs(indNVO,:),[],2)];
        xEndCoordList = min(xEndCoordList,[],2);
        
        
        indNVOshort = find(abs(xStartCoordList-xEndCoordList)<=TOL); % identify overlapping segments that are shorter than the tolerance TOL.  we don't have to consider segment length in the y direction here, because the line would be essentially vertical if the segment were very long and the x-limits of the segment were within TOL
        j1 = find(abs(xStartCoordList-xEndCoordList)>TOL); % identify overlapping segments that are longer than the tolerance TOL
        
        % for short segments (length in x dir < TOL), treat the segment as a point
        xi(indNVO(indNVOshort)) = xStartCoordList(indNVOshort);
        yi(indNVO(indNVOshort)) = slopes1(indNVO(indNVOshort)).*(xStartCoordList(indNVOshort) ...
            - x1segs(indNVO(indNVOshort))) + y1segs(indNVO(indNVOshort)); % y=mx+b
        
        % for longer segments, save both endpoints of the overlapping
        % section using the same real + imag format we used for vertical
        % overlapping lines, above.
        xi(indNVO(j1)) = xStartCoordList(j1) + 1i*xEndCoordList(j1);
        yi(indNVO(j1)) = ...
            slopes1(indNVO(j1)).*( xStartCoordList(j1) - x1segs(indNVO(j1)) ) + y1segs(indNVO(j1))  ... % real component is the first y coordinate.  m=(y-yi)/(x-xi); y = m(x-xi)+yi
            + 1i*slopes1(indNVO(j1)).*( xEndCoordList(j1) - x1segs(indNVO(j1)) ) + 1i*y1segs(indNVO(j1)); % imaginary component is the second y coordinate.  y = m(x-xi)+yi
    end
end % done with parallel or overlapping lines


%%%% deal with non-parallel (i.e., intersecting) lines
indNotPar = find(abs(slopes1-slopes2)>TOL);
if ~isempty(indNotPar), % if any nonparallel segments are found
    
    %%%% deal with segment pairs where neither line is vertical
    indNotVorH = indNotPar( slopes1(indNotPar)~=inf & slopes2(indNotPar)~=inf );

    xi(indNotVorH) = (y1segs(indNotVorH) - y2segs(indNotVorH) + slopes2(indNotVorH).*x2segs(indNotVorH) - slopes1(indNotVorH).*x1segs(indNotVorH)) ./ ...
        (slopes2(indNotVorH) - slopes1(indNotVorH));
    
    yi(indNotVorH) = y1segs(indNotVorH) + slopes1(indNotVorH).*(xi(indNotVorH)-x1segs(indNotVorH));
    
    %%%% deal with segment pairs where the 1st line is vertical
    indVert1 = indNotPar(slopes1(indNotPar)==inf);
    xi(indVert1) = x1segs(indVert1);
    yi(indVert1) = y2segs(indVert1) + slopes2(indVert1).*(xi(indVert1)-x2segs(indVert1));

    %%%% deal with segment pairs where the 2nd line is vertical
    indVert2 = indNotPar(slopes2(indNotPar)==inf);
    xi(indVert2) = x2segs(indVert2);
    yi(indVert2) = y1segs(indVert2) + slopes1(indVert2).*(xi(indVert2)-x1segs(indVert2));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if line intersections don't fall within the bounds of the given segments,
% throw those intersections out
dx1 = [min(x1segs,[],2)-xi, xi-max(x1segs,[],2)];
dy1 = [min(y1segs,[],2)-yi, yi-max(y1segs,[],2)];

dx2 = [min(x2segs,[],2)-xi, xi-max(x2segs,[],2)];
dy2 = [min(y2segs,[],2)-yi, yi-max(y2segs,[],2)];

indPtsOffSegs = [dx1 dy1 dx2 dy2]>TOL; % get row (and column) numbers where distances are greater than the tolerance. 
indPtsOffSegs = sum(indPtsOffSegs,2)>0; % sum along rows to find all rows with a nonzero value. (we're only really interested in row numbers)

xi(indPtsOffSegs) = NaN;
yi(indPtsOffSegs) = NaN;

% throw out rows where no intersection was found (i.e., rows assigned "NaN")
xi = xi(~isnan(xi));
yi = yi(~isnan(yi));


% insert imaginary valued intersections into the list (real + imaginary
% values represent 2 intersections on the same segment)
indImagVals = find(imag(xi) | imag(yi)); % find all rows with a double intersection (rows containing imaginary values)

for j=length(indImagVals):-1:1, % count backwards
    iRow = indImagVals(j);
    xi = [xi(1:iRow-1); imag(xi(iRow)); real(xi(iRow:end))];
    yi = [yi(1:iRow-1); imag(yi(iRow)); real(yi(iRow:end))];
end



function [x1segs,y1segs,x2segs,y2segs] = polyLinesToSegLists(x1,y1,x2,y2)
% convert the 2 polys/lines to segment lists

nSegs1 = length(x1)-1;  % Number of segments in first line/poly (it takes 2 points to make a segment)
nSegs2 = length(x2)-1;  % Number of segments in second line/poly

% assemble lists of segments of line/poly #1 [x1 y1] and 
% line/poly #2 [x2 y2] into the matrices [x1segs y1segs] and [x2segs y2segs],
% such that rows [x1segs y1segs x2segs y2segs] include all possible 
% segment pairs from the two lines/polys.

ones1 = ones(1,nSegs1); % used for repeating the 2nd poly/line, as row vectors
ones2 = ones(nSegs2,1); % used for repeating the 1st poly/line, as col vectors

x1start = x1(1:end-1); % the x coord starting point of each segment
y1start = y1(1:end-1); % the y coord starting point of each segment
x1end = x1(2:end); % the x coord ending point of each segment
y1end = y1(2:end); % the y coord ending point of each segment

x2tr = x2'; % transpose seg 2 into row matrices
y2tr = y2';

x2start = x2tr(1:end-1); % x coord starting point of each segment of 2nd poly/line
x2end = x2tr(2:end);
y2start = y2tr(1:end-1);
y2end = y2tr(2:end);

x1start = x1start(:, ones2); % repeat the starting x coord list as column vectors
y1start = y1start(:, ones2);
x1end = x1end(:, ones2);
y1end = y1end(:, ones2);

x2start = x2start(ones1, :); % repeat the starting x coord list as row vectors
y2start = y2start(ones1, :);
x2end = x2end(ones1, :);
y2end = y2end(ones1, :);

% create arrays of segments so that all segment pairs are covered (essentially we loop
% over segments in [x1 y1] for each segment in [x2 y2]).
x1segs = [x1start(:) x1end(:)];
y1segs = [y1start(:) y1end(:)];
x2segs = [x2start(:) x2end(:)];
y2segs = [y2start(:) y2end(:)];

