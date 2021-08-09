function [maxval,minval] = get_maxnonzeromin(data)

maxval=max(data,[],'all');
tmp = data(:); tmp(~tmp) = inf; % replace any zeros w/ inf to calculate nonzero min
minval=min(tmp);
end