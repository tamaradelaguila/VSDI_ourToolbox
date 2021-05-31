%% aux_plot_tiles_brady_waves
... PLOT SINGLE TRIAL + BRADY

clear 
user_settings; 
% set(0,'DefaultFigureVisible','off')

for nfish = [1 5 7 11 13]
VSDI = TORus('load',nfish);
spike = TORus('loadspike', nfish);

% Load movie for tiles
movie_ref = '_06filt3'; % input movie
VSDmov = TORus('loadmovie',nfish,movie_ref);

% load waves to plot: 
VSDroiTS =TORus('loadwave',nfish)
roi2plotidx = [1 3 5 7 11];  %@ SET

%% 
for triali = 90%makeRow(VSDI.nonanidx) 

    figure
    trialref = VSDI.list(triali).Name(end-7:end-4);
    sgtitle([num2str(VSDI.ref) ': trial ' trialref '#' num2str(VSDI.list(triali).code) '(' num2str(VSDI.list(triali).mA) 'mA)'])

    absthres =  0.20;%@ SET threshold to zero-out the movie...;
    ylim_waves = [-0.1 0.6];%@ SET y-axis limits to plot waves
    act_clim= [-0.5 0.5];  %@ SET coloraxis of the shown colors

    %% 1. Plot ECG

    ax1 = subplot (4,4,1:2);
    %get values
    [ecg_crop,tbase] = get_ecg_crop(VSDI.spike.RO(triali), 30, spike.ecg, spike.ecg_timebase);
    plot(tbase, ecg_crop)
    ylim([-2.5 2.5]);
    xline(VSDI.spike.RO(triali)+VSDI.info.Sonset/1000,'--r', 'LineWidth',1.5);


    %% 2. PLOT WAVES

    ax2 = subplot (4,4,[3 4 7 8]);
    timeseries = VSDroiTS.filt306.data;
    titletxt = '(right hemisph)';
    stim_dur = VSDI.list(triali).Sdur;

    for i = 1:length(roi2plotidx)
        shownrois(i) = VSDI.roi.labels(roi2plotidx(i));
    end

    plot(VSDI.timebase, VSDroiTS.filt306.data(:,roi2plotidx,triali), 'Linewidth', 1.5);
    ylim(ylim_waves) 
    yline(absthres, '--k', 'Linewidth',0.8)
    legend([shownrois 'color thresh'])
    if VSDI.list(triali).mA ~=0 %if there is stimulus, plot
        xline(0, '--r', 'Linewidth',1.3); hold on
        xline(VSDI.info.Sdur(triali), '--r', 'Linewidth',1.3);
    end

    %% 3. Plot Tiles 
    movie = VSDmov.data(:,:,1:end-1,triali); %movie to plot

        % ... what and how to plot
        t2lpot = linspace(-10, 600, 10);

        idx2plot = find_closest_timeidx(t2lpot, VSDI.timebase);
        realt2plot = VSDI.timebase(idx2plot);
        % ...noise threshold settings
    %     baseline = 1:100; %range of frames to consider baseline (idx)
    %     SDfactor = 4;
        %...absolute threshold settings
        method = 'absvalue';


    % ABSOLUTE THRESHOLD 
    [movie_thres, alphachan] = movie_absthresh(movie,method,absthres);
        [movie_thres, alphachan] = movie_absthresh(movie,method,0.5);

    % NOTE_DEV: test how it has to be the alphachannel

    plotsites = [5 6 9 10 11 12 13 14 15 16]; 

    for ii= 1:length(idx2plot)
        ploti = plotsites(ii);
        % OVERLAID PLOT
        background = VSDI.backgr(:,:,triali);
        % frame = movie(:,:,frame2plot);
        frame = movie_thres(:,:,idx2plot(ii));
        framealpha = alphachan(:,:,idx2plot(ii));

        ax(ploti) = subplot(4,4,ploti);
        title([num2str(realt2plot(ii)) 'ms']);
        plot_framesoverlaid(frame,background, framealpha ,0, ax(ploti), act_clim, 1); 
        % imAct, imBack, logicalpha, plotnow, axH, act_clim, plot_cbar
        ax(ploti).XTick = []; ax(ploti).YTick = [];
    end

    pathsave = '/home/tamara/Documents/MATLAB/VSDI/TORus/plot/indiv_trials'; %@ SET
    trialref = num2str(VSDI.trialref(triali)); trialref = [trialref(end-2:end) 'A']; 
    name2save = fullfile(pathsave,[num2str(VSDI.ref) '_trial' trialref '.jpg'])
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 12 12])
    saveas(gcf,name2save,'jpg')
% 
%     close

end %trial
end %nfish
set(0,'DefaultFigureVisible','on')
