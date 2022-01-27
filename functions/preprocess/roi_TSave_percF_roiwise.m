function [outwave] = roi_TSave_percF_roiwise(Y,roimask, F0)
% [outwave] = roi_TSave_percF_roiwise(Y,roimask, F0). Extracts %F timeserie from a
% diffF (F-F0) movie input (excluding last frame, in case that the
% background was included) dividing the averaged roi-wave by the averaged
% F0-value


% INPUT: 'Y' 3D data matrix (movie: x*y*frames); 'roimask', 2D logic;
% 'F0' is a 2D matrix with the F0 (background) values used to calculate
% diffF (F - F0)

% OUTPUT: 'wave' of the ROI timeserie, that is the average value of all the pixels
% in the ROI (roimask)

Nframes= size(Y,3)-1; % substract last frame in case it is the background
outwave = zeros(1, Nframes); % vector of length the n� of frames in data (Y) 

F0values = F0.*roimask;
aveF0 = sum(F0values(:)) / sum(roimask(:)); 

for frame=1:Nframes
        ROIvalues = Y(:,:,frame).*roimask;
        ROIvalues = fillmissing(ROIvalues,'constant', 0); 
        
        aveROI = sum(ROIvalues(:))/sum(roimask(:)); %sum(ROImask) gives the number of pixels included in the ROI
        
        outwave(frame) = aveROI/aveF0;
end

end

%%  LAST UPDATE: 
% Created: 22/11/21 (from roi_TSave)

