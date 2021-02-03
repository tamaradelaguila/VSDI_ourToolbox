%% s01 IMPORT MOVIES and BASIC PREPROCESSING: FOR EACH FISH
% 00 - IMPORT RAW MOVIE (from python-extracted matfiles) MATFILES 
% 01 - BRAIN ALINEATION THROUGH TRIALS
% 02 - DIFFERENTIAL VALUES
% 03 - MASKED MOVIES

user_settings

nfish = 1;

%% PYTHON dml extraction
% adjust paths in '00automatic_extraction.py) and execute

%% 00 - IMPORT RAW MOVIE (from python-extracted matfiles) MATFILES 
% folder with all movies extracted with python
py_output = 'C:\Users\User\Documents\UGent_brugge\lab_maps\BVdml\output'; %where matfiles have been output from python

[VSDI] = ROSmapa('load',nfish);
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

% 1. REFERENCES for input/output movies
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
ROSmapa('save',nfish);

% 3.SAVE NEW MOVIE STRUCTURE: Save new registered movie, copying some references from the movie
% structure used to apply new changes in
VSDmov.ref = inputStruct.ref;
VSDmov.movieref= outputRef;
VSDmov.data = movies4D;
VSDmov.times = inputStruct.times;
VSDmov.hist = inputStruct.hist;
VSDmov.hist{1,size(inputStruct.hist,1)+1} = 'imregister trials'; %append a new cell with new info
ROSmapa('savemovie', VSDmov, VSDmov.movieref); 
clear inputStruct

%% 02 - DIFFERENTIAL VALUES

% 1. REFERENCES for input/output movies
inputRef =  '_01registered';
outputRef = '_02diff';

inputStruct = ROSmapa('loadmovie', nfish, inputRef);


% 2. PERFORM COMPUTATIONS: %DIFFERENTIAL VALUES

inputdata = inputStruct.data;

baseframe = 1:10; % @SET! idx of frames to use as F0 in differential formula
% Turn into string to save later in History:
    baseltext = strcat(num2str(baseframe(1)),'to',num2str(baseframe(end)));

% Preallocate in NaN 
diffmovie = NaN(size(inputdata));

for triali = VSDI.nonanidx
    inputmovie = squeeze(inputdata(:,:,:,triali));
    diffmovie(:,:,:,triali) = raw2diffperc2(inputmovie, baseframe); 
end
    
% 3.SAVE NEW MOVIE STRUCTURE:  copying some references from the movie
% structure used to apply new changes in
VSDmov.ref = inputStruct.ref;
VSDmov.movieref= outputRef;
VSDmov.data = diffmovie;
VSDmov.times = inputStruct.times;
VSDmov.hist = inputStruct.hist;
VSDmov.hist{1,size(inputStruct.hist,1)+1} = strcat('%diff basel idx=',baseltext); %append a new cell with new info
ROSmapa('savemovie', VSDmov, VSDmov.movieref); 

% SUGGESTION: if different F0 are ,keep the basic reference and add info about the F0, e.g. outputRef = '_02diffbase10';

%% 03 - MASKED MOVIES

% MAKE MASK FROM REFERENCE FRAME AND SAVE IN VSDI


