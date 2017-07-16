img = rgb2gray(imread('gulfstream.png'));

%The matrix "A" from part a) is provided for convenience:
theta = pi/4;
A = [cos(theta) -sin(theta); sin(theta) cos(theta)];

%Replace the identity matrix below with your transformation
%matrix, and run this script.
%%%%%%%%%%%% Your code here %%%%%%%%%%%%%%
T = [1 0;0 1];
T=A*[1 0;0 0.5];
%%%%%%%%%%%% end of your code %%%%%%%%%%%%%%

%The code below applies the transformation to every pixel in the image, and 
%displays both images. This code takes care of some MATLAB-specific things 
%that have low educational value, and you don't need to understand it.

%adds the translation part to get a complete affine transformation matrix
TWithTranslation = [T [0;0];0 0 1];

%MATLAB affine-transform convention is the transpose of ours, so we feed it
%the transpose of the transformation matrix
tform = maketform('projective',TWithTranslation');
%Images are drawn with the +y axis pointing down. So flip the image before
%and after the transformation to simulate normal Cartesian coordinates
transformed = flipud(imtransform(flipud(img), tform, 'FillValues',255));
imshow(img)
figure
imshow(uint8(transformed))