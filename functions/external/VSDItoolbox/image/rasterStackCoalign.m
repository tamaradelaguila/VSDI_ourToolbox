function stretchedStack = rasterStackCoalign(rasterCellArray)
% RASTERSTACKCOALIGN co-aligns rasters in the input RASTERCELLARRAY.
% This is accomplished by interpolating ("stretching") each raster, to give
% the same number of rows in each raster.  Interpolation operations are
% performed on each anatomical region separately, so that regions are the
% same size in each raster.
%

userSettings; % load user settings

nRasters=length(rasterCellArray);

% first, determine the indices of empty rows in each raster (empty rows
% indicate anatomical transition points).  It is expected that each raster
% will have the same number of these blank rows.
zeroRowInd = cell(nRasters,1); % preallocate
indEachRegion = cell(nRasters,1); % preallocate
for i=1:nRasters,
    [zeroRowInd{i},indEachRegion{i}] = rasterFindZeroRows(rasterCellArray{i}); % store indices of zero lines in zeroRowInd, and store the indices of all data-containing rows in indEachRegion
    if i==1, % on the first iteration, note the number of zero lines found
        expectedNumZeroRows = length(zeroRowInd{i});
        nRegions = expectedNumZeroRows + 1; % the number of regions is the number of zero rows +1
    end
    
    if expectedNumZeroRows ~= length(zeroRowInd{i}); % compare the number of zero-containing rows to the expected number.  if the number of rows is not expected, throw an error.
        error(['Number of anatomical boundary rows in cell #' num2str(i) ' (' num2str(length(zeroRowInd{i})) ') does not match the number of boundary rows in cell #1 (' num2str(expectedNumZeroRows) ')!'])
    end
end
zeroRowInd = cell2mat(zeroRowInd')'; % convert the cell array to a regular matrix.  (if we made it to this point, we know that all cells of zeroRowInd contain the same size matrix)

regionSizes = zeros(nRasters,nRegions); % preallocate.
for i=1:nRasters,
    for j=1:length(indEachRegion{i}),
        regionSizes(i,j) = length(indEachRegion{i}{j});
    end
end


disp(' ')
disp(['These rasters contain ' num2str(nRegions) ' anatomical regions.'])
disp(['    Current average region sizes: ' num2str(mean(regionSizes),2)])
disp(['    Current max region sizes:     ' num2str( max(regionSizes),2)])
disp(' ')


% prompt the user to choose the size for each region (after stretching)
validInput=0; % initialize while loop conditional
while ~validInput,
    
    if isempty(defaultStretchedSizes{nRegions}), % loaded from userSettings
        disp(['No default values found for a raster containing ' num2str(expectedNumZeroRows) ' anatomical regions.']);
    end
    
    disp('Enter interpolated lengths for each region.')
    disp('To stretch a raster containing 3 regions,')
    disp('enter three integers in braces, e.g. [4 24 16].')
    
    if ~isempty(defaultStretchedSizes{nRegions}),
        disp(['    * Press enter to accept default region sizes of [' num2str(defaultStretchedSizes{nRegions}) '] *'])
    end
    
    userInput = input('    Your input: ','s');
    
    try        
        if strcmp(userInput,''),
            stretchedSizes = defaultStretchedSizes{nRegions}; % if no input was provided, try to use the default values (from userSettings)
        else
            stretchedSizes = eval(userInput); % if a string was provided, try to convert it to a matrix
        end
        if length(stretchedSizes) == nRegions, % if stretchedSizes is a matrix with an appropriate number of values, we can exit the loop
            validInput=1; % set to 1 to exit the loop
        end
    catch
    end
    
end


stretchedRasterCells = cell(nRasters,nRegions); % init a cell array for storing stretched rasters for each region, for each raster
for i=1:nRasters,
    for j=1:nRegions,
        regionRowInds = indEachRegion{i}{j}; % indices for the rows for the current region of the current raster
        stretchedRasterCells{i,j} = stretchImage(rasterCellArray{i}(regionRowInds,:),stretchedSizes(j)); % stretch the region to be the size defined in strechedSizes
    end
end

blankLine = zeros(1,size(rasterCellArray{1},2)); % a blank line with the correct number of time samples for vertically concatenating with raster data
stretchedStack = cell(nRasters,1); % init raster array for output
for i=1:nRasters,
    wholeRaster = stretchedRasterCells{i,1};
    if nRegions>1, % if there's more than 1 region in each raster, add a blank row to the output and continue adding regions
        for j=2:nRegions,
            wholeRaster = [wholeRaster; blankLine; stretchedRasterCells{i,j}];
        end
    end
    stretchedStack{i} = wholeRaster; % assign the output for each raster to be the newly assembled, stretched raster
end





