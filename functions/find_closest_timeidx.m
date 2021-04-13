function [idx] = find_closest_timeidx (timepoint, alltimes)
%% find_closest_timeidx (timepoint, alltimes) finds the closest index corresponding to the value 'timepoint' in a vector 'alltimes',
...even if one or both are duration vectors
    
% INPUT 
% 'timepoint' - can be a value or a vector
% ' alltimes'

% OUTPUT
% 'idx' - index from alltimes that closest match to the input timepoint


if length(timepoint) ==1
    mode = 'single'; 
elseif length(timepoint) > 1
    mode = 'mult';
end
    
    
% timepoint = t1; 
% alltimes = times; 
switch mode
    case 'single'
        if isduration (timepoint)
        timepoint = seconds(timepoint); 
        end

        if isduration(alltimes)
            alltimes = seconds(alltimes);
        end
        difference = alltimes - timepoint; 

        [~, idx] = min(abs(difference)); 
        
    case 'mult'
        for ii = 1:length(timepoint)
            
            singlet = timepoint(ii);
            if isduration (singlet)
                singlet = seconds(singlet); 
            end

            if isduration(alltimes)
                alltimes = seconds(alltimes);
            end
            
            difference = alltimes - singlet; 
            [~, idx(ii)] = min(abs(difference)); 
            clear difference  singlet
        end
        
end
end

%% Created: 30/03/21