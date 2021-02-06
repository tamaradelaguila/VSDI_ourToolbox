%% s02 DEFINE ROIS
% Draw ROIs from brain areas.

% Draw ROIs and store in structure
VSDI.roi.labels = {'dm4_R', 'dm4_L',...
   'dm2_R', 'dm2_L',...
   'dm1_R', 'dmd1_L'}';

% DEFINE with the help of the function:
[manual_poly, manual_mask] = roi_draw(VSDI.crop.preview,VSDI.roi.labels); %in each column, one set of rois

% View the result
roi_preview(VSDI.crop.preview, manual_poly); 

VSDI.roi.manual_poly  = manual_poly;
VSDI.roi.manual_mask = manual_mask; 

% View the result
roi_preview_multiple(VSDI.crop.preview, VSDI.roi.manual_poly);
