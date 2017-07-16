function Pano = PairStitch(img1, img2, H, fileName)
%PairStitch Stitch a pair image.
%
%   Stitch img1 to img2 given the transformation from img1 to img2 is H.
%   Save the stitched panorama to fileName.
%
%INPUT:
%   img1: image 1
%   img2: image 2
%   H: 3 by 3 affine transformation matrix
%   fileName: specified file name
%
%OUTPUT:
%   Pano: the panoramic image
%

if ~exist('fileName', 'var'),
    fileName = 'pano.jpg';
end

[nrows, ncols, ~] = size(img1);

outBounds = zeros(2,2);
outBounds(1,:) = Inf;
outBounds(2,:) = -Inf;

Transformation = cell(1, 2);
Transformation{1} = H;
Transformation{2} = eye(3);
for i = 1 : length(Transformation),
    T = maketform('affine', Transformation{i}');
    Bounds = findbounds(T, [1, 1; 2*nrows, 2*ncols]);
    outBounds(1,:) = min(outBounds(1,:), Bounds(1,:));
    outBounds(2,:) = max(outBounds(2,:), Bounds(2,:));
end

XdataLimit = round(outBounds(:, 1)');
YdataLimit = round(outBounds(:, 2)');

Pano = imtransform( im2double(img2), maketform('affine', eye(3)), 'bilinear', ...
                    'XData', XdataLimit, 'YData', YdataLimit, ...
                    'FillValues', NaN, 'XYScale', 1);

AddOn = imtransform(im2double(img1), maketform('affine', H'), 'bilinear', ...
                    'XData', XdataLimit, 'YData', YdataLimit, ...
                    'FillValues', NaN, 'XYScale', 1);
                
result_mask = ~isnan(Pano(:,:,1));
temp_mask = ~isnan(AddOn(:,:,1));
add_mask = temp_mask & (~result_mask);

for c = 1 : size(Pano,3),
    cur_im = Pano(:,:,c);
    temp_im = AddOn(:,:,c);
    cur_im(add_mask) = temp_im(add_mask);
    Pano(:,:,c) = cur_im;
end

%% Cropping
[I, J] = ind2sub([size(Pano, 1), size(Pano, 2)], find(~isnan(Pano(:, :, 1))));
upper = max(min(I)-1, 1);
lower = min(max(I)+1, size(Pano, 1));
left = max(min(J)-1, 1);
right = min(max(J)+1, size(Pano, 2));
Pano = Pano(upper:lower, left:right,:);
imwrite(Pano, fileName);

end

