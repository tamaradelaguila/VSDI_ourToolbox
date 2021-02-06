function [] = roi_preview_multiple(backgr, roicellstruct)

% INPUT
% 'backgr':
% 'roicellstruct': cell structure with the coordinates for each roi in each
% row-cell

% OUTPUT
% 


figure
imagesc(backgr); colormap('bone'); hold on
roicolors= roi_colors();

for nroi = 1:size(roicellstruct,1)
    coord = roicellstruct{nroi};
    plot(coord(:,1), coord(:,2), 'color', roicolors(nroi,:), 'LineWidth', 1); hold on
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

% Updated: -