% userSettings.m
% User-specific constant parameters for VSDItoolbox.
%

%% Parameters used by rasterMain() and its dependencies.
GLO_VARS.frameInterval_ms = 2; % this is the number of ms between frames (use "2" if data were recorded at 500 frames per second)
GLO_VARS.tStimMS = 70; % the time point when the first stimulus was delivered in each recording (in ms).  this is used to set the time axis offset appropriately in plots

GLO_VARS.CVLstep_mm = 0.100; % arclength of each curvilinear region (in mm)
GLO_VARS.pixLen = 0.025; % width (or height) of each pixel (in mm).  this is used to convert from pixel numbers to real-world distances.  pixels are assumed to be square

GLO_VARS.medianFilterLength=5; % number of samples for temporal median filtering of the raster data.  to turn off median filtering, set to 1.

GLO_VARS.regionNamesCVL=cell(3,1); % preallocate.  CVL stands for "curvilinear"
GLO_VARS.regionNamesCVL{1}='CA (hippocampus proper)'; 
GLO_VARS.regionNamesCVL{2}='DG (dentate gyrus)';
GLO_VARS.regionNamesCVL{3}='SLM (stratum lacunosum moleculare)';

GLO_VARS.colors = zeros(50,3); % make the colors array big with a default of black.  ("50" makes it possible to outline up to 50 regions without trying to access a nonexistent color)
GLO_VARS.colors(1,:) = [0  0  1]; % CA, blue
GLO_VARS.colors(2,:) = [1  0  0]; % DG, red
GLO_VARS.colors(3,:) = [1  0  1]; % SLM, purple


%% Parameters used by rasterStackCoalign(), for stretching rasters.
defaultStretchedSizes = cell(50,1); % preallocate a large cell array, so attempts to access indices >3 do not result in an error
defaultStretchedSizes{1} = 12;         % the first cell of defaultStrechedSizes defines the length of the region to interpolate to if only 1 region is found
defaultStretchedSizes{2} = [10 10];    % defines the length of the regions to interpolate to if 2 regions are found
defaultStretchedSizes{3} = [4 24 16];  % defines the length of the regions to interpolate to if 3 regions are found


%% Parameters for permutation testing, used by rasterPermTestIterate() and rasterPermTestCompare().
N_X_SAM = 3; % number of spatial samples to average for measurement at each raster pixel.  this value must be odd.
N_T_SAM = 3; % number of temporal samples to average for measurement at each raster pixel.  this value must be odd.


%% Parameters for movie output, used by VSDthreshMovie().
GLO_VARS.BGframes = 1:33; % a range of frame numbers before stimulus delivery.  used to measure the standard deviation of the background noise in the data
SD_NOISE_MOV = 3; % reject signal as "noise" below this number of standard deviations
% GLO_VARS.movieSmoothingKernel=ones(5,5,1)/(5*5*1); % [r,c,t] smoothing of the movie using convolution (this kernel averages over a 5x5 pixel neighborhood for each pixel)
GLO_VARS.movieSmoothingKernel=fspecial('gaussian',5,1.2); % [r,c,t] smoothing of the movie using convolution (this kernel uses a gaussian kernel to produce a center-weighted average of a 5x5 neighborhood for each pixel)

