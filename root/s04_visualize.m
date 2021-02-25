%% s04 VISUALIZE 
clear
user_settings
nfish = 1; %@ SET

VSDI = ROSmapa('load',nfish);

%% 1. WAVEPLOTS OF TRIALS for each roi
% Load data
VSDroiTS = ROSmapa('loadwave',nfish);
waves = VSDroiTS.diff02.data; %@ SET

% Make waveplots
titulo = strcat('fish',num2str(VSDroiTS.ref)); %@ SET
close all
plot_wavesplot(waves, VSDroiTS.roi.labels, titulo, VSDI.nonanidx, 2);

% Save and close
path2save = 'C:\Users\User\Documents\UGent_brugge\VSDI_tamaraToolbox\ROSmapa_plots\ejemplo_waveplots\' ; %@ SET
name2save = strcat('waveplot', num2str(VSDroiTS.ref));  %@ SET (if you want)

save_currentfig(path2save, name2save)

%% 2. ERPs

%@ SET: what to plot:
timeseries= VSDroiTS.diff02.data;
roi2plotidx = [1]; 
titletxt = strcat('#',num2str(VSDroiTS.ref));
trials2plot = VSDI.nonanidx; %@ SET 
% trials2plot = choosetrials(VSDI.condition, [1 2]);
stim_dur = 300; %ms

plot_ERPs(timeseries, VSDI.timebase,trials2plot, roi2plotidx , VSDroiTS.roi.labels, titletxt, stim_dur); 

%% 3. FRAME from movies

%@ SET...
    % ... what and how to plot
    movie_ref = '_04filt1'; % input movie
    frame2plot = 66; %idx
    trial2plot = 2; %idx
    act_clim= [-0.2 0.2]; %coloraxis of the shown colors
    % ...noise threshold settings
    baseline = 1:20; %range of frames to consider baseline (idx)
    SDfactor = 4;
    %...absolute threshold settings
    method = 'absvalue';
    value = 0.07;
% Load movie
VSDmov = ROSmapa('loadmovie',nfish,movie_ref);
movie = VSDmov.data(:,:,1:end-1,trial2plot); %movie to plot

%@ SET which threshold to use (and leave the other unmuted)
% NOISE THRESHOLD:
% [movie_thres, alphachan, ~] = movie_noisethresh(movie,baseline,SDfactor, 0); 

% ABSOLUTE THRESHOLD 
[movie_thres, alphachan] = movie_absthresh(movie,method,value); 
% NOTE_DEV: comprobar cómo tiene que ser alphachannel

% OVERLAID PLOT
background = VSDI.backgr(:,:,trial2plot);
% frame = movie(:,:,frame2plot);
frame = movie_thres(:,:,frame2plot);
framealpha = alphachan(:,:,frame2plot);

ax1 = subplot(1,1,1);
title(['']);
plot_framesoverlaid(frame,background, ~framealpha ,0, ax1, act_clim, 1); 
% imAct, imBack, logicalpha, plotnow, axH, act_clim, plot_cbar
ax1.XTick = []; ax1.YTick = [];

% DEV NOTE (still to do):  imlpement tiles function with the overimposed
% colors

%% 4 - TILES
    movie_ref = '_04filt1'; % input movie
    VSDmov = ROSmapa('loadmovie',nfish,movie_ref);

          tileset.start_ms = -100; % time in ms for first tile
          tileset.end_ms = 1000;
          tileset.nrows = 6; 
          tileset.ncols = 8; 
%           tileset.climsat = 0.8 ; %colormap limit would be the 80% of the max/min value
          tileset.clims = [0-0.9 0.9];
          tileset.thresh = [-0.5 0.5];
          tileset.time2plot = 0; %select time (ms)
          tileset.x = 35; 
          tileset.y = 35; 

     movie2plot = VSDmov.data(:,:,:,2); 
     plot_tilemovie(movie2plot, VSDI.timebase, tileset);
     
%% 5 - OVERLAID 12 TILES
    movie_ref = '_05filt1'; %@ SET input movie
    trial2plot = 16; %@ SET
    VSDmov = fertest('loadmovie',nfish,movie_ref);
    movie2plot = VSDmov.data(:,:,:,trial2plot); 
%     movie2plot = movie_ave(VSDmov.data, 1:16); % for average

          tileset.start_ms = -100; % time in ms for first tile
          tileset.end_ms = 1000;
%           tileset.clims = [-0.9 0.9];
%           tileset.thresh = [-0.1 0.1];
          tileset.clims = [-4 4]; %higher threshold for diff values
          tileset.thresh = [-1 1];

     plot_tilemovie12frames(movie2plot, VSDI.timebase, tileset);
