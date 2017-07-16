function in_bounds = InBounds(img, y, x)
% Check whether the coordinates of a given point are within the bounds of
% an image.
%
% INPUTS
% img - The array
% y, x - The coordinates of the point
%
% OUTPUT
% in_bounds - Whether img(y, x) is within the bounds of img.
    height = size(img, 1);
    width = size(img, 2);
    in_bounds = (1 <= y & y <= height & 1 <= x & x <= width);
end