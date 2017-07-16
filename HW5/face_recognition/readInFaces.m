function [faceMatrix, imageOwner, imgHeight, imgWidth] = readInFaces()
% Loads face data (from the facedatabase directory) into a huge matrix,
% where each column is made by unrolling a single face image.

% RETURNS:
% faceMatrix - column 1 of this matrix is image 1, converted to grayscale,
%       and unrolled columnwise into a vector. So if image 1 is 120x100,
%       column 1 will be length 12000. Column 2 is the same for image 2.
% imageOwner - a vector of size 1 x numImages, where imageOwner(i) holds 
%       the integer label of image (i). Images from the same person have
%       the same label.
% imgHeight - the height of an original image (they are all the same size)
% imgWidth - the width of an original image (they are all the same size)

% the number of distinct people
num_subjects=16; 

% Directory that holds images, named like f3_8.png, where the first number
% is the person and the second number is the pose. Each person is captured
% with multiple poses (facial expressions). This improves reliability of
% Eigenfaces and is a requirement for Fisherfaces. All images must be the
% same size, and faces must be aligned.
dataFolder = './facedatabase/'; 

% Each column of A will be an image, unrolled columnwise
A = [];
% Each entry is the integer ID of the subject of the photo. E.g. the third
% photo is of subject 1, so imageOwner[3] = 1.
imageOwner = [];

for subjIndex=1:num_subjects
    basename = [dataFolder 'f' num2str(subjIndex)];
    poseIndex = 1;
    fileExists = true;
    while(fileExists)
        filename = [basename '_' num2str(poseIndex) '.png'];
        try
            img = double(rgb2gray(imread(filename)));
        catch %we'll come here if file doesn't exist
            fileExists = false;
        end
        if(fileExists)        
            A(:, end+1) = img(:);
            imageOwner(end+1) = subjIndex;
        end
        poseIndex = poseIndex+1;
    end
end
[imgHeight, imgWidth] = size(img);
% disp('The matrix A is loaded in memory. Its size is:')
% disp(size(A));

faceMatrix = A;
% for subjIndex = 1:20
%     testFileName = ['image' num2str(subjIndex)];
%     load(testFileName);
% end

end
