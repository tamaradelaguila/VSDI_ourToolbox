%% FOURIER ANALYSIS OF UNFILTERED DATA

%% LOAD DATA
clear
user_settings

nfish = 1; %@ SET
movieref = '_02diff';
% movieref = '_04crop';

[VSDI] = STIM('load',nfish);
VSDmov = STIM('loadmovie',nfish,movieref);

% SELECT CONDITION

% Get unique conditions
cond = unique(VSDI.condition, 'rows');
ncond = size(cond,1);
% find different conditions

condirow = 1; %which specific row of unique conditions
[idx] = choose_condidx(VSDI.condition, cond(condirow,:));

%% GET TILES FROM AVERAGED MOVIES



%% GET WAVES FROM THE BRAIN FROM ONE CONDITION

%% FFT FOR ALL CROPMASK PIXELS SEPARATELY (concatenated trials)

% all trials in a row

t0 = dsearchn(VSDI.timebase, 0);
selmovies= VSDmov.data(:,:,t0:end-1,idx); %from t0 to the end (excluding background)
movieL = VSDI.timebase(end) ;%movie length: already substracted the baseline excluded in the movie

d = size(selmovies);
movieall  = reshape(selmovies, [d(1), d(2),d(3)*d(4)]);

mask = VSDI.crop.mask;
mask3D = repmat(VSDI.crop.mask,  [1,1,size(movieall, 3)]);
mask3D = logical(mask3D);

% FFT of the mask
% data = movieall(mask3D);
data  = movieall;

% fft parameters
stime = VSDI.info.stime / 1000;
Fs = 1/stime;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = d(3)* d(4)*stime; % Length of signal: ms of all concatenated movies

%
for x = 1:size(mask,1)
    for y = 1:size(mask,2)
        
        if mask(x,y) % this
            
            wave = squeeze(data(x,y,:));
            
            Y = fft(wave);
            
            % Define the frequency domain f and plot the single-sided amplitude spectrum P1. The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise. On average, longer signals produce better frequency approximations.
            
            % plot fft
            P2 = abs(Y(:)/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            
            plot(f,P1); hold on
            clear P2 P1 f Y
        end %if
    end %for y
end % for x

% fft parameters definition


title('Single-Sided Amplitude Spectrum of X(t) from all trials - CROPMASK')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% FFT FOR ALL BACKGROUND PIXELS SEPARATELY (concatenated trials)

% all trials in a row

t0 = dsearchn(VSDI.timebase, 0);
selmovies= VSDmov.data(:,:,t0:end-1,idx); %from t0 to the end (excluding background)
movieL = VSDI.timebase(end) ;%movie length: already substracted the baseline excluded in the movie

d = size(selmovies);
movieall  = reshape(selmovies, [d(1), d(2),d(3)*d(4)]);

mask = VSDI.crop.mask;
mask3D = repmat(VSDI.crop.mask,  [1,1,size(movieall, 3)]);
mask3D = logical(mask3D);

% FFT of the mask
% data = movieall(mask3D);
data  = movieall;

% fft parameters
stime = VSDI.info.stime / 1000;
Fs = 1/stime;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = d(3)* d(4)*stime; % Length of signal: ms of all concatenated movies

%
for x = 1:size(mask,1)
    for y = 1:size(mask,2)
        
        if ~mask(x,y) % this
            
            wave = squeeze(data(x,y,:));
            
            Y = fft(wave);
            
            % Define the frequency domain f and plot the single-sided amplitude spectrum P1. The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise. On average, longer signals produce better frequency approximations.
            
            % plot fft
            P2 = abs(Y(:)/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            
            plot(f,P1); hold on
            clear P2 P1 f Y
        end %if
    end %for y
end % for x

% fft parameters definition


title('Single-Sided Amplitude Spectrum of X(t) from all trials - BACKGROUND')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% FFT FOR ALL CROPMASK PIXELS AND ALL TRIALS IN A ROW

% TRIALS SELECTION
for condirow = 1: ncond
    %which specific row of unique conditions
[idx] = choose_condidx(VSDI.condition, cond(condirow,:));


% all trials in a row

t0 = dsearchn(VSDI.timebase, 0);
selmovies= VSDmov.data(:,:,t0:end-1,idx); %from t0 to the end (excluding background)
movieL = VSDI.timebase(end) ;%movie length: already substracted the baseline excluded in the movie

d = size(selmovies);
movieall  = reshape(selmovies, [d(1), d(2),d(3)*d(4)]);

mask = VSDI.crop.mask;
mask3D = repmat(VSDI.crop.mask,  [1,1,size(movieall, 3)]);
mask3D = logical(mask3D);

% FFT of the mask
% data = movieall(mask3D);
data  = movieall;

bigwave = [];
bigwaveback = [];
for x = 1:size(mask,1)
    for y = 1:size(mask,2)
        
        if mask(x,y) % 
            newwave = squeeze(data(x,y,:));
            bigwave = [bigwave newwave] ;
            
        else 
            newwave = squeeze(data(x,y,:));
            bigwaveback = [bigwaveback newwave]; 
            
        end %if
    end %for y
end % for x

% fft parameters definition

% fft parameters
stime = VSDI.info.stime / 1000;
Fs = 1/stime;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = d(3)* d(4)*stime; % Length of signal: ms of all concatenated movies

% fft
Y = fft(bigwave);
Yb = fft(bigwaveback);
% Define the frequency domain f and plot the single-sided amplitude spectrum P1. The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise. On average, longer signals produce better frequency approximations.

% plot fft
P2 = abs(Y(:)/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

P2b = abs(Yb(:)/L);
P1b = P2b(1:L/2+1);
P1b(2:end-1) = 2*P1b(2:end-1);
fb = Fs*(0:(L/2))/L;

plot(f,P1, 'b');
hold on 
plot(fb,P1b, 'r');
legend crop back
title('Single-Sided Amplitude Spectrum of X(t) from all trials - BACKGROUND')
xlabel('f (Hz)')
ylabel('|P1(f)|')

end
%% 