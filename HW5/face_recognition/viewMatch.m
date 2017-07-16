function viewMatch( closestMatch, unknownFace , imageHeight)
%viewMatch Reshapes a pair of column-vector faces into the original image
% shapes, and displays them (using a 0 to 255 scale)
% INPUTS:
%   closestMatch - a grayscale image which has been unrolled into a column.
%   Gets displayed on top. 
%   unknownFace - a grayscale image which has been unrolled into a column.
%   Gets displayed on the bottom.
%   imgHeight - the height of the original images. (The width is figured
%   out using the size of the unrolled column.)
    figure('name','Closest match');
    subplot(2,1,1),  imshow(reshape(closestMatch,imageHeight, []),[0 255]);
    subplot(2,1,2),  imshow(reshape(unknownFace, imageHeight, []),[0 255]);

end

