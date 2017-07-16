function H = ComputeAffineMatrix( Pt1, Pt2 )
%ComputeAffineMatrix 
%   Computes the transformation matrix that transforms a point from
%   coordinate frame 1 to coordinate frame 2
%Input:
%   Pt1: N * 2 matrix, each row is a point in image 1 
%       (N must be at least 3)
%   Pt2: N * 2 matrix, each row is the point in image 2 that 
%       matches the same point in image 1 (N should be more than 3)
%Output:
%   H: 3 * 3 affine transformation matrix, 
%       such that H*pt1(i,:) = pt2(i,:)

    N = size(Pt1,1);
    if size(Pt1, 1) ~= size(Pt2, 1),
        error('Dimensions unmatched.');
    elseif N<3
        error('At least 3 points are required.');
    end
    
    % Convert the input points to homogeneous coordintes.
    P1 = [Pt1';ones(1,N)];
    P2 = [Pt2';ones(1,N)];

    % Now, we must solve for the unknown H that satisfies H*P1=P2
    % But MATLAB needs a system in the form Ax=b, and A\b solves for x.
    % In other words, the unknown matrix must be on the right.
    % But we can use the properties of matrix transpose to get something
    % in that form. Just take the transpose of both sides of our equation
    % above, to yield P1'*H'=P2'. Then MATLAB can solve for H', and we can
    % transpose the result to produce H.
    
    H = [];
    H=zeros(3,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE:                               %
%        Use MATLAB's "A\b" syntax to solve for H_transpose as discussed       %
%                     above, then convert it to the final H                    %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P1_t=P1';
    P2_t=P2';
    b1=P2_t(:,1);
    x1=P1_t\b1;
    b2=P2_t(:,2);
    x2=P1_t\b2;
    H(1,:)=x1;
    H(2,:)=x2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       END OF YOUR CODE                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Sometimes numerical issues cause least-squares to produce a bottom
    % row which is not exactly [0 0 1], which confuses some of the later
    % code. So we'll ensure the bottom row is exactly [0 0 1].
    H(3,:) = [0 0 1];
end
