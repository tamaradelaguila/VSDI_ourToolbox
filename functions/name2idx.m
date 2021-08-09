function [idx] =name2idx(name,namelist_cellS)

% INPUT
% 'roi_names' -
% OUTPUT
% 'roi_idx'


if ischar(name) || isstring(name)
    mode = 'single';
elseif length(name) > 1
    mode = 'multiple';
end

switch mode
    
    case 'single'
        for ii= 1:length(namelist_cellS)
            if strcmpi(namelist_cellS{ii},name)
                idx= ii;
            end
        end
        
        if ~exist('idx')
            disp('check the name of the roi')
        end
        
    case 'multiple'
        for nami = 1:length(name)
            tname = name{nami};
            
            for ii= 1:length(namelist_cellS)
                
                if strcmpi(namelist_cellS{ii},tname)
                    idx(nami)= ii;
                end
                
                checkerror(ii) =  strcmpi(namelist_cellS{ii},tname) ;
                
            end %ii
            
            % WRONG NAME CHECK
            if sum(checkerror) ==0
                error (['check the name of roi: ' tname])
            end
            %  END OF CONTROL
            
            
        end %nami
        
        
end % switch mode
end

%% Created: 26/05/21
% updated 24/06/21
% updated 27/07/21 - add multiple name arguments, 
