function D = SpatialPyramidDist( I1, I2, nbins )
%SpatialPyramidDist
%   Compute the spatial pyramid measure for the two given image
%   patches.
%
%Input:
%   I1: image patch 1
%   I2: image patch 2
%   nbins: number of bins for color histograms. Note this is unrelated to 
%   spatial partitioning of the image.
%
%Output:
%   D: spatial pyramid measure (a real number)
%
if nargin == 2
    nbins = 20;
end
nbins=200;
numLevel = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%                You should fill in D with the weighted distance               %
%                   between histograms of two entire images.                   %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D = 0;
H1=Histogram(I1,nbins);
H2=Histogram(I2,nbins);
H=[H1 ;H2];
D0=sum(min(H,[],1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D_sum=0;
for l = 1 : numLevel,
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%             You should fill in numCells with the number of cells             %
%                           along x and y directions.                          %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numCells = 0;
    numCells=2.^(l);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     D=0;
    for i = 1 : numCells,
        for j = 1 : numCells,
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%               You should fill in x_lo1, x_hi1, y_lo1, y_hi1 to               %
%                    extract one cell of I1 in the pyramid.                    %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            x_lo1 = 0;
            x_hi1 = 0;
            y_lo1 = 0;
            y_hi1 = 0;
            I1size=size(I1);
            x_lo1=floor((j-1)*I1size(2)/numCells)+1;
            x_hi1=floor(j*I1size(2)/numCells);
            y_lo1=floor((i-1)*I1size(1)/numCells)+1;
            y_hi1=floor(i*I1size(1)/numCells);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%               You should fill in x_lo2, x_hi2, y_lo2, y_hi2 to               %
%                    extract one cell of I2 in the pyramid.                    %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            x_lo2 = 0;
            x_hi2 = 0;
            y_lo2 = 0;
            y_hi2 = 0;
            I1size=size(I2);
            x_lo2=floor((j-1)*I1size(2)/numCells)+1;
            x_hi2=floor(j*I1size(2)/numCells);
            y_lo2=floor((i-1)*I1size(1)/numCells)+1;
            y_hi2=floor(i*I1size(1)/numCells);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%You should increment D by the weighted distances between patches in this cell.%
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             D = 0;
            I1_path=I1(y_lo1:y_hi1,x_lo1:x_hi1);
            I2_path=I2(y_lo2:y_hi2,x_lo2:x_hi2);
            H1=Histogram(I1_path,nbins);
            H2=Histogram(I2_path,nbins);
            H=[H1 ;H2];
            D_path=sum(min(H,[],1));
            D=D+D_path;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
    D_sum=D_sum+D*1/(2.^(numLevel-l+1));
end
D=D0/(2.^numLevel)+D_sum;
end

