
function fcM = Fconn_matrix (timeser, roi_idx, timebase, wind)

%  fcM = Fconn_matrix (timeser, roi_idx, timebase, wind)
%  fcM = Fconn_matrix (timeser, roi_idx)

%% COMPUTES THE CORRELATION MATRIX FROM TIMESERIES (Pearson correlation) AMONG INPUT ROIs AND FOR THE INPUT TIMEWINDOW

% INPUT 
% 'TSdata' - timeseries dataset from one trial. Input the timeseries for all rois (the rois to analyze are selected with the input 'roi_idx'. Dimensions:
% Timepoints*Rois*trialidx
% 'window' = [t1 t2](ms) timewindow from TFdata to analyse 
% 'timebase' (ms) - same reference as window (ms)
% 'roi_idx' - indexes of roi included in the analysis

% OUTPUT
% 'fcM' - connectivity matrix for all trials (roi*roi*trial)

% ------------------------
% TSdata = VSDroiTS.filt.data(:,:,trial);
% roi_idx = [3:10 15 16];
% timebase = VSDI.timebase; (ms)
% wind= [-1200 0]; (ms)
% ------------------------

if nargin>2
    findwind =1;
else
    findwind = 0;
    widx(1) = 1; widx(2) = size(timeser,1); %if no window is input, the window spans all timepoints (all idx from the timeser)
end
% end input control

n_roi = length(roi_idx);

% Find window indexes if provided
if findwind ==1
    [~ , widx(1)] = min(abs(timebase - wind(1)));
    [~, widx(2)] = min(abs(timebase - wind(2)));
end

data= timeser(widx(1):widx(2),roi_idx, :); % time x roi
fcM = NaN(n_roi, n_roi, size(timeser,3));
% Construct Trial-wise correlation matrices
for trialidx = 1:size(timeser,3)
for roi1 = 1:n_roi
for roi2 = 1:n_roi
% adjM(roi1,roi2, trialidx) = corr (sel_data(1:680,roi1,trialidx), sel_data(1:680,roi2,trialidx));
fcM (roi1,roi2,trialidx) = corr(data(:,roi1,trialidx), data(:,roi2,trialidx));
end % roi1
end % roi2

% Turn to zero values from the diagonal
for k = 1:n_roi
    fcM(k,k,trialidx) =0;
end %k

end %trialidx

% imagesc(mean(fcM(:,:,25), 3)); colorbar; 

end

%% Created: 19/07/21 from Gent's funtion