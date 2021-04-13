function [rasterInner,rasterOuter,polyInner,polyOuter] = rasterizeMain(D,imBg)
% rasterizeMain converts a 3D movie to a 2D raster plot (or set of raster
% plots).

userSettings; % load settings from userSettings.m


%% Draw (or load) anatomical boundaries (the user will either load a file or outline ROIs)

figure(100),close(100) % clear the figure window, in case pre-existing impolys are present

disp('Use polylines from a previous recording, or "Cancel" to draw new.')
[filename, pathname] = uigetfile('*.mat', 'Select a geometry file'); % load file dialogue

regionPolyCVL=cell(1,1); % initialize
regionLinesCVL=cell(1,1);

% if user selected 'cancel', guide the user to draw new regions
if isequal(filename,0), disp('User selected Cancel')
    % draw new regions
    drawAnother=1; % allow the user to add additional regions to segment (for example, the first region could be the hippocampus proper and the 2nd region could be the dentate gyrus)
    regionNum=0;
    while drawAnother,
        regionNum=regionNum+1; % increment counter before drawing the next region
        if regionNum<=length(GLO_VARS.regionNamesCVL),
            disp(['Click to select the ' GLO_VARS.regionNamesCVL{regionNum} ' region...']) % if the region has a name in userSettings, display the name
        else
            disp(['Click to select region #' num2str(regionNum) '...']) % if no region name is found in userSettings, display the number of the region
        end
        
        regionPolyCVL{regionNum,1} = createNewROIs(imBg,GLO_VARS.colors(regionNum,:),regionPolyCVL); % prompt the user to draw regions
        regionLinesCVL{regionNum,1} = createNewROIlines();
        
        strIn = input('     Add another region (y/n)? ','s');
        if ~isempty(strIn),
            if strcmpi(strIn(1),'n')
                drawAnother=0; % if the user says they don't want to draw another region, break out of the loop
            end
        end
    end
    
    polyInner = cell(length(regionPolyCVL),1);% preallocate
    polyOuter = cell(length(regionPolyCVL),1);
    combineRegions_TrueFalse = zeros(length(regionPolyCVL),1); % preallocate
    
    for i=1:length(regionPolyCVL),
        if regionNum<=length(GLO_VARS.regionNamesCVL),
            disp(['       Combine the ' GLO_VARS.regionNamesCVL{i} ' region across centerline?'])
            combineRegionsYN = input('     (y/n; "n" will give 2 rasters for each region, 1 red and 1 green): ','s'); % ask the user if they would like to combine the current region set
        else
            disp(['       Combine region #' num2str(i) ' across centerline?'])
            combineRegionsYN = input('     (y/n; "n" will give 2 rasters for each region, 1 red and 1 green): ','s'); % ask the user if they would like to combine the current region set
        end
        
        if strcmpi(combineRegionsYN(1),'y'),
            combineRegions_TrueFalse(i)=1;
        else
            combineRegions_TrueFalse(i)=0;
        end
        
        [polyInner{i}, polyOuter{i}] = segmentRegion3(regionPolyCVL{i},regionLinesCVL{i}{1},imBg,GLO_VARS.CVLstep_mm,GLO_VARS.pixLen,combineRegions_TrueFalse(i),1); % segment the region
        
        if ~combineRegions_TrueFalse, % for each region where the centerline was used to give two separately segmented regions, prompt the user to verify that the red region is on the inside of the arc
            rasterPlotPoly(polyInner(i),polyOuter(i),imBg,combineRegions_TrueFalse(i),100)
            %plotSegmentedRegions(imBg,polyInner{i},polyOuter{i});
            
            if regionNum<=length(GLO_VARS.regionNamesCVL),
                isInsideArcRed_YN = input(['     For the ' GLO_VARS.regionNamesCVL{i} ' region, are the red lines on the inside of the arc? (y/n): '],'s');
            else
                isInsideArcRed_YN = input(['     For region #' num2str(i) ', are the red lines on the inside of the arc? (y/n): '],'s');
            end
            
            if strcmpi(isInsideArcRed_YN(1),'n'), % if the user says the red lines aren't on the inside of the arc, switch the red and green regions.
                tempPoly = polyInner{i};
                polyInner{i} = polyOuter{i};
                polyOuter{i} = tempPoly;
                clear tempPoly
                rasterPlotPoly(polyInner(i),polyOuter(i),imBg,combineRegions_TrueFalse(i),100)
                %plotSegmentedRegions(imBg,polyInner{i},polyOuter{i});
                pause(0.5)
            end
        end
    end
    
    
    % prompt user to save geometries
    [fnameOut, pnameOut] = uiputfile('*.mat', 'Save Geometry as');
    if ~isequal(fnameOut,0),
        save(fullfile(pnameOut,fnameOut),'imBg','regionLinesCVL','regionPolyCVL','polyOuter','polyInner','combineRegions_TrueFalse')
    else
        disp('User selected Cancel.  No geometry file saved.')
    end
        
    
else % load regions from the selected file
    disp(['Loading geometry from file: ', fullfile(pathname, filename)])
    load(fullfile(pathname, filename),'polyInner','polyOuter','regionPolyCVL','regionLinesCVL','combineRegions_TrueFalse') % load the geometry (including regionPolyCVL, regionLinesCVL, polyOuter, and polyInner) from the user-specified file.  we *aren't* loading imBg, because we want to keep the imBg that was provided as input to rasterizeMain.
    % note that we haven't loaded imBg!  we want to keep the input imBg,
    % because that's the image that corresponds to the data D
    
    h = drawAllROIs(imBg,regionPolyCVL,GLO_VARS.colors,100); % draw new IMPOLYs from the loaded regionPolyCVL
    hl = drawAllROIlines(regionLinesCVL);% draw new IMFREEHAND lines from the regionLinesCVL that is already in the workspace
    [h,hl,regionShift] = adjustRegions(h,hl,GLO_VARS.colors,imBg); % user-guided adjustment of the regions to accommodate changes in the field of view
    
    % shift all polyOuter and polyInner coordinates by the same amount, so
    % polygons are aligned with user-drawn lines
    polyInner = translatePoly(polyInner,regionShift); % apply the shift to polyInner
    polyOuter = translatePoly(polyOuter,regionShift); % apply the shift to polyOuter
    
    % get save-able coordinates from all the impoly objects
    regionPolyCVL = hRegionToPolyRegion(h);
    regionLinesCVL = hRegionToPolyRegion(hl);
    
    % convert the loaded data structures to cell if they aren't already,
    % for consistency with references to cells below (non-cell type structures
    % can occur here if only 1 region is defined in the loaded geometry
    % file)
    if ~iscell(regionPolyCVL), regionPolyCVL = {regionPolyCVL}; end
    if ~iscell(regionLinesCVL), regionLinesCVL = {regionPolyCVL}; end
    
end


%% Display poly regions

rasterPlotPoly(polyInner,polyOuter,imBg,combineRegions_TrueFalse,100)
drawnow


%% Create rasters for each geometry

rasters = cell(length(regionPolyCVL),2); % preallocate
rasterNames = cell(length(regionPolyCVL),2); % preallocate

for i=1:length(regionPolyCVL),
    [rasterInner,rasterOuter] = polyGeomToRaster2(polyInner{i},polyOuter{i},regionLinesCVL{i},D,combineRegions_TrueFalse(i));
    
    rasterInner(end,:) = []; % truncate the final segment of the raster, because it won't be the standard segment length
    rasterInner = medfilt1RepEdge(rasterInner,GLO_VARS.medianFilterLength,[],2); % median filter the temporal signals
    if ~isempty(rasterOuter),
        rasterOuter(end,:) = [];
        rasterOuter = medfilt1RepEdge(rasterOuter,GLO_VARS.medianFilterLength,[],2);
    end
    
    rasters{i,1} = rasterInner; % save the rasters for this region to a cell array
    rasters{i,2} = rasterOuter;
    
    % create a cell array of names for each raster
    if i<=length(GLO_VARS.regionNamesCVL), % if a name is defined for this region in userSettings.m, use that name
        currRegionName = GLO_VARS.regionNamesCVL{i};
    else % if no name is defined for this region in userSettings.m, use a generic name, e.g., "Region #3".
        currRegionName = ['Region #' num2str(i)];
    end
    
    if combineRegions_TrueFalse(i), % if regions were combined, only one raster will be saved for the current region
        rasterNames{i,1} = [currRegionName ': whole'];
        rasterNames{i,2} = 'not used';
    else % if regions weren't combined, two rasters will be saved (inner and outer)
        rasterNames{i,1} = [currRegionName ': inner'];
        rasterNames{i,2} = [currRegionName ': outer'];
    end
end


%% Display the rasters

rasterPlotMultiregion(rasters,rasterNames,101)
drawnow


%% Save rasters for this data file
    
[fnameOut, pnameOut] = uiputfile('*.mat', 'Save Rasters as');
if ~isequal(fnameOut,0),
    save(fullfile(pnameOut,fnameOut),'rasters','rasterNames','imBg','regionLinesCVL','regionPolyCVL','polyOuter','polyInner','combineRegions_TrueFalse')
else
    disp('User selected Cancel.  No raster file saved.')
end










