function [] = roi_preview_multiple(backgr, roicellstruct, axH)

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
roicolors= roi_colors();
axis image
for nroi = 1:size(roicellstruct,1)
    coord = roicellstruct{nroi};
    plot(coord(:,1), coord(:,2), 'color', roicolors(nroi,:), 'LineWidth', 1); hold on
end

if nest_on
linkprop([axH ax1],'Position');
end


end


function roicolors= roi_colors()

roicolors= [.1 .5 .5;... turqu#
            .1 .5 .5;...
            .8 .4 .05;... red #
            .8 .4 .05;...
            .9 .1 .1;... orange 
            .9 .1 .1;...
            .8 .7 .0;...yellow 
            .8 .7 .0;...
            .2 .6 .2; ...green 
            .2 .6 .2;...
            .70 .43 .50;... pink 
            .70 .43 .50;......
            .46 .37 .06;...brown 
            .46 .37 .06;...
            .6,.6,.6;...%gray
            .6,.6,.6;...% REPEAT COLOURS
            .1 .5 .5;... turqu#
            .1 .5 .5;...
            .8 .4 .05;... red #
            .8 .4 .05;...
            .9 .1 .1;... orange 
            .9 .1 .1;...
            .8 .7 .0;...yellow 
            .8 .7 .0;...
            .2 .6 .2; ...green 
            .2 .6 .2;...
            .70 .43 .50;... pink 
            .70 .43 .50;......
            .46 .37 .06;...brown 
            .46 .37 .06;...
            .6,.6,.6;...%gray
            .6,.6,.6
            ];
end

%% Created : 06/02/21 (from old code)

% Updated: 26/05/21 'nest_on'
% Updated: 16/12/21: axis image