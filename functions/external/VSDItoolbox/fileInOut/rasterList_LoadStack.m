function stackOut = rasterList_LoadStack(listFile,rasterIndex,InnerOuterIndex)
% Given the path to a file that contains a list of raster data files (.mat),
% STACKRASTERS loads the raster specified by rasterIndex and
% InnerOuterIndex from each raster data file.
% 

fid = fopen(listFile);
matFilesToLoad = textscan(fid, '%s'); % a cell array
fclose(fid);

matFilesToLoad = matFilesToLoad{1}; % the first level of textscan's output is a cell; go a level deeper to get the cell array of file names

stackOut = cell(size(matFilesToLoad)); % preallocate output array

for i=1:length(matFilesToLoad),
    
    loadStruct = load(matFilesToLoad{i});
    
    try
        rasters = loadStruct.rasters; % try to load rasters from the specified file
        try
            stackOut{i} = rasters{rasterIndex,InnerOuterIndex}; % try to load the raster for the specified index
            if isempty(rasters{rasterIndex,InnerOuterIndex}),
                disp(['Warning: In file ' matFilesToLoad{i} ', rasters{' num2str(rasterIndex) '}{' num2str(InnerOuterIndex) '} is empty!']) 
            end
        catch
            disp(['Warning: In file ' matFilesToLoad{i} ', index {' num2str(rasterIndex) '}{' num2str(InnerOuterIndex) '} exceeds dimensions of RASTERS cell array.']) 
        end
    catch
        disp(['Warning: File ' matFilesToLoad{i} ' does not contain rasters!  Nothing loaded from this file.'])
    end
    
end