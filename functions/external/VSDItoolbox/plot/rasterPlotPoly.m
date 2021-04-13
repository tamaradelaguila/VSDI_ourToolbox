function rasterPlotPoly(polyInner,polyOuter,imBg,combineRegions_TrueFalse,figureNum)

if ischar(polyInner), % if a text input is provided as the first argument, try to load the data from the file specified by the string
    try
        load(polyInner,'polyInner','polyOuter','imBg','combineRegions_TrueFalse');
    catch
        error('Unable to load geometry data from specified file')
    end
end

if nargin<4, % create a figure window
    hFig = figure;
else
    hFig = figure(figureNum);
end

clf(hFig); % clear the current figure window

imagesc(imBg),axis equal, colormap gray, axis off, hold on % plot the background image

for i=1:length(polyInner), % for each drawn region,
    if combineRegions_TrueFalse(i), % if the regions were combined, plot the combined region in blue
        polyPlot(polyInner{i},imBg,'b',gca)
    else % if the regions weren't combined, plot the separate regions in red and green
        polyPlot(polyInner{i},imBg,'r',gca)
        polyPlot(polyOuter{i},imBg,'g',gca)
    end
end

