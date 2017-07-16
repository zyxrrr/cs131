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
%            p1     - an m x 3 matrix whose rows are the
%                     (homogeneous) coordinates of interest points
%                     in im1 (this will be the value given to the 'p1'
%                     option, if it is supplied)
%            p2     - an n x 3 matrix whose rows are the
%                     (homogeneous) coordinates of interest points
%                     in im2
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

function [p1, p2, a, F] = motion_corr(im1, im2, varargin)

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
			                'sdthresh', 1.0, ...
			                'dthresh', 30);
if (isnan(rthresh2)) rthresh2 = rthresh / 2.0; end

'yes this is the right file...'

% STEP 1: Extract interest points in the second image.  Note that
%         this is done with the smaller (or more forgiving)
%         relative threshold.  Later, we will re-threshold to
%         remove those points in im2 that remain unmatched and do
%         not satisfy rthresh (the more selective threshold).
[p2, z2] = harris_pts(im2, 'smoothing', smoothing, ...
		      'nmsrad', nmsrad, 'rthresh', rthresh2);
% If no interest points were provided for the first image, compute them
if (isempty(p1)) 
  p1 = harris_pts(im1, 'smoothing', smoothing, 'nmsrad', nmsrad, ...
		  'rthresh', rthresh);
else
  % Ensure the final coordinates are unity
  p1 = p1 ./ p1(:, [3 3 3]);
end
  
% STEP 2: Form a cost matrix based upon local properties of the
%         interest points.  The cost metric we use here is the sum of
%         squared differences of intensity values in a square
%         neighborhood around the pixels; a hard Euclidean distance
%         threshold is implemented so all point pairs that are too far
%         apart are given infinite cost.
D = disteusq(p1(:, 1:2), p2(:, 1:2), 'xs');
N1 = nbhds(im1, round(p1(:, 2)), round(p1(:, 1)), 5, 5);
N2 = nbhds(im2, round(p2(:, 2)), round(p2(:, 1)), 5, 5);
C = disteusq(double(N1), double(N2), 'x');
C(find(D > dthresh)) = Inf;

% STEP 3: Compute the correspondence.
[a, F] = corr(p1, p2, C, 'sdthresh', sdthresh, corr_opts{:});

% STEP 4: Enforce thresholds.  Keep only those points in the second
%         image that (a) obey the primary relative threshold or (b)
%         are matched with points in the first image.
i = find(a);
k = setdiff(find(z2 >= rthresh * max(z2)), a(i));
p2 = p2([a(i); k], :);
a(i) = 1:length(i);

figure 
imagesc(im1);
colormap gray
hold on
for i=1:size(p1,1)
    plot(p1(i,1),p1(i,2),'g+');
end


for i=1:size(p1,1)
    x = p1(i,1);
    y = p1(i,2);
    if a(i)~=0 
        u = p2(a(i),1)-p1(i,1);
        v = p2(a(i),2)-p1(i,2);
        plot([x x+u],[y y+v],'y');
    end
end

    

figure 
imagesc(im2);
colormap gray
hold on
for i=1:size(p2,1)
    plot(p2(i,1),p2(i,2),'g+');
   
end
