function poly = hRegionToPolyRegion(h)
% Get the coordinates of an impoly object H and return a list of vertices
% of the polygon.

poly=cell(length(h),1); % preallocate

if iscell(h), % if it's a cell array, get coords for each h{i} and store in poly{i}
    for i=1:length(h),
        poly{i}=hRegionToPolyRegion(h{i}); % go a level deeper into the cell structure and recurse
    end
    
elseif length(h)== 1, % if h is not a cell array, and the length of h is 1, we don't want to return a cell array
    poly = getPosition(h);
    
else % if there are multiple polygons in h but h is not a cell array, return a cell array
    for i=1:length(h),
        poly{i}=getPosition(h(i));
    end
end
