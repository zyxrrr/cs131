function [x, y, R] = RANSAC(D, maxIter, maxInlierError, goodFitThresh)
% RANSAC Use RANSAC to fit circles to a set of points.
% Input:
%   D: The data to fit. An N x 2 matrix, where each row is a 2d point.
%   maxIter: the number of iterations RANSAC will run
%   maxInlierError: A point not in the seed set is considered an inlier if
%                   its error is less than maxInlierError. Error is
%                   measured as abs(distance^2 - R^2), using the provided
%                   ComputeErrors() function
%   goodFitThresh: The threshold for deciding whether or not a model is
%                  good; for a model to be good, at least goodFitThresh
%                  non-seed points must be declared inliers.
%   
% Output:
%   x, y, R: (x, y) is the center of the fitted circle, R is the radius of
%   the fitted circle
%
%

    % The number of randomly-chosen seed points that we'll use to fit our
    % initial circle
    seedSetSize = 3;
    % The number of data points that weren't in the seed set.
    nonSeedSetSize = size(D, 1) - seedSetSize;

    % x, y, and R are the best parameters that we have seen so far.
    x = 0;
    y = 0;
    R = 0;
    
    % bestError is the error assicated with the best set of parameters we
    % have seen so far.
    bestError = Inf;
        
    for i = 1:maxIter
        % Randomly partition the data into seed and non-seed sets.
        % The RandomlySplitData() function below may be helpful
        seedSet = zeros(seedSetSize, 2);
        nonSeedSet = zeros(nonSeedSetSize, 2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%               YOUR CODE HERE: Fill in the above two variables.               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [seedSet,nonSeedSet]=RandomlySplitData(D,seedSetSize);        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Use the seed set to fit a model using least squares. The
        % function you made in part (a) may be useful.
        xx = 0;
        yy = 0;
        RR = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%               YOUR CODE HERE: Fill in the above 3 variables.                 %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [xx,yy,RR]=FitCircle(seedSet);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Compute the error of this model on the non-seed set, using the 
        % ComputeErrors function below.
        nonSeedErrors = zeros(nonSeedSetSize, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                  YOUR CODE HERE. Fill in the above variable.                 %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nonSeedErrors = ComputeErrors(xx, yy, RR, nonSeedSet);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Determine which of the points in the non-seed set agree with
        % this model. The nonSeedIsInlier vector should have a 1 (true)
        % when the corresponding point is an inlier, and a 0 when it is not
        % an inlier.
        nonSeedIsInlier = false(nonSeedSetSize, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                  YOUR CODE HERE. Fill in the above variable.                 %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        indInliner=nonSeedErrors<maxInlierError;
        nonSeedIsInlier(indInliner)=true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % If at least goodFitThresh points are inliers
        % then the model is good so fit a new model using the seed set and
        % the non-seed inliers.
        if sum(nonSeedIsInlier(:)) >= goodFitThresh
            % Combine the seed set and the non-seed inliers into a single
            % set of inliers. 
            % Hint: in MATLAB, you can use an array
            % of true/false values as an "index", and the result will be
            % only the entries where the "index" array = 1. For example,
            % inliers([1 0 1],:) would return an array containing the 
            % 1st and 3rd inlier.
            inliers = seedSet;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                  YOUR CODE HERE. Fill in the above variable.                 %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            inliers=[seedSet ;nonSeedSet(indInliner,:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Fit a new model using the inliers.
            xx = 0;
            yy = 0;
            RR = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                 YOUR CODE HERE. Fill in the above 3 variables.               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [xx, yy, RR] = FitCircle(inliers);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Compute the total error of the new model on the inliers.
            % There are several ways to define this, but for our purposes,
            % just add up the error at each inlier to produce a total
            % error.
            error = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                  YOUR CODE HERE. Fill in the above variable.                 %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            error = sum(ComputeErrors(xx, yy, RR, inliers));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % If this model is better than any we've seen before then
            % record its parameters.
            if error < bestError
                bestError = error;
                x = xx;
                y = yy;
                R = RR;
            end
        end
    end
    if R == 0
        disp('No RANSAC fit was found.')
    end
end

function [D1, D2] = RandomlySplitData(D, splitSize)
% Randomly split the rows of a matrix into two sets.
%
% Input:
% D: n x m matrix of data to split
% splitSize: The desired number of elements in the first set.
%
% Output:
% D1: splitSize x m matrix containing splitSize rows of D chosen at random
% D2: (n - splitSize) x m matrix containing the rest of the rows of D.
    idx = randperm(size(D, 1));
    D1 = D(idx(1:splitSize), :);
    D2 = D(idx(splitSize+1:end), :);
end

function error = ComputeErrors(x, y, R, D)
% Compute the error associated with fitting the circle (x, y, R) to the
% data in D.
%
% Input:
% x, y, R: Center and radius of the circle
% D - n x 2 matrix where each row is a data point [x_i, y_i]
%
% Output:
% error: An n x 1 vector where error(i) is the error of fitting the data
%        point D(i, :) to the circle (x, y, R).
%        Error is measured as abs(dist^2-R^2). This error measure isn't
%        very intuitive but it's fast.

    error = abs((x-D(:,1)).^2 + (y-D(:,2)).^2 - R^2); 
end
