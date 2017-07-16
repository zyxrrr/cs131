%% Clear all
clc; close all; clc;

%% Load image
img1 = imread('./data/uttower1.jpg');
img2 = imread('./data/uttower2.jpg');

%% Feature detection
[feature1, pyr1, imp1] = detect_features(img1);
pointsInImage1 = feature1(:, 1:2);
pointsInPyramid1 = feature1(:, 8:9);
desc1 = SIFTDescriptor(imp1, pointsInPyramid1, feature1(:,3));

[feature2, pyr2, imp2] = detect_features(img2);
pointsInImage2 = feature2(:, 1:2);
pointsInPyramid2 = feature2(:, 8:9);
desc2 = SIFTDescriptor(imp2, pointsInPyramid2, feature2(:,3));

%% Matching
M = SIFTSimpleMatcher(desc1, desc2);

%% Transformation
maxIter = 200;
maxInlierErrorPixels = .05*size(img1,1);
seedSetSize = max(3, ceil(0.1 * size(M, 1)));
minInliersForAcceptance = ceil(0.3 * size(M, 1));
H = RANSACFit(pointsInImage1, pointsInImage2, M, maxIter, seedSetSize, maxInlierErrorPixels, minInliersForAcceptance);

%% Make Panoramic image
saveFileName = 'uttower_pano.jpg';
PairStitch(img1, img2, H, saveFileName);
disp(['Panorama was saved as uttower_pano.jpg' saveFileName]);
imshow(imread(saveFileName));