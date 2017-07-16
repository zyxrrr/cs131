%% Clear all
clc; close all; clc;
%% Add path
addpath('KeypointDetect');
%% Load image
img1 = imread('./data/uttower2.jpg');
img2 = imread('./data/uttower1.jpg');

%% Feature detection
[feature1, pyr1, imp1] = detect_features(img1);
pt1disp = feature1(:,1:2);
pt1 = feature1(:, 8:9);
desc1 = SIFTDescriptor(imp1, pt1, feature1(:,3));

[feature2, pyr2, imp2] = detect_features(img2);
pt2disp = feature2(:,1:2);
pt2 = feature2(:, 8:9);
desc2 = SIFTDescriptor(imp2, pt2, feature2(:,3));

%% Test Matcher
M = SIFTSimpleMatcher(desc1, desc2);

%% Visualize match
PlotMatch(im2double(img1), im2double(img2), pt1disp', pt2disp', M');
