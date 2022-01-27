function [] = roicirc_preview_multiple_cmap(backgr, center, r, axH, cmap)

% INPUT
% 'backgr':
% 'roicellstruct': cell structure with the coordinates for each roi in each
% row-cell

% OUTPUT
%

%Input control
if isempty('axH') | ~exist('axH')
nest_on = 0;
else
    nest_on = 1;
end
% End of input control

ax1 = axes;
imagesc(backgr); colormap('bone'); hold on
axis image
roicolors= cmap;

for nroi =  1:size(center,1)
    coord = center(nroi,:);
    viscircles(coord,r, 'color',roicolors(nroi,:)); hold on
    axis image
end

if nest_on
linkprop([axH ax1],'Position');
end

end


%% Created : 06/02/21 (from old code)

% Updated: -
