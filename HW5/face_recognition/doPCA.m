function [prinComponents, weightCols] = doPCA(A, numComponentsToKeep)
% Performs PCA on data and returns the principal components (unit vectors
% which can be combined to reproduce each data sample) and the PCA-space
% representation of each data sample (i.e. weights on the principal
% components which would reproduce the sample)
% INPUTS:
%   A - A matrix where each column is a data sample. Its size is
%       sampleDimensionality x numSamples.
%   numComponentsToKeep - How many principal components should be retained.
%       The top few principal components can represent most of the
%       variation in an image set.
% RETURNS:
%   prinComponents - Columns that can be linearly combined to reproduce the
%       input data samples. Size is sampleDimensionality x
%       numComponentsToKeep
%   weightCols - Each column holds the weights necessary to reproduce one
%       input data column. E.g. prinComponents * weightCols(:,1) will
%       produce an approximation of the first column of A. Size is
%       numComponentsToKeep x numSamples

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                       YOUR PART 2 CODE HERE                         %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Perform PCA on A to produce the principal components and weights, as
    % discussed above. 
    weightCols = zeros(numComponentsToKeep, size(A,2));
    prinComponents = zeros(size(A,1), numComponentsToKeep);
%     sig=A*A.'/size(A,1);
    [U,S,V] = svd(A,'econ');
    prinComponents=U(:,1:numComponentsToKeep);
    sig=S(1:numComponentsToKeep,1:numComponentsToKeep);
    V=V.';
    v=V(1:numComponentsToKeep,:);
    weightCols=sig*v;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                     %
    %                            END YOUR CODE                            %
    %                                                                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
