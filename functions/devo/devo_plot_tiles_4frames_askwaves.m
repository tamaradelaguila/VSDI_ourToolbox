function [] = devo_plot_tiles_4frames_askwaves(moviedata, times, tileset, custom_map, npoints, r)
% [] = plot_tilemovie(moviedata, times, tileset, custom_map, npoints, r)% IT plots 4 tiles and asks for npoints to plot 

%% INPUTS:
%       moviedata: 3D already-inverted data
%       times: timebase corresponding to the different frames (in ms)
%       tileset: structure with settings for tiling in fields: 
%           .start_ms = -300; % time in ms for first tile       
%           .end_ms = 2520;
%           .time2plot = 0; %select time (ms)
%           .x = 35; 
%           .y = 35; 
%           .clims = [] --- values above or below will be saturated
%           .thresh = [negthresh posthres]; --- values inside this range
%           will be zero-out

% Input control
if nargin < 4
    custom_map = colormap_loadBV();
end

if isfield(tileset, 'backgr')
    background = tileset;
else
    background = moviedata(:,:,end);
end
% End of input control

datatime = times; 
moviedata = moviedata(:,:,1:end-1);

% n� samples
starttime = tileset.start_ms;
endtime = tileset.end_ms;

% n� tiles
nrows = 3;
ncols = 4;
ntiles = nrows*ncols;

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

xdim = size(background,1); 
ydim = size(background,2);

pointcolors = parula(npoints);

tit = 'test';
figure
    
    for i = 1:4
   ax(i) = subplot(nrows, ncols, i); 
%    imagesc(imtiles(:,:,ploti))
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax(i), tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax(i).Title.String = tit; 
   axis image
   
    end
    
    %%% TODO: ask for point to extract wave from, plot it in the last frame
    %%% and extract the waves
    
% GET POINT FOR WAVES

for ii = 1:npoints
    title(['select one point and Press any key when it is ready' ])
display(strcat('select point nº:', num2str(ii), '-and Press any key to continue. Once you have drawn it, before pressing enter, you can adjust the point position by simply dragging '))

% Get the initial center position from the user
[x, y] = ginput(1);

% Draw a cicle, and allow the user to change the position
drawncircle = drawcircle('Center', [x, y], 'InteractionsAllowed', 'translate', 'Radius', r, 'LineWidth', 1.5, 'color',pointcolors(ii,:) );
pause
mask = createMask(drawncircle,xdim,ydim);

% save in output
centreO(ii,:) = drawncircle.Center;
mask0(ii,:,:) = createMask(drawncircle,xdim,ydim);

    viscircles([x y],r, 'color',pointcolors(ii,:)); 

end

% EXTRACT WAVE AND PLOT IN TH ELAST AXIS
ax(5) = subplot(nrows, ncols, 5);
hold on

for nwave = 1:npoints
    roimask = squeeze(mask0(nwave,:,:));
    wave  = roi_TSave(moviedata,roimask);
    plot(times(2:end), wave, 'color', pointcolors(nwave,:));
    clear wave roimask
end
    

end

%% Created:24/07/21 (from function plot_tilemovie12frames)

function  plot_framesoverlaid(imAct, imBack, logicalpha, plotnow, axH, act_clim, plot_cbar, thresh, custom_map)
% INPUT 
% 'imAct' - image to display in colors
% 'imBack' - background image
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

%% Created  25/07/21 
% Updated: 
