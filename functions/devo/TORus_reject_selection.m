function [rejectidx] = TORus_reject_selection(VSDI, reject_settings)
% makes the selection of rejected trials according to 'settings'

% setting.manual_reject = 0; %@ SET
% setting.GSmethod_reject = 1;  %@ SET
% setting.GSabsthres_reject = 1; %@ SET
% setting.force_include = 1; %@ SET

rejectidx= [];
% SELECT EXCLUDED

if reject_settings.manual_reject
    rejectidx = [rejectidx  makeRow(VSDI.reject.manual)];
end

if reject_settings.GSabsthres_reject
    rejectidx = [rejectidx  makeRow(VSDI.reject.GSabs025)];
    
end

if reject_settings.GSmethod_reject
    rejectidx = [rejectidx makeRow(VSDI.reject.GSdeviat2sd)];
end

if reject_settings.force_include
    rejectidx = setdiff(rejectidx, VSDI.reject.forcein);
    
end

rejectidx = sort(unique(rejectidx));

end


%% Created: 05/07/21
% Updated: -