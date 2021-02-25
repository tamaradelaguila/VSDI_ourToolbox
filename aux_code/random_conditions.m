%% GENERATE RANDOM ORDER OF STIMULUS PRESENTATION
j= 0;
n_cond = 5; % 4 intensities + no-stimulus

for i = 1:n_cond
sample(j+1:9*i) = i-1;
j = j+9;
end

length(find(sample==0))

rand = randord(sample);
randsample = sample(randperm(length(sample))); 

