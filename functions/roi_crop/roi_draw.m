function [coord0, mask0] = roi_draw(back0,roi_labels0)
% THE FUNCTIONS ASKS TO DRAW THE ROIS IN THE INPUT BACKGROUND AND STORES THEM AS POLYGONS INTO A CELL
% STRUCTURE, AND AS MASKS INTO A 3-D MATRIX. If 'roi_labels' argument is not input, a single mask is done. 
% Colormap is defined up to 14 rois

% INPUT:
% 'back' : 2D-image
% 'roi_labels': in the order in which they will be plot. Exmaple:
%     roi_labels = {'dm4l_R', 'dm4l_L', 'dm4m_L', 'dm4m_L',...
%     'dm2_R', 'dm2_L', 'dldc_R', 'dldc_L', 'dldm_R', 'dldm_L'...
%      'dm1_R', 'dm1_L', 'dm3_R', 'dm3_L', }';

% OUTPUT: 
% 'coord': Cell-structure with one set of coordinates in each row. 
% 'mask': 3D-matrix with one roi in each 3rd dimension

if nargin ==1
    nroi = 1;
    roi_labels0 = {'crop'};
elseif nargin ==2
    nroi =  length(roi_labels0);
end 

roicolor = roi_colors();
xdim = size(back0,1); 
ydim = size(back0,2);

imagesc(back0); colormap('bone');hold on


for ii = 1:nroi
title(['draw ROI:',roi_labels0{ii}, '(and Press any key)' ])
display(strcat('draw ROI:',roi_labels0{ii}, '-and Press any key to continue. Once you have drawn it, before pressing enter, you can adjust the points by simply dragging '))
% drawnroi = drawpolygon('LineWidth',1.5,'Color',roicolor(ii,:), 'Label', roi_labels0{ii});
drawnroi = drawpolygon('LineWidth',1.5,'Color',roicolor(ii,:));

pause
coord0{ii,1} = drawnroi.Position;
coord0{ii,1}(end+1,:) = coord0{ii,1}(1,:); % close the polygon
mask0(:,:,ii) = poly2mask(drawnroi.Position(:,1), drawnroi.Position(:,2), xdim, ydim); % create mask from polygon

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