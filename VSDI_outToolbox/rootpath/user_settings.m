% 
% path.rootpath = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\VSDI_ourToolbox\rootpath';
% path.data = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\ROSmapa_data';
% path.list = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\BVdml';
% 
% addpath(genpath(fullfile(path.rootpath, 'functions')));


% path.rootpath = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\VSDI_ourToolbox\rootpath';
path.rootpath = pwd;
 temp.idcs   = strfind(path.rootpath,'\');
 temp.newdir = path.rootpath(1:temp.idcs(end-1));

path.data = fullfile(temp.newdir, 'ROSmapa_data');
path.list =fullfile(temp.newdir, 'BVdml');
path.grouplist = fullfile(temp.newdir, 'ROSmapa_data');

clear temp

addpath(genpath(fullfile(path.rootpath, 'functions')));


