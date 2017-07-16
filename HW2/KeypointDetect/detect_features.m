
%/////////////////////////////////////////////////////////////////////////////////////////////
%
% detect_features - scale space feature detector based upon difference of gaussian filters.
%                 selects features based upon their maximum response in scale space
%
% Usage:  [features,pyr,imp,keys] = detect_features(img, scl, disp_flag, thresh, radius, radius2, radius3, min_sep, edgeratio)
%
% Parameters:  
%            
%            img :      original image
%            scl :      scaling factor between levels of the image pyramid
%            thresh :   threshold value for maxima search (minimum filter response considered)
%            radius :   radius for maxima comparison within current scale
%            radius2:   radius for maxima comparison between neighboring scales
%            radius3:   radius for edge rejection test
%            min_sep :  minimum separation for maxima selection.
%            edgeratio: maximum ratio of eigenvalues of feature curvature for edge rejection.
%            disp_flag: 1- display each scale level on separate figure.  0 - no display
%
% Returns:
%
%            features  - matrix with one row for each feature, containing:
%              [x position in original image,  y position in original image, scale(sub-level), 
%                   size of feature on image, edge flag, edge orientation, 
%                   curvature of response through scale space, x position in the keypoint's pyramid level, 
%                   y position in the keypoint's pyramid level ]                              
%               so in other words, imp{scale}(y,x) is the center pixel
%
%            pyr, imp -  filter response and image pyramids
%            keys - key values generated for each feature by construct_key.m
%
% Notes: 
%            recommended parameter values are:
%            scl = 1.5; thresh = 3;   radius = 4; radius2 = 4; radius3 = 4; min_sep = .04; edgeratio = 5;
%
% Author: 
% Scott Ettinger
% scott.m.ettinger@intel.com
% May 2002
%
%
% Modified by:
% Jiayuan Ma
% September 2013
%
%/////////////////////////////////////////////////////////////////////////////////////////////

function [features, pyr, imp]  = detect_features(img, scl, disp_flag, thresh, radius, radius2, radius3, min_sep, edgeratio)

    if ~exist('scl', 'var')
        scl = 1.5;
    end
     
    if ~exist('thresh', 'var')
        thresh = 3;
    end
    
    if ~exist('radius', 'var')
        radius = 4;
    end
    
    if ~exist('radius2', 'var')
        radius2 = 4;
    end

    if ~exist('radius3', 'var')
        radius3 = 4;
    end
    
    if ~exist('min_sep', 'var')
        min_sep = .04;
    end

    if ~exist('edgeratio', 'var')
        edgeratio = 5;
    end
    
    if ~exist('disp_flag', 'var')
        disp_flag = 0;
    end

    if size(img,3) > 1
        img = rgb2gray(img);
    end
    
    % Computation of the maximum number of levels:
    Lmax = floor(min(log(2*size(img)/12)/log(scl)));
    
    % Build image pyramid and difference of gaussians filter response pyramid
    [pyr,imp] = build_pyramid(img,Lmax,scl);  
    
    % Get the feature points
    pts = find_features(pyr,img,scl,thresh,radius,radius2,disp_flag,1);

    %classify points and create sub-pixel and sub-scale adjustments 
    [features, ~] = refine_features(img,pyr,scl,imp,pts,radius3,min_sep,edgeratio);
end