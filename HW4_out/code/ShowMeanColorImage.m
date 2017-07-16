function ShowMeanColorImage(img, segments)
% Given a segmentation of an image, creates a figure showing the original
% image and a recolored version of the image where the pixels of each
% segment are replaced by the mean color of all pixels in that segment.
%
% INPUTS
% img - The image for which a segmentation has been computed.
% segments - A struct array containing a segmentation for img. The format
%            of the struct array is described in ComputeSegmentation.m.

    % Compute the mean color image.
    meanColorImg = MakeMeanColorImage(segments);
    
    figure;
    
    % Show the original image.
    subplot(1, 2, 1);
    imshow(img);
    
    % Show the mean color image.
    subplot(1, 2, 2);
    imshow(meanColorImg);

end