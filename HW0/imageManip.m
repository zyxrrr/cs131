%reads in the image, converts it to grayscale, and converts the intensities
%from uint8 integers to doubles. (Brightness must be in 'double' format for
%computations, or else MATLAB will do integer math, which we don't want.)
dark = double(rgb2gray(imread('u2dark.png')));

%%%%%% Your part (a) code here: calculate statistics
valMean=mean(dark(:))
valMax=max(dark(:))
valMin=min(dark(:))

%%%%%% Your part (b) code here: apply offset and scaling
off=valMin
fac=255/(valMax-valMin)
fixedimg = fac*(dark-off);

%displays the image
imshow(uint8(fixedimg));

%%%%%% Your part (c) code here: apply the formula to increase contrast,
% and display the image
contrasted = 2*(fixedimg-128)+128;
figure;imshow(uint8(contrasted))