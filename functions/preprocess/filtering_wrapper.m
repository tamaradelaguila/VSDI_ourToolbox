function VSDmov = filtering_wrapper(inputVSDmov, outputref, functionlist, params)
% outputVSDmov = filtering_wrapper(inputmovie, outputref, functionlist,
% params) will apply the filters in the order of functionlist; it will need
% the params asked for contained in params

movie = inputVSDmov.data ;

VSDmov.ref = outputref;
VSDmov.hist = inputVSDmov.hist;

ntrials = size(movie, 4);
%

for apply = functionlist
    
    switch apply
        % ----------------------------
        case 'filter_spatial2'
            % ----------------------------
            
            
            try isfield(params, 'filter_spatial2')
                pix = params.filter_spatial2;
            catch
                warning('A P value for thefilter_spatial2 filter was not provided; it will be set to 3pix');
                pix = 3;
            end
            % end of input control
            % ---------------------
            
            
            filtmov = movie;
            for triali = 1:ntrials
                tempmov = movie;
                filtmov(:,:,:,triali) = filter_spatial(tempmov, pix);
                clear tempmov
            end
            
            movie = filtmov;
            VSDmov.hist{length(VSDmov.hist)+1,1} = ['spatialmean = ' num2str(pix)]; %@ SET
            
            % ----------------------------
        case 'filter_Tcnst'
            % ----------------------------
            
            % VSDmov.hist{length(VSDmov.hist)+1,1} = ['tcnst =' num2str(tcnst)]; %@ SET
            
            % ----------------------------
        case 'filtermedian'
            % ----------------------------
            
            % VSDmov.hist{length(VSDmov.hist)+1,1} = ['median =' num2str(medianpix)]; %@ SET
            
    end % switch
    
    
end % for apply

% Save the completely filtered movie
VSDmov.data = movie;

end
