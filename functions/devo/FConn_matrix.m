
function fcM = FConn_matrix(timeser, nodenames, axH)
% devo_FConn_alltrials (timeser, nodelabels)

%% COMPUTES THE CORRELATION MATRIX FROM TIMESERIES (Pearson correlation) AMONG INPUT ROIs AND FOR THE INPUT TIMEWINDOW

% INPUT
% 'TSdata' - timeseries dataset from one trial.
% Timepoints*Rois
% 'nodenames' cell structure with node names

% OUTPUT
% 'fcM' - connectivity matrix for all trials (roi*roi*trial)


% input control
if nargin == 3
    flagaxis = 1;
    ploton = 1;
elseif  nargin == 2
    flagaxis = 0;
    ploton = 1;
elseif nargin == 1
    flagaxis = 0;
    ploton = 0;
end
% end of input control


n = size(timeser,2);


fcM = NaN(n, n);
% Construct Trial-wise correlation matrices
for node1 = 1:n
    for node2 = 1:n
        % adjM(roi1,roi2, trialidx) = corr (sel_data(1:680,roi1,trialidx), sel_data(1:680,roi2,trialidx));
        fcM (node1,node2) = corr(timeser(:,node1), timeser(:,node2));
    end % roi1
end % roi2

% Turn to zero diagonal values
for k = 1:n
    fcM(k,k) =0;
end %k

if ploton
    ax1 = imagesc(fcM);
    axis square
    colormap(parula)
    colorbar
    set(gca, 'clim' ,[-1 1])
    xticks(1:n)
    xticklabels (nodenames); xtickangle(90)
    yticks(1:n)
    yticklabels (nodenames)
    if flagaxis
        linkprop([axH ax1],'Position');
    end
end %if ploton



end

%% Created: 27/07/21 from Gent's funtion