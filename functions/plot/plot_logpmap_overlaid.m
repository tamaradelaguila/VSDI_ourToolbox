function  plot_logpmap_overlaid(pmap, imBack, pthresh, plotnow, axH, plot_cbar, custom_map)
%  plot_logpmap_overlaid(pmap, imBack, pthresh, plotnow, axH, plot_cbar, custom_map)

% INPUT
% 'pmap' - pmap to display in colors
% 'imBack' - background image
% 'pthresh': value of p used as a threshold to build the logicmatrix with transparency information (if p<pthresh, then the logic value will be 1 = shown pixel)
% 'plotnow': whether we want to plot the figure (set to 0 if we are providing a axisHandle)
% 'axH': axes handle in which to plot it, when it's going to be included into a subplot
% 'act_clim': color limits for 'imAct'. If no color limits is provided for the activity (color) map, use the max
% and min from the input movie
% 'plot_cbar' : whether we want to plot the colorbar (useful in subplots)


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

logicalpha = pmap<pthresh;

ax1 = axes;
imagesc(imBack);
colormap(ax1,'bone');
ax1.Visible = 'off';
axis image

ax2 = axes;
BVmap= colormap_loadBV();
% imagesc(ax2,imAct,'alphadata',imAct>thresh);
imagesc(ax2,pmap,'alphadata',logicalpha);

if colormode == 1
    colormap(ax2, custom_map);
else
    colormap(ax2,BVmap);
end

% adjust colorscale
% get the minimum and maximum value of data
c1 = 0;
c2 = max(pmap(:));
% set limits for the caxis

ax2.Visible = 'off';
axis image
set(ax2, 'ColorScale','log', 'clim', [0 pthresh])


if plot_cbar % plot logaritmic colorbar
    cb = colorbar();
    cb.Ruler.Scale = 'log';
    cb.Ruler.MinorTick = 'on';
    cb.Ticks = [0 0.0001 0.001 0.01 0.05];
	cb.TickLabelsMode = 'auto';
end

linkprop([axH ax1 ax2],'Position');

% if plotnow
%    close (fig1)
% end

end

%% Copied from old code: 07/02/21
% Update: 30/05/21 (axis image)
% Update: 29/07/21 color log scale: set(ax2, 'ColorScale','log')

