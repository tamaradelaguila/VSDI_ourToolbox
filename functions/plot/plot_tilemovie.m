function [] = plot_tilemovie(moviedata, times, tileset)
% [] = plot_tilemovie(moviedata, times, tileset)
% EXTRACT TILES FROM INPUT MOVIE 3D and  STRUCTURE THAT CONTAINS ALL THE SETTINGS

% INPUTS:
%       moviedata: 3D already-inverted data
%       times: timebase corresponding to the different frames (in ms)
%       tileset: structure with settings for tiling in fields: 
%           .start_ms = -300; % time in ms for first tile       
%           .end_ms = 2520;
%           .nrows = 6; 
%           .ncols = 8; 
%           .time2plot = 0; %select time (ms)
%           .x = 35; 
%           .y = 35; 
%           .clims = [] --- values above or below will be saturated
%           .thresh = [negthresh posthres]; --- values inside this range
%           will be zero-out

datatime = times; 
background = moviedata(:,:,end);
moviedata = moviedata(:,:,1:end-1);

% nº samples
starttime = tileset.start_ms;
endtime = tileset.end_ms;

% nº tiles
nrows = tileset.nrows;
ncols = tileset.ncols;
ntiles = nrows*ncols;

% color limit thresholds (eg: climsat =0.8)

% SET TIME AND PIXEL TO PLOT WAVE AND EXAMPLE OF IMAGE WITH COLORBAR
   time2plot = tileset.time2plot; %select time (ms)
   Xpix = tileset.x;
   Ypix = tileset.y;

% Obtain Time
tilestimes0 = linspace (starttime, endtime, ntiles); %ms included in the 
timeindx = NaN(size(tilestimes0));

for ii = 1:length(tilestimes0) % find indexes to localized the frames to tile
   [~, index] = min(abs(datatime - tilestimes0(ii))); % finds index closest to the time in ms 
   timeindx(ii) = index;
end

imtiles = moviedata(:,:, timeindx,: ); % movie of the selected frames

%% Get alphachannel to plot overlaid

imalpha = imtiles> tileset.thresh(1) & imtiles< tileset.thresh(2);

%% PLOT
    % find color limits from movie and threshold them
%     cmin = climsat*min(min(min(moviedata(:,:,1:end-2))));
%     cmax = climsat* max(max(max(moviedata(:,:,1:end-2))));
cmin = tileset.clims(1);
cmax = tileset.clims(2);
    figure
for ploti = 1: ntiles
    
   subplot(nrows, ncols, ploti)
   imagesc(imtiles(:,:,ploti))
   tit= strcat(num2str(datatime(timeindx(ploti))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none', 'clim', [cmin cmax])
   colormap(jet)
   
%    colormap jet
%    colormap('bluewhitered')
%    colorbar % unmute to check if they are all the same
   
end    

% SHOW ONE TILE WITH COLORBAR AND ONE POINT WAVE PREVIEW
figure

%find the frame to plot
   [~, index2] = min(abs(datatime - time2plot));
   timeindx = index2;

% plot
subplot(1,2,1)
imagesc(moviedata(:,:,timeindx))
hold on
scatter (Xpix, Ypix, 20, 'k', 'LineWidth', 1.5)
set(gca,'XColor', 'none','YColor','none', 'clim', [cmin cmax])
colormap(polarmap(jet))
colorbar
title(strcat(num2str(time2plot), 'ms'))
hold off

subplot(1,2,2)
plot (datatime, squeeze(moviedata(Xpix,Ypix,:)))

end

%% Created: 16/02/21 (from Gent1)