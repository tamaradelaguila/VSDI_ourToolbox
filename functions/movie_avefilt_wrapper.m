function [ave, hist] = movie_avefilt_wrapper(movies4D, trialsidx, filtermode, filterset)
% movieave_filt_wrapper(movies4D, idx, filt_mode, filtset) averages the
% trials selected from the input movie according to the set of filters
% defined by 'filtermode' and the filtersettings

% INPUT:
% 'movies4D' (x*y*time*trials)
% 'trialsidx' - idx of all trials in movies4D to average across
% 'filtermode': character string: 'filt1', ---
% 'filterset': structure with fields with parameter settings. if one is not
% present, a default value will apply

% OUTPUT:
% 'ave' : averaged movie
% hist - structure with history of filters applied

% 'filt1': Tcnst, Spatial, Median, Cubic
%

% 'filterset' (default values:
    % filterset.Tcnst = 10 (from 1 to 10)
    %filterset.meanpix = 3
    % filterset.medianpix= 3

    % INPUT CONTROL
    if ~exist('filterset')
    filterset.Tcnst = 10;
    filterset.meanpix = 3;
    filterset.medianpix= 3;

    else
        if ~isfield(filterset,'Tcnst')
            filterset.Tcnst = 10;
        end
   
        if ~isfield(filterset,'meanpix')
            filterset.meanpix = 3;
        end
       
        if ~isfield(filterset,'medianpix')
            filterset.medianpix = 3;
        end
    end
    % end of input control
       
movie_ave = mean(movies4D(:,:,:,trialsidx),4);

switch filtermode
   
    case 'filt1'
       
    filtmov1 = NaN(size(movie_ave));
    filtmov2 = NaN(size(movie_ave));
    filtmov3 = NaN(size(movie_ave));
    filtmov4 = NaN(size(movie_ave));

       
    % 1.1. Tcnst
    filtmov1 = filter_Tcnst(movie_ave,filterset.Tcnst);

    % 1.2. Spatial Filter (mean)
    filtmov2 = filter_spatial(filtmov1, filterset.meanpix);

    % 1.3. Median spatial filter
    filtmov3 = filter_median(filtmov1, filterset.medianpix);

    % 1.4. Cubic filter
    filtmov4 = filter_cubicBV(filtmov1);
   
    % Output of the function
    ave = filtmov4;
   
    % Info about filters applied
    hist.filters{1,1} = strcat('ave=',num2str(length(trialsidx)));
    hist.filters{2,1} = strcat('tcnst =', num2str(filterset.Tcnst));
    hist.filters{3,1} = strcat('spatialmean = 9', num2str(filterset.meanpix));
    hist.filters{4,1} = strcat('median = 3',num2str(filterset.medianpix));
    hist.filters{5,1} = 'cubicBV';
    hist.filters{6,1} = strcat('trials:',num2str(trialsidx));

end

%% Created: 25/02/21


