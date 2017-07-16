function idx = ReindexClusters(idx)
% Utility function to reindex an array of cluster identities from 1 to the
% number of clusters.
%
% For example, if
%
% idx = [2, 1, 5, 5, 10]
%
% then 
%
% ReindexClusters(idx) = [2, 1, 3, 3, 4]
%
% INPUTS
% idx - A vector giving assignments of points to clusters.
%
% OUTPUTS
% idx - The same vector but reindexed as described above.

    u = unique(idx);
    oldIdx = idx;
    idx = zeros(size(idx));
    for i = 1:length(u)
        idx(oldIdx == u(i)) = i;
    end
end