% if 'pwd' is used instead of manually adding the rootpath, user_settings
% has to be executed everytime from the rootpath folder (make sure that you
% are in the rootpath folder for your experiment everytime it's going to be
% called from inside a script)



% path.rootpath = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\VSDI_ourToolbox\rootpath';
path.rootpath = pwd; 
 temp.idcs   = strfind(path.rootpath,'\');
 temp.newdir = path.rootpath(1:temp.idcs(end));

path.data = fullfile(path.rootpath, 'data');
path.grouplist = fullfile(path.rootpath);
path.list =fullfile(path.rootpath, 'BVdml');


addpath(genpath(fullfile(temp.newdir, 'VSDI_ourToolbox', 'functions')));

clear temp
