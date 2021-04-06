function [] = inspect_allbackgrounds(backgrounds)

n = size(backgrounds,3);

block_idx = makeblocks_inrows(1:n, 25);
nfig= size(block_idx,1); %as many figures as rows of 25 trials

for figi = 1:nfig%one figure every 25 backs
   figure
    for ploti = 1:25
        if ~isnan(block_idx(figi, ploti))
        subplot(5,5,ploti)
        imagesc(backgrounds(:,:,block_idx(figi, ploti)));
        colormap(bone)
        title(['trial:',num2str(block_idx(figi, ploti))])
        end
    end
    
end

end

function [blocks] = makeblocks_inrows(vector, n_items)
% divides the vector in rows of n_items
n = length(vector);

nrows= ceil(n/n_items);

if n/n_items ~= round(n/n_items)
    vector(n+1:nrows*n_items) = NaN;
end

blocks = reshape(vector,[n_items nrows])'; % although inside reshape the nrows in in the column dimension, note that it is later transposed

end

%% Created: 01/04/2021