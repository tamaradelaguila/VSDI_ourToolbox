%% s02 FILTERING (further preprocessing) and crop
% Crop masks should have been drawn in the s01_importmov_basic_preproces

clear 
user_settings; 
nfish = 1;

VSDI = ROSmapa('load',nfish);

%% FILT1:
%@ SET FILTERS PARAMETERS : 
tcnst = 10;% Time-constant for TEMPORAL SMOOTHING
gauss_kernel = 1; %  gaussian smoothing kernel for SPATIAL SMOOTHERING
mpix = 3; % pixels size for MEDIAN SPATIAL FILTER

% 1. REFERENCES for input/output movies (see 'z_notes.txt', point 5 for
% complete list)
inputRef =  '_02diff';
outputRef = '_04filt1'; %@ SET 

% Load input movie 
[inputStruct] = ROSmapa('loadmovie',nfish,inputRef); 
inputdata=inputStruct.data;

% 2. PERFORM COMPUTATIONS: %DIFFERENTIAL VALUES

% Preallocate in NaN
filtmov = NaN(size(inputdata));

% 2.1. Tcnst
for triali = makeRow(VSDI.nonanidx)
tempmov = inputdata(:,:,:,triali);
filtmov(:,:,:,triali) = filter_Tcnst(tempmov,10);
clear tempmov
end

% 2.2. Gaussian spatial (not into function yet)
for triali = makeRow(VSDI.nonanidx)
    tempmov = filtmov(:,:,:,triali);
     filtmov(:,:,:,triali) = filter_gauss2D(tempmov, gauss_kernel);
     clear tempmov
end
  
% 2.3. Median spatial filter
for triali = makeRow(VSDI.nonanidx)
    tempmov = filtmov(:,:,:,triali);
     filtmov(:,:,:,triali) = filter_median(tempmov, mpix);
     clear tempmov
end

% 2.4. Crop background
for triali = makeRow(VSDI.nonanidx)
    tempmov = squeeze(filtmov(:,:,:,triali));
    filtmov(:,:,:,triali)= roi_crop(tempmov, VSDI.crop.mask);
    clear tempmov
end


% 3.SAVE NEW MOVIE STRUCTURE:  copying some references from the movie
% structure used to apply new changes in
VSDmov.ref = inputStruct.ref;
VSDmov.movieref= outputRef;
VSDmov.data = filtmov;
VSDmov.times = inputStruct.times;
%@ SET !!! according to the filters applie (append as many as needeed)
VSDmov.hist = inputStruct.hist;
VSDmov.hist{length(VSDmov.hist)+1,1} = 'tcnst = 10'; %@ SET   
VSDmov.hist{length(VSDmov.hist)+1,1} = 'gauss = 1'; %@ SET  
VSDmov.hist{length(VSDmov.hist)+1,1} = 'median = 3'; %@ SET  
VSDmov.hist{length(VSDmov.hist)+1,1} = 'crop-background'; %@ SET  
ROSmapa('savemovie', VSDmov, VSDmov.movieref); 

