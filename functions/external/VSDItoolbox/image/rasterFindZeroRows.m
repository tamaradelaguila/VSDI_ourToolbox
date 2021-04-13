function [rowIndOut, regions] = rasterFindZeroRows(rasterIn)
% find lines that contain only zeros (first will be DG/Hilus boundary, 
% second will be hilus/CA3 boundary, third, if present, will be CA3/CA1 
% boundary).
% 
% From this list of row indices, also return a cell array of indices, REGIONS,
% that bound each region that lies between the row indices.



traceSums = sum(abs(rasterIn),2); % use abs so that nonzero values can't just sum to zero by chance.  operates along dim 2 because, for SUM, dim 1 is columns and dim 2 is rows
rowIndOut=find(traceSums==0); % return indices of rows that contain only zeros

if ~isempty(rowIndOut),
    regions=cell(length(rowIndOut)+1,1); % preallocate
    
    regions{1} = 1:(rowIndOut(1)-1); % first boundary (includes row #1)
    
    if length(rowIndOut)>1,
        for i=2:length(rowIndOut), % middle parts (bounded by two blank rows)
            regions{i}=(rowIndOut(i-1)+1):(rowIndOut(i)-1); % span between the two blank rows
        end
    end
    regions{end} = (rowIndOut(end)+1):size(rasterIn,1);
else
    rowIndOut=[];
    regions={1:size(rasterIn,1)};
end