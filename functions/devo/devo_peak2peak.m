function [output , fig] = devo_peak2peak(wave, timebase, wind, noise, method, plot_on, flag_on)
%%  [output , fig] = devo_peak2peak(wave, timebase, wind, noise, method, plot_on, flag_on)
% the measures are returned in 'ms'


% INPUTS: 'input' structure with fields:
% 'wave':  vector with one wave (timeserie)
% 'timebase' = (VSDI.timebase). Time in ms with zero in the stimulus onset
% 'wind' structure with fields:
% 'wind.min', 'wind.max':  vectors with the windows in which to find the
% minimum and maximum peak respectively
% 'wind.movsum' = window that will be used as sliding window to get the
% cummulative values (in method 'movsum'), and that will be used  to calculate the averaged peakvalue (in all
% methods)
% 'wind.baseline' to calculate peak_minus_base
% 'wind.slope' - use to calculate slope_max
% 'wind.wmean' - to get mean activity from
% 'method': 'movsum' or 'peakfind', depending on the function used to
% find the peaks. Movsum is set as the default
% 'plot_on'
% 'flags_on' - whether printing the advises

% If VSDI.timebase
% is used (i.e., time zero-centered in the stimulus onset), then the window
% to find peaks should be given in the same scale (e.g. [0;600] ms)


% OUTPUTS:
%'peakidx' = [tmin tmax] : indexes of the min value in wind.min and max
...value in wind.max
    %'p2p_value': average activity around max peak in wind.max minus average activity around
...minimum value in wind.min (single value)
    %'peakminusbasel': average activity around max peak in wind.max minus mean
...activity in baseline.
    ... no baseline is provided, a windowo of 100ms pre-stimulus is set.
    ... average activity in wind.baseline
    % 'peaklat_ms': latency of the max peak respect the stimulus onset (timebase = 0) (single value)
% 'p2plat_ms' : latency of the max peak respect to the minimumm peak(single
... value) in ms
    % 'onset30_latency_ms' - defined as the time (ms) to reach the 30% of the max
... amplitude-according to Liesefeld (2018)
    % 'output.onsetnoise_ms'-
% 'output.noisethresh' - %threshold used
% 'output.slopemax
% 'wmean' - mean in window

% (if plot_on ==1) fig: figure of wave indicating
% the window used to find the peaks in the analysis

%--------------------------------------
%  DEBUG MODE
%--------------------------------------

% wave = squeeze(VSDroiTS.filt306.data(:,3,VSDI.nonanidx(1)));
% timebase= VSDI.timebase; %ms
% wind.min =[  -100 100 ]; %ms
% wind.max = [  0 600 ]; %ms
% wind.movsum = 50; %in ms
% wind.baseline = [-300 0]; %in ms
% wind.slope = 50; %in ms

% noise.fr_abovenoise = 20; %number of frames above noise to be considered signal (!!!)
% noise.SDfactor = 4;
% method = 'movsum'; % 'movsum' 'findpeaks'
% plot_on = 1;


%%
%--------------------------------------
% INPUT CONTROL and DEFAULT VALUES
%--------------------------------------


if ~exist('method') || isempty('method')
    method = 'movsum';
end

if ~exist('plot_on') || isempty('plot_on')
    plot_on = 0;
end


if ~exist('flag_on') || isempty('flag_on')
    flag_on = 1;
end


if ~isfield(wind, 'baseline')
    wind.baseline = [-100 0];
    if flag_on
        display(['DEFAULT baseline set at:' num2str(wind.baseline)]);
    end
end

if ~isfield(noise, 'fr_abovenoise')
    noise.fr_abovenoise = 20;
    if flag_on
        display(['DEFAULT fr_abovenoise  set at:' num2str(noise.fr_abovenoise)]);
    end
end

if ~isfield(noise, 'SDfactor')
    noise.SDfactor = 4;
    if flag_on
        display(['DEFAULT noise SD factor set at:' num2str(noise.SDfactor)]);
    end
end



% Turn window vectors into columns so  dsearchn works without a problem
wind.min = makeCol(wind.min);
wind.max = makeCol(wind.max);
timebase = makeCol(timebase);

% END OF INPUT CONTROL
%--------------------------------------

% ANALYSIS SETTINGS
% window in which to find the peaks translated into indexes
range_min = dsearchn(timebase,wind.min); %find indexes corresponding to that window in ms
range_max = dsearchn(timebase,wind.max);

% actual window in ms (to later plot)
range_min_ms = timebase(range_min);
range_max_ms = timebase(range_max);

% Average window
samplingtime = abs(timebase(2)-timebase(1));
movwin = floor(wind.movsum/samplingtime);  %n of samples (of idx) to be taken for the sliding window
movwin_h = round(movwin/2); %half window

movave = floor(wind.slope/samplingtime);  %n of samples (of idx) to be taken for the sliding window

%--------------------------------------
% FIND PEAKS
%--------------------------------------

switch method
    
    case 'movsum' %default
        % With movsum
        movmax= movmean(wave(range_max(1):range_max(2)), movwin);
        [~,tmax] = max(movmax);
        movmin = movmean(wave(range_min(1):range_min(2)),movwin);
        [~,tmin] = min(movmin);
        
    case 'findpeaks'
        % With findpeaks
        [~, tmax] = findpeaks(wave(range_max(1):range_max(2)), 'SortStr', 'descend');%, 'MinPeakProminence', 0.01);
        [~, tmin] = findpeaks(-1*wave(range_min(1):range_min(2)), 'SortStr', 'descend');%, 'MinPeakProminence', 0.01);
        %         [~, tmin] = findpeaks(-1*wave(range_min(1):range_min(2)), 'SortStr', 'descend');%, 'MinPeakProminence', 0.01);
        tmax = tmax(1);
        tmin = tmin(1);
        
        
end

% adjust local window idx to WAVE timing in idx
tmax = tmax+range_max(1)-1; %(tmin + range_neg(1)-1) gives the index respect to the whole timescale, and not to the window
tmin = tmin+range_min(1)-1; %tmin(1) - we take the first value

%--------------------------------------
% % ARTIFACTS DETECTION: if the wave has a trend in the first window
% (wind.min), take the value at timebase = 0
% It only affects the min peak value, and so peak to peak measures
if strcmpi(method, 'movsum')
    if  min(movmin) == movmin(1)
        tmin = dsearchn(timebase,0);
    end
end

%--------------------------------------
% ARTIFACT DETECTION IN PEAK FINDING 
if tmax<= tmin+1 
    flag_nopeak = 1; %flag to control for artifacts (in slope, for instance, we need at least 3 points to get a measure)
    tmax = tmin+2;
    if flag_on
        disp('max-peak was found to happen before min-peak, so it was forced to be in tmin+2 frame');
    end
else
    flag_nopeak = 0;
    
end

% CONVERT times to ms
tmin_ms =timebase (tmin);
tmax_ms = timebase (tmax);


%--------------------------------------
% % PEAK-TO-PEAK MEASURES
%--------------------------------------

%  average values around the peak time
valueMin = mean( wave(tmin-movwin_h:tmin+movwin_h) );
valueMax = mean( wave(tmax-movwin_h:tmax+movwin_h) );

output.peakidx = [tmin tmax];
output.peak_ms = [tmin_ms tmax_ms];

output.peaklat_ms = tmax_ms; %in ms

output.p2p_value = valueMax - valueMin; %unit of activity
output.p2plat_ms = tmax_ms - tmin_ms; %ms (peak to peak lat)


%--------------------------------------
% % PEAK MINUS BASELINE
%--------------------------------------
b1 = dsearchn(timebase,wind.baseline(1));
b2 = dsearchn(timebase,wind.baseline(end));

output.peakminusbasel = valueMax - mean(wave(b1:b2));

%--------------------------------------
% % MAX SLOPE
%--------------------------------------

idx0 = dsearchn(timebase,0);

    wavepost = wave(idx0:tmax); %slope max in a window from stimulus onset until the peak; if the tmax = 0
    diffwave = diff(wavepost);

if numel(diffwave)<  movave/2 %if the distance between 0 and tmax is not the half of the window for averaging, discard with NaN
    output.slopemax = 0; %change to NaN and manage into code
else
    output.slopemax = max(movmean(diffwave, movave)); %it uses 'movwin', that is, the same precision as the peak-finder part of the function
end
%--------------------------------------
% % ONSET_NOISE: MS TO REACH NOISE-THRESHOLD
%--------------------------------------

noiseSD = std(wave(b1:b2));
noisemean = mean(wave(b1:b2));

idx0 = dsearchn(timebase,0);

wavepost = wave(idx0+1:end);
%         wavepost=wavepost-noisemean; % y-shifting the signal allows to threshold directly with the SD
above = wavepost>=noisemean + noise.SDfactor*noiseSD;

abovewin = noise.fr_abovenoise; % lower limit of nºof frames that have to be above threshold to be considered...

crossidx = find(movsum(above, abovewin)==abovewin, 1, 'first'); ...for that we make a sliding window and find the first windows in which all values are 1
    crossidx = crossidx-round(abovewin/2); %we take the first idx of that window  (it's 'wavepost-referenced)

output.onsetnoise_ms = timebase(idx0 + crossidx); %time at which it stays above threshold for'abovewin' nºof frames (in 'wave' reference)
output.noisethresh = noisemean + noise.SDfactor.*noiseSD; %threshold used

if isequal(output.onsetnoise_ms, []) | isempty(output.onsetnoise_ms)
    output.onsetnoise_ms = timebase(end);
end

%--------------------------------------
% 30% ONSET LATENCY
%--------------------------------------

%  define the window to find the time of the 30%amplitude latency between
% the tmin and tmax (in indexes) and then transform as well into ms
range_latency = [tmin tmax];
movlat = movmean(wave(range_latency(1):range_latency(2)),movwin);

%drag the wave into the positive values to avoid confusion if the values are
%negative:
movlat_drag = movlat + abs(min(movlat));
threshval = valueMin + 0.3*(valueMax - valueMin); %threshold value that correponds to the reach of 30% of the peak2peak value
threshval_drag = threshval +  abs(min(movlat));
t30 = find(movlat_drag >  threshval_drag, 1, 'first');% 't30' is the time to reach the maximum level
t30 = t30 + range_latency(1)-1; % turn local index into wave-referenced

% if isempty(t30); t30 = length(timebase);end %if there is no time in which the threshold is reach, we set it to the last frame

t30_ms = timebase(t30);

if isempty(t30_ms)
    output.onset30_latency_ms = NaN; %in ms
else
    output.onset30_latency_ms = t30_ms; %in ms
end

%--------------------------------------
% FIND Vmax
% in the whole window of analysis: [wind.min wind.max])
%--------------------------------------
% vpos = diff( erp(range_neg(1):range_pos(2)));
% mov_vpos = movmean(vpos,[2 2]);
% [vmax,vmax_i] = max(mov_vpos);
% vmax_i = tmin+range_neg(1)-1; % re-reference to the whole vector

%--------------------------------------
% WINDOWED MEAN (mean in window minus mean of the baseline)
%--------------------------------------
    l1= dsearchn(timebase,wind.wmean(1)); 
    l2 = dsearchn(timebase,wind.wmean(end));
    output.wmean = mean(wave(l1:l2))- mean(wave(b1:b2)); %mean minus baseline
    clear l1 l2

%.................................................
%.................................................
% PLOT
%.................................................
%.................................................

fig = [];

ylim = [min(wave) max(wave)];

if plot_on
    fig = figure;
    hold on
    ph = patch(range_min_ms([1 1 2 2]),ylim([1 2 2 1]),'b');
    set(ph,'facealpha',.3,'edgecolor','none')
    ph = patch(range_max_ms([1 1 2 2]),ylim([1 2 2 1]),'y');
    set(ph,'facealpha',.3,'edgecolor','none') %make them transparent without borders
    set(gca,'Children',flipud(get(gca,'Children') ))% move the patches to the background
    plot(timebase, wave, 'Linewidth', 1.4, 'Color', 'k')
    
    xline(tmin_ms, '--b');
    xline(tmax_ms,'--r');
    
    if ~isempty(t30_ms)
        xline(t30_ms, '--g');
        legend wind1 wind2 data minPeak maxPeak '30% onset lat'
    else
        legend wind1 wind2 data min_peak max_peak
        
    end
    
    
    
    legend('location','southeast')
    hold off
    
end



end

%% Created 18/05/2021 (from Ugent ana_erps_peak2peak.m)
% Updated: 01/06/21 
% Updated: 30/07/21 - include 'wmean' output