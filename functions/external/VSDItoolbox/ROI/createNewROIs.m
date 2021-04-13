function regionPoly = createNewROIs(imBg,color,regionPoly)
% help the user draw new ROIs.  if any previously existing ROIs are
% provided, they will be plotted for reference on the background image.

% plot a frame of data (for selecting masks)
figure(100); set(gcf,'Position',[807 408 640 480]); clf(100)
hAx1 = axes; % handle to axes
imagesc(imBg,'Parent',hAx1);colormap gray, axis equal

hold on
if nargin==3, % if existing regions were provided, plot them
    if ~isempty(regionPoly{1}),
        polyPlot(regionPoly,imBg,'k',hAx1)

%         for i=1:length(regionPoly),
%             plot([regionPoly{i}(:,1); regionPoly{i}(1,1)],[regionPoly{i}(:,2); regionPoly{i}(1,2)],'k')
%         end

    end
end
hold off

set(hAx1,'Ylim',get(hAx1,'Xlim')) % creates white space around image (helpful when drawing regions that hang off edges)
h = pickROI(color); % store the handle of the new IMPOLY in the cell array H

disp('Adjust region if necessary.  When finished, DOUBLE CLICK the region.')
wait(h); % this actually returns a vertices list for hMaskDGexp.  That output isn't used here, because vertices lists are loaded from the mask handles in MASKEDSIGS

regionPoly = hRegionToPolyRegion(h); % store the region info in REGIONPOLY
    
%     savePolyFname = input('Enter file name (e.g. "slice1poly") to save regionPoly to a .mat file (skip with "no"): ', 's');
%     if ~strcmp(savePolyFname,'no'),
%         save(savePolyFname,'regionPoly','imBg')
%     end