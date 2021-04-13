function segOut = getPolyPathBetweenPts(vertList,r1,c1,r2,c2)
% find the shortest path through the points in VERTLIST from the point
% [r1 c1] to the point [r2 c2].  VERTLIST is assumed to be a polygon.
% VERTLIST should *not* be a closed polygon.
% E.g., a 2D triangle with points A, B, and C should be a vertList of 
% three points [Ar Ac; Br Bc; Cr Cc], NOT four points
% [Ar Ac; Br Bc; Cr Cc; Dr Dc].

[vertListPtsAdded, ind1] = insertPointIntoVector([vertList; vertList(1,:)],r1,c1); % insert first point into the vertList to determine where the point would fit into the list.  vertList(ind1,:) will actually be the first point after 
[vertListPtsAdded, ind2] = insertPointIntoVector(vertListPtsAdded,r2,c2); % store the index of the second point in ind2

% if we inserted a second point in the vector before the first point, the index of the first point will have to be shifted +1
if ind2<=ind1,
    ind1=ind1+1;
end

indPts=zeros(size(vertListPtsAdded,1),1);
indPts(ind1)=1;
indPts(ind2)=1;
repIndPts=[indPts(1:end-1); indPts]; % the last point in VERTLISTPTSADDED is a repeat of the first point.  it is not possible for the last point to be the inserted point because insertPointIntoVector can only insert points *between* pre-existing points.  Therefore we can get rid of the last point when making the repeated indices list

repVertListPtsAdded = [vertListPtsAdded(1:end-1,:); vertListPtsAdded]; % repeat the list twice so we can find the shortest segment between points, considering both directions around the polygon

indDistOnPath=find(repIndPts,3);% find the first three indices in repIndPts.  This is equivalent to making 1 complete loop around the polygon path.
distOnPath = diff(indDistOnPath); % measure the length of the two possible paths

if distOnPath(1)<distOnPath(2), % if the first path is shortest
    segOut = repVertListPtsAdded(indDistOnPath(1):indDistOnPath(2),:);
else
    segOut = repVertListPtsAdded(indDistOnPath(2):indDistOnPath(3),:);
end


