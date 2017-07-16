%% Clean up
close all; clear all; clc;

%% Read data
template = imread('./data/template.jpg');
imgList = dir('./data/starbucks*.jpg');

%% Sliding window search
img = imread('./data/starbucks4.jpg');
% Box = SlideWindowDetector(template, img, (@HistIntersectDist), true); % Histogram intersection distance
% Box = SlideWindowDetector(template, img, (@ChiSquareDist), false); % Chi squared
Box = SlideWindowDetector(template, img, (@SpatialPyramidDist), true); % Spatial pyramid

%% Visualize result
VisualizeBox(img, Box);