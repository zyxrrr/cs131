function descriptors = SIFTDescriptor(pyramid, keyPtLoc, keyPtScale)

% SIFTDescriptor Build SIFT descriptors from image at detected key points'
% location with detected key points' scale and angle
%
% INPUT:
%   pyramid: Image pyramid. pyramid{i} is a rescaled version of the
%            original image, in grayscale double format
%
%   keyPtLoc: N * 2 matrix, each row is a key point pixel location in
%   pyramid{round(keyPtScale)}. So pyramid{round(keyPtScale)}(y,x) is the center of the keypoint
%
%   keyPtScale: N * 1 matrix, each entry holds the index in the Gaussian
%   pyramid for the keypoint. Earlier code interpolates things, so this is a
%   double, but we'll just round it to an integer.
%
% OUTPUT:
%   descriptors: N * 128 matrix, each row is a feature descriptor
%

    % Precompute the gradients at all pixels of all pyramid scales
    
    % This is a cell array, which is like an ArrayList that holds matrices.
    % You use {} to index into it, like this: magnitude = grad_mag{1}
    grad_theta = cell(length(pyramid),1);
    grad_mag = cell(length(pyramid),1);
    
    for scale = 1:length(pyramid)
        currentImage = pyramid{scale};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%                          Read the doc for filter2.                           %
%                Use with the filter [-1 0 1] to fill in img_dx,               %
%                  and the filter [-1;0;1] to fill in img_dy.                  %
%                    Please use the filter2 'same' option so                   %
%                the result will be the same size as the image.                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % gradient image, for gradients in x direction.
        img_dx = zeros(size(currentImage)); 
        % gradients in y direction.
        img_dy = zeros(size(currentImage));
        img_dx=filter2([-1 0 1],currentImage,'same');
        img_dy=filter2([-1;0;1],currentImage,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE                                %
%                Use img_dx and img_dy to compute the magnitude                %
%                   and angle of the gradient at each pixel.                   %
%       store them in grad_mag{scale} and grad_theta{scale} respectively.      %
%           The atan2 function will be helpful for calculating angle           %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Calculate the magnitude and orientation of the gradient.
        grad_mag{scale} = zeros(size(currentImage));
        grad_theta{scale} = zeros(size(currentImage));
        grad_mag{scale}=sqrt(img_dx.^2+img_dy.^2);
        grad_theta{scale}=atan2(img_dy,img_dx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % atan2 gives angles from -pi to pi. To make the histogram code
        % easier, we'll change that to 0 to 2*pi.
        grad_theta{scale} = mod(grad_theta{scale}, 2*pi);
        
    end
    
    % The number of bins into which each gradient vector will be placed.
    num_angles = 8;
    
    % The patch extracted around each keypoint will be divided into a grid
    % of num_histograms x num_histograms.
    num_histograms = 4;
    
    % Each histogram covers an area "pixelsPerHistogram" wide and tall
    pixelsPerHistogram = 4;
    
    % For each keypoint we will extract a region of size
    % patch_size x patch_size centered at the keypoint.
    patch_size = num_histograms * pixelsPerHistogram;
    
    % Number of keypoints that were found by the DoG blob detector
    N = size(keyPtLoc, 1);
    
    % Initialize descriptors to zero
    descriptors = zeros(N, num_histograms * num_histograms * num_angles);
            
    % Iterate over all keypoints
    for i = 1 : N

        scale = round(keyPtScale(i));    
        % Find the window of pixels that contributes to the descriptor for the
        % current keypoint.
        xAtScale = keyPtLoc(i, 1);%center of the DoG keypoint in the pyramid{2} image
        yAtScale = keyPtLoc(i, 2);
        x_lo = round(xAtScale - patch_size / 2);
        x_hi = x_lo+patch_size-1;
        y_lo = round(yAtScale - patch_size / 2);
        y_hi = y_lo+patch_size-1;              
        
        
        % These are the gradient magnitude and angle images from the 
        % correct scale level. You computed these above.
        magnitudes = grad_mag{scale};
        thetas = grad_theta{scale};
        try    
            % Extract the patch from that window around the keypoint
            patch_mag = zeros(patch_size,patch_size);
            patch_theta = zeros(patch_size,patch_size);
            patch_mag = magnitudes(y_lo:y_hi,x_lo:x_hi);
            patch_theta = thetas(y_lo:y_hi,x_lo:x_hi);
        catch err
            % If any keypoint is too close to the boundary of the image
            % then we just skip it.
            continue;
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                              YOUR CODE HERE:                                 %
%                                                                              %
%  Express gradient directions relative to the dominant gradient direction     %
%                              of this keypoint.                               %
%                                                                              %
%            HINT: Use the ComputeDominantDirection function below.            %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Step 1: compute the dominant gradient direction of the patch
        patch_angle_offset = 0;
        patch_angle_offset = ComputeDominantDirection(patch_mag(:), patch_theta(:));        
        % Step 2: change patch_theta so it's relative to the dominant direction
        patch_theta = patch_theta-patch_angle_offset;

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                              END OF YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % This line will re-map patch_theta into the range 0 to 2*pi
        patch_theta = mod(patch_theta, 2*pi);
        % Weight the gradient magnitudes using a gaussian function
        patch_mag = patch_mag .* fspecial('gaussian', patch_size, patch_size / 2);
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                             YOUR CODE HERE:                                  %
%                                                                              %
%         Compute the gradient histograms and concatenate them in the          %
%  feature variable to form a size 1x128 SIFT descriptor for this keypoint.    %
%                                                                              %
%            HINT: Use the ComputeGradientHistogram function below.            %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % The patch we have extracted should be subdivided into
        % num_histograms x num_histograms cells, each of which is size
        % pixelsPerHistogram x pixelsPerHistogram. 
        
        % Compute a gradient histogram for each cell, and concatenate 
        % the histograms into a single feature vector of length 128.
        
        % Please traverse the patch row by row, starting in the top left,
        % in order to match the given solution. E.g. if you use two 
        % nested 'for' loops, the loop over x should  be the inner loop.
        
        % (Note: Unlike the SIFT paper, we will not smooth a gradient across
        % nearby histograms. For simplicity, we will just assign all
        % gradient pixels within a pixelsPerHistogram x pixelsPerHistogram
        % square to the same histogram.)
        
        % Initializing the feature vector to size 0. Hint: you can
        % concatenate the histogram descriptors to it like this: 
        % feature = [feature, histogram]
        feature = [];
        num_bins=8;
        for i_x=1:4:13
            for i_y=1:4:13
                patch_magnitudes=patch_mag(i_x:i_x+3,i_y:i_y+3);
                patch_angles=patch_theta(i_x:i_x+3,i_y:i_y+3);
                [histogram, angles] = ComputeGradientHistogram(num_bins, patch_magnitudes(:), patch_angles(:));
                feature = [feature, histogram];
            end
        end

        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Add the feature vector we just computed to our matrix of SIFT
        % descriptors.
        descriptors(i, :) = feature;
    end
    
    % Normalize the descriptors.
    descriptors = NormalizeDescriptors(descriptors);
end



function [histogram, angles] = ComputeGradientHistogram(num_bins, gradient_magnitudes, gradient_angles)
% Compute a gradient histogram using gradient magnitudes and directions.
% Each point is assigned to one of num_bins depending on its gradient
% direction; the gradient magnitude of that point is added to its bin.
%
% INPUT
% num_bins: The number of bins to which points should be assigned.
% gradient_magnitudes, gradient angles:
%       Two arrays of the same shape where gradient_magnitudes(i) and
%       gradient_angles(i) give the magnitude and direction of the gradient
%       for the ith point. gradient_angles ranges from 0 to 2*pi
%                                      
% OUTPUT
% histogram: A 1 x num_bins array containing the gradient histogram. Entry 1 is
%       the sum of entries in gradient_magnitudes whose corresponding
%       gradient_angles lie between 0 and angle_step. Similarly, entry 2 is for
%       angles between angle_step and 2*angle_step. Angle_step is calculated as
%       2*pi/num_bins.

% angles: A 1 x num_bins array which holds the histogram bin lower bounds.
%       In other words, histogram(i) contains the sum of the
%       gradient magnitudes of all points whose gradient directions fall
%       in the range [angles(i), angles(i + 1))

    angle_step = 2 * pi / num_bins;
    angles = 0 : angle_step : (2*pi-angle_step);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE:                               %
%        Use the function inputs to calculate the histogram variable,          %
%                               as defined above.                              %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    histogram = zeros(1, num_bins);
    for ii=1:num_bins
        ind_gra=gradient_angles>=angles(ii) & gradient_angles<angles(ii)+angle_step;
        histogram(ii)=sum(gradient_magnitudes(ind_gra));
    end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



function direction = ComputeDominantDirection(gradient_magnitudes, gradient_angles)
% Computes the dominant gradient direction for the region around a keypoint
% given the scale of the keypoint and the gradient magnitudes and gradient
% angles of the pixels in the region surrounding the keypoint.
%
% INPUT
% gradient_magnitudes, gradient_angles:
%   Two arrays of the same shape where gradient_magnitudes(i) and
%   gradient_angles(i) give the magnitude and direction of the gradient for
%   the ith point.
% scale: The scale of the keypoint
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE:                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute a gradient histogram using the weighted gradient magnitudes.
    % In David Lowe's paper he suggests using 36 bins for this histogram.
    num_bins = 36;
    % Step 1:
    % compute the 36-bin histogram of angles using ComputeGradientHistogram()
    [histogram, angles]=ComputeGradientHistogram(num_bins,gradient_magnitudes,gradient_angles);
    % Step 2:
    % Find the maximum value of the gradient histogram, and set "direction"
    % to the angle corresponding to the maximum. (To match our solutions,
    % just use the lower-bound angle of the max histogram bin. (E.g. return
    % 0 radians if it's bin 1.)
    ind_max_his=find(histogram==max(histogram));
    direction=angles(ind_max_his);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                 END YOUR CODE                                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



function descriptors = NormalizeDescriptors(descriptors)
% Normalizes SIFT descriptors so they're unit vectors. You don't need to
% edit this function.
%
% INPUT
% descriptors: N x 128 matrix where each row is a SIFT descriptor.
%
% OUTPUT
% descriptors: N x 128 matrix containing a normalized version of the input.

    % normalize all descriptors so they become unit vectors
    lengths = sqrt(sum(descriptors.^2, 2));
    nonZeroIndices = find(lengths);
    lengths(lengths == 0) = 1;
    descriptors = descriptors ./ repmat(lengths, [1 size(descriptors,2)]);

    % suppress large entries
    descriptors(descriptors > 0.2) = 0.2;

    % finally, renormalize to unit length
    lengths = sqrt(sum(descriptors.^2, 2));
    lengths(lengths == 0) = 1;
    descriptors = descriptors ./ repmat(lengths, [1 size(descriptors,2)]);

end