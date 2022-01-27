function [] = roi_preview_multiple_cmap(backgr, roicellstruct, axH, cmap)

% INPUT
% 'backgr':
% 'roicellstruct': cell structure with the coordinates for each roi in each
% row-cell (e.g. VSDI.roi.manual_poly)

% OUTPUT

% Input control
if isempty('axH') | ~exist('axH')
nest_on = 0;
else
    nest_on = 1;
end
% End of input control

ax1 = axes;
imagesc(backgr); colormap('bone'); hold on
roicolors= cmap;
axis image
for nroi = 1:size(roicellstruct,1)
    coord = roicellstruct{nroi};
    plot(coord(:,1), coord(:,2), 'color', roicolors(nroi,:), 'LineWidth', 1); hold on
end

if nest_on
linkprop([axH ax1],'Position');
end


end



%% Created : 06/02/21 (from old code)

% Updated: 26/05/21 'nest_on'
% Updated: 16/12/21: axis image