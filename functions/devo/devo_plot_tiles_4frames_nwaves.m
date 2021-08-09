function [] = devo_plot_tiles_4frames_nwaves(movieset, tileset, waveset)
% [] = plot_tilemovie(moviedata, times, tileset, custom_map, npoints, r)% IT plots 4 tiles and asks for npoints to plot

%% INPUTS:
%       'movieset': structure with fiels:
%           .moviedata: 3D already-inverted data
%           .times: timebase corresponding to the different frames (in ms)
%           .backgr = VSDI.backgr(:,:,VSDI.nonanidx(1)) - when
%           present, this would be the plotted as a backgr instead of
%           the last movie frame

%       'tileset': structure with settings for tiling in fields:
%           .start_ms = -300; % time in ms for first tile
%           .end_ms = 2520;
%           .time2plot = 0; %select time (ms)
%           .clims = [] --- values above or below will be saturated
%           .thresh = [negthresh posthres]; --- values inside this range
%           will be zero-out
%           . custom_map


% Input control
if isfield(tileset, 'custom_map')
    custom_map = tileset.custom_map;
else
    custom_map = colormap_loadBV();
end

if isfield(movieset, 'backgr')
    backgr= movieset.backgr;
else
    backgr = movieset.moviedata(:,:,end);
end

% End of input control

% GET VARIABLES FROM STRUCTURE (for code simplicity)
moviedata = movieset.moviedata;
times= movieset.times;

datatime = times;
moviedata = moviedata(:,:,1:end-1);

coord = waveset.coord;
r= waveset.r;
npoints = size(coord,1);


% n� samples
starttime = tileset.start_ms;
endtime = tileset.end_ms;

% n� tiles
ntiles = 4;

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
imalpha = ~imalpha;
%% PLOT
nrows = 1;
ncols = 5;

xdim = size(backgr,1);
ydim = size(backgr,2);

pointcolors = lines(npoints); %

figure

%Plot the circles in the first frame
i = 1;
ax(1) = subplot(nrows, ncols, i);
plot_framesoverlaid(imtiles(:,:,i),backgr, imalpha(:,:,i) ,0, ax(i), tileset.clims, 0, tileset.thresh, custom_map);
tit= strcat(num2str(datatime(timeindx(i))), 'ms');
title(tit, 'fontsize', 6)
set(gca,'XColor', 'none','YColor','none')
ax(i).Title.String = tit;
axis image

set(ax(i),'visible', 'off'); %set the axis invisible (the white square behind)
set(findall(gca, 'type', 'text'), 'visible', 'on') %keeps the title visible


for ii = 1 :npoints
    drawncircle = drawcircle('Center', coord(ii,:), 'Radius', r,  'InteractionsAllowed', 'none','LineWidth', 1.5, 'color',pointcolors(ii,:) );
    mask(ii,:,:) = createMask(drawncircle,xdim,ydim);
    %     viscircles(coord(ii,:),r, 'color',pointcolors(ii,:));
end %ii


for i = 2:4
    ax(i) = subplot(nrows, ncols, i);
    %    imagesc(imtiles(:,:,ploti))
    plot_framesoverlaid(imtiles(:,:,i),backgr, imalpha(:,:,i) ,0, ax(i), tileset.clims, 0, tileset.thresh, custom_map);
    tit= strcat(num2str(datatime(timeindx(i))), 'ms');
    title(tit, 'fontsize', 6)
    set(gca,'XColor', 'none','YColor','none')
    ax(i).Title.String = tit;
    axis image
    set(ax(i),'visible', 'off'); %set the axis invisible (the white square behind)
    set(findall(gca, 'type', 'text'), 'visible', 'on') %keeps the title visible
  
end

% TO-DO
% ASSIGN COLORLIMITS TO THE AXIS TO PLOT THE COLORBAR (this won't affect
% the true colors shown because they are computed inside the function)

% Set colormap and color limits for all subplots
% assign color bar to one tile 
% cbh = colorbar(ax(end)); 
% set(ax, 'Colormap', custom_map, 'CLim', tileset.clims)
% set(cbh, 'colormap', custom_map, 'clims', tileset.clims);
% % To position the colorbar as a global colorbar representing
% % all tiles, 
% cbh.Layout.Tile = 'south'; 


% DRAW POINTS AND GET MASK FOR THE NEXT STEP

% EXTRACT WAVE AND PLOT IN TH ELAST AXIS
ax(5) = subplot(nrows, ncols, 5);
hold on

for nwave = 1:npoints
    roimask = squeeze(mask(nwave,:,:));
    wave  = roi_TSave(moviedata,roimask);
    wavemax(nwave) = max(wave);
    plot(times(2:end), wave, 'color', pointcolors(nwave,:), 'linewidth', 1.5);
    clear wave roimask
end


pbaspect([ydim xdim 1]) %fit the proportions of the plot to the image ratio
    yl = ylim;
    down= yl(1); up=yl(2); 
    patch ([starttime endtime, endtime, starttime],[down down up up],'k','FaceAlpha',.3, 'LineStyle', 'none')
    xlim(waveset.xlim)


end

%% Created:24/07/21 (from function plot_tilemovie12frames)

%% AUXILIARY FUNCTION
function [outwave] = roi_TSave(Y,roimask)
% [outwave] = roi_TSaverage(Y,roimask). Extracts timeserie of the input
% movie (excluding last frame, in case that the backgr was included)

% INPUT: 'Y' 3D data matrix (movie: x*y*frames); 'roimask', 2D logic;

% OUTPUT: 'wave' of the ROI timeserie, that is the average value of all the pixels
% in the ROI (roimask)

Nframes= size(Y,3)-1; % substract last frame
outwave = zeros(1, Nframes); % vector of length the n� of frames in data (Y)

for frame=1:Nframes
    
    ROIvalues = Y(:,:,frame).*roimask;
    ROIvalues = fillmissing(ROIvalues,'constant', 0);
    outwave(frame) = sum(ROIvalues(:))/sum(roimask(:)); %sum(ROImask) gives the number of pixels included in the ROI
end

end

%% AUXILIARY FUNCTION
function  plot_framesoverlaid(imAct, imBack, logicalpha, plotnow, axH, act_clim, plot_cbar, thresh, custom_map)
% INPUT
% 'imAct' - image to display in colors
% 'imBack' - backgr image
% 'logicalpha': logic matrix with transparency information (1 = shown pixel)
% 'plotnow': whether we want to plot the figure (set to 0 if we are providing a axisHandle)
% 'axH': axes handle in which to plot it, when it's going to be included into a subplot
% 'act_clim': color limits for 'imAct'. If no color limits is provided for the activity (color) map, use the max
% and min from the input movie
% 'plot_cbar' : whether we want to plot the colorbar (useful in subplots)


if ~exist('act_clim')
    act_clim = [min(nonzeros(imAct(:))) max(nonzeros(imAct(:)))];
elseif isempty(act_clim)
    act_clim = [min(nonzeros(imAct(:))) max(nonzeros(imAct(:)))];
end

% if ~exist('thresh')
%     thresh = 0;
% elseif isempty(thresh)
%         thresh = 0;
% end

if ~exist('plotnow')
    plotnow= 1;
elseif isempty(plotnow)
    plotnow= 1;
end

if ~exist('plot_cbar')
    plot_cbar= 1;
elseif isempty(plot_cbar)
    plot_cbar= 1;
end


if ~exist('custom_map')
    colormode= 0;
elseif isempty(custom_map)
    colormode= 0;
else
    colormode = 1;
end

% end of input control ------------------------
if plotnow
    fig1 = figure;
end

thresh_polarmap = min(abs(thresh));

ax1 = axes;
imagesc(imBack);
colormap(ax1,'bone');
ax1.Visible = 'off';
axis image

ax2 = axes;
% imagesc(ax2,imAct,'alphadata',imAct>thresh);
imagesc(ax2,imAct,'alphadata',logicalpha);

if colormode == 1
    colormap(ax2, custom_map);
else
    colormap(ax2,polarmap());
end

caxis(ax2, act_clim);
ax2.Visible = 'off';
axis image

if plot_cbar
    colorbar;
end
linkprop([axH ax1 ax2],'Position');

% if plotnow
%    close (fig1)
% end

end

%% Created  25/07/21 (Adapted from 12tiles)
% Updated:
