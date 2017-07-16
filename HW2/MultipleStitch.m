function Pano = MultipleStitch( IMAGES, TRANS, fileName )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MultipleStitch 
%   This function stitches multiple images together and outputs the panoramic stitched image
%   with a chain of input images and its corresponding transformations. 
%   
%   Given a chain of images:
%       I1 -> I2 -> I3 -> ... -> Im
%   and its corresponding transformations:
%       T1 transforms I1 to I2
%       T2 transforms I2 to I3 
%       ....
%       Tm-1 transforms Im-1 to Im
%
%   We choose the middle image as the reference image, and the outputed
%   panorama is in the same coordinate system as the reference image.
%   
%   For this part, all the image stitching code has been provided to you.
%   The main task for you is to fill in the code so that current
%   transformations are used when we produce the final panorama.
%   
%   Originally, we have
%       I1 -> I2 -> ... -> Iref -> ... -> Im-1 -> Im
%   When we fix Iref as the final coordinate system, we want all other
%   images transformed to Iref. You are responsible for finding the current
%   transformations used under this circumstances.
%
% INPUT:
%   IMAGES: 1 * m cell array, each cell contains an image
%   TRANS: 1 * (m-1) cell array, each cell i contains an affine
%   transformation matrix that transforms Ii to Ii+1.
%   fileName: the output file name.
%
% OUTPUT:
%   Pano: the final panoramic image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('fileName', 'var'),
    fileName = 'pano.jpg';
end

if length(IMAGES) ~= length(TRANS)+1,
    error('Number of images does not match the number of transformations.');
end

%% Outbounds of panorama image
outBounds = zeros(2,2);
outBounds(1,:) = Inf;
outBounds(2,:) = -Inf;

%% Choose reference image Iref
refIdx = ceil(median(1:length(IMAGES)));

%% Estimate the largest possible panorama size
[nrows, ncols, ~] = size(IMAGES{1});
nrows = length(IMAGES) * nrows;
ncols = length(IMAGES) * ncols;

% imageToRefTrans is a 1 x m cell array where imageToRefTrans{i} gives the
% affine transformation from IMAGES{i} to the reference image
% IMAGES{refIdx}. Your task is to fill in this array.
imageToRefTrans = cell(1, length(IMAGES));

% Initialize imageToRefTrans to contain the identity transform.
for idx = 1:length(imageToRefTrans)
    imageToRefTrans{idx} = eye(3);
end

%% Find the correct transformations used for images on the left side of Iref
for idx = refIdx-1:-1:1,
    imageToRefTrans{idx} = makeTransformToReferenceFrame(TRANS, idx, refIdx);
    T = imageToRefTrans{idx};
    tmpBounds = findbounds(maketform('affine', T'), [1 1; ncols nrows]);
    outBounds(1,:) = min(outBounds(1,:),tmpBounds(1,:));
    outBounds(2,:) = max(outBounds(2,:),tmpBounds(2,:));
end

%% Find the correct transformations used for images on the right side of Iref

for idx = refIdx + 1 : length(imageToRefTrans),  
    imageToRefTrans{idx} = makeTransformToReferenceFrame(TRANS, idx, refIdx);
    T = imageToRefTrans{idx};
    T(3, :) = [0, 0, 1]; % Fix rounding errors in the last row.
    tmpBounds = findbounds(maketform('affine', T'), [1 1; ncols nrows]);
    outBounds(1,:) = min(outBounds(1,:),tmpBounds(1,:));
    outBounds(2,:) = max(outBounds(2,:),tmpBounds(2,:));
end

%% Stitch the Iref image.
XdataLimit = round(outBounds(:,1)');
YdataLimit = round(outBounds(:,2)');
Pano = imtransform( im2double(IMAGES{refIdx}), maketform('affine', eye(3)), 'bilinear', ...
                    'XData', XdataLimit, 'YData', YdataLimit, ...
                    'FillValues', NaN, 'XYScale',1);
                
%% Transform the images from the left side of Iref using the correct transformations you computed
for idx = refIdx-1:-1:1,
    T = imageToRefTrans{idx};
    Tform = maketform('affine', T');
    AddOn = imtransform(im2double(IMAGES{idx}), Tform, 'bilinear', ...
                        'XData', XdataLimit, 'YData', YdataLimit, ...
                        'FillValues', NaN, 'XYScale',1);
    result_mask = ~isnan(Pano(:,:,1));
    temp_mask = ~isnan(AddOn(:,:,1));
    add_mask = temp_mask & (~result_mask);

    for c = 1 : size(Pano,3),
        cur_im = Pano(:,:,c);
        temp_im = AddOn(:,:,c);
        cur_im(add_mask) = temp_im(add_mask);
        Pano(:,:,c) = cur_im;
    end
end

%% Transform the images from the right side of Iref using the correct transformations you computed
for idx = refIdx + 1 : length(imageToRefTrans),
    T = imageToRefTrans{idx};
    T(3, :) = [0, 0, 1]; % Fix rounding errors in the last row.
    Tform = maketform('affine', T');
    AddOn = imtransform(im2double(IMAGES{idx}), Tform, 'bilinear', ...
                        'XData', XdataLimit, 'YData', YdataLimit, ...
                        'FillValues', NaN, 'XYScale',1);
    result_mask = ~isnan(Pano(:,:,1));
    temp_mask = ~isnan(AddOn(:,:,1));
    add_mask = temp_mask & (~result_mask);

    for c = 1 : size(Pano,3),
        cur_im = Pano(:,:,c);
        temp_im = AddOn(:,:,c);
        cur_im(add_mask) = temp_im(add_mask);
        Pano(:,:,c) = cur_im;
    end
end

%% Cropping the final panorama to leave out black spaces.
[I, J] = ind2sub([size(Pano, 1), size(Pano, 2)], find(~isnan(Pano(:, :, 1))));
upper = max(min(I)-1, 1);
lower = min(max(I)+1, size(Pano, 1));
left = max(min(J)-1, 1);
right = min(max(J)+1, size(Pano, 2));
Pano = Pano(upper:lower, left:right,:);

imwrite(Pano, fileName);

end

function T = makeTransformToReferenceFrame(i_To_iPlusOne_Transform, currentFrameIndex, refFrameIndex)
%makeTransformToReferenceFrame
% INPUT:
%   i_To_iPlusOne_Transform: this is a cell array where
%   i_To_iPlusOne_Transform{i} contains the 3x3 homogeneous transformation
%   matrix that transforms a point in frame i to the corresponding point in
%   frame i+1
%   
%   currentFrameIndex: index of the current coordinate frame in i_To_iPlusOne_Transform
%   refFrameIndex: index of the reference coordinate frame
%
% OUTPUT:
%   T: A 3x3 homogeneous transformation matrix that would convert a point
%   in the current frame into the corresponding point in the reference
%   frame. For example, if the current frame is 2 and the reference frame
%   is 3, then T = i_To_iPlusOne_Transform{2}. If the current frame and
%   reference frame are not adjacent, T will need to be calculated.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                 YOUR CODE HERE: Calculate T as defined above.                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HINT 1: There are two separate cases to consider: currentFrameIndex <
% refFrameIndex (this is the easier case), and currentFrameIndex >
% refFrameIndex (this is the harder case).

% HINT 2: You can use the pinv function to invert a transformation.
T=eye(3);
if currentFrameIndex<refFrameIndex
    for ii=currentFrameIndex:refFrameIndex-1
        T=T*i_To_iPlusOne_Transform{ii};
    end
end
if currentFrameIndex>refFrameIndex
    for ii=fliplr(refFrameIndex:currentFrameIndex-1)
        T=T*pinv(i_To_iPlusOne_Transform{ii});
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                               END OF YOUR CODE                               %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
