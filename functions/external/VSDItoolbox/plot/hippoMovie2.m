function [mov] = hippoMovie2(Dthresh,imBg,dFoverFmax,colorMap,debug)
%
% HIPPOMOVIE2 converts a 3-dimensional VSD dataset (x,y,t) into a 
% pseudocolor movie MOV.  The input DTHRESH should be thresholded to set
% all values below the noise threshold to zero.
%

if nargin==4,
    debug=0;
end

szD = size(Dthresh);

Dvect = single(Dthresh(:)); %vectorize the movie to make array logic compute faster

% convert background image to a 0 to 1 grayscale image (RGB arrays are 0 to 1, and that's where we're headed)
imBg=mat2gray(imBg);

bgV = single(repmat(imBg(:),szD(3),1)); % make a vector containing the background, repeated #movie_frames times
bgV(Dvect~=0)=0; % get rid of the background image everywhere the voltage data is suprathreshold

% % shift dF/F values toward zero so the sub-threshold values don't eat up the whole colormap
% depolMin = min(Dvect(Dvect>0));
% hyperpolMin = max(Dvect(Dvect<0));
% 
% if debug>0, % regular debug mode - display lower bounds of colormap indexing
%     disp(['depolMin = ' num2str(depolMin)]);
%     disp(['hyperpolMin = ' num2str(hyperpolMin)]);
% end


pseudoColors=single(Dvect); % save some memory by using single precision
% pseudoColors(Dvect>0)=Dvect(Dvect>0)-depolMin;
% pseudoColors(Dvect<0)=Dvect(Dvect<0)-hyperpolMin-0.00000000001; % depol and hyperpol can't share the same zero value, so shift the zero point for hyperpol every-so-slightly


pseudoColors=pseudoColors/(dFoverFmax)/2; % scale voltages so that dF/F max range spans a range from -.5 to +.5
% pseudoColors(Dvect~=0)=pseudoColors(Dvect~=0)+0.5; % shift nonzero values to set 0.5 = resting membrane potential (but we want to maintain the definition of 0==within bounds of "no activity")
pseudoColors = pseudoColors+0.5; % shift the dataset so that the middle value, 0.5, corresponds to dF/F=0

if debug>1, % super debug mode - plot things
    figure(11)
    plot(bgV,'k')
    hold on
    plot(pseudoColors)
    hold off
end

% colorMapBlue=jet(256+150);
% colorMapBlue=colorMapBlue(1:128,:);
% colorMapRed=jet(256+80);
% colorMapRed=colorMapRed(end-127:end,:);
% colorMap=[colorMapBlue ; colorMapRed];
% size(colorMap)

% load('colormapPurpleGrayRed.mat','myCmap')
% colorMap = myCmap;

% get color codes for pixels with non-resting Vm
%pseudoRGB=ind2rgb(gray2ind(pseudoColors,256),jet(256));
pseudoRGB=single(ind2rgb(gray2ind(pseudoColors,256),colorMap));
pseudoR=pseudoRGB(:,1);
pseudoG=pseudoRGB(:,2);
pseudoB=pseudoRGB(:,3);
clear pseudoColors pseudoRGB % save memory by deleting redundant copy of this data

% the jet colormap actually uses "0" as a code for a blueish hue.  DVECT is used to determine which datapoints aren't active here, because all the shifting we did made "0" look like a valid hyperpolarizing voltage.
pseudoR(Dvect==0)=1;
pseudoG(Dvect==0)=1;
pseudoB(Dvect==0)=1;

red = reshape(pseudoR,szD(1),szD(2),szD(3));
clear pseudoR
green = reshape(pseudoG,szD(1),szD(2),szD(3));
clear pseudoG
blue = reshape(pseudoB,szD(1),szD(2),szD(3));
clear pseudoB
bg = reshape(bgV,szD(1),szD(2),szD(3)); % background array for movie output
clear bgV

mov = single(cat(4,red+bg,green+bg,blue+bg));
mov = permute(mov,[1 2 4 3]); % make movie [x,y,color,time]

