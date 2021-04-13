function indIntersection = intLinePolyList(polyList,lineIn)
% given a cell array of polygons POLYLIST and a line LINEIN,
% INTLINEPOLYLIST returns the number of the first cell in POLYLIST that
% has an intersection with LINEIN.

% initialize counting variables
intFound=0;
i=1;
while intFound==0,
    polyClosed=[polyList{i}; polyList{i}(1,:)]; % close polygon
    [ci, ~] = polyIntPoly(polyClosed(:,1),polyClosed(:,2),lineIn(:,1),lineIn(:,2));
    if ~isempty(ci), %if an intersection was found
        indIntersection=i; % return the number of the polygon that intersects the line
        intFound=1;
    end
        
    if i==length(polyList),
        intFound=-1; % this means no intersection was found
    end
    i=i+1;
end

if intFound==-1,
    indIntersection=0;
    disp('Warning: No intersection found between polyList and lineIn')
end