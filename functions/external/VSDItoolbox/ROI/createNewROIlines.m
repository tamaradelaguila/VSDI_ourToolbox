function regionLines = createNewROIlines()
% if there aren't ROIs in the current workspace, help the user draw new ROIs


% the user selects regions
disp('Drag to draw region midline...')

h(1) = drawAndRedrawLine(); % draw the centerline

disp('     How many dividing lines would you like to draw?')
numLinesStr = input('     For example, to mark the hilus/CA3 boundary and the CA3/CA1 boundary, enter "2": ','s');

for i=2:str2num(numLinesStr)+1,
    disp(['Drag to draw hatch mark #' num2str(i-1) '; for example, mark the boundary between the hilus and CA3.'])
    disp('(The order in which hatch marks are drawn does not matter.)...')
    h(i) = drawAndRedrawLine();
end
    
regionLines = hRegionToPolyRegion(h); % store the region info in REGIONPOLY

if ~iscell(regionLines),
    regionLines = {regionLines}; % in the case that no dividing lines were drawn, hRegionToPolyRegion returns a non-cell array.  this statement forces REGIONLINES to return a cell array. !!!!!!!!!!!!!!!!!!!!
end

function h = drawAndRedrawLine()

    happy=0; % init conditional variable for while loop
    while happy==0,
        h = imfreehand(gca,'Closed',0); % store the handle of the new IMPOLY in the cell array H
        inputYN = input('     Are you happy with that line? (y/n): ','s');
        if strcmpi(inputYN(1),'y'),
            happy=1;
        else
            delete(h)
        end
    end