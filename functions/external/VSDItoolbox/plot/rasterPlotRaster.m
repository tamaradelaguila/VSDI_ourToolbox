function rasterPlotRaster(imgIn,frameInterval_ms,tStim,t1,t2,axHandle)
% RASTERPLOTRASTER(D) plots the 2D raster image D.
%
% RASTERPLOTRASTER(D,frameInterval_ms) plots the 2D raster image D with the
% temporal axis incremented in time steps between movie frames.  (For a
% recording obtained at 500 frames per second, frameInterval_ms = 2 ms.)
%
% RASTERPLOTRASTER(D,frameInterval_ms,tStim) adjusts the temporal axis so 
% that t = 0 ms corresponds to the time of stimulus delivery.
%
% RASTERPLOTRASTER(D,frameInterval_ms,tStim,t1,t2) plots D, showing only 
% the samples during the time interval t1:t2.  Note that t1 and t2 are in 
% units of time, not sample numbers.
%
% RASTERPLOTRASTER(D,frameInterval_ms,tStim,t1,t2,axHandle) plots D as 
% described above, in the axes defined by the handle axHandle.
%
% It is also possible to omit some inputs to RASTERPLOTRASTER, by providing
% empty arrays, [], for some inputs.  For example, to plot a raster in the
% axes defined by axis handle "axHandle" without providing tStim, t1, or
% t2, the following command could be used:
%
% rasterPlotRaster(D,2,[],[],[],axHandle)
%


%% if any inputs aren't provided, set default values
if ~exist('frameInterval_ms','var') % if frameInterval_ms doesn't exist
    frameInterval_ms = 1; % define it as 1
elseif isempty(frameInterval_ms), % or if the variable exists but is empty
    frameInterval_ms = 1; % define it as 1
end
    
if ~exist('tStim','var') % if tStim doesn't exist
    tStim = 1; % define it as 1
elseif isempty(tStim), % or if the variable exists but is empty
    tStim = 1; % define it as 1
end

if ~exist('t1','var') % if t1 doesn't exist
    t1 = 1*frameInterval_ms; % define it as 1
elseif isempty(t1), % or if the variable exists but is empty
    t1 = 1*frameInterval_ms; % define it as 1
end

if ~exist('t2','var') % if t2 doesn't exist
    t2 = size(imgIn,2)*frameInterval_ms; % define t2 according to the number of temporal samples in the data input
elseif isempty(t2), % or if the variable exists but is empty
    t2 = size(imgIn,2)*frameInterval_ms; % define t2 according to the number of temporal samples in the data input
end

if ~exist('axHandle','var') % if axHandle doesn't exist
    figure % create a figure and axes
    set(gcf,'Position',[661 264 410 210])
    axHandle = axes;
elseif isempty(axHandle), % or if the variable exists but is empty
    figure % create a figure and axes
    set(gcf,'Position',[661 264 410 210])
    axHandle = axes;
end
% end of input control 
%%

% t1 and t2 are *time limits* for the xaxis

t = ((t1):frameInterval_ms:t2-1) - tStim; % numbers for labeling the axis

ind = (t1/frameInterval_ms):(t2/frameInterval_ms-1); % indices of the image

prettyRaster = colorizeRaster(imgIn(:,ind));
axis(axHandle);
imagesc(t,[],prettyRaster)
set(axHandle,'YDir','normal') % put the DG at the bottom of the plot
xlabel('time (ms)')
%set(gcf,'Position',[661 264 360 210])

%% Y labels

szIm = size(imgIn);

boundaryRows = rasterFindZeroRows(imgIn);

tickInd = zeros(2+length(boundaryRows),1); % preallocate.  there will be a tick mark for the first and last rows, plus a tick mark for the first row in each anatomical region
tickVal = zeros(2+length(boundaryRows),1);

tickInd(1) = 1;
tickVal(1) = 1;

tickInd(end) = szIm(1);
tickVal(end) = szIm(1)-length(boundaryRows);

if ~isempty(boundaryRows), % 
    for i=1:length(boundaryRows),
        tickInd(i+1) = boundaryRows(i) + 1; % always put a tick mark one row above the anatomical boundary row
        tickVal(i+1) = boundaryRows(i) + 1 - i; % subtract the number of boundary rows encountered thus far from the value, so that tick numbers ignore the bounary rows
    end
end

set(axHandle,'YTick',tickInd,'YTickLabel',tickVal) % display the y ticks and y tick labels on the figure
















