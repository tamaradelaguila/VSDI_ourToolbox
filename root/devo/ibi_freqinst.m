%% COUNTING FUNCTION FROM 'spike' structure


trialidx = 20; 

spikes = spike.spikes;
matchidx = find([spike.match.BVtrialidx]==20)
find(arrayfun(@(spike.match.BVtrialidx) ismember(trialidx )))

% find stimulus onset (spike time + VSDI.info.Sonset/100; 
S = RO + Sonset; 

% FIRST ITI: idx1 - idx0
% get first beat before the onset (idx0): 
% first beat after postwindow: get time postw and closest beat after
% idx 1 find( > , 1, 'first')

% SECOND IBI: idx after 

% PRE-IBI (idx wise)
% idx-1 to idx0
% idx-1 to idx-2, etc

% inst frequency