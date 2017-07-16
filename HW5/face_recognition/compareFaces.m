function label = compareFaces(method, testImg)
% Finds the closest match to testImg in our database. Returns the label of
% the closest match
% INPUTS:
%   method - one of 'simple', 'eigenface', or 'fisherface'. Determines the
%       face-comparison method to use.
%   testImg - a grayscale test image
% RETURNS:
%   label - the label of the person in the training set who best matches
%       the testImg face
    
    % load our face database into a matrix.
    [rawFaceMatrix, imageOwner, imgHeight, imgWidth] = readInFaces();
    % This give us: faceMatrix - column 1 of this matrix is image 1,
    %       converted to grayscale, and unrolled columnwise into a vector.
    %       So if image 1 is 120x100, column 1 will be length 12000. Column
    %       2 is the same for image 2.
    % imageOwner - a vector of size 1 x numImages, where imageOwner(i)
    %       holds the integer label of image (i). Images from the same
    %       person have the same label.
    % imgHeight - the height of an original image (they are all the same
    %       size) 
    % imgWidth - the width of an original image (they are all the same
    %       size)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                       YOUR PART 1 CODE HERE                         %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find the mean column of rawFaceMatrix, and subtract it from every
    % column to produce a zero-mean matrix A
    meanFace = zeros(size(rawFaceMatrix,1),1);
    meanFace=mean(rawFaceMatrix,2);
    A = zeros(size(rawFaceMatrix));
    A=rawFaceMatrix-repmat(meanFace,1,size(rawFaceMatrix,2));
    % Also "unroll" testImg to produce a single column vector, and
    % subtract the mean column from it, so that it can be compared to the
    % columns in the matrix A.
    testImg=testImg(:)-meanFace;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                            END YOUR CODE                            %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Now that we have testImg in the same form as the columns of A, we can
    % try various methods to compare it to the columns.
    if strcmp(method,'simple')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                       YOUR PART 1 CODE HERE                         %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compare the unrolled image to every other image in the matrix, and return the
        % index of the closest. The indexOfClosestColumn() function below
        % will be helpful.
        indexOfClosestMatch = 0;
        [~, indexOfClosestMatch] = indexOfClosestColumn(A, testImg);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif strcmp(method,'eigenface')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                       YOUR PART 2 CODE HERE                         %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Call your doPCA() function to yield the principal components for
        % the image set. Convert the test image into the same PCA space,
        % and compare it to the PCA-space version of each training image to
        % find the closest.
        numComponentsToKeep = 20;
        prinComponents = [];
        weightCols = [];
        [prinComponents, weightCols] = doPCA(A, numComponentsToKeep);
        testImgWeightCol=prinComponents.'*testImg;        
        
        indexOfClosestMatch = 0;
        [~, indexOfClosestMatch] = indexOfClosestColumn(weightCols, testImgWeightCol);
        % uncomment this line to view the principal components (a.k.a.
        % Eigenfaces) as images.
        viewComponents(prinComponents, imgHeight); 
        
        faceReproduce=meanFace+prinComponents*testImgWeightCol;
        viewFace(faceReproduce,imgHeight);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif strcmp(method,'fisherface')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                       YOUR PART 3 CODE HERE                         %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Use the provided fisherfaces function to find the LDA basis
        % vectors for the image set. Also convert the test image into the
        % LDA space, and compare it to the LDA-space version of each
        % training image to find the closest. This code will be very
        % similar to your code above.
        numComponentsToKeep = 20;
        prinComponents = [];
        weightCols = [];
        [prinComponents, weightCols] = fisherfaces(A,imageOwner,numComponentsToKeep);
        indexOfClosestMatch = 0;
        testImgWeightCol=prinComponents.'*testImg;        
        [~, indexOfClosestMatch] = indexOfClosestColumn(weightCols, testImgWeightCol);
        % uncomment this line to view the principal components (a.k.a.
        % Eigenfaces or Fisherfaces) as images.
        viewComponents(prinComponents, imgHeight); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        error('invalid method name');
    end
    
    % Displays the test image and its closest match, and prints whether the
    % closest match was labeled
    viewMatch(rawFaceMatrix(:,indexOfClosestMatch), testImg+meanFace, imgHeight);
        
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                       YOUR PART 1 CODE HERE                         %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Nearest Neighbor: Find the label of the closest-matched training
    % example. (The imageOwner array holds the labels).
    label = 1;
    label=imageOwner(indexOfClosestMatch);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                            END YOUR CODE                            %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Sarah Connor was subject number 16 in the labeled training data.
    sarahConnorsID = 16; 
    if label == sarahConnorsID
        disp('>>>> That is Sarah Connor. <<<<');
        beep;
    else
        disp('>>>> That is not Sarah Connor. <<<<');
    end
end

function [minDist, indexOfClosest] = indexOfClosestColumn(A, testColumn)
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
