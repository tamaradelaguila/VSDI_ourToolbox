
% path.rootpath = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\VSDI_ourToolbox\rootpath';
path.rootpath = pwd;
 temp.idcs   = strfind(path.rootpath,'\');
 temp.newdir = path.rootpath(1:temp.idcs(end-1));

path.data = fullfile(temp.newdir, 'ROSmapa_data');
path.list =fullfile(temp.newdir, 'BVdml');
path.list = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\BVdml';

clear temp

addpath(genpath(fullfile(path.rootpath, 'functions')));

