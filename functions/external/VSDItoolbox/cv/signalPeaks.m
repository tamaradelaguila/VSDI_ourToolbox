function out = signalPeaks(s,halfwin_sz)
% given a 1D signal S and a half-window length HALFWIN_SZ,
% SIGNALPEAKS uses a sliding window of length 1+2*HALFWIN_SZ
% to find the peaks in the signal.  Output OUT is a
% binary 1D signal of peaks.

return_row_vector=0; % use this later to flip output, so it matches the dimensions of the input

if size(s,2)>1, % if the signal s is a row vector, make it a column vector
    s=s';
    return_row_vector=1;
    if size(s,2)>1, % if transposing doesn't give a column vector, the input isn't 1-dimensional
        error('Bad input to signalPeaks: Input must be 1D signal')
    end
end

out=zeros(length(s),1); % preallocate output array

w=halfwin_sz; % w is half window length
ss = padarray(s,w,'both');

i=w+1;
while i<=length(s)+w,
    sWin = ss(i-w:i+w); % get a section of the signal of window length 1+2w
    if sWin(w+1)==max(sWin), % if the point at the middle of the window is the maximal value in the window, it's a peak we want to return in OUT.
        if std(sWin)>0, % ignore the peak if the signal is a flat line
            out(i-w)=1;
            i=i+w-1; % if we find a peak, jump ahead a half window width
        end
    end
    i=i+1;
end

if return_row_vector, % flip the output if we flipped the input
    out=out';
end