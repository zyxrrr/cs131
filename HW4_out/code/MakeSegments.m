function segments = MakeSegments(img, idx)
% Use the cluster assignments for each pixel in an image to create a data
% structure describing the computed segments.
%
% INPUTS
% img - The original image; an array of size w x h x 3
% idx - Cluster identities for the image. idx(i, j) = c means that the
%       pixel img(i, j, :) is assigned to cluster c.
%
% OUTPUTS
% segments - A struct array with one element for each cluster.
%            segments(c) is a struct describing segment number c and has
%            the following fields:
%
%     .img  - An array of size h x w x 3 containing image data for the cth
%             cluster.
%     .mask - A logical array of size h x w where mask(i, j) = 1 if
%             img(i, j, :) is part of cluster c.

    labels = unique(idx);
    
    segments = repmat(struct('img', [], 'mask', []), 1, length(labels));
    
    for i = 1:length(labels)
        mask = (idx == labels(i));
        segments(i).mask = mask;
        segments(i).img = MaskImage(mask, img);
    end
end