function Dsuprathresh = movieSDthresh(movIn,FR_SAMPLE_BASELINE,SD_NOISE)
% For each pixel trace in MOVIN, MOVIESDTHRESH calls SDTHRESH to set the
% value of the trace to 0 if the value at that time point is within 
% SD_NOISE standard deviations of the noise (computed over the frames 
% FR_SAMPLE_BASELINE) in that signal.

Dsuprathresh=zeros(size(movIn)); % preallocate
for r=1:size(movIn,1),
    for c=1:size(movIn,2),
        Dsuprathresh(r,c,:) = SDthresh(movIn(r,c,:),FR_SAMPLE_BASELINE,SD_NOISE); % the last input to SDthresh is how many times away from the standard deviation the signal must be before we say the signal isn't noise
    end
end