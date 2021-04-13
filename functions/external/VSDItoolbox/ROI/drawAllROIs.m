function h = drawAllROIs(image,regionPoly,colors,figureNum)
% DRAWREGIONS plots the outlines of the regions defined in REGIONPOLY, in the color order
% specified in COLORS, over the background image IMAGE.

if nargin==3,
    figureNum=100;
end

figure(figureNum); % create figure window (or make it active)
clf(figureNum); % clear the figure window

if ~isempty(image), % if an image is provided, plot it
    set(gcf,'Position',[807 208 640 480])
    imagesc(image); colormap gray, axis equal
    set(gca,'Ylim',get(gca,'Xlim')) % creates white space around image (helpful when drawing regions that hang off edges)
end

for i=1:size(regionPoly,1),
    h(i) = roiDrawPoly(regionPoly{i},colors(i,:)); % draw new IMPOLYs from the regionPoly that is already in the workspace
end