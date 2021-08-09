%% Load pike matfile
% Previous steps in 'spike_export.txt'

clear

user_settings
nfish =12;
VSDI = TORus('load',nfish); 

pathspike= '/home/tamara/Documents/MATLAB/VSDI/TORus/data/dataspike';
load(fullfile(pathspike,[num2str(VSDI.ref) 'spike.mat']))
clear EIwave ROwave Keyboard pathspike

%% ECG info

spike.ref = VSDI.ref;

% GET TIMEBASE : not needed anymore because times can be extracted in the
% spike file
% times(1) = 0;
% for tt =2:ecg.length
%    times(tt) = times(tt-1) + ecg.interval;
% end
% times= times';
% times = downsample(times,10);
% downsample and save

% GET DOWNSAMPLED VALUES
spike.ecg= downsample (ecg.values, 10);
spike.ecg_timebase = downsample(ecg.times,10) ;

clear ecg times tt
% % get idx from a given time interval
% t1 = seconds(60*60);
% 
% idx1 = find_timeidx(t1);
% 
% datenum(t1, 'seconds')
% s1 = 
% 
% plot(spike.timebase(1:2000), spike.values_d(1:2000))

%% Heart beats from event channel

spike.spikes = round(spikes.times,3);
spike.Sonset = round(stim.times,3);

clear spikes stim
%% MATCH - GET REFERENCE TIMES AND ESTIMATED ROtimes correspondence

% MANUALLY ADD REFERENCE
spike.reftime.trial = '006A';%trial to reference from
spike.reftime.trialidx = 7 ;%corresponding BrainVision index
spike.reftime.BVtime=  '14:20:04'; %from VSDI.list (BVfile time of creation)
spike.reftime.spiketime = '14:02:08'; %time frmo the from spike (setting cursor)
spike.reftime.spike0 = '14:00:22';  %starting time from spike as well

% ... and turn into 'duration' vectors
spike.reftime.BVtime = duration(spike.reftime.BVtime, 'Format','hh:mm:ss');
spike.reftime.spiketime = duration(spike.reftime.spiketime, 'Format','hh:mm:ss');
spike.reftime.spike0 = duration(spike.reftime.spike0, 'Format','hh:mm:ss');
% gap between 
spike.reftime.gap = spike.reftime.BVtime - spike.reftime.spiketime;

for ii= 1:length(ro.times)
spike.match(ii).ROspike = seconds(ro.times(ii)); % absolute seconds

spike.match(ii).BVestim = spike.match(ii).ROspike + spike.reftime.gap;

spike.match(ii).ROspike_h = spike.reftime.spike0 + spike.match(ii).ROspike; % absolute seconds
spike.match(ii).BVestim_h = spike.reftime.spike0 + spike.match(ii).BVestim; 

end

%% MATCH - GET timeinfo from BV files

% 1. GET Original BV files time of creation
    for ii= 1:length(VSDI.trialtime)
    BVtimes_sec(ii) = duration(VSDI.trialtime(ii).hour, 'Format', 'hh:mm:ss')- spike.reftime.spike0; 
    end
    BVtimes_sec = BVtimes_sec';
    BVtimes_sec.Format = 's';
    
% 2. MANUALLY CORRECT: BEFORE MATCHING CHECK FOR INCONGRUENCIES and correct them into the VSDI.trialtime:
    ...check if there is any odd 'iti', or any 'BVtime' that violates the flow of time (i.e., that is earlier than the previous one), and correct the 'time' mismatch from the time in the spike file
    ... skip the non-interest trials (that is, non-recorded trials)
    ... add a new colum/field with 'old_hour' and correct it in the first 'hour' one

% check if there is a missing BV file  
if length(find(diff(VSDI.trialref)==0)) > 0
	disp('"there is at least 1 missing BV file"')

else 
    disp('"there is no missing BV file"')
    
end   

% check if there is any 
    check_idx = [];
    for ti = 2:length(BVtimes_sec)
        if seconds(BVtimes_sec(ti)) < seconds(BVtimes_sec(ti-1))
            check_idx = [check_idx; ti-1];
        end
    end

    if ~isempty(check_idx)
        disp(['"check iti in trials idx:"' makeRow(check_idx)])
    else
        disp('"there is no odd iti"')
    end
    
%     % 2.1. Manually get the new time and correct the VSDI structure
%     correctedtime = '17:05:15'; % @SET get from spike file (spike-referenced); the spike file is the most accurate because the BV time is the time after writing the file and can vary
%     correctedtime = duration(correctedtime, 'Format', 'hh:mm:ss'); 
%     newtime = correctedtime + spike.reftime.gap  % time into BV-reference; copy and manually substitute into VSDI.trialtime.hour (as string) -store old time into VSDI.trialtime.old_hour
% 
    TORus('save', VSDI) 

% 3. AND SUBSTITUTE THE CORRECT VALUES INTO THE BVtimes_sec

    % GET timeinfo from BV files
    for ii= 1:length(VSDI.trialtime)
    BVtimes_sec(ii) = duration(VSDI.trialtime(ii).hour, 'Format', 'hh:mm:ss')- spike.reftime.spike0;
    end
    BVtimes_sec = BVtimes_sec';
    BVtimes_sec.Format = 's';
    
    ...and run again to see if some mismatch remain
            check_idx = [];
            for ti = 2:length(BVtimes_sec)
                if seconds(BVtimes_sec(ti)) < seconds(BVtimes_sec(ti-1))
                    check_idx = [check_idx; ti-1];
                end
            end
    
%% MATCH - MATCHING PROCESS

% For each spike-ROtime, find the closest 
for ii= 1:length(spike.match)
idx= find_closest_timeidx(spike.match(ii).BVestim, BVtimes_sec);
spike.match(ii).BVtrialidx =  idx;
spike.match(ii).BVfiletime = BVtimes_sec(idx);
spike.match(ii).BVref = VSDI.trialref(idx);
end

% Turn into string to easily read 
for ii=1:length(spike.match)
spike.match_str(ii).ROspike= seconds(spike.match(ii).ROspike);
spike.match_str(ii).BVestim= seconds(spike.match(ii).BVestim);
spike.match_str(ii).ROspike_h= datestr(spike.match(ii).ROspike_h);
spike.match_str(ii).BVestim_h= datestr(spike.match(ii).BVestim_h);

spike.match_str(ii).BVtrialidx =  spike.match(ii).BVtrialidx;
spike.match_str(ii).BVref = spike.match(ii).BVref;
spike.match(ii).BVfiletime = seconds(spike.match(ii).BVfiletime);

end

% check whether there is a repeated matched trial:
            check_idx = [];
            for ti = 2:length(spike.match)
                if spike.match(ti).BVtrialidx- spike.match(ti-1).BVtrialidx < 1
                    check_idx = [check_idx; ti-1];
                end
            end
            
    if ~isempty(check_idx)
        disp(['check matched trial with idx (from the spike.match):' num2str( makeRow(check_idx))])
    else
        disp('there is no repeated consecutive trial or in reversed order')
    end


% delete any row from ROspike events without a BV file if needed

%% TRANSFER INTO VSDI.structure so the spike times can be used

for ii = 1:length(spike.match)
trialidx = spike.match(ii).BVtrialidx; 
VSDI.spike.RO(trialidx,1) = round(seconds(spike.match(ii).ROspike),2); %save in the correspondent BVindex
end
VSDI.spike.match = spike.match_str; 
% VSDI matching structure


%% CHECKING - TEST WHETHER THE PRESENCE OF STIMULUS IN SPIKE COINCIDES WITH THE PRESENCE OF STIMULUS IN BRAINVISION
% And whether there are spike trials not recorded on BV

check_trialidx=[];
for ii= 1:makeRow(VSDI.nonanidx)
    % check if there is stimulus in that spike trial
    
    limit1 = spike.Sonset >= VSDI.spike.RO(ii);
    coinc = spike.Sonset== VSDI.spike.RO(ii);
    limit2 = spike.Sonset < VSDI.spike.RO(ii)+2;
    
    spike_idx = find (( limit1 & limit2 )); 
    if ~isempty(spike_idx) && spike_idx > 0
    stim_spike_flag = 1;
    else 
    stim_spike_flag = 0;
    end
    
    % check if there is stimulus according to BrainVision
         stim_BV_flag = VSDI.list(ii).mA ~=0 && ~isnan(VSDI.list(ii).mA );
        
    % if they do not coincide: check index
if stim_spike_flag ~= stim_BV_flag
    check_trialidx=[check_trialidx; ii];
end

clear stim_spike_flag stim_BV_flag
end

%% SAVE SPIKE STRUCTURE
TORus('save',VSDI)
TORus('savespike',spike)

%% COUNTING SPIKES 

% PLOT - individual trial tiles + waves + heart example >> do the three
% fish

% first iti(s) after stimulus onset

%% NOTE THAT ONE OF THE FOLLOWING ISSUES MIGHT HAPPEN:

% that the BVfile is saved just before or after the following trial
% that there can be a spike event without a real BV file (but with no
% missing BVfile, because it was rewritten)
% that there can be any missing BV file

