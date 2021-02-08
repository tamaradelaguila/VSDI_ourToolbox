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
    movie_ref = '_03crop'; % input movie
    frame2plot = 200; 
    trial2plot = 2;
    act_clim= [-0.2 0.2]; %coloraxis of the shown colors
    % ...noise threshold settings
    baseline = 1:20; %range of frames to consider baseline (idx)
    SDfactor = 4;

% Load movie
VSDmov = ROSmapa('loadmovie',nfish,movie_ref);
movie = VSDmov.data(:,:,1:end-1,trial2plot); %movie to plot

% NOISE THRESHOLD:
[movie_thres, alphachan, ~] = movie_noisethresh(movie,baseline,SDfactor, 0); 

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
