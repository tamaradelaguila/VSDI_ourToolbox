function impolyCellDelete(h)
% recursively delete all impoly objects in the cell array of impoly objects 'h'.

if iscell(h),
    for i=1:length(h),
        impolyCellDelete(h{i})
    end
else
    for i=1:length(h),
        delete(h(i))
    end
end