function rasterPlotMultiregion(rasters,rasterNames,figureNum)

if ischar(rasters) % if a text input is provided as the first argument, try to load 'rasters' and 'rasterNames' from the file specified by the string
    try
        load(rasters,'rasters','rasterNames');
    catch
        error('Unable to load "rasters" and "rasterNames" from specified file')
    end
end

if nargin<3, % create a figure window
    hFig = figure;
else
    hFig = figure(figureNum);
end

clf(hFig); % clear the current figure window

userSettings; % load userSettings to get the stimulus time and frame rate

szR = size(rasters); % size of the raster cell array output

for i=1:szR(1), % for each row in the raster cell array output
    axCurrent = subplot(szR(1),2,(i-1)*2+1,'replace');
    rasterPlotRaster(rasters{i,1},GLO_VARS.frameInterval_ms,GLO_VARS.tStimMS,[],[],axCurrent) % plot the 'inner' raster in column 1
    title(axCurrent,rasterNames{i,1}) % create a text title for the plot
    
    if ~isempty(rasters{i,2}), % if there's an 'outer' raster, plot it
        axCurrent = subplot(szR(1),2,(i-1)*2+2,'replace');
        rasterPlotRaster(rasters{i,2},GLO_VARS.frameInterval_ms,GLO_VARS.tStimMS,[],[],axCurrent) % plot the 'inner' raster in column 1
        title(axCurrent,rasterNames{i,2}) % create a text title for the plot
    end
end
