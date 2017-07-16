% FMRANSAC_TEST
%
% This script demonstrates the use of the RANSAC algorithm (in
% combination with local information) for inducing point
% correspondences between two images of the same scene.
%
% First, an image with corners is created.  Then, the Harris corner
% detector is used to compute a set of interest points.  Next, both
% the image and the feature points are passed through a projective
% transformation in order to create a new image with the same feature
% points as the first (and thus, a known correspondence).
%
% Then the following steps are performed to match the points
% (without knowledge of the actual correspondence).  First, a crude
% matching is obtained by using feature keys that characterize the
% local neighborhood of each interest point.  Then, RANSAC is used
% on this set of matches to exclude incorrect matches and generate
% an estimate of the fundamental matrix that relates the two sets
% of points.  Finally, the fundamental matrix is used to match the
% original set of interest point.

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

clear p im hc hcm hcmf hcmfi;

% Play with these parameters:
keytype = 2;    % The type of feature key to use
gdorder = 4;    % The highest order Gaussian derivative filters to use
gdsigma = 5;    % The standard deviation of the Gaussian derivatives
steer = 0;      % Steer filters in gradient direction for rotational invariance

% Create an image with lots of "inside" and "outside" corners in it
im1 = corners('prob', 0.5);
[ny, nx] = size(im1);
if 0
% Transform the image twice
T = maketform('projective', ...
	       [0 0; ny 0;      ny nx;     0 nx], ...
	       [0 0; ny 0.3*nx; ny 0.7*nx; 0 nx]);
im2 = imtransform(im1, T, 'FillValues', 255);
else
    im2 = affine(im1, pi/2, 1, 1, 0, 0, nx/2, ny/2);
end

% Run the Harris corner detector on both images
p1 = harris_pts(im1, 'smoothing', 1.0, 'nmsrad', 2, 'relthresh', 0.1);

% Project the corners in the first image through the transformation
p2 = fliplr(tformfwd(fliplr(p1), T));

% Compute the feature keys
switch keytype
 case 0
  % Test: this should be perfect
  W = -diag(ones(1, size(p1, 1)));
 case 1
  K1 = nfdkeys(p1, 'k', 20, 'sd', 10, 'ss', pi/20);
  K2 = nfdkeys(p2, 'k', 20, 'sd', 10, 'ss', pi/20);
  W = -real(K1 * K2');
 case 2
  F = gdfilters(gdorder, gdsigma);
  f = cat(3, F{:});
  K1 = fkeys(im1, round(p1), f, 'steer', steer);
  K2 = fkeys(im2, round(p2), f, 'steer', steer);
  % Compute an affinity matrix
  W = disteusq(K1, K2, 'x', inv(cov([K1; K2])));
end

% Obtain an initial set of matches using local information.  Only
% some of these will be correct.
a = match(W);
b = find(a);
s = length(b);
q1 = [p1(b, [2 1]), ones(s, 1)];
q2 = [p2(a(b), [2 1]), ones(s, 1)];
% Plot the matching
subplot(3, 2, 1);
imagesc(im1); colormap(gray); axis image; axis off; hold on;
correct = find(a' == 1:length(a));
incorrect = find(a' ~= 1:length(a));
text(q1(incorrect, 1), q1(incorrect, 2), int2str(incorrect'), ...
     'Color', 'r', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
text(q1(correct, 1), q1(correct, 2), int2str(correct'), ...
     'Color', 'b', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
title('Local matches (blue=correct;red=incorrect)');
hold off;
subplot(3, 2, 2);
imagesc(im2); colormap(gray); axis image; axis off; hold on;
text(q2(incorrect, 1), q2(incorrect, 2), int2str(incorrect'), ...
     'Color', 'r', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
text(q2(correct, 1), q2(correct, 2), int2str(correct'), ...
     'Color', 'b', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
title(sprintf('Local matches (%d/%d correct)', ...
	      sum(a' == 1:size(p1, 1)), ...
	      size(p1, 1)));
hold off;

% Run RANSAC to obtain the final matching
[F, k] = fmransac(q1, q2, 'numpairs', 7, 'conf', 0.9, ...
		  'maxsamples', 10000);
correct = find(a(b(k)) == b(k));
incorrect = find(a(b(k)) ~= b(k));

% Plot the matching
subplot(3, 2, 3);
imagesc(im1); colormap(gray); axis image; axis off; hold on;
text(q1(k(incorrect), 1), q1(k(incorrect), 2), int2str(k(incorrect)), ...
     'Color', 'r', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
text(q1(k(correct), 1), q1(k(correct), 2), int2str(k(correct)), ...
     'Color', 'b', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
title('RANSAC matches (blue=correct;red=incorrect)');
hold off;
subplot(3, 2, 4);
imagesc(im2); colormap(gray); axis image; axis off; hold on;
text(q2(k(incorrect), 1), q2(k(incorrect), 2), int2str(k(incorrect)), ...
     'Color', 'r', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
text(q2(k(correct), 1), q2(k(correct), 2), int2str(k(correct)), ...
     'Color', 'b', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
title(sprintf('RANSAC-matches (%d/%d correct)', ...
	      sum(a(b(k)) == b(k)), ...
	      size(k, 1)));
hold off;

% Finally, use the estimated fundamental matrix to search for
% matches.
q1 = [p1(:, [2 1]), ones(size(p1, 1), 1)];
q2 = [p2(:, [2 1]), ones(size(p2, 1), 1)];
a = fmmatch(q1, q2, F);

% Plot the final matching
subplot(3, 2, 5);
imagesc(im1); colormap(gray); axis image; axis off; hold on;
correct = find(a' == 1:length(a));
incorrect = find(a' ~= 1:length(a));
text(q1(incorrect, 1), q1(incorrect, 2), int2str(incorrect'), ...
     'Color', 'r', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
text(q1(correct, 1), q1(correct, 2), int2str(correct'), ...
     'Color', 'b', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
title('Final matches (blue=correct;red=incorrect)');
hold off;
subplot(3, 2, 6);
imagesc(im2); colormap(gray); axis image; axis off; hold on;
text(q2(incorrect, 1), q2(incorrect, 2), int2str(a(incorrect)), ...
     'Color', 'r', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
text(q2(correct, 1), q2(correct, 2), int2str(a(correct)), ...
     'Color', 'b', 'FontSize', 7, ...
     'HorizontalAlignment', 'center');
title(sprintf('Final matches (%d/%d correct)', ...
	      sum(a' == 1:length(a)), ...
	      size(p1, 1)));
hold off;

return
