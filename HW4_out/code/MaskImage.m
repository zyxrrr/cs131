function maskedImg = MaskImage(mask, img, bgColor)
% Extract parts of an image using a mask.
%
% INPUTS
% mask - A logical array of size h x w specifying the segments of the image
%        to extract.
% img - An array of image data of size h x w x 3.
% bgColor - A vector [r, g, b] giving the background color of the masked
%           image where 0 <= r, g, b <= 1. This parameter is OPTIONAL; if
%           it is not set then it is set to the default background color
%           for figures.

    height = size(img, 1);
    width = size(img, 2);
    numChannels = size(img, 3);

    % If a background color is not specified then we hack a bit to set the
    % background color to the default background color of a figure.
    if nargin < 3
        bgColor = get(0, 'DefaultFigureColor');
    end
    
    % A dirty hack to convert the bgColor to the class of img.
    bgColor = eval(sprintf('im2%s(%s)', class(img), 'bgColor'));
    
    bgColor = reshape(bgColor, [1, 1, numChannels]);
    maskedImg = repmat(bgColor, [height, width, 1]);
    
    mask = repmat(mask, [1, 1, numChannels]);
    maskedImg(mask) = img(mask);
    
    % Another dirty hack to convert the output to the class of the input
    maskedImg = eval(sprintf('%s(%s)', class(img), 'maskedImg'));
end