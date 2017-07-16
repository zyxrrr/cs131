% MOTION_CORR - Computes a set of interest point correspondences
%               between two successive frames in an image
%               sequence.  First, a Harris corner detector is used
%               to choose interest points.  Then, CORR is used to
%               obtain a matching, using both geometric constraints
%               and local similarity of the points' intensity
%               neighborhoods.
%
% Usage:  [p1, p2, a, F] = motion_corr(im1, im2[, OPTIONS])
%
% Arguments:   
%            im1    - an image
%            im2    - another image
% Options:
%            'p1'        - an m x 3 matrix whose rows are
%                          (homogeneous) coordinates of interest
%                          points in im1; if supplied,
%                          this matrix will be returned as p1; it can be
%                          the empty matrix [] (in which case it is as if
%                          they were not supplied)
%            'smoothing' - pre-smoothing before corner detection
%                          (default: 2.0)
%            'nmsrad'    - radius for non-maximal suppression of Harris
%                          response matrix (default: 2)
%            'rthresh'   - relative threshold for Harris response
%                          matrix (default: 0.3)
%            'rthresh2'  - smaller relative threshold used to
%                          search for matches in the second image
%                          (default: rthresh / 2.0)
%            'sdthresh'  - a distance threshold; no matches will be
%                          accepted such that the Sampson distance
%                          is greater than the threshold (default: 1.0)
%            'dthresh'   - a distance threshold; no matches will be
%                          accepted such that the Euclidean
%                          distance between the matched points is
%                          greater than dthresh (default: 30)
%
%   This function also accepts options for CORR.
%
% Returns:
%
%            a      - an m x 1 assignment vector.  a(i) is the index of
%                     the feature of the second image that was matched
%                     to feature i of the first image.  For example,
%                     p1(i, :) is matched to p2(a(i), :).  If feature i
%                     (of the first image) was not matched to any 
%                     feature in the second image, then a(i) is zero.
%            F      - the fundamental matrix used to compute the matching.
%
% See also CORR and HARRIS_PTS.


% Copyright (C) 2002 Mark A. Paskin
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
% USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [p1, p2 , a, F] = motion_corr2(f1,k1,f2,k2,im1,im2, varargin)

% STEP 0: Process options
[p1, ...
 smoothing, ...
 nmsrad, ...
 rthresh, ...
 rthresh2, ...
 sdthresh, ...
 dthresh, ...
 corr_opts] = process_options(varargin, 'p1', [], ...
                                        'smoothing', 2, ...
                                        'nmsrad', 2, ...
                                        'rthresh', 0.3, ...
                                        'rthresh2', nan, ...
			                'sdthresh', 1e-2, ...
			                'dthresh', 30);
if (isnan(rthresh2)) rthresh2 = rthresh / 2.0; end

  
% STEP 2: Form a cost matrix based upon local properties of the
%         interest points.  The cost metric we use here is the sum of
%         squared differences of intensity values in a square
%         neighborhood around the pixels; a hard Euclidean distance
%         threshold is implemented so all point pairs that are too far
%         apart are given infinite cost.

C = make_cost(k1,k2);


p1 = f1(:,1:2); %create homogeneous coordinates 
p2 = f2(:,1:2);
p1(:,3) = 1;
p2(:,3) = 1;


% STEP 3: Compute the correspondence.
[a, F] = corr(p1, p2, C, 'sdthresh', sdthresh, corr_opts{:});



