
function [prinComponents, weightCols] = fisherfaces(A,imageOwner,numComponentsToKeep)
% Performs LDA on data and returns the principal components (unit vectors
% which can be combined to reproduce each data sample) and the LDA-space
% representation of each data sample (i.e. weights on the principal
% components which would reproduce the sample). Unlike PCA, LDA will find
% the principal components which maximize between-class variation but
% MINIMIZE within-class variation.
% INPUTS:
%   A: A matrix where each column is a data sample. Its size is
%   sampleDimensionality x numSamples.
%   imageOwner: A size 1 x numSamples vector, where entry 'i' holds the class
%   label of column 'i' in the matrix A.
%   numComponentsToKeep: How many principal components should be retained.
%   The top few principal components can represent most of the variation in
%   an image set.
% RETURNS:
%   prinComponents: Columns that can be linearly combined to reproduce the
%   input data samples. Size is sampleDimensionality x numComponentsToKeep
%   weightCols: Each column holds the weights necessary to reproduce one
%   input data column. E.g. prinComponents * weightCols(:,1) will produce
%   an approximation of the first column of A. Size is numComponentsToKeep 
%   x numSamples

  % number of samples
  A = A';
  N = size(A,1);
  % number of classes
  labels = unique(imageOwner);
  c = length(labels);
  if(nargin < 3)
    numComponentsToKeep = c-1;
  end
  numComponentsToKeep = min(numComponentsToKeep,(c-1));
  [Wpca, mu] = pca(A, imageOwner, (N-c));
  proj = (A-repmat(mu, N, 1))*Wpca;
  [Wlda, mu_lda] = lda(proj, imageOwner, numComponentsToKeep);
  prinComponents = Wpca*Wlda;
  weightCols = prinComponents'*A';
end

function [W, mu] = lda(X,y,k)
  % dimension of observation
  [n,d] = size(X);
  % number of classes
  labels = unique(y);
  C = length(labels);
  % allocate scatter matrices
  Sw = zeros(d,d);
  Sb = zeros(d,d);
  % total mean
  mu = mean(X);
  % calculate scatter matrices
  for i = 1:C
    Xi = X(find(y == labels(i)),:); % samples for current class
    n = size(Xi,1);
    mu_i = mean(Xi); % mean vector for current class
    Xi = Xi - repmat(mu_i, n, 1);
    Sw = Sw + Xi'*Xi;
    Sb = Sb + n * (mu_i - mu)'*(mu_i - mu);
  end
  % solve general eigenvalue problem
  [W, D] = eig(Sb, Sw);
  % sort eigenvectors
  [D, i] = sort(diag(D), 'descend');
  W = W(:,i);
  % keep at most (c-1) eigenvectors
  W = W(:,1:k);
end

function [W, mu] = pca(X, y, k)
  [n,d] = size(X);
  mu = mean(X);
  Xm = X - repmat(mu, size(X,1), 1);
  if(n>d)
    C = Xm'*Xm;
    [W,D] = eig(C);
    % sort eigenvalues and eigenvectors
    [D, i] = sort(diag(D), 'descend');
    W = W(:,i);
    % keep k components
    W = W(:,1:k);
  else
    C = Xm*Xm';
    %C = cov(Xm');
    [W,D] = eig(C);
    % multiply with data matrix
    W = Xm'*W;
    % normalize eigenvectors
    for i=1:n
      W(:,i) = W(:,i)/norm(W(:,i));
    end
    % sort eigenvalues and eigenvectors
    [D, i] = sort(diag(D), 'descend');
    W = W(:,i);
    % keep k components
    W = W(:,1:k);
  end
end
