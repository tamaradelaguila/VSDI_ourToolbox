function [idx] =name2idx(name,namelist_cellS)

% INPUT
% 'roi_names' - 
% OUTPUT
% 'roi_idx'

for ii= 1:length(namelist_cellS) 
    if strcmpi(namelist_cellS{ii},name)
        idx= ii;
    end
    
    if ~exist('idx') 
       display('check the name of the roi') 
    end
end
end

%% Created: 26/05/21
