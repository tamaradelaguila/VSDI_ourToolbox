function [imageOut] = stretchImage(imageIn,newNumRows,debug)
% STRETCHIMAGE uses RESAMPLE to change the number of rows in the input
% image to NEWNUMROWS.  This is slightly more involved than a simple call
% to RESAMPLE because resample introduces error when the boundaries of the
% input signals are nonzero.  To get around this error, a straight line is
% subtracted from each image column before resampling, and then the
% straight line is added back after resampling.
%
% Additionally, resample() conventionally returns all NaNs when the input
% signal contains a single NaN.  STRETCHIMAGE works around the NaNs to 
% return a resampled image with NaNs in the correct positions.

if nargin==2,
    debug=0;
end

szIn = size(imageIn); % size of input
imageOut=zeros(newNumRows,szIn(2)); % preallocate output array

if ndims(imageIn)>2,
    error(['stretchRaster: only 2D input is supported. Your input was ' num2str(szIn)])
end

for i=1:szIn(2), % for each column of the input image
    
    if sum(isnan(imageIn(:,i))) == 0 || sum(isnan(imageIn(:,i))) == szIn(1), % if there are no NaNs in the input signal, or if the input signal is ALL NaNs,
        imageOut(:,i) = resampleRepEdge(imageIn(:,i),newNumRows,szIn(1)); % call resamRepEdge to resample the column, and we're done
        
    else % otherwise, there are NaNs co-mingled with real values in the input signal and we'll have to work around the NaNs
        sig = imageIn(:,i); % get the NaN-containing signal from the input image
        sigNans = isnan(sig); % find all the NaNs in the signal
        dummyResam = resampleRepEdge(sigNans,newNumRows,szIn(1));% resample the dummySig the same way we will resample the real signal.  Indices in this signal >0 indicate points that have large contributions from NaN points, and those should be set to NaN in the output
        indToNanify = dummyResam>0.5; % this should pick up all the indices in the outputs signal that had any contribution from the NaN positions in the input signal
        indToNanify = convRepEdge(indToNanify,[1; 1; 1])>0 ; % convolve with a 3 point wide kernel to expand the NaNs list to include all points that are next to NaNs (these points are probably bad data too, because the raster is getting pretty close to the edge of the image there)
        
        % replace all the NaNs in SIG with the last non-NaN value in SIG that precedes it (this is to try to avoid creating really sharp edges in the signal that could potentially create shenanigans when we resample)
        % first, make sure the first value in the signal is not a NaN.  if the first value of the signal is a NaN, assign the first non-NaN value in the signal to sig(1)
        if sigNans(1), % if the first value in the signal is a NaN
            sig(1) = sig(find(~sigNans,1)); % set the first value in the signal to the first non-NaN value found in the signal
        end
        nanInd = find(isnan(sig)); % get indices of NaNs in the input signal.  this is not the same as sigNans, because the first value may have just been doctored to seed the replacement of NaNs by smearing non-NaN values from left to right
        for j=1:length(nanInd), % march through the signal and assign 
            sig(nanInd)=sig(nanInd-1); % for each NaN in the signal, smear the values in the signal from left to right to remove NaNs.  "nanInd-1" is always on the signal because nanInd is always >=2 (the first point in the signal was set to be non-NaN in the IF conditional right before this loop)
        end
        
        imageOut(:,i) = resampleRepEdge(sig,newNumRows,szIn(1));% resample the NaN-less signal
        imageOut(indToNanify,i) = NaN; % finally, set the appropriate positions in the output to NaN.  all done!
    end
end

if debug,
    figure(51)
    set(gcf,'Name','imageIn')
    imagesc(imageIn)
    
    figure(52)
    set(gcf,'Name','imageOut')
    imagesc(imageOut)
end






function sigsOut =resampleRepEdge(sigsIn,p,q)
% RESAMPLEREPEDGE subtracts a linear offset from the input signals SIGSIN
% before resampling to a sampling rate of p/q.  Typically, P is the desired
% sampling rate and Q is the sampling rate of the input.
% like RESAMPLE, RESAMPLEREPEDGE operates along the columns of sig.

szInput = size(sigsIn);
sigsOut = zeros(round(szInput(1)*p/q),szInput(2)); % preallocate

for i=1:szInput(2),
    botVal = sigsIn(1,i); % % get boundary values to substract a straight line fit from the image column.  (resample wants boundaries to be zero.)
    topVal = sigsIn(end,i);
    
    baseline = linspace(botVal,topVal,szInput(1))'; % linear offset (a straight line between the values at the ends of the image column)
    sigsOut(:,i) = resample(sigsIn(:,i)-baseline,p,q); % subtract baseline from the image column and resample 
    sigsOut(:,i) = sigsOut(:,i)+linspace(botVal,topVal,round(szInput(1)*p/q))'; % add the baseline back in (with the correct number of sample points)
end