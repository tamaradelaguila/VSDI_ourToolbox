function plot_ERPs(waves,timebase, trials2plot,  roi2plot, labels, titletxt, stim_dur, custom_ylim)
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
if nargin ==8
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
end


end

%% Updated: 02/04/2021
%  02/04/2021: fixed 'roi' bug and custom_ylim added