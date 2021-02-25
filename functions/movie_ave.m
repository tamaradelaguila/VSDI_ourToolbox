function [average] = movie_ave (movie, idx2ave)

average = mean(movie(:,:,:,idx2ave), 4);

end

%% Created: 23/02/21