function [output, fig] = ana_erp_peak2peak(input)
%%  [p2p, peaklat, p2plat, vmax, fig] = ana_erp_peak2peak(input)
% the measures are returned in 'ms'
% if input various trialidx, then the measures are computed for the erp
% (the mean of all waves)

% INPUTS: 'input' structure with fields: 
    % 'data': 2D vector with the timeseries for all trials from one region.
    % E.g: data = TSroi.data(:,roi,:). Dimensions: timextrials
    % 'c_idx': indexes of the condition to consider
    % 'timebase' = (VSDI.timebase). Time in ms with zero in the stimulus
    % 'findwind_neg', 'findwind_pos': column vectors with the first and last
    % value of the time window from the timebase in which to find the peaks in ms
    % 'avew': values will be averaged in this window around the peak values
    % 'input.Sonset' - 
    % 'plot_on': if ==1, plotting trials, erp, and the window for analysis of
    % first(negative) and second (positive) peaks. 

% 'findwind_neg' and 'timebase' must have the reference. If VSDI.timebase
% is used (i.e., time zero-centered in the stimulus onset), then the window
% to find peaks should be given in the same scale (e.g. [0;600] ms)

% OUTPUTS: 
% 'p2p': average activity around max peak minus average activity around
% minimum value in the first window (single value)
% 'peaklat': latency of the max peak (single value)
% 'p2plat' : latency of the max peak respect to the minimumm peak(single
% value) in 
% 'vmax':
% 'onset_latency' - defined as the time to reach the 30% of the max
% amplitude-according to Liesefeld (2018)
% 'fig': if plot_on ==1


% (if plot_on ==1) fig: figure with alltrials waves + erp plot, indicating
% the window used to find the peaks in the analysis

%  DEBUG MODE
% input.data = squeeze(TSroi.datap6(:,roi,:));
% input.trialidx = find(VSDI.condition==2);
% input.timebase= VSDI.timebase; %ms
% input.findwind_neg =[  0;600 ]; %ms
% input.findwind_pos = [  600;1200 ]; %ms
% input.avew = 50; 
% input.plot_on = 1;
% input.Sonset = VSDI.info.Sonset; 

% GET timeserie matrix of the selected idx and erp
timeser = input.data(:,input.trialidx); 
erp = mean(timeser, 2); 

% ANALYSIS SETTINGS
% window in which to find the peaks translated into indexes
range_neg = dsearchn(input.timebase,input.findwind_neg); %find indexes corresponding to that window in ms
range_pos = dsearchn(input.timebase,input.findwind_pos);

% Average window 
avew = round(input.avew/2); %ms (half of the window)
    samplingtime = abs(input.timebase(2)-input.timebase(1));
avewidx = round(avew/input.samplingtime);  %indexes (n of samples)

movwin = 5; %n of timepoints taken for the sliding windows
%--------------------------------------
% ANALYSIS: FIND PEAK
%--------------------------------------

% % find minimum/maximum peak times (in idx).
% Option1: with min/max 
% [~,tmin] = min(erp(range_neg(1):range_neg(2)));
% [~,tmax] = max(erp(range_pos(1):range_pos(2)));


% Option2: with findpeaks 
% [~, tmax] = findpeaks(erp(range_pos(1):range_pos(2)), 'SortStr', 'descend');%, 'MinPeakProminence', 0.01); 
% [~, tmin] = findpeaks(-1*erp(range_neg(1):range_neg(2)), 'SortStr', 'descend');%, 'MinPeakProminence', 0.01); 
% plot(erp(range_neg(1):range_neg(2))); hold on; plot(-1*erp(range_neg(1):range_neg(2)))
% tmin = tmin(1)+range_neg(1)-1; %tmin(1) - we take the first value
% tmax = tmax(1)+range_pos(1)-1; %(tmin + range_neg(1)-1) gives the index respect to the whole timescale, and not to the window

% % Option3: with movsum 
movpos= movmean(erp(range_pos(1):range_pos(2)),movwin); 
[~,tmax] = max(movpos);
movneg = movmean(erp(range_neg(1):range_neg(2)),movwin); 
[~,tmin] = min(movneg);

% adjust local window idx to ERP timing in idx
tmax = tmax+range_pos(1)-1; %(tmin + range_neg(1)-1) gives the index respect to the whole timescale, and not to the window
tmin = tmin+range_neg(1)-1; %tmin(1) - we take the first value

% now find average values around the peak time
erpMin = mean( erp(tmin-avewidx:tmin+avewidx) ); % 
erpMax = mean( erp(tmax-avewidx:tmax+avewidx) );


% ERP timings in ms
tmin_ms = input.timebase (tmin);
tmax_ms = input.timebase (tmax); 


% 30%LATENCY define the window to find the time of the 30%amplitude latency between
% the tmin and tmax (in indexes) and then transform as well into ms
range_latency = [tmin tmax];
movlat = movmean(erp(range_latency(1):range_latency(2)),movwin);
%drag the wave into the positive values to avoid problems if the values are
%negative:
movlat_drag = movlat + abs(min(movlat));
erpMax_drag = erpMax +  abs(min(movlat));
t30 = find(movlat_drag > 0.3*erpMax_drag, 1, 'first');% 't30' is the time to reach the maximum level
t30 = t30 + range_latency(1)-1;

if isempty(t30); t30 = length(input.timebase);end %if there is no time in which the threshold is reach, we set it to the last frame

t30_ms = input.timebase (t30); 

% plot(erp); hold on; plot(-1*erp)

%--------------------------------------
% FIND Vmax
% in the whole window of analysis: [findwind_neg findwind_pos])
%--------------------------------------
% vpos = diff( erp(range_neg(1):range_pos(2)));
% mov_vpos = movmean(vpos,[2 2]); 
% [vmax,vmax_i] = max(mov_vpos);
% vmax_i = tmin+range_neg(1)-1; % re-reference to the whole vector

%--------------------------------------
% OUTPUT (peak-to-peak voltage and latency)
%--------------------------------------
output.peak = erpMax;
output.p2p = erpMax - erpMin; %unit of activity
output.p2plat = tmax_ms - tmin_ms; %ms (peak to peak lat)
output.peaklat = tmax_ms; %in ms
output.onset_latency = t30; %in ms

%--------------------------------------
% PLOT
%--------------------------------------
  fig = []; 

if input.plot_on ==1
    fig = figure;
  % plot ALL TRIALS

    plot(input.timebase, timeser); hold on
    ylim = get(gca,'ylim');
    %plot ERP
    ph = patch(input.timebase(range_neg([1 1 2 2])),ylim([1 2 2 1]),'b');
    set(ph,'facealpha',.3,'edgecolor','none')
    ph = patch(input.timebase(range_pos([1 1 2 2])),ylim([1 2 2 1]),'y');
    set(ph,'facealpha',.3,'edgecolor','none') %make them transparent without borders
    set(gca,'Children',flipud( get(gca,'Children') ))% move the patches to the background
    plot(input.timebase, erp, 'Linewidth', 1.4, 'Color', 'k')

    xline(tmin_ms, '--b')
    xline(t30_ms, '--k')
    xline(tmax_ms,'--r')
end


end

%% Updated : 30/10/20
