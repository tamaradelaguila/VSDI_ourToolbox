function [] = plot_rejected (waves, trialidx, reject_idx, ylimi)
% 

% INPUT 
% 'waves' is a 2-dim array time*trials (eg : waves =
% VSDroiTS.filt306.data(:,roi,:);

% 'trialidx' - idx of trials to plot
% 'reject_idx' - idx to reject (can be from other waves not included in the
% trials to plot; onluy overlapping trials will be plotted)

outidx = intersect (trialidx, reject_idx);

figure
plot(waves(:,trialidx), 'color', [.6 .6 .6], 'linewidth', 0.5)
hold on

plot (waves(:,outidx ), 'color', [1, 0 , .2], 'linewidth', 1.5)


if exist('ylimi')
ylim(ylimi)
end

 
end