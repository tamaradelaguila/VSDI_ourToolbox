function [tMatReal, diffIm] = rasterPermTestCompare(stackCtl,stackExp,allTs,alpha,debug)
% 
% RASTERPERMTESTCOMPARE computes t-statitics for continuous small regions 
% that span the entire data field.  This is the *actual* comparison 
% (control group versus experimental group).  Significance is determined by
% comparing the t-statistic at each site to the input TCUTOFF:
% t-statistics larger than TCUTOFF indicate sites of statistically
% significant difference between control and experimental groups.
% 
% INPUTS:
%
% STACKCTL and STACKEXP are 3D stacks of raster data that contain control
% and experimental data, respectively.
%
% ALLTS is a 3D array of t-statistics (x,t,num_bootstrap_iterations).
% Sites with t-statistics corresponding to <ALPHA will be
% deemed to be sites of statistically significantly difference between the
% control and experimental groups.
%
% DEBUG, when set to 1, plots the output DIFFIM in a new figure window.
%
%
% OUTPUTS:
%
% TMATREAL is the array of t-statistics computed for the comparison of the
% control and experimental groups.
%
% DIFFIM is a 2D array that shows the difference between the average
% experimental and control images, thresholded to show only sites where the
% t-statistic exceeds TCUTOFF.

if nargin==4,
    debug=0;
end

userSettings; % load user settings

% if the input is a cell array, convert the raster stack to a 3D regular array
if iscell(stackCtl),
    stackCtl = rasterCellStackToMatStack(stackCtl);
end
if iscell(stackExp),
    stackExp = rasterCellStackToMatStack(stackExp);
end

[~,tMatReal] = rasterTtestContinuousVarInput(stackCtl,stackExp,N_X_SAM,N_T_SAM); % do the "real" comparison (true CTL versus EXP groups)

% using ALLTS, create an array of t cutoffs (corresponding to ALPHA) for each point
allTs = sort(abs(allTs),3); % sort the array of Ts 
indCutoff = round(size(allTs,3)*alpha); % get the index of the cutoff
TcutoffMat = squeeze(allTs(:,:,end-indCutoff+1)); % the index that is 95% of the way to the end of the list will contain the T value that corresponds to p<0.05

% for each site, mark values as significant that exceed the T threshold
signifMat = abs(tMatReal)>TcutoffMat; % points of *significant* difference are points where the T statistic in the "real" comparison are greater than Tcutoff for that site

diffIm = nanmean(stackExp,3)-nanmean(stackCtl,3); % diffIm will show the difference (EXP-CTL) at each point.
diffIm(~signifMat)=0; % threshold diffIm so that only points with a significant difference are retained

% insert blank rows to identify anatomical boundaries
zeroRows = rasterFindZeroRows(stackCtl(:,:,1)); % find anatomical boundary rows
for i=1:length(zeroRows),
    diffIm(zeroRows(i),:)=0; % set each anatomical boundary row =0, so that anatomical boundary rows are plotted as transparent
    tMatReal(zeroRows(i),:)=0;
end


if debug,
    userSettings
    diffImForPlot = diffIm+0.0000001; % add a tiny offset so that pixels with no difference are plotted as gray and not transparent (white)
    zeroRows = rasterFindZeroRows(stackCtl(:,:,1)); % find anatomical boundary rows
    for i=1:length(zeroRows),
        diffImForPlot(zeroRows(i),:)=0; % set each anatomical boundary row =0, so that anatomical boundary rows are plotted as transparent
    end
    rasterPlotRaster(diffImForPlot,GLO_VARS.frameInterval_ms,GLO_VARS.tStimMS) % plot the result
end


