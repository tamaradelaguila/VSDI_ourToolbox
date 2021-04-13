function colorRasterOut = colorizeRaster(rasterIn)

load('colormapPurpleGrayRed.mat','myCmap') % COLOR colormap for hippoMovie
% load('colormapBlackAndWhite.mat','myCmap') % BLACK AND WHITE colormap for hippoMovie

fakeMov=cat(3,rasterIn,rasterIn); % make a 2 frame "movie" to make hippoMovie happy
[prettyMov] = hippoMovie2(fakeMov,zeros(size(rasterIn)),0.00125,myCmap);
colorRasterOut=squeeze(prettyMov(:,:,:,1));
        