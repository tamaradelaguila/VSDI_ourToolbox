%% PREPARATORY STEPS

% ROOT FOLDER content: 
% pipeline files, 'savecode'
% 'functions' folder
% 'data_structures' folder - for VSDI structures, struct_list
% 'data_bigstructures' folder -for movies and big mat files
% 'plots' folder

%load prespecify settings (change rootpath for each computer)
user_settings

%% 1. CREATE LIST OF FISH
% It will be needed for looping across fish
% It has to match the name of the .mat that cointain the 

grouplist{1} = 'ROSmapa_200611' ;
grouplist{} = '';

save(fullfile(rootpath,'grouplist.mat'),'grouplist');


%% 2. CREATE VSDI structure (FOR EACH FISH) 
VSDI.ref = 200611 ;
VSDI.info.stime = 6; %ms (sampling time)

% IMPORT LIST. Have to be saved from Brainvision. See notes for details 
listpath =  'C:\Users\User\Documents\UGent_brugge\lab_maps\BVdml'; %set
listpath = fullfile(listpath,strcat('filelist',num2str(VSDI.ref),'.csv'));

list_table=  readtable(listpath);
VSDI.list = table2struct(list_table);
for triali = 1:length(VSDI.list)
VSDI.trialref(triali,1) = str2num(VSDI.list(triali).Name(1:end-5)); %save references for the trials
end
ROSmapa('save',VSDI);

% ADD MANUALLY THE CONDITION FOR EACH TRIAL (in new fields -name them to be able to copy them)...
% Non-included trials: NaN

%AND THEN COPY IT INTO A NEW 'condition' FIELD
for triali = 1:length(VSDI.list)
VSDI.condition(triali,1) = VSDI.list(triali).c1; %set the name of the field so it c an be c opied
VSDI.condition(triali,2) = VSDI.list(triali).c2;
end

VSDI.nonanidx= find(~isnan(VSDI.condition(:,1))) ;

VSDI.info.Sonset = 300; % ms (from start of recording)
VSDI.info.Sdur = []; % ms(duration of stimulus)

% Save changes
ROSmapa('save',VSDI);

% test saving
clear
[VSDI] = ROSmapa('load',1);

