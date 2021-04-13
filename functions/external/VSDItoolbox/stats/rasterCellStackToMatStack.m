function rasterMatStack = rasterCellStackToMatStack(rasterCellArray)
% given a 1-D cell array RASTERCELLARRAY, where each cell contains a raster
% of the same size, RASTERCELLSTACKTOMATSTACK returns a regular 3D matrix,
% with dimensions [rasterSpatialDimension, rasterTemporalDimension, rasterNumber].

rasterSz = size(rasterCellArray{1});
nRasters = length(rasterCellArray);

rasterMatStack = zeros(rasterSz(1),rasterSz(2),nRasters); % preallocate

for i=1:nRasters,
    rasterMatStack(:,:,i) = rasterCellArray{i};
end
