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
elseif isempty(axHandle), % or if the variable exists but is empty
%     figure % create a figure and axes
    set(gcf,'Position',[661 264 410 210])
    axHandle = axes;
end
% 
if ~exist('axHandleColormap','var') % if axHandle doesn't exist
%     figure % create a figure and axes
    set(gcf,'Position',[661 100 410 60])
    axHandleColormap = axes;
elseif isempty(axHandleColormap), % or if the variable exists but is empty
%     figure % create a figure and axes
    set(gcf,'Position',[661 100 410 60])
    axHandleColormap = axes;
end
end of input control

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
