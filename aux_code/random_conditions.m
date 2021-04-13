%% GENERATE RANDOM ORDER OF STIMULUS PRESENTATION
j= 0;
n_cond = 4; % 3 intensities + no-stimulus

nrep= 40;

for i = 1:nrep
temp = 0:n_cond-1; temp = temp(randperm(n_cond, n_cond));
sample(j+1:n_cond*i) = temp;
j = j+n_cond;
end

sample = sample';
% length(find(sample==0))

% randsample = sample(randperm(length(sample))); 
% length(find(randsample==4))

% randsample = randsample';