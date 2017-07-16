function [mask, simg] = ChooseSegments(segments, background)
% Presents a graphical interface to select a set of segments.
%
% The current segment will be shown on the left, and a composite image made
% up of all selected segments will be shown on the right. The following
% actions are available:
%
% left / right arrow keys - Cycle through the segments
% 't' key - Transfer the current segment to the set of selected segments
% 'r' key - Remove the current segment from the set of selected segments
% 'enter' or 'escape' keys - Close the graphical interface and return the
%                            image data and mask for the selected segments.
%
% INPUTS
% segments - A struct array containing information about computed segments
%            as described in MakeSegments.m.
% background - OPTIONAL argument giving image data for an image to be used
%              as a background for the selected segments. If this argument
%              is not provided then a solid color will be used as a
%              background.
%
% OUTPUTS
% mask - A logical array of size h x w such that mask(i, j) = 1 iff the
%        pixel at position (i, j) is located in one of the selected
%        segments.
% simg - Array of image data for the selected segments.

    % Initialize the outputs
    height = size(segments(1).img, 1);
    width = size(segments(1).img, 2);
    mask = false(height, width);
    
    simg = zeros(height, width, 3);
    if nargin >= 2
        background = imresize(background, [height, width]);
    else
        % This is the default background color of Matlab figures
        bgColor = im2uint8(get(0, 'DefaultFigureColor'));
        background = repmat(reshape(bgColor, [1, 1, 3]), [height, width, 1]);
    end
    simg = background;
        
    h = figure;
    i = 1;
    set(h, 'KeyPressFcn', @KeyPressFn);
    
    subplot(1, 2, 1);
    imshow(segments(i).img);
    
    subplot(1, 2, 2);
    imshow(simg);

    function KeyPressFn(h, e)        
        if strcmp(e.Key, 'rightarrow')
            i = min(i + 1, length(segments));
        elseif strcmp(e.Key, 'leftarrow')
            i = max(i - 1, 1);
        elseif strcmp(e.Key, 't')
            mask(segments(i).mask) = 1;
            maskC = repmat(segments(i).mask, [1, 1, size(simg, 3)]);
            simg(maskC) = segments(i).img(maskC);
        elseif strcmp(e.Key, 'r')
            mask(segments(i).mask) = 0;
            for channel = 1:size(simg, 3)
                simgChannel = simg(:, :, channel);
                bgChannel = background(:, :, channel);
                simgChannel(segments(i).mask) = bgChannel(segments(i).mask);
                simg(:, :, channel) = simgChannel;
            end
        elseif strcmp(e.Key, 'return') || strcmp(e.Key, 'escape')
            close(h);
            return;
        end
        
        subplot(1, 2, 1);
        imshow(segments(i).img);

        subplot(1, 2, 2);
        imshow(simg);
    end

    waitfor(h);
end