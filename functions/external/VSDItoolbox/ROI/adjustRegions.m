function [h,hl,shift] = adjustRegions(h,hl,colors,imBg)
% ADJUSTREGIONS prompts the user to reposition the region masks in h.  if
% the input "hl" is also provided (lines), the elements of hl are also
% translated.

% ADJUSTREGIONS calls translatePoly.

posOrig = mean(getPosition(h(1)),1); % find the centroid of the first region
R1centroidOld = posOrig; % initialize position variable

happy=0; % repeat the loop if happy==0
while happy==0,
    disp('Drag Region 1 (blue?) to align.  When finished, DOUBLE CLICK Region 1.')
    R1centroid=mean(wait(h(1)),1); % get user-refined position of 1st region
    
    if ~(R1centroidOld(1)==R1centroid(1)) && ~(R1centroidOld(2)==R1centroid(2)), % if the mask was moved, then move all the regions.  otherwise don't bother moving anything
        disp('Shifting (this can take a minute)...')
        
        shiftRC=mean(R1centroid,1)-mean(R1centroidOld,1); % measure how far the mask was moved
        R1centroidOld = mean(getPosition(h(1)),1); % the new location will be the "old" location on the next iteration of the while loop
        
        regionPoly = hRegionToPolyRegion(h); % convert the impoly handle object to coordinates we can manipulate
        
        if length(h)>1, % if there's more than one poly region, shift all the other regions by the same distance that the first region was shifted
            regionPoly(2:end) = translatePoly(regionPoly(2:end),shiftRC); % Reposition regions based on the user's translation.  note that we aren't translating the first polygon because the user already moved it with the mouse.
        end
        impolyCellDelete(h) % Delete impoly handle objects prior to redrawing
        
        %keyboard
        
        if ~isempty(hl), % if an array of lines are provided, shift those lines by the same amount as the polys were shifted
            regionLines = hRegionToPolyRegion(hl);
            regionLines = translatePoly(regionLines,shiftRC);
            impolyCellDelete(hl)
        end
        
        % redraw the repositioned impoly handle objects
        h = drawAllROIs(imBg,regionPoly,colors,100); 
        if ~isempty(hl),
            hl = drawAllROIlines(regionLines);
        end
        
        
    end
    
    strIn = input('Are you happy with this alignment? (y/n): ','s');
    if strIn == 'y', happy=1; end
end
shift = mean(getPosition(h(1)),1) - posOrig; % return the magnitude of the total shift