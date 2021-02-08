function [idx] = choose_condidx(cond_matrix, cond2find)
% [idx] = choose_condidx(cond_matrix, find_cond) outputs trials idx from the
% chosen condition

% INPUT: 
% 'cond_matrix'
% 'find_cond'
%OUTPUT: 'idx' of the rows that coindice with 'cond2find'

idx = [];
for rowi =1:length(cond_matrix)
   if cond_matrix(rowi,:) == cond2find
       idx = [idx rowi];
   end
end

end

%% Created: 07/02/21
% Updated: