function polyOut = translatePoly(poly,vectorRC)

% MASKOUT translates the vertices of a polygon in the direction VECTORRC

if iscell(poly),
    polyOut = cell(size(poly)); % preallocate cell array output
    for i=1:length(poly),
        polyOut{i} = translatePoly(poly{i},vectorRC); % if the current level of POLY is a cell, go a level deeper and recurse
    end
elseif isempty(poly), % if poly is empty, return an empty array
    polyOut = [];    
else
    polyOut=zeros(size(poly));
    polyOut(:,1)=poly(:,1)+vectorRC(1);
    polyOut(:,2)=poly(:,2)+vectorRC(2);
end