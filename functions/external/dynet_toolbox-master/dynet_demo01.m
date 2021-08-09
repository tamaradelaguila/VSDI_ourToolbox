%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Brief tutorial of dynet_toolbox
%
% Last update 22.10.2019
%--------------------------------------------------------------------------
% INVOKED FUNCTIONs
% free.m; dynet_sim.m; review.m; dynet_ar2pdc.m; dynet_connplot.m; 
% dynet_SSM_KF.m; dynet_SSM_STOK.m; roc_auc.m
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%  Initializing

% I1) Add the path containing the folder "dynet_toolbox" 

mypath     = ['C:\Users\User\Documents\UGent_brugge\functions\toolboxes\dynet_toolbox-master'];
p          = genpath(mypath);
addpath(p)

% I2) Clear everything

free

%% Simulation

% S1) Simulate surrogate data with default network settings 
% (type 'help dynet_sim' for customizing) 

sim        = dynet_sim(10,200,2,5,.6,3,400,5,0);

% S2) Review the main properties of the simulated network

review(sim)

% S3) Compute and visualize the ground truth PDC obtained directly from the 
% true tvMVAR data-generating process (here squared-PDC, column norm)

gt_PDC     = dynet_ar2pdc(sim,sim.srate,sim.frange','sPDC',0,[],1);
dynet_connplot(gt_PDC,sim.time,sim.frange',[],[],[],sim.FC,1)

% note: in the diagonal the parametric MVAR-derived PSD, scaled to the
%       range of off-diagonal PDC values for graphical purpose;
%       cells framed in red are open (existing) functional connections

%% Adaptive Filtering

% AF1) Apply the general Linear Kalman Filter (canonical c=0.02) & compute
% sPDC

KF         = dynet_SSM_KF(sim.Y,sim.popt,0.02);
kf_PDC     = dynet_ar2pdc(KF,sim.srate,sim.frange,'sPDC',[],[],1);
dynet_connplot(kf_PDC,sim.time,sim.frange,[],[],[],sim.FC,1)
sgtitle('gKF') % only with >MATLAB R2019a

% AF2) Apply the STOK filter & compute sPDC

SK         = dynet_SSM_STOK(sim.Y,sim.popt);
sk_PDC     = dynet_ar2pdc(SK,sim.srate,sim.frange,'sPDC',[],[],1);
dynet_connplot(sk_PDC,sim.time,sim.frange,[],[],[],sim.FC,1)
sgtitle('STOK') % only with >MATLAB R2019a

%% Comparison

% C1) Compare the two algorithms with ROC analysis

figure()
auc_kf     = roc_auc(gt_PDC,kf_PDC,20,1);
hold on
auc_sk     = roc_auc(gt_PDC,sk_PDC,20,1);
legend('gKF','','STOK')
disp(['AUC results: KF = ' num2str(auc_kf) ' STOK = ' num2str(auc_sk)])


%% TRY DEMO IN MY DATA

free
nfish = 2;
[VSDI, TSroi] =loadfish(nfish);

% Input to the algorithm

% select cases: 
excluded = union(VSDI.reject.GStotal, VSDI.reject.sharks); excluded = union(excluded, VSDI.reject.absthresh); 
c2_idx = intersect(find(VSDI.condition ==2), VSDI.trials_in); 
c2_idx = setdiff(c2_idx, excluded);

c0_idx = intersect(find(VSDI.condition ==0), VSDI.trials_in); 
c0_idx = setdiff(c0_idx, excluded);
popt = 6;
srate = 166;
frange = 1:100; frange = frange';

%condition 2
Yc2 = permute(TSroi.datap10(1:680,[3 4 5 6 7 8 9 10 15 16],c2_idx), [3,2,1]);

SKc2 = dynet_SSM_STOK(Yc2,popt);
sk_PDCc2 = dynet_ar2pdc(SKc2,srate,frange,'sPDC',[],[],1);
% dynet_connplot(sk_PDCc2,VSDI.timebase,frange,[],[],[],[],0)

%condition 0
Yc0 = permute(TSroi.datap10(1:680,[3 4 5 6 7 8 9 10 15 16],c0_idx), [3,2,1]);

SKc0 = dynet_SSM_STOK(Yc0,popt);
sk_PDCc0 = dynet_ar2pdc(SKc0,srate,frange,'sPDC',[],[],1);
% dynet_connplot(sk_PDCc0,VSDI.timebase,frange,[],[],[],[],0)

sk_PDCdiff = zeros(size(sk_PDCc0));
for nn= 1:10
    for m = 1:10
       sk_PDCdiff(nn,m,:,:) = sk_PDCc2(nn,m,:,:) - sk_PDCc0(nn,m,:,:); 
    end
end
% dynet_connplot(sk_PDCdiff,VSDI.timebase,frange,[],[],[],[],0)
sgtitle(['STOK_ difference between conditions (', num2str(VSDI.ref),')']) % only with >MATLAB R2019a
 
clear excluded c2_idx c0_idx Yc2 Yc0 SKc2 SKc0 sk_PDCc2 sk_PDCc0 sk_PDCdiff

PDCmean_diff = squeeze(mean(PDCall_diff, 1)); 
dynet_connplot(PDCmean_diff,VSDI.timebase,frange,[],[],[],[],0)
sgtitle(['STOK_ difference between conditions (mean of all subjects)']) % only with >MATLAB R2019a

%% TRY DEMO IN MY DATA

free
for nfish = 2:7
[VSDI, TSroi] =loadfish(nfish);

% Input to the algorithm

% select cases: 
excluded = union(VSDI.reject.GStotal, VSDI.reject.sharks); excluded = union(excluded, VSDI.reject.absthresh); 
c2_idx = intersect(find(VSDI.condition ==2), VSDI.trials_in); 
c2_idx = setdiff(c2_idx, excluded);

c0_idx = intersect(find(VSDI.condition ==0), VSDI.trials_in); 
c0_idx = setdiff(c0_idx, excluded);
popt = 6;
srate = 166;
frange = 1:100; frange = frange';

%condition 2
Yc2 = permute(TSroi.datap10(1:680,[3 4 5 6 7 8 9 10 15 16],c2_idx), [3,2,1]);

SKc2 = dynet_SSM_STOK(Yc2,popt);
sk_PDCc2 = dynet_ar2pdc(SKc2,srate,frange,'sPDC',[],[],1);
% dynet_connplot(sk_PDCc2,VSDI.timebase,frange,[],[],[],[],0)

%condition 0
Yc0 = permute(TSroi.datap10(1:680,[3 4 5 6 7 8 9 10 15 16],c0_idx), [3,2,1]);

SKc0 = dynet_SSM_STOK(Yc0,popt);
sk_PDCc0 = dynet_ar2pdc(SKc0,srate,frange,'sPDC',[],[],1);
% dynet_connplot(sk_PDCc0,VSDI.timebase,frange,[],[],[],[],0)

sk_PDCdiff = zeros(size(sk_PDCc0));
for nn= 1:10
    for m = 1:10
       sk_PDCdiff(nn,m,:,:) = sk_PDCc2(nn,m,:,:) - sk_PDCc0(nn,m,:,:); 
    end
end
PDCall_c2(nfish,:,:,:,:) = sk_PDCc2;
PDCall_c0(nfish,:,:,:,:) = sk_PDCc0;
PDCall_diff(nfish,:,:,:,:) = sk_PDCdiff;
% dynet_connplot(sk_PDCdiff,VSDI.timebase,frange,[],[],[],[],0)
sgtitle(['STOK_ difference between conditions (', num2str(VSDI.ref),')']) % only with >MATLAB R2019a
 
clear excluded c2_idx c0_idx Yc2 Yc0 SKc2 SKc0 sk_PDCc2 sk_PDCc0 sk_PDCdiff
end %nfish

PDCmean_diff = squeeze(mean(PDCall_diff, 1)); 
dynet_connplot(PDCmean_diff,VSDI.timebase,frange,[],[],[],[],0)
sgtitle(['STOK_ difference between conditions (mean of all subjects)']) % only with >MATLAB R2019a

%% Last Update: 25/11/20