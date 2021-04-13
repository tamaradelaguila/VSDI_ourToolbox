function [VSD, BNC, darkFrame, header] = daopen(filename)
%
% Usage: 
% [VSD, BNC, darkFrame, header] = daopen(filename);
%
% DAOPEN reads a RedShirt .da file and returns:
%
% VSD: the optical CCD data [columns rows frameNums].  
%      The camera frame orientation in VSD in Matlab matches 
%      the camera frame orientation in Neuroplex on my rig.
%
% BNC: 8 channels of BNC data
%
% darkFrame: the "Resting Light Intensities" (RLI) frame -- subtracted 
%      from the movie to display traces in Neuroplex.
%
% header: a struct containing all header info from the .da file (frames,
%      columns, rows, frame interval, and acquisitionRatio).
%
% DAOPEN follows this redshirt datasheet: http://www.redshirtimaging.com/support/dfo.html
%
% DAOPEN was written by Elliot Bourgeois,
% last modified 2011-03-08
%

fid = fopen(filename);
if fid==-1 
  disp(['Unable to open ' filename ', file does not exist!']);
  return
end

% process .da file header
headerRaw=fread(fid,2560,'int16');
header.frames=headerRaw(5);
header.columns=headerRaw(385);
header.rows=headerRaw(386);

header.frameInterval_ms=headerRaw(389)/1000;
if header.frameInterval_ms>=10, % this is what the redshirt datasheet says to do: http://www.redshirtimaging.com/support/dfo.html
    frameIntervalDividingFactor=headerRaw(391);
    header.frameInterval_ms=header.frameInterval_ms/frameIntervalDividingFactor;
end

header.acquisitionRatio=headerRaw(392); %ratio of acquisition rates, electrical over optical
if header.acquisitionRatio==0,
    header.acquisitionRatio=1; % this is what the redshirt datasheet says to do: http://www.redshirtimaging.com/support/dfo.html
end

vsdRaw=fread(fid,header.columns*header.rows*header.frames,'int16=>int16');
VSD=shiftdim(reshape(vsdRaw,header.frames,header.columns,header.rows),1);
% VSD=flipdim(permute(VSD,[2 1 3]),2); % Put the movie in the same orientation as you would see it in NeuroPlex: "Permute" does a transpose which results in a diagonal mirror image of the movie.  "flipdim" does a left-to-right mirror image.
VSD=permute(VSD,[2 1 3]); % Put the movie in the same orientation as you would see it in NeuroPlex: "Permute" does a transpose which results in a diagonal mirror image of the movie.  "flipdim" does a left-to-right mirror image.

bncRaw=fread(fid,header.frames*header.acquisitionRatio*8,'int16=>int16'); % *8 because there are always 8 channels of BNC data
BNC=reshape(bncRaw,header.frames*header.acquisitionRatio,8)';

darkRaw=fread(fid,header.columns*header.rows,'int16=>int16');
darkFrame=fliplr(rot90(reshape(darkRaw,header.columns,header.rows),-1));

fclose(fid);