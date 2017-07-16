function H = Histogram (I, bins)
%Histogram Build histogram
%   Build color histograms for the given image patch
%
%Input:
%   I: an image patch
%   bins: number of bins (dimension of the histogram)
%
%Output:
%   H: 1 * bins vector
%
    if nargin == 1,
        bins = 10;
    end
    
    if numel(size(I)) == 3,
        N = numel(I(:, :, 1));
        L = I(:, :, 1);
        a = I(:, :, 2);
        b = I(:, :, 3);
        H = [   histc(L(:)', 0:(100/(bins-1)):100)./N, ... 
                histc(a(:)', -100:(200/(bins-1)):100)./N, ...
                histc(b(:)', -100:(200/(bins-1)):100)./N ];
    elseif numel(size(I)) == 2,
        H = hist(I(:), bins) ./ numel(I);
    elseif numel(size(I)) == 1,
        H = hist(I, bins) ./ numel(I);
    else
        error('Unsupported dimension of I');
    end
end

