function frDerivPeak = rasterFindTdepol(Din,halfwinSz,debug)
% Din is an array of signals with dimensions [position time]

%Din(:,1:100)=0;


if nargin==2,
    debug=0;
end

RESAMPLE_FACTOR = 10;

Din=resample(Din',RESAMPLE_FACTOR,1)';

peaks = zeros(size(Din)); % preallocate
frDerivPeak = zeros(size(Din,1),1); % preallocate

DinFilt = sgolayfilt(Din,5,21,[],2); % 5th order polynomial with 21 sample filtering window
%dDin = convRepEdge(DinFilt,[4 3 2 1 0 -1 -2 -3 -4]); % derivative of signals
dDin = convRepEdge(DinFilt,4*RESAMPLE_FACTOR:-1:-4*RESAMPLE_FACTOR); % derivative of signals

% find peaks in each derivative signal
for i=1:size(Din,1),
    peaks(i,:) = signalPeaks(dDin(i,:),halfwinSz*RESAMPLE_FACTOR); % get a binary signal ("1" indicates a peak)
    if sum(peaks(i,:)), % if any peaks were found for the current trace
        frDerivPeak(i) = find(peaks(i,:),1,'first'); % return the first peak in each signal
    end
end
frDerivPeak = frDerivPeak / RESAMPLE_FACTOR; % convert back to normal sample units


if debug,
    colors = 'bgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmkbgrcmk';
    
    figure(423)
    
    for i=1:size(Din,1), % for each signal, plot a marker in the correct color that identifies the sample where the peak derivative was found
        plot(Din(i,:),colors(i))
        hold on
        if frDerivPeak(i)>0, % if there is a peak for the trace, then plot it
            plot(frDerivPeak(i)*RESAMPLE_FACTOR,Din(i,frDerivPeak(i)*RESAMPLE_FACTOR),[colors(i) 'o'])
        end
    end
    hold off
    
    figure(424)
    plot(dDin')
    hold on
    for i=1:size(Din,1), % for each signal, plot a marker in the correct color that identifies the sample where the peak derivative was found
        if frDerivPeak(i)>0, % if there is a peak for the trace, then plot it
            plot(frDerivPeak(i)*RESAMPLE_FACTOR,dDin(i,frDerivPeak(i)*RESAMPLE_FACTOR),[colors(i) 'o'])
        end
    end
    hold off
    
    % plot activation times with spatial dimension as the y axis
    figure(425)
    plot(frDerivPeak*RESAMPLE_FACTOR,1:length(frDerivPeak),'.')
    
    
    % plot activation times on top of the resampled input raster
    figure(426)
    imagesc(colorizeRaster(Din))
    axis xy
    hold on
    plot(frDerivPeak*RESAMPLE_FACTOR,1:length(frDerivPeak),'.')
    
    
    
    if debug>1, % super debug mode!
        
        % plot each signal, the derivative peak, and the projected x intercept
        figure(427)
        for i=1:size(Din,1), % for each signal, plot a marker in the correct color that identifies the sample where the peak derivative was found
            plot(Din(i,:),[colors(i)])
            hold on
            if frDerivPeak(i)>0, % if there is a peak for the trace, then plot it
                plot(frDerivPeak(i)*RESAMPLE_FACTOR,Din(i,frDerivPeak(i)*RESAMPLE_FACTOR),[colors(i) 'o'])
            end
            pause
            hold off
        end
    end
end