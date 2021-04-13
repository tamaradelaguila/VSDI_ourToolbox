function plot_16perm_results(mode, maps, title_info)

% 'mode' - defines what will be plotted
%       mode = 'diffmap_alpha'
%       mode = Pmap

% 'maps' - contains all the maps that'll be needed for the selected
% plotting. Each field is a 3D matrix, with the maps piles in the 3rd
% dimension
%       maps.Pmap
%       maps.diffmap
%       maps.alphamap
%       maps.background - needed to plot the thresholded diffmap (with
%       'overlay' function
%       maps.clim - needed to diffmap_alpha (color limits); threshold is set to zero because the threshold is on the alphamap        
% 'times' - corresponding to each analized timepoint 

% 'title_info' - with info about the fish, conditions, p-threshold used for the alphamap,  
nrows = 4; ncols = 4;

switch mode
    
    case 'diffmap_alpha'
        imtiles = maps.diffmap;
        imalpha = maps.alphamap;
        background = maps.background; 
        custom_map = colormap_loadBV();
        clims = maps.clim;
        thresh = 0;
        
        %% PLOT CASE diffmap_alpha

        figure
        sgtitle(title_info)
            i = 1; 
           ax1 = subplot(nrows, ncols, i); 
        %    imagesc(imtiles(:,:,ploti))
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax1, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax1.Title.String = tit; 

           i = 2; 
           ax2 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax2, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax2.Title.String = tit; 

           i = 3; 
           ax3 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax3, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax3.Title.String = tit; 

           i = 4; 
           ax4 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax4, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax4.Title.String = tit; 

           i = 5; 
           ax5 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax5, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax5.Title.String = tit; 

           i = 6; 
           ax6 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax6, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax6.Title.String = tit; 

           i = 7; 
           ax7 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax7, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax7.Title.String = tit; 

           i = 8; 
           ax8 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax8, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax8.Title.String = tit; 

           i = 9; 
           ax9 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax9, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax9.Title.String = tit; 

           i = 10; 
           ax10 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax10, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax10.Title.String = tit; 


           i = 11; 
           ax11 = subplot(nrows, ncols, i);
              tit= strcat(num2str(maps.timepoints(i)), 'ms');
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax11, clims, 0, thresh, custom_map); 
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax11.Title.String = tit; 

           i = 12; 
           ax12 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax12, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax12.Title.String = tit; 

           i = 13; 
           ax13 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax13, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax13.Title.String = tit;            
           
           i = 14; 
           ax14 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax14, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax14.Title.String = tit;
           
           i = 15; 
           ax15 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax15, clims, 0, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax12.Title.String = tit;            
           
           i = 16; 
           ax16 = subplot(nrows, ncols, i); 
           plot_framesoverlaid(imtiles(:,:,i),background, imalpha(:,:,i) ,0, ax16, clims, 1, thresh, custom_map); 
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
           set(gca,'XColor', 'none','YColor','none')
           ax16.Title.String = tit; 

        case 'Pmap'
            
        Pmap = maps.Pmap;    
            
        figure
        sgtitle(title_info)

           i = 1; 
           ax1 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax1);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax1.Title.String = tit; 

           i = 2; 
           ax2 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax2);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax2.Title.String = tit; 

           i = 3; 
           ax3 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax3);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax3.Title.String = tit; 

           i = 4; 
           ax4 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax4);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax4.Title.String = tit; 

           i = 5; 
           ax5 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax5);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax5.Title.String = tit; 

           i = 6; 
           ax6 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax6);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax6.Title.String = tit; 

           i = 7; 
           ax7 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax7);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax7.Title.String = tit; 

           i = 8; 
           ax8 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax8);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax8.Title.String = tit; 

           i = 9; 
           ax9 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax9);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax9.Title.String = tit; 

           i = 10; 
           ax10 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),0,ax10);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax10.Title.String = tit; 


           i = 11; 
           ax11 = subplot(nrows, ncols, i);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           plot_logPmap(Pmap(:,:,i),0,ax11);
           title(tit, 'fontsize', 6)
%          set(gca,'XColor', 'none','YColor','none')
           ax11.Title.String = tit; 

           i = 12; 
           ax12 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),1,ax12);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax12.Title.String = tit;
           
           i = 13; 
           ax13 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),1,ax13);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax13.Title.String = tit;
           
           i = 14; 
           ax14 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),1,ax14);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax14.Title.String = tit;
           
           i = 15; 
           ax15 = subplot(nrows, ncols, i); 
           plot_logPmap(Pmap(:,:,i),1,ax15);
           tit= strcat(num2str(maps.timepoints(i)), 'ms');
           title(tit, 'fontsize', 6)
%            set(gca,'XColor', 'none','YColor','none')
           ax15.Title.String = tit;
           
           i = 16; 
           ax16 = subplot(nrows, ncols, i); 
%            plot_logPmap(Pmap(:,:,i),1,ax16);
%            tit= strcat(num2str(maps.timepoints(i)), 'ms');
           imagesc(maps.background(:,:,1)); colormap(bone);
%            tit('background')
%            title(tit, 'fontsize', 6)
%          set(gca,'XColor', 'none','YColor','none')
%            ax16.Title.String = tit; 
    end

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
function [heatMap,colorbarForLegend,colorbarTickPositions,colorbarTickLabels] = plot_logPmap(Pmap, show_cbar,axHandle,axHandleColormap)
%% Modified function to plot directly from a given Pmap

% Original function documentation:
% Given a 2D array of T-statistics TMATREAL and a list of
% permutation-generated T-statistics ALLTS to compare against,
% TSTATHEATMAPLOG creates a pseudocolor heat map of P values.
% P values <0.05 will be shaded purple.
%
% INPUTS:
% The inputs TMATREAL and ALLTS are required.  TMATREAL is the primary
% output array from the function rasterPermTestCompare(). ALLTS is the
% primary output array from the function rasterPermTestIterate().
%

% TSTATHEATMAPLOG(tMatReal,allTs,frameInterval_ms) compares the T
% statistic matrix TMATREAL (from the control vs. experimental test)
% to the emperical null distribution matrix ALLTS to compute and plot
% P values for all sites in a raster plot.
%
% TSTATHEATMAPLOG(tMatReal,allTs,frameInterval_ms) plots the heatmap of
% P values with the temporal axis incremented in time steps between movie
% frames.  (For a recording obtained at 500 frames per second,
% frameInterval_ms = 2 ms.)
%
% TSTATHEATMAPLOG(tMatReal,allTs,frameInterval_ms,tStim) adjusts the temporal axis so
% that t = 0 ms corresponds to the time of stimulus delivery.
%
% TSTATHEATMAPLOG(tMatReal,allTs,frameInterval_ms,tStim,t1,t2) plots the
% heatmap, showing only the samples during the time interval t1:t2.  Note
% that t1 and t2 are in units of time, not sample numbers.
%
% TSTATHEATMAPLOG(tMatReal,allTs,frameInterval_ms,tStim,t1,t2,axHandle)
% plots the heatmap as described above, in the axes defined by the handle
% axHandle.
%
% It is also possible to omit some inputs to TSTATHEATMAPLOG, by providing
% empty arrays, [], for some inputs.  For example, to plot a heatmap in the
% axes defined by axis handle "axHandle" without providing tStim, t1, or
% t2, the following command could be used:
%
% tStatHeatMapLog(tMatReal,allTs,2,[],[],[],axHandle)
%
%
% OUTPUTS:
% A number of variables generated by tStatHeatMapLog can be returned, in
% the following order:
% [Pmat,heatMap,colorbarForLegend,colorbarTickPositions,colorbarTickLabels] = tStatHeatMapLog(...)
%
% These variables are defined as follows:
%
% Pmat: P values for each spatiotemporal site (same size as TMATREAL).
%
% heatMap: the RGB color-indexed image of the heatMap.  this is the image
% plotted by TSTATHEATMAPLOG.
%
% colorbarForLegend: RGB color-indexed colormap, of size [1000 3].  This is
% the colormap plotted by TSTATHEATMAPLOG.
%
% colorbarTickPositions: for the colorbar, used to set the positions of the
% X axis labels, e.g., set(gca,'XTick',colorbarTickPositions) .
%
% colorbarTickLabels: for the colorbar, used to set the values of the X axis
% labels, e.g., set(gca,'XTickLabel',colorbarTickPositions) .
%

ALPHA = 0.05;
P_MIN = 0.001;


if ~exist('axHandle','var') % if axHandle doesn't exist
%     figure % create a figure and axes
    set(gcf,'Position',[661 264 410 210])
    axHandle = axes;
elseif isempty(axHandle) % or if the variable exists but is empty
%     figure % create a figure and axes
    set(gcf,'Position',[661 264 410 210])
    axHandle = axes;
end
% 
% if ~exist('axHandleColormap','var') % if axHandle doesn't exist
% %     figure % create a figure and axes
%     set(gcf,'Position',[661 100 410 60])
%     axHandleColormap = axes;
% elseif isempty(axHandleColormap), % or if the variable exists but is empty
% %     figure % create a figure and axes
%     set(gcf,'Position',[661 100 410 60])
%     axHandleColormap = axes;
% end
% end of input control

heatMap = pMatToLogImgGrayPurple(Pmap,ALPHA,P_MIN); % call function (below) to convert matrix to RGB image

pMinExp = log10(P_MIN); % for colormap
colorbarLegendVect = 10.^(linspace(pMinExp,0,1000));
colorbarForLegend = pMatToLogImgGrayPurple(colorbarLegendVect,ALPHA,P_MIN); % make a colorbar

% colorbarTickLabels = [0.001:.001:.01 .02:.01:.1 .2:.1:1]; % for labelling X axis of color legend
colorbarTickLabels = [0.001 0.005 .01 .05 .1 .5 1]; % for labelling X axis of color legend

colorbarTickPositions = zeros(size(colorbarTickLabels)); % preallocate
for i=1:length(colorbarTickLabels)
    colorbarTickPositions(i) = find(colorbarLegendVect>=colorbarTickLabels(i),1)/1000; % find the tick position that corresponds to the current tick
end

% colorbarTickLabels=num2cell(colorbarTickLabels);

set(gca,'XTick',colorbarTickPositions)
set(gca,'XTickLabel',colorbarTickLabels)
box off
set(gca,'YTick',[])


imagesc(heatMap,'Parent',axHandle,[0 1])
% set(axHandle,'YDir','normal')
xlabel('time (ms)')


%% Y labels
% szIm = size(Pmap);

% set(axHandle,'YTick',tickInd,'YTickLabel',tickVal) % display the y ticks and y tick labels on the figure

%% colorbar

xRange = [0 1];
if show_cbar
figure
imagesc(xRange,[],colorbarForLegend,'Parent',axHandleColormap)
set(axHandleColormap,'XTick',colorbarTickPositions)
set(axHandleColormap,'XTickLabel',colorbarTickLabels)
set(axHandleColormap,'YTick',[])
set(gcf,'Name','Heatmap color legend (logarithmic)')
box off
end
end

%% Created 29/03/21 from modified function fomr Gent2


function [grayPurpleLogIm] = pMatToLogImgGrayPurple(Pmat,ALPHA,P_MIN)

logPmat = log10(1./Pmat); % take the inverse log of P.  this will expand the range of P values so we can see them better

% create color maps
grayCmap = linspace(165/255,255/255,256)';
grayCmap = [grayCmap grayCmap grayCmap];

purpleCmapR = linspace(55/255,155/255,256)';
purpleCmapG = linspace(30/255,150/255,256)';
purpleCmapB = linspace(110/255,235/255,256)';

purpleCmap = [purpleCmapR purpleCmapG purpleCmapB];

% for log plots, colormaps need to be flipped because small values become
% big logs, and vice versa
grayCmap=flipud(grayCmap);
purpleCmap=flipud(purpleCmap);

% to get better color depth in the purple (<ALPHA) range, we will
% create separate arrays for above-ALPHA and below-ALPHA
PmatInsignif=logPmat; % copy the matrix into PmatInsignif
PmatInsignif(Pmat<ALPHA)=NaN; % NaN-out all the values that are significant
PmatSignif = logPmat;
PmatSignif(Pmat>=ALPHA)=NaN; % NaN-out all the insignificant values; PmatSignif now contains only significant values less than ALPHA; will be rendered purple

% convert each Pmat matrix to RGB values (result will be MxNx3)
PmatInsignifScale = PmatInsignif/log10(1/ALPHA); % stretch to use the full color scale
PimgGray = ind2rgb(gray2ind(PmatInsignifScale,256),grayCmap);

PmatSignifScale = (PmatSignif-log10(1/ALPHA))/(log10(1/P_MIN)-log10(1/ALPHA));
PmatSignifScale(isnan(PmatSignif))=0; % zero all sites that are supposed to be zero (subtraction on the line above caused zeros to become -log10(1/ALPHAs) )
PimgPurple=ind2rgb(gray2ind(PmatSignifScale,256),purpleCmap);

% combine the two images, one channel at a time

% first, set values to zero for sites that will not be colored with a given
% map (for example, sites with ALPHA<0.05 will be zeroed in the gray map)
PimgGrayR = PimgGray(:,:,1);
PimgGrayR(isnan(PmatInsignif)) = 0; % if a site was zero in PmatInsignif, make it zero in the image output
PimgGrayG = PimgGray(:,:,2);
PimgGrayG(isnan(PmatInsignif)) = 0; % same for G channel
PimgGrayB = PimgGray(:,:,3);
PimgGrayB(isnan(PmatInsignif)) = 0; % same for B channel

PimgPurpleR = PimgPurple(:,:,1);
PimgPurpleR(~isnan(PmatInsignif)) = 0; % if a site was zero in PmatSignif, make it zero in the image output
PimgPurpleG = PimgPurple(:,:,2);
PimgPurpleG(~isnan(PmatInsignif)) = 0; % same for G channel
PimgPurpleB = PimgPurple(:,:,3);
PimgPurpleB(~isnan(PmatInsignif)) = 0; % same for B channel

grayPurpleLogIm = cat(3,PimgGrayR+PimgPurpleR,PimgGrayG+PimgPurpleG,PimgGrayB+PimgPurpleB);
end
%% Created: 29/03/21 (Tamara)
