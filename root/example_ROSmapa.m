function [output] = ROSmapa(action, object, object_feature)
% PERFORMS BASIC LOAD/SAVE FUNCTIONS REFERENCE TO ROSmapa
% action = 'save' or 'load' or 'savemovie' or 'loadmovie'

% Input and output will depend on the case ('action')
% Use according to 'action':
%   [~]= ROSmapa('save', VSDI) or  ROSmapa('save', VSDI)-uses internal VSDI.ref to save in appropiate
%	.mat
%   [VSDI] = ROSmapa('load', nfish)
%  [~]= ROSmapa('savemovie', VSDmov, movierefernce) - uses moviereference
%  (~char) to name the matfile

%  [VSDmov]= ROSmapa('loadmovie', nfish, moviereference) - uses moviereference

datapath = 'C:\Users\User\Documents\Git\ROSmapa\data';

VSDIpath = fullfile(datapath,'dataVSDI');
moviepath = fullfile(datapath,'datamovies');
wavespath = fullfile(datapath,'datawaves');

expref = 'ROSmapa';

% Input control
switch action
    case 'save'
            if  ~isstruct(object) 
            disp('the input is not what expected'); end
    case 'load'
%         assert(mod(object, 1) == 0 && , 'input to load must be a single number');
        
        try
            load(fullfile(datapath, 'grouplist.mat'))
        catch 
            warning('fish cannot be load because "grouplist.mat" does not exist')
        end
        
     case 'savemovie'
            if ~exist('object_feature') 
                error('input a proper reference name for the movie (as 3rd argument)'); end
end % input control

%% FUNCTION CODE:

switch action
    case 'save'
        VSDI = object; 
        %saveVSDI saves current VSDI structure respect to the current rootpath
        pathname = fullfile(VSDIpath,[expref '_' num2str(object.ref) '.mat']);
        save(pathname, 'VSDI')

    case 'load'
        load(fullfile(datapath, 'grouplist')) %load structure list to take the fish reference
        load(fullfile(VSDIpath,[grouplist{object},'.mat'])) %load the fish VSDI
        disp(strcat (grouplist{object}, '_loaded'));
        output= VSDI;
        
    case 'savemovie' 
       VSDmov= object;
       %saveVSDI saves current VSDI structure respect to the current rootpath
       pathname = fullfile(moviepath,['ROSmapaMov_',num2str(VSDmov.ref),object_feature,'.mat']);
       save(pathname,'VSDmov', '-v7.3')

    case 'loadmovie' 
       load(fullfile(datapath, 'grouplist'))
       fishref = grouplist{object}(9:end);
       %saveVSDI saves current VSDI structure respect to the current rootpath
       movieref = [expref,'Mov_',fishref,object_feature,'.mat'];
       load(fullfile(moviepath,movieref))
       output= VSDmov;       
       disp([movieref, '_loaded']);

    case 'savewave'
        VSDroiTS = object; 
        %saveVSDI saves current VSDI structure respect to the current rootpath
        pathname = fullfile(wavespath,[expref 'RoiTS_' num2str(object.ref) '.mat']);
        save(pathname, 'VSDroiTS')

    case 'loadwave'
        load(fullfile(datapath, 'grouplist')) %load structure list to take the fish reference
        fishref = grouplist{object}(9:end);
        load(fullfile(wavespath,[expref 'RoiTS_',fishref,'.mat'])) %load the fish VSDI
        disp(strcat ('ROIs timeseries for fish',grouplist{object}, '_loaded'));
        output= VSDroiTS;

        
end %switch
end

% function T = isIntegerValue(X)
% T = (mod(X, 1) == 0);
% end

%% Created: 31/01/2021
% Updated: 08/02/21
