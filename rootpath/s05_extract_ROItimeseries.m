%% s05 EXTRACT ROI timeseries
clear

user_settings
nfish= 1;

VSDI = ROSmapa('load',nfish);
VSDroiTS = ROSmapa('loadwave',nfish);

%% CREATE STRUCTURES FROM SELECTED MOVIES

% 1. REFERENCES for input movies/output waves (see 'z_notes.txt', point 5 for
% complete list)
inputRef =  '_02diff'; 
fieldref = strcat(inputRef(4:end),inputRef(2:3)); 

%load input movie 
[inputStruct] = ROSmapa('loadmovie',nfish,inputRef); 
movies=inputStruct.data;

% 2. PERFORM COMPUTATIONS:  EXTRACT WAVES 
nroi =length(VSDroiTS.roi.labels);
allroi_waves = NaN(length(VSDI.timebase), nroi, VSDI.nonanidx(end)); 

for triali = makeRow(VSDI.nonanidx)
    movietrial = movies(:,:,:,triali);
    for roii = 1:nroi
        roimask = VSDroiTS.roi.manual_mask(:,:,roii);
        allroi_waves(:,roii,triali) = roi_TSave(movietrial,roimask);
    end
end

% 3.SAVE in TS STRUCTURE: Save waves (VSDroiTS) structure copying some references from the movie
% structure used to apply new changes in
VSDroiTS.(fieldref).data= allroi_waves;
VSDroiTS.(fieldref).times = inputStruct.times;
VSDroiTS.(fieldref).hist = inputStruct.hist;
ROSmapa('savewave', VSDroiTS, VSDroiTS.ref); 
clear inputStruct