function viewFace( faceColumn, imgHeight)
%VIEWFACE Reshapes a column-vector face into the original image shape, and
% displays it (using a 0 to 255 scale)
% INPUTS:
%   faceColumn - a grayscale image which has been unrolled into a column
%   imgHeight - the height of the original image. (The width is figured out
%   using the size of the unrolled column.)
    figure;
    imshow(reshape(faceColumn,imgHeight, []),[0 255]);
end

