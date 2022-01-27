function [] = plot_tilemovie_custom(moviedata, times, tileset,roipoly, custom_map)
% [] = plot_tilemovie(moviedata, times, tileset)
% EXTRACT 12 TILES FROM INPUT MOVIE 3D and STRUCTURE THAT CONTAINS ALL THE SETTINGS

% INPUTS:
%       moviedata: 3D already-inverted data
%       times: timebase corresponding to the different frames (in ms)
%       tileset: structure with settings for tiling in fields: 
%           .start_ms = -300; % time in ms for first tile       
%           .end_ms = 2520;
%           .time2plot = 0; %select time (ms)
%           .x = 35; 
%           .y = 35; 
%           .clims = [] --- values above or below will be saturated
%           .thresh = [negthresh posthres]; --- values inside this range will be zero-out

%         .nrowcol = [nrows ncols] number of rows and columns
%         .step = 10 %frame step in tiles

%          .backgr
%       custom_map 
%       roipoly: roi polygons if we want to overdraw them in every frame (e.g.:VSDI.roi.manual_poly)

% Input control
if ~exist('roipoly', 'var')
    plot_rois = 0;
else
    plot_rois = 1;
end

if nargin < 5
    custom_map = colormap_loadBV();
end

if isfield(tileset, 'backgr')
    background = tileset.backgr;
else
    background = moviedata(:,:,end);
end

if isfield(tileset, 'nrowcol')
nrows = tileset.nrowcol(1) ;
ncols = tileset.nrowcol(2);

else
    nrows = 4; 
    ncols = 5;
end


if isfield(tileset, 'step')
step =tileset.step;
else
step = NaN;
end

% End of input control


datatime = times; 
moviedata = moviedata(:,:,1:end-1);

% n samples
starttime = tileset.start_ms;
endtime = tileset.end_ms;

% n tiles
if isnan(step)
    ntiles = nrows*ncols;
    tilestimes0 = linspace (starttime, endtime, ntiles); %ms included in the 
else
    skip = step* (times(2)-times(1));
    
    tilestimes0  = starttime:skip:endtime; 
    ntiles = length(tilestimes0);
    if ntiles > ncols*nrows
        disp('the number of rows have been changed to fit the number of tiles required')
        nrows = ceil(ntiles/ncols);
        
    end
end

% Obtain Time
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

figure
 
n = ntiles; 

   for  i = 1:n-1
   ax(i) = subplot(nrows, ncols, i); 
%    imagesc(imtiles(:,:,ploti))
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax(i), tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax(i).Title.String = tit; 
   
      if plot_rois
          hold on
%        roicolors= roi_colors();
       for nroi = 1:size(roipoly,1)
           coord = roipoly{nroi};
%            plot(coord(:,1), coord(:,2), 'color', roicolors(nroi,:), 'LineWidth', 1); hold on
           plot(coord(:,1), coord(:,2), 'color', 'b', 'LineWidth', 0.5); hold on
       end
      end
%        axis image
       % delete axis 
       ax(i).XTick = [];
       ax(i).YTick = [];
       
       ax(i).FontSize = 6;

    set(ax(i),'visible', 'off'); %set the axis invisible (the white square behind)
    set(findall(gca, 'type', 'text'), 'visible', 'on') %keeps the title visible


   end
   
   i = n;
   ax(i) = subplot(nrows, ncols, i);
   %    imagesc(imtiles(:,:,ploti))
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax(i), tileset.clims, 1, tileset.thresh, custom_map);
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax(i).Title.String = tit; hold on

   if plot_rois
%        roicolors= roi_colors();
       for nroi = 1:size(roipoly,1)
           coord = roipoly{nroi};
%            plot(coord(:,1), coord(:,2), 'color', roicolors(nroi,:), 'LineWidth', 1); hold on
           plot(coord(:,1), coord(:,2), 'color', 'b', 'LineWidth', 0.5); hold on
       end
   end
       ax(i).XTick = [];
       ax(i).YTick = [];
       
       ax(i).FontSize = 6;
    set(ax(i),'visible', 'off'); %set the axis invisible (the white square behind)
    set(findall(gca, 'type', 'text'), 'visible', 'on') %keeps the title visible


   
end

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
if plot_cbar
colorbar;
end
axis image

linkprop([axH ax1 ax2],'Position');

% if plotnow
%    close (fig1)
% end

end

%% Created  07/02/21(Copied from 'plot_tilemovie12frames') custom number of plots
% Updated 01/12/21 - add 'axH' 