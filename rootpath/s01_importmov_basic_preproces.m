%% s01 IMPORT MOVIES and BASIC PREPROCESSING: FOR EACH FISH
% 00 - IMPORT RAW MOVIE (from python-extracted matfiles) MATFILES ('_00raw' )
% 01 - BRAIN ALINEATION THROUGH TRIALS ('_01registered')
% 02 - DIFFERENTIAL VALUES ('_02diff')
% 03 - MASKED MOVIES ('_03crop' )

clear
user_settings

nfish = 1; %@ SET
[VSDI] = ROSmapa('load',nfish);

%% PYTHON dml extraction
% adjust paths in '00automatic_extraction.py) and execute

%% 00 - IMPORT RAW MOVIE (from python-extracted matfiles) MATFILES 
% folder with all movies extracted with python
py_output = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\BVdml\output'; %@SET where matfiles have been output from python %@ SET

[movies4D, times] = assemble4Draw(VSDI,py_output,VSDI.info.stime);
movieref = '_00raw';

%Save movie structure
VSDmov.ref = VSDI.ref;
VSDmov.movieref= movieref;
VSDmov.data = movies4D;
VSDmov.times = times;
VSDmov.hist{1} = 'raw: py-imported + assemble4Dmovies'; 
ROSmapa('savemovie', VSDmov, movieref); 

% [Save times  in VSDI]
VSDI.timeabs = VSDmov.times;
VSDI.timebase = VSDI.timeabs - VSDI.info.Sonset;
ROSmapa('save',VSDI);

% Test
VSDmov = ROSmapa('loadmovie',nfish,movieref);

%% 01 - BRAIN ALINEATION THROUGH TRIALS
clearvars -except VSDI nfish

% 1. REFERENCES for input/output movies (see 'z_notes.txt', point 5 for
% complete list)
inputRef =  '_00raw'; 
outputRef = '_01registered'; 

%load input movie (non-aligned raw)
[inputStruct] = ROSmapa('loadmovie',nfish,inputRef); 
rawmov=inputStruct.data;

% 2. PERFORM COMPUTATIONS:  REGISTER 
ref_frame = rawmov(:,:,1,VSDI.nonanidx(1)) ; %background from 1st included trial
[registermov] = register_wrap(rawmov,ref_frame, VSDI.nonanidx);

% [Save reference frame in VSDI]
VSDI.backgr = ref_frame;
ROSmapa('save',VSDI,nfish);

% 3.SAVE NEW MOVIE STRUCTURE: Save new registered movie, copying some references from the movie
% structure used to apply new changes in
VSDmov.ref = inputStruct.ref;
VSDmov.movieref= outputRef;
VSDmov.data = registermov;
VSDmov.times = inputStruct.times;
VSDmov.hist = inputStruct.hist;
VSDmov.hist{length(VSDmov.hist)+1,1} = 'register'; %append a new cell with new info
ROSmapa('savemovie', VSDmov, VSDmov.movieref); 
clear inputStruct

% Save background value in VSDI
for triali = makeRow(VSDI.nonanidx) %import only included trials
  
    VSDI.backgr(:,:,triali) = VSDmov.data(:,:,1,triali); % store background
end
%% 02 - DIFFERENTIAL VALUES
clearvars -except VSDI nfish

% 1. REFERENCES for input/output movies
inputRef =  '_01registered'; 
outputRef = '_02diff';

inputStruct = ROSmapa('loadmovie', nfish, inputRef);

% 2. PERFORM COMPUTATIONS: %DIFFERENTIAL VALUES

inputdata = inputStruct.data;

baseframe = 1; % @SET! idx of frames to use as F0 in differential formula
% Turn into string to save later in History:
    baseltext = strcat(num2str(baseframe(1)),'to',num2str(baseframe(end)));

% Preallocate in NaN 
inputdim = size(inputdata); 
diffmovies = NaN(inputdim(1),inputdim(2),inputdim(3)+1,inputdim(4));

for triali = makeRow(VSDI.nonanidx) %import only included trials
    inputmovie = squeeze(inputdata(:,:,:,triali));
    diffmovies(:,:,:,triali) = raw2diffperc2(inputmovie, baseframe);
    
    VSDI.backgr(:,:,triali) = diffmovies(:,:,end,triali); % store background
end
    
% 3.SAVE NEW MOVIE STRUCTURE:  copying some references from the movie
% structure used to apply new changes in
VSDmov.ref = inputStruct.ref;
VSDmov.movieref= outputRef;
VSDmov.data = diffmovies;
VSDmov.times = inputStruct.times;
VSDmov.hist = inputStruct.hist;
VSDmov.hist{length(VSDmov.hist)+1,1} = 'raw2diffperc2'; %append a new cell with new info
ROSmapa('savemovie', VSDmov, VSDmov.movieref); 

ROSmapa('save', VSDI); 

% SUGGESTION: if different F0 are ,keep the basic reference + info about the F0, e.g. outputRef = '_02diffbase10';

%% 03 - [1] MAKE CROPMASK, [2] CROPPED-MOVIES
clearvars -except VSDI nfish

% [1] MAKE & SAVE CROP MASK

% MAKE MASK FROM REFERENCE FRAME AND SAVE IN VSDI
ref_frame = VSDI.backgr(:,:,VSDI.nonanidx(1)); %the background from the first included trial

%  Before cropping: check all backgrounds to take into account if there is
%  much movements (and, for instance, leave out of the mask the margins)
for triali = makeRow(VSDI.nonanidx)
imagesc(VSDI.backgr(:,:,triali)); colormap('bone');
title(strcat('trial=',num2str(triali)))
    pause %to advance to the next frame, press any key; to skip to the end, press 'Ctrl+C'
end

% DRAW & SAVE CROPMASK:
[crop_poly, crop_mask] = roi_draw(ref_frame);

% View the result on a selected trial
trialsel = 2; %@ SET (if you want to check the mask onto any specific frame)
roi_preview(VSDI.backgr(:,:,trialsel), crop_poly{1}); 

% polygon_preview(VSDI.backgr(:,:,1), VSDI.crop.poly{1,1}); 

% IF WE ARE HAPPY WITH THE MASK: SAVE in structure
VSDI.crop.mask = crop_mask; 
VSDI.crop.poly = crop_poly{1}; %stored in rows

% Save one cropped image to help in drawing the different ROI
cropframe =roi_crop(VSDI.backgr(:,:,VSDI.nonanidx(1)), VSDI.crop.mask);

VSDI.crop.preview = cropmovies(:,:,end,VSDI.nonanidx(1)); % save the crop movie of the first included frame
ROSmapa('save', VSDI);

% [2] CROPPED-MOVIES (mute if you don't want to extract them)

% 1. REFERENCES for input/output movies
inputRef =  '_02diff'; 
outputRef = '_03crop';

inputStruct = ROSmapa('loadmovie', nfish, inputRef);
inputdata = inputStruct.data;

% 2. PERFORM COMPUTATIONS: APPLY MASK
cropmovies = NaN (size(inputdata));

%initialize
for triali = makeRow(VSDI.nonanidx)
inputmovie = squeeze(inputdata(:,:,:,triali));
cropmovies(:,:,:,triali)= roi_crop(inputmovie, VSDI.crop.mask);
end

% 3.SAVE NEW MOVIE STRUCTURE:  copying some references from the movie
% structure used to apply new changes in
VSDmov.ref = inputStruct.ref;
VSDmov.movieref= outputRef;
VSDmov.data = cropmovies;
VSDmov.times = inputStruct.times;
VSDmov.hist = inputStruct.hist;
VSDmov.hist{length(VSDmov.hist)+1,1} = 'crop_backgr'; %append a new cell with new info

ROSmapa('savemovie', VSDmov, VSDmov.movieref); 
