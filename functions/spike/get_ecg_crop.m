function [ecg_crop,tbase] = get_ecg_crop(timepoint, wind, ecg_values, ecg_timebase)
%% [ecg_crop,tbase] = get_ecg_crop(timepoint, wind, ecg_values, ecg_timebase) returns an ecg crop the length of the input window

t1 = timepoint - round(wind/2);  
t2 = timepoint + round(wind/2);

idx1 = find_closest_timeidx(t1, ecg_timebase);
idx2 = find_closest_timeidx(t2, ecg_timebase);

tbase = ecg_timebase(idx1:idx2); 
ecg_crop = ecg_values(idx1:idx2);

end

function [idx] = find_closest_timeidx (timepoint, alltimes)
%% find_closest_timeidx (timepoint, alltimes) finds the closest index corresponding to the value 'timepoint' in a vector 'alltimes',
...even if one or both are duration vectors


% timepoint = t1; 
% alltimes = times; 

if isduration (timepoint)
timepoint = seconds(timepoint); 
end

if isduration(alltimes)
    alltimes = seconds(alltimes);
end
difference = alltimes - timepoint; 

[~, idx] = min(abs(difference)); 

end

%% Created: 30/03/21