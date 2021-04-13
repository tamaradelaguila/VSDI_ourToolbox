function indIntersection = encircledPointPolyList(polyList,line1,line2)
% given a cell array of polygons POLYLIST and two lines LINE1 and LINE2,
% INTLINEPOLYLIST returns the number of the first cell in POLYLIST that
% contains the point defined by the intersection of LINE1 and LINE2.

[xInt,yInt] = polyIntPoly(line1(:,1),line1(:,2),line2(:,1),line2(:,2)); % find the point of intersection of the two input lines


% initialize counting variables
encircFound=0;
i=1;
while encircFound==0,
    polyClosed=[polyList{i}; polyList{i}(1,:)]; % close polygon
    isPtEncirc = inpolygon(xInt,yInt,polyClosed(:,1),polyClosed(:,2)); % for each polygon, determine if the point is encircled by the polygon
    if isPtEncirc, %if the point is inside the polygon,
        indIntersection=i; % return the number of the polygon that intersects the line
        encircFound=1;
    end
        
    if i==length(polyList),
        encircFound=-1; % this means no polygon was found to contain the point
    end
    i=i+1;
end

if encircFound==-1,
    indIntersection=0;
    disp('Warning: polygon in polyList was found to contain the hatch mark intersection point.')
end