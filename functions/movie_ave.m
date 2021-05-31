function [average] = movie_ave (movie, idx2ave)

average = mean(movie(:,:,1:end-1,idx2ave), 4);

end

%% Created: 23/02/21
% Updated: 18/05/21 (to exclude last frame = background)