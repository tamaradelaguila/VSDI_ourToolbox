function plot_ERPs_plusroi(waves,timebase, trials2plot,  roi2plot, labels, titletxt, stim_dur, background, roi_poly, custom_ylim)
% plot_ERPs(waves,timebase, trials2plot,  roi2plot, labels, titletxt, stim_dur)

% INPUT
% waves = waves;
% labels = VSDroiTS.roi.labels;
% trials2plot = VSDI.nonanidx;
% roi2plot = [1,5];
% timebase = VSDI.timebase;
% titletxt = 'titulo';
%'stim_dur' : in ms
% 'ylim: [y1 y2]
% 'background' : image to plot the rois
% roi_poly: column cell structure with roi polygons coordinates inside each
% cell (also in 2 columns) 

if nargin ==10
    cust_y = 1;
else 
    cust_y =0;
end
%end of input control

nroi = length(roi2plot);

for ii = 1:nroi

figure 
roi = roi2plot(ii); % Fixed bug

select2plot = squeeze(waves(:,roi,trials2plot));


% plot ALL TRIALS
subplot(3,4, [1 2 3 5 6 7 9 10 11])
% subplot(1,3, 1:2)

plot(timebase, select2plot); hold on

%plot mean
plot(timebase, mean(select2plot,2, 'omitnan'), 'Linewidth', 1.4, 'Color', '#292924')

sgtitle(strcat(titletxt,'.',labels{roi})) ; 
% plot settings
% ylim([ymin ymax])
xline(0, '--'); xline(stim_dur, '--'); 
xlabel('Time')
ylabel('% \Delta F') % note that matlab interprets "\mu" as the Greek character for micro

if cust_y
    ylim(custom_ylim)
end

subplot(3,4,4)
% subplot(1,3,3)
imagesc(background); colormap('bone'); hold on
coord = roi_poly{ii,:};
fill(coord(:,1), coord(:,2), [1 .3 .3]); hold on
plot(coord(:,1), coord(:,2), 'color',[1 0 0], 'LineWidth', 1.5); 


axis image

end %roi


end

%% Updated: 02/04/2021
%  02/04/2021: fixed 'roi' bug and custom_ylim added