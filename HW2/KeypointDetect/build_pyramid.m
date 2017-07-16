%/////////////////////////////////////////////////////////////////////////////////////////////
%
% build_pyramid - build scaled image pyramid and difference of gaussians pyramid
%
% Usage:  [pyr,imp] = build_pyramid(img,levels,scl);
%
% Parameters:  
%            
%            img :      original image
%            levels :   number of levels in pyramid
%            scl :      scaling factor between pyramid levels
%
% Returns:
%
%            pyr :      difference of gaussians filtered image pyramid
%            imp :      image pyramid cell array
%
% Author: 
% Scott Ettinger
% scott.m.ettinger@intel.com
%
% May 2002
%/////////////////////////////////////////////////////////////////////////////////////////////

function [pyr,imp] = build_pyramid(img,levels,scl)

img2 = img;
img2 = resample_bilinear(img2,1/2);         %expand to retain spatial frequencies

%img2 = imresize(img2,2,'bilinear');         %expand to retain spatial frequencies

sigma=1.5;    %variance for laplacian filter
sigma2=1.5;   %variance for downsampling

sig_delta = (1.6-.6)/levels;


for i=1:levels
        
     if i==1
         img3 = img2;
         img2 = filter_gaussian(img2,7,.5); %slightly filter bottom level
     end
        
     imp{i}=img2;
     A = filter_gaussian(img2,7,sigma);    %calculate difference of gaussians
     B = filter_gaussian(A,7,sigma);
     pyr{i} = A-B;  %store result in cell array
     
     
     
     if i==1
         img2 = img3;
     else
         B = filter_gaussian(img2,7,sigma2);    %anti-alias for downsampling
         B = filter_gaussian(B,7,sigma2);
     end
     
     img2 = resample_bilinear(B,scl);       %downsample for next level
     
end

%show_pyramid(pyr)  %show pyramid if desired

%///////////////////////////////////////////////////////////////////////////////
function show_pyramid(pyr)

    close all

    [h,w] = size(pyr);
    for i=1:w
    
        figure
        imagesc(pyr{i});
        colormap gray;
    end