%% COMPUTATION: PERMUTATION + maxpix - Diffmap with p-value based threshold

function stats = perm2D_maxpix(dataA, dataB, nperm, pval)
% 

% INPUT: 
% 'dataA' : frames of condition A, piled in the 3rd dimension
% 'dataB': frames of baseline condition
% 'nperm': n� of permutations. TO-DO: if exceded the number of possible
% combinations, calculate automatically and yield a message advising it

% OUTPUT:
% stats.diffmap
% stats.Tobs
% stats.Tobs_adj


xpix = size(dataA,1); ypix = size(dataA,2); %A and B have the same dimensions
nA = size(dataA,3); nB =  size(dataB,3);

% alphaP = Pmap<p_thresh; % Transparency for the statistical comparisons


% get diffmap and Tobs
diffmap = mean(dataA,3) - mean(dataB,3) ;

Tobs =  diffmap ./ squeeze( sqrt( var(dataA,[],3)/nA + var(dataB,[],3)/nB )); % T observed 

% initialize null hypothesis maps
permmaps = NaN(nperm,xpix,ypix);
max_val = NaN(nperm,2); % "2" for min/max
% for convenience, tf power maps are concatenated (along trial dimension)
data3d = cat(3,dataA, dataB); %concatenated in the 'trials' dimension


% generate maps under the null hypothesis (the null hypothesis here is that
% the two channels have the same activity)
for permi = 1:nperm
    % randomize trials, which also randomly assigns trials to channels
    randorder = randperm(size(data3d,3));
    temp3d = data3d(:,:,randorder); %real data with trial numbers swapt
    % we are computing the same as diffmap but with randomly swapt trials (from
    % the two rois)

    % DIFFMAP (in Tvalues) & CORRECTIONS FOR MULTIPLE COMPARISONS:
    % MAX-PIXEL-BASED THRESHOLDING at the same time
    
    % compute the "difference" T map under the null hypothesis:
    num = squeeze( mean(temp3d(:,:,1:nA),3) - mean(temp3d(:,:,nA+1:end),3) ); 
    denom = squeeze( sqrt( var(temp3d(:,:,1:nA),[],3)/nA + var(temp3d(:,:,nA+1:end),[],3)/nB ));
    permmaps(permi,:,:) = num./ denom; 

    max_val(permi,:) = [ min(min(permmaps(permi,:,:))) max(max(permmaps(permi,:,:))) ];
end


%% STEP:  FIND THRESHOLD FOR LOWER AND UPPER VALUES FOT Tmap
lower_threshold = prctile(max_val(:,1), pval/2*100);
upper_threshold = prctile(max_val(:,2), (1-pval/2)*100);

Tobs_adj = Tobs;
Tobs_adj(Tobs_adj > lower_threshold & Tobs_adj < upper_threshold) = 0; % we delete the central values from the distribution (null hipothesis)

%% STEP: FIND Pmap from corrected Tmap



%% OUTPUT
stats.diffmap= diffmap;
stats.Tobs = Tobs; 
stats.Tobs_adj=Tobs_adj;

end

%% PLOT 3 FRAMES
