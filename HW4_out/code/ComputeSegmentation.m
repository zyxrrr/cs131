function segments = ComputeSegmentation(img, k, clusteringMethod, featureFn, ...
                                        normalizeFeatures, resize)
% Compute a segmentation for an image.
%
% First a feature vector is extracted from each pixel of the image. Next a
% clustering algorithm is applied to the set of all feature vectors. Two
% pixels are assigned to the same segment if and only if their feature
% vectors are assigned to the same cluster.
%
% Note that segmenting an image of size w x h involves clustring w*h
% points; this could run very slowly for high resolution images. To improve
% performance in this case, we can segment a shrunk version of the image
% and then use the segmentation of the small image to construct a
% segmentation for the original image. Setting the resize parameter enables
% this optimization.
%
% segments = ComputeSegmentation(img, k, clusteringMethod, featureFn, normalizeFeatures, resize)
%
% INPUTS
% img - An array of pixel data for the image to segment.
% k - The number of segments into which the image should be split.
% clusteringMethod - The method to use for clustering. Must be one of
%                    'kmeans' or 'hac' for k-means or hiehierarchical
%                    agglomerative clustering respectively.
% featureFn - Parameter specifying a handle to a function used to
%             extract features from the image. To create a function handle,
%             prepend a @ to the name of a function like this:
%             @ComputeColorFeatures
% normalizeFeatures - OPTIONAL parameter; if true then NormalizeFeatures
%                     will be used to normalize features after they are
%                     computed.
% resize - OPTIONAL parameter giving the scale to which the image should be
%          resized prior to extracting features and clustering; should be
%          in the range 0 < resize <= 1. Setting this argument to a smaller
%          value will increase the speed of the clustering algorithm but
%          will cause the computed segments to be blockier. This setting is
%          usually not necessary for kmeans clustering, but when using
%          hac clustering this parameter will probably need to be set to
%          a value less than 1.
%
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

    if strcmp(clusteringMethod, 'kmeans')
        clusterFn = @KMeansClustering;
    elseif strcmp(clusteringMethod, 'hac')
        clusterFn = @HAClustering;
    else
        error('method must be one of ''kmeans'' or ''hac''');
    end

    if nargin < 5
        normalizeFeatures = true;
    end
    
    if nargin < 6
        resize = 1;
    end

    
    height = size(img, 1);
    width = size(img, 2);
    
    % Resize the image.
    imgSmall = imresize(img, resize);
    
    % Compute features for the smaller image.
    features = featureFn(imgSmall);
    
    % Maybe normalize the features.
    if normalizeFeatures
        features = NormalizeFeatures(features);
    end
    
    % The features array is of size h x w x f, but the clustering
    % algorithms expect a matrix of points of shape (h*w) x f, so we have
    % to reshape the features array.
    points = reshape(features, [], size(features, 3));
    
    % Apply the clustering algorithm to get an assignment of each point to
    % a cluster.
    idx = clusterFn(points, k);
    
    % The clustering algorithm gives a vector of cluster identities, but we
    % want a rectangular array of the same size as the image so we reshape
    % again.
    idx = reshape(idx, size(features, 1), size(features, 2));
    
    % The image may have been resized prior to clustering, but we want
    % a segmentation of the original image. To fix this we treat the array
    % of cluster identities as an image, and resize it to the size of the
    % original image. For this to work correctly the cluster identities
    % need to be resized using nearest neighbor interpolation.
    idx = imresize(idx, [height, width], 'nearest');
    
    % Conver the array of cluster identities into a more convenient data
    % structure.
    segments = MakeSegments(img, idx);
end