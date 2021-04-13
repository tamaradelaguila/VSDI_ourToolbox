function [hMask,poly] = pickROI(color)
% PICKROI calls IMPOLY to accept a user input
% polygonal region mask.  The color of the mask
% is then changed to COLOR.  PICKROI returns both
% the handle to the impoly object (HMASK) and the 
% coordinates of the vertices (POLY).

hMask = impoly(gca);
setColor(hMask,color);
poly=getPosition(hMask); % return the vertices of the selected polygon - note that these can change if the user moves any points in the polygon or drags to translate the polygon

