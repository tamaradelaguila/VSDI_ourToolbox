
function [output] = filter_bleach_butterhigh(input, cutoff, stime)
%[output] = filter_bleach_butterhigh(input, cutoff, stime)
% 2-order Buttworth high-pass filter

% MOVIE (3Dinput).

% INPUT:
% 'input' image or movie. If it is a movie, the filter is applied accross the third dimension
% 'cutoff' : cutoff fequency
% stime : sampling rate (in ms) (e.g. VSDI.info.stime)

% OUTPUT: filtered  movie

% Performs "pix-wise" buttworth high pass filter of second order. Inspired
% by Matsuo 2016
... slow drift in each pixel’s time course was removed using a high-pass
    ...filter (>0.01 Hz, second-order Butterworth.)
    
% If input is a wave, returns a filtered wave.
% If the input is a movie (3D), ut returns a movie in which each pixel timeserie has
% been filtered independently


%%
input = squeeze(input);
data_dim = length(size(input));

Freq = 1000/(stime); % sampling frequency in hertz
nyquist = Freq *0.5;

if data_dim < 3
    
    [B, A] = butter(2, cutoff / nyquist, 'high');
    %     output = transpose(filtfilt(B, A, transpose(input)));
    output = filter(B,A,input);
end

if data_dim ==3
    for x = 1:size(input,1)
        
        for y = 1:size(input,2) % apply the filter to each frame
            wave = squeeze(input(x,y,1:end-1));
            [B, A] = butter(2, cutoff / nyquist, 'high');
            local =   filter(B,A,wave);
            output(x,y,:) = local;
        end % for y
        
    end % for x
    
    % Restore the background frame
    output(:,:,end+1) = input(:,:,end);
end % if
end

%% Created: 20/10/21
% Updated:
