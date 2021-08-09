function [ADJmat] = PDCtoADJ(PDCmat, timeidx_range, freq_range)
% CONVERTS PARTIAL DIRECTED COHERENCE 4D MATRICES INTO ADJACENCY MATRIX
% SUMMING THE VALUES OF CERTAIN FREQUENCY AND TIME RANGE
% in ADJmat: rows = drivers; cols = receivers (contrary to the output from
% dynet_ar2pdc

% INPUT
% 'PDCmat'
% 'freq_range' = 1:83;
% 'timeidx_range' = 200:250; 
% 'srate' sampling rate to get the frequency spectrum used in the PDC and select
% the indexes accordingly

% OUTPUT
% 'ADJmat' - in which element (i,j) correcponds to the connectivity i-to-j
% (the reverse of the PDC convention)

% PDCmat = sk_PDCc2; 
% freq_range = 1:83; 
% timeidx_range = 200:250; 
% srate = 166.66;

nsize = size(PDCmat,1); % in PDC: receivers
msize = size(PDCmat,2); % in PDC: drivers

for n = 1:nsize
    for m = 1:msize
        if n~=m
            temp = squeeze(PDCmat(n,m,freq_range,timeidx_range));           
ADJmat(m,n) = sum(temp,'all'); % order reversed to (drivers, receivers)
        end 
    end %m
end %n

end