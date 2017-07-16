%% Close all
clc; close all; clear all;

%% Add path
addpath('KeypointDetect');

%% Load image (You should not change the file name.)
img = imread('./data/yard1.jpg');

%% Detect keypoints
[feature, ~, imp] = detect_features(img);

%% Call your implementation of SIFTDescriptor.m
descriptors = SIFTDescriptor(imp, feature(:,8:9), feature(:,3));

%% Load data and check solution (You should not change this part.)
load('./checkpoint/SIFT_ref.mat');
fprintf('%s\n', 'Your error with the reference solution...');
display( sum(sum((descriptors-solution).^2)) );

if sum(sum(descriptors-solution).^2) < 1e-3,
    fprintf('%s\n', 'Accepted!');
else
    fprintf('%s\n', 'There is something wrong.');
end