function movieOut = VSDthreshMovie(D,imBg)

userSettings; % load settings (contains filter params)

% Spatial smoothing
Dfilt=convRepEdge(D,GLO_VARS.movieSmoothingKernel);

% Median filter
Dfilt = medfilt1RepEdge(Dfilt,GLO_VARS.medianFilterLength,[],3);

% Threshold traces
DsuprathrMov = single(movieSDthresh(Dfilt,GLO_VARS.BGframes,SD_NOISE_MOV)); % for each normalized pixel trace, set values within SD_NOISE_MOV standard deviations of the noise to zero


% Make a movie
load('colormapMovieClassic','movieCmap') % colormap for hippoMovie
[movieOut,~] = hippoMovie(DsuprathrMov,imBg,5e-3,movieCmap); % the last number defines the + and - limits of the range of DF/F values in the movie colormap (a value of 5e-3 means the colormap will span from -5e-3 to +5e-3).  This number is raw DF/F, not a percent.
%[movieOut,~] = hippoMovie(Dsuprathresh,imBg,3,1); % made range bigger for bicuculline video


% tif file output
disp('    Choose a location to save the movie as a .tif stack (cancel to skip)')
[fnameOut, pnameOut] = uiputfile('*.tif', 'Save Tif Movie as'); % raise GUI to get user pathname and filename
if ~isequal(fnameOut,0), % if the user didn't press cancel
    writeTiffMovie(movieOut,fullfile(pnameOut,fnameOut),4); % write the tiff file to the user-selected location
else
    disp('User selected Cancel.  Nothing saved.')
end