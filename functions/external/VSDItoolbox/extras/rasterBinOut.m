function rasterBinOut(rasterIn,fnameOut,debug)
%
% Syntax: rasterBinOut(rasterIn,fnameOut,debug)
%
% RASTERBINOUT writes RASTERIN to a binary file FILEOUT with 
% precision double.  If DEBUG=1, RASTERBINOUT provides suggested
% settings for use with pClamp's binary file importer.

if nargin==2,
    debug=0;
end

userSettings; % used to get the camera frame interval

fid=fopen(fnameOut,'w'); % get a pointer to the filename for writing

rasterT=rasterIn'; % transpose so that the first dimension is time and the 2nd dimension is space
fwrite(fid,rasterT(:),'double'); % write the raster as a 1-D vector (march through row 1, then through row 2...)
fclose(fid); % close the file after writing

if debug, % display tips for importing data to pClamp, if the user asked for this info
    disp('Settings for pClamp binary importer:')
    disp('    Data Type: Double')
    disp('    Acquisition Mode: Fixed-Length Sweeps')
    disp(['    Sampling interval per sig: ' num2str(GLO_VARS.frameInterval_ms*1000) ]) % convert camera frame rate (in ms) to a number in microseconds
    disp('    Sweeps to convert: All')
    disp(['    Samples per signal: ' num2str(size(rasterIn,2)) ])
end

