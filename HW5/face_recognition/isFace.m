function isFace = isFace( img )
% Decides if a given image is a human face
%   INPUT:
%       img - a grayscale image, size 120 x 100
%   OUTPUT:
%       isFace - should be true if the image is a human face, false if not.

    numDiscard=4;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                       YOUR PART 4 CODE HERE                         %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Design your own method to decide if the image is a human face
    isFace = false;
    [rawFaceMatrix, imageOwner, imgHeight, imgWidth] = readInFaces();
%     meanFace = zeros(size(rawFaceMatrix,1),1);
%     meanFace=mean(rawFaceMatrix,2);
%     A = zeros(size(rawFaceMatrix));
%     A=rawFaceMatrix-repmat(meanFace,1,size(rawFaceMatrix,2));
%     testImg=img(:)-meanFace;
%     
%     numComponentsToKeep = 16;
%     prinComponents = [];
%     weightCols = [];
%     [prinComponents, weightCols] = doPCA(A, numComponentsToKeep);
%     prinComponents(:,1:numDiscard)=0;
%     testImgWeightCol=prinComponents.'*testImg;  
%     weightCols(1:numDiscard,:)=0;
%     testImgWeightCol(1:numDiscard)=0;
%     minDist= indexOfClosestColumn(weightCols, testImgWeightCol);
%     distAll=pdist(weightCols);
%     dist=mean(distAll);
%     if minDist<dist
%         isFace=true;
%     end
    
    [noFaceMatrix, imgHeight, imgWidth] = readInNonFaces();
%     meanFace = zeros(size(noFaceMatrix,1),1);
%     meanFace=mean(noFaceMatrix,2);
%     A = zeros(size(noFaceMatrix));
%     A=noFaceMatrix-repmat(meanFace,1,size(noFaceMatrix,2));
%     testImg=img(:)-meanFace;
%     [noFacePrinComponents, noFaceWeightCols] = doPCA(A, numComponentsToKeep);
%     noFacePrinComponents(:,1:numDiscard)=0;
%     testImgNoFaceWeightCol=noFacePrinComponents.'*testImg;  
%     noFaceWeightCols(1:numDiscard,:)=0;
%     testImgNoFaceWeightCol(1:numDiscard)=0;
%     minNoFaceDist= indexOfClosestColumn(noFaceWeightCols, testImgNoFaceWeightCol);
%     
%     if minNoFaceDist>minDist
%         isFace=true;
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                            END YOUR CODE                            %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    imgMartix=[rawFaceMatrix noFaceMatrix];
    meanFace = zeros(size(imgMartix,1),1);
    meanFace=mean(imgMartix,2);
    A = zeros(size(imgMartix));
    A=imgMartix-repmat(meanFace,1,size(imgMartix,2));
    testImg=img(:)-meanFace;
    
    numComponentsToKeep = 20;
    prinComponents = [];
    weightCols = [];
    [prinComponents, weightCols] = doPCA(A, numComponentsToKeep);
    prinComponents(:,1:numDiscard)=0;
    testImgWeightCol=prinComponents.'*testImg;  
    weightCols(1:numDiscard,:)=0;
    testImgWeightCol(1:numDiscard)=0;
    [minDist,indexOfClosest]= indexOfClosestColumn(weightCols, testImgWeightCol);
    if indexOfClosest<=90
        isFace=true;
    end
end

function [minDist,indexOfClosest] = indexOfClosestColumn(A, testColumn)
% Compares testColumn to each column in A and returns the distance and
% index of the closest column in A.
% INPUTS:
%   A: A matrix where each column is a data sample. Its size is
%   sampleDimensionality x numSamples.
%   testColumn: A column vector which needs to be compared to each column
%   in the matrix A.
% RETURNS:
%   minDist: The Euclidean distance between testColumn and its closest
%   column in A
%   closest: The index of the column in the matrix which has the lowest
%   Euclidean distance to testColumn.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                       YOUR PART 1 CODE HERE                         %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implement the function as described above.
    testImage=repmat(testColumn,1,size(A,2));
    err=(A-testImage).^2;
    err=sqrt(sum(err,1));
    minDist=min(err);
    indexOfClosest=find(minDist==err);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                            END YOUR CODE                            %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end