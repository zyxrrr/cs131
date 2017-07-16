function ShowSegments(img, segments)
% Creates a figure showing the individual segments of a segmentation.
%
% INPUTS
% img - The image for which a segmentation has been computed.
% segments - A struct array containing a segmentation for img. The format
%            of the struct array is described in ComputeSegmentation.m.

    % Pick the width and height of the subplot grid automatically to make
    % it as square as possible.
    gridWidth = ceil(sqrt(length(segments) + 1));
    gridHeight = ceil((1 + length(segments)) / gridWidth);

    figure;
    
    % Show the original image.
    subplot(gridHeight, gridWidth, 1);
    imshow(img);
    
    % Show each segment.
    for i = 1:length(segments)
        subplot(gridHeight, gridWidth, i + 1);
        imshow(segments(i).img);
    end
    subplot(gridHeight, gridWidth, 1);
    
end