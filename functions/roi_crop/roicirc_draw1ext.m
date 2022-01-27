function [cROI] = roicirc_draw1ext(VSDI, r)
% [cROI] = roicirc_draw1ext(VSDI, r)    ... Draws a circular roi from the
% background in the VSDI structure with the specified radius and save the
% roi parameters and references from original brain into the output cROI
% structure

% to preview function-defined roi, use:  roicirc_preview_multiple(cROI.im, cROI.centre, cROI.r); 
% to preview the mask: imagesc(cROI.mask); axis image

% input

% output: 'cROI' structure that includes reference from brain with fields:
% 'cROI.ref'
% 'cROI.im' image of the brain
% 'cROI.coord'
% 'cROI.r'
%'cROI.mask' 

% [manual_poly, manual_mask] = roicir_draw(VSDI.crop.preview,VSDI.roi.labels, R); %in each column, one set of rois

cROI.ref = VSDI.ref;
cROI.im = VSDI.crop.preview;
cROI.r = r;

[cROI.centre cROI.mask] = roicir_draw(VSDI.crop.preview,{'croi'},r);




end

%% Created: 02/09/21