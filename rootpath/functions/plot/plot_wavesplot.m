function [] = plot_wavesplot(waves, roilabels, txttitle, trials2plot, trials_inblock)
%  [] = plot_wavesplot(waves, roilabels, ref, trials2plot, trials_inblock) Makes waveplots with one line for each roi all roi of 'trials2plot', to trial inspection; each figure will have
% 'trials_inblock' number of trials.

% INPUT
% 'waves' data matrix of dimensions (time x roi x trials)
% 'roilabels' = cell with all labels in rows
% 'title' string
% 'trials2plot' - idx of trials to include
% 'trials_inblock' - number of trials per figure

% OUTPUT: wavesplot

% trials_inblock= 15; 
nblocks = ceil(length(trials2plot)/trials_inblock);
nroi=length(roilabels);

j = 1;
for i = 1:nblocks
if i < nblocks
blocks{i} = trials2plot(j:j+trials_inblock-1);
j = j+trials_inblock;
elseif i == nblocks %in the last one we don't know how many trials there are
blocks{i} = trials2plot(j:end);
end
end

% WAVE PLOT FOR EACH BLOCK OF TRIALS
for ii = 1:length(blocks)

% step1: apend into time dimension all trials in the block
channels = [];
% trial_flag = [];
j=1;

for trial_idx = blocks{ii}' 

channels = cat(1,channels,waves(:,:,trial_idx)); % channel-dim: (all-trial-times x roi)

% build vector for plotting trials' markers
ntime = size(waves,1);
trial_flag(j) =  j*ntime;
trial_label{j} = num2str(trial_idx);
j = j+1;
end

% step 2: plot block of concatenated trials
figure; hold on
yonset = 0; 
for roi_idx = 1:nroi 
yonset = yonset +.25;
plot(channels(:,roi_idx)+yonset);
end

% step 3: axis labelling
ymax = 0.25*nroi;
ylim([0,ymax+0.15])
yticks ([linspace(.25, ymax, nroi)]);
yticklabels (roilabels) 
xticks(trial_flag)
xticklabels (trial_label)
xlabel ('trial idx')
for ii= 1:length(trial_flag)
xline(trial_flag(ii))
end
hold off

title(txttitle)

end