% Read the input images. 
img = imread('../imgs/cat_mouse.jpg');
img = imread('../imgs/black_kitten.jpg');
background = imread('../imgs/backgrounds/beach.jpg');

% Choose the number of clusters and the clustering method.
k = 10;
clusteringMethod = 'kmeans';

% Choose the feature function that will be used. The @ syntax creates a
% function handle; this allows us to pass a function as an argument to
% another function.
featureFn = @ComputePositionColorFeatures;
featureFn = @ComputeColorFeatures;
% Whether or not to normalize features before clustering.
normalizeFeatures = true;

% Whether or not to resize the image before clustering. If this script
% runs too slowly then you should set resize to a value less than 1.
resize = 1.0;

% Use all of the above parameters to actually compute a segmentation.
segments = ComputeSegmentation(img, k, clusteringMethod, featureFn, ...
                               normalizeFeatures, resize);

% Use the graphical interface to transfer a subset of the selected segments
% to the background image.
[~, compositeImg] = ChooseSegments(segments, background);

% Save the composite image.
imwrite(compositeImg, 'GrabCat.jpg', 'JPG');