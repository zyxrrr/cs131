function VisualizeBox( I, Box )
%VisualizeBox Visualize detection results by overlaying the bounding box on
%the image.
%   I: the original image
%   Box: the bounding box, [left, right, upper, bottom]
%   left/right: the leftmost/rightmost index
%   upper/bottom: the upper/bottom index
%
%
    figure,
    imshow(I);
    hold on;
    line([Box(1), Box(1), Box(2), Box(2), Box(1)], [Box(3), Box(4), Box(4), Box(3), Box(3)], 'linewidth', 3, 'color', 'r');
    hold off;
end