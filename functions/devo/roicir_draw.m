function [coord0, mask0] = roicir_draw(back0,roi_labels0,r)
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

nroi =  length(roi_labels0);

roicolor = roi_colors();
xdim = size(back0,1); 
ydim = size(back0,2);

imagesc(back0); colormap('bone');hold on

axis image % Use axis image, for setting aspect ratio to 1:1


for ii = 1:nroi
display(strcat('draw ROI:',roi_labels0{ii}, '-and Press any key to continue. Once you have drawn it, before pressing enter, you can adjust the points by simply dragging '))

% Get the initial center position from the user
[x, y] = ginput(1);

% Draw a cicle, and allow the user to change the position
drawncircle = drawcircle('Center', [x, y], 'InteractionsAllowed', 'translate', 'Radius', 6, 'LineWidth', 1.5);



% Draw a cicle, and allow the user to change the position 
drawncircle = drawcircle('Center', [x, y], 'InteractionsAllowed', 'translate', 'Radius', r, 'LineWidth', 1.5);
pause
% mask = createMask(drawncircle,xdim,ydim);
% imagesc(mask)
% sum(mask(:))

%create circular mask with given 'r'
coord = drawncircle.Center;
xx = coord(1); yy= coord(2);
[xx,yy] = ndgrid((1:xdim)-x,(1:ydim)-y); %create coordinate arrays centered on the point
mask = (xx.^2 + yy.^2)<r^2; %threshold the distance

% save in output
centre0(ii,1:2) = [xx yy];
radius0(ii,1)
mask0(:,:,ii) = mask;
pause

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