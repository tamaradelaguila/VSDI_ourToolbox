function [noise_thresh] = return_noisethresh(data, timebase, basel_ms, stdfactor)
% [noise_thresh] = return_noisethresh(data, timebase, basel_ms, stdfactor)

% INPUT
% 'data'. it can be a wave or a movie; noise_thresh will be a single value or an image accordingly
% timebase 

ndim = size(data);
if numel(ndim) == 3
    modo = 'movie';
elseif numel(ndim) == 2
    modo = 'wave';
end

%in case it is given in range, turn into 2 values
basel_ms = [basel_ms(1) basel_ms(end)];

% To dsearchn to work, set both to columns
timebase = makeCol(timebase);
basel_ms = makeCol(basel_ms);
%END OF INPUT CONTROL

baseidx = find_closest_timeidx(basel_ms, timebase);

switch modo
    case 'wave'
        baseline = data(baseidx(1):baseidx(2));
        noise_thresh.sup  = mean(baseline) + std(baseline)*stdfactor;
        noise_thresh.inf  = mean(baseline) - std(baseline)*stdfactor;
        
    case 'movie'
        baseline = data(:,:,baseidx(1):baseidx(2));
        noise_thresh.sup  = mean(baseline, 3) + std(baseline, [], 3)*stdfactor;
        noise_thresh.inf  = mean(baseline, 3) - std(baseline, [], 3)*stdfactor;
end

end

%% Created: 20/05/21 

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