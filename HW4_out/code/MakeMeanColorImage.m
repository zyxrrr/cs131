function meanColorImg = MakeMeanColorImage(segments)
% Visualize a segmentation of an image by replacing each segment of the
% original image with its mean color.
%
% INPUTS
% segments - A struct array containing information about computed segments
%            as described in MakeSegments.m.
% meanColorImg - An array of the same size as the original image such that
%                meanColorImg(i, j, :) is the average color of the segment
%                to which pixel (i, j) of the original image has been
%                assigned.

    meanColorImg = zeros(size(segments(1).img));
    
    for channel = 1:size(meanColorImg, 3)
        simgChannel = zeros(size(meanColorImg, 1), size(meanColorImg, 2));
        for c = 1:length(segments)
            segmentChannel = double(segments(c).img(:, :, channel));
            mask = segments(c).mask;
            simgChannel(mask) = mean(segmentChannel(mask));
        end
        meanColorImg(:, :, channel) = simgChannel;
    end
    
    meanColorImg = uint8(meanColorImg);
end