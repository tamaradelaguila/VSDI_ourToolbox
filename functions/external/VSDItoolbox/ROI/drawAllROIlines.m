function h = drawAllROIlines(regionLines)
% DRAWALLROILINES plots the outlines of the regions defined in REGIONPOLY.

if iscell(regionLines),
    h=cell(size(regionLines)); % preallocate
    for i=1:length(regionLines),
        h{i} = drawAllROIlines(regionLines{i}); % if h is a cell, go a level deeper into the cell structure and recurse
    end
    
else
    h = roiDrawLines(regionLines); % draw new IMPOLYs from regionLines
end