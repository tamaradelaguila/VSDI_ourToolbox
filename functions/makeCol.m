function colvector = makeCol(vector)
% Checks whether vector is a column and, if so, turns it into a col

% input control
if size(size(vector))> 2
    error('input a 2d vector')
end
% end

if length(vector) >1 % If it is a scalar, it leaves it unchanged
    
    if size(vector,2) > size(vector,1)
        colvector = vector';
    else
        colvector = vector;
    end
    
else
    colvector = vector;
    
end

end

%% Created: 18/05/2021 (from makecol)