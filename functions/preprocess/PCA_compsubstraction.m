function [moviePCA, idx_comp] = PCA_reconstruction(movie, idx_comp)
% moviePCA = PCA_1compsubstraction(movie, nComp) performs the substractio

% INPUT
% 'movie'
% 'idx_comp' - idx of components to leave in. For example: idx = [1:15]
% will reconstruct the data with the first 15 components
    
                dim = size(movie); %with 2 first dimensions of pixels, time in the third
                X = reshape(movie, [dim(1)*dim(2) dim(3)]);
                X = X';     

                mu = mean(X);
                [eigenvectors, scores] = pca(X);

                Xhat = scores(:,idx_comp) * eigenvectors(:,idx_comp)';
                Xhat = bsxfun(@plus, Xhat, mu);
                
                Xhat(1,:); 
                
                moviePCA = reshape(Xhat', [dim(1), dim(2) , dim(3)]);
                
                display (['PCA-component reconstruction from components:' num2str(idx_comp))
end

%% Created: 07/12/21