%/////////////////////////////////////////////////////////////////////////////////////////////
% Author : Scott Ettinger
%
% resample_bilinear(img, ratio)  
%
% resamples a 2d matrix by the ratio given by the ratio parameter using bilinear interpolation
% the 1,1 entry of the matrix is always duplicated. 
%/////////////////////////////////////////////////////////////////////////////////////////////

function img2 = resample_bilinear(img, ratio)

img=double(img);

[h,w]=size(img);  %get size of image

[y,x]=meshgrid( 1:ratio:h-1, 1:ratio:w-1 );  %create vectors of X and Y values for new image
[h2,w2] = size(x);                           %get dimensions of new image

x = x(:);     %convert to vectors
y = y(:);

alpha = x - floor(x);   %calculate alphas and betas for each point
beta = y - floor(y);

fx = floor(x);   fy = floor(y);

inw = fy + (fx-1)*h;    %create index for neighboring pixels
ine = fy + fx*h;
isw = fy+1 + (fx-1)*h;
ise = fy+1 + fx*h;

img2 = (1-alpha).*(1-beta).*img(inw) + ...  %interpolate
       (1-alpha).*beta.*img(isw) + ...
       alpha.*(1-beta).*img(ine) + ...
       alpha.*beta.*img(ise);
   
img2 = reshape(img2,h2,w2);                 %turn back into 2d
img2 = img2';

