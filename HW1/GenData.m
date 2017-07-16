function [Data, x, y, R] = GenData(N, sigma, uniform_fraction)
% GenData Randomly generate N noisy 2-D points from a circle.
%
% Input:
%   N: the number of points to be generated
%   sigma: the standard deviation of the additive Gaussian noise.
%          Default is 0.1.
%   uniform_fraction: The fraction of points that should be drawn from a
%                     uniform distribution; these are outliers. Default is
%                     0.
% Output:
%   Data: N by 2 matrix, each row is a point in 2D space
%   x, y, R: The true center and radius of the circle.

    if nargin < 2
        sigma = 0.1;
    end
    
    if nargin < 3
        uniform_fraction = 0;
    end

    % Compute the split between circle and uniform points.
    N1 = round(uniform_fraction * N);
    N2 = N - N1;
    
    % Generate the parameters for the circle.
    x = 1 - 2 * rand;
    y = 1 - 2 * rand;
    R = 1 + rand * 4;
        
    % Generate some uniformly distributed points. If the center of the
    % region from which these points are drawn is the center of the circle
    % then least squares won't be affected by these points; therefore we
    % bias these points toward one side to ensure that least squares gives
    % the wrong answer.
    uniformx = x + 8 * R * (rand(N1, 1) - 0.3);
    uniformy = y + 8 * R * (rand(N1, 1) - 0.3);
    UniformData = [uniformx, uniformy];
    
    % Generate noisy circle points.
    theta = 2 * pi * rand(N2, 1);
    ptx = x + R * cos(theta);
    pty = y + R * sin(theta);
    CircleData = [ptx, pty] + sigma * randn(N2, 2);
    
    % Concatenate the two types of data and shuffle.
    Data = [UniformData; CircleData];
    Data = Data(randperm(N), :);
end