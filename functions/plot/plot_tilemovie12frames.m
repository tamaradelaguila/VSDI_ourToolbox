function [] = plot_tilemovie12frames(moviedata, times, tileset, custom_map)
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
%           .thresh = [negthresh posthres]; --- values inside this range
%           will be zero-out

datatime = times; 
background = moviedata(:,:,end);
moviedata = moviedata(:,:,1:end-1);

% nº samples
starttime = tileset.start_ms;
endtime = tileset.end_ms;

% nº tiles
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

figure
    
    i = 1; 
   ax1 = subplot(nrows, ncols, i); 
%    imagesc(imtiles(:,:,ploti))
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax1, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax1.Title.String = tit; 
   
   i = 2; 
   ax2 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax2, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax2.Title.String = tit; 
  
   i = 3; 
   ax3 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax3, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax3.Title.String = tit; 

   i = 4; 
   ax4 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax4, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax4.Title.String = tit; 
  
   i = 5; 
   ax5 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax5, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax5.Title.String = tit; 

   i = 6; 
   ax6 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax6, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax6.Title.String = tit; 

   i = 7; 
   ax7 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax7, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax7.Title.String = tit; 

   i = 8; 
   ax8 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax8, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax8.Title.String = tit; 

   i = 9; 
   ax9 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax9, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax9.Title.String = tit; 
   
   i = 10; 
   ax10 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax10, tileset.clims, 0, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax10.Title.String = tit; 

   
   i = 11; 
   ax11 = subplot(nrows, ncols, i);
      tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax11, tileset.clims, 0, tileset.thresh, custom_map); 
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax11.Title.String = tit; 

   i = 12; 
   ax12 = subplot(nrows, ncols, i); 
   plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax12, tileset.clims, 1, tileset.thresh, custom_map); 
   tit= strcat(num2str(datatime(timeindx(i))), 'ms');
   title(tit, 'fontsize', 6)
   set(gca,'XColor', 'none','YColor','none')
   ax12.Title.String = tit; 

end

%% Created: 16/02/21 (from Gent1)
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
linkprop([axH ax1 ax2],'Position');

% if plotnow
%    close (fig1)
% end

end

%% Created  07/02/21(Copied from Gent code)
% Updated: 19/02/21 - 'change plot_framesoverlaid': BV colormap
