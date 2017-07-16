
%/////////////////////////////////////////////////////////////////////////////////////////////
%
% find_extrema - finds local maxima within a grayscale image.  Each point is 
%                checked against all of the pixels within a given radius to be a local max/min.
%                The magnitude of pixel values must be above the given threshold to be picked 
%                as a valid maxima or minima. 
%
% Usage:  m = find_extrema(img,thresh,radius,min_separation)
%
% Parameters:   
%            img :      image matrix
%            thresh :   threshold value
%            radius :   pixel radius          
%
% Returns:
%
%            m       - an nX2 matrix of row,column coordinates of selected points
%
% Author: 
% Scott Ettinger
% scott.m.ettinger@intel.com
%
% May 2002
%/////////////////////////////////////////////////////////////////////////////////////////////


function [mx] = find_extrema(img,thresh,radius)

%img = abs(img);

[h,w] = size(img);

% get interior image subtracting radius pixels from border
p = img(radius+1:h-radius, radius+1:w-radius);  

%get pixels above threshold
[yp,xp] = find(p>thresh);     
yp=yp+radius; xp=xp+radius;
pts = yp+(xp-1)*h;

%create offset list for immediate neighborhood
z=ones(3,3);                    
z(2,2)=0;
[y,x]=find(z);
y=y-2; x=x-2;

if size(pts,2)>size(pts,1)
    pts = pts';
end

%test for max within immediate neighborhood
if size(pts,1)>0
    maxima=ones(length(pts),1);
    for i=1:length(x)
        pts2 = pts + y(i) + x(i)*h;
        maxima = maxima & img(pts)>img(pts2);
    end
    
    xp = xp(find(maxima));                          %save maxima 
    yp = yp(find(maxima));
    pts = yp+(xp-1)*h;                              %create new index list of good points
end
    
%create offset list for radius of pixels
[y,x]=meshgrid(-20:20,-20:20);  
z = (x.^2+y.^2)<=radius^2 & (x.^2+y.^2)>(1.5)^2;    %include points within radius without immediate neighborhood
[y,x]=find(z);
x=x-21; y=y-21;

%create offset list for ring of pixels
[y2,x2]=meshgrid(-20:20,-20:20);    
z = (x2.^2+y2.^2)<=(radius)^2 & (x2.^2+y2.^2)>(radius-1)^2;
[y2,x2]=find(z);
x2=x2-21; y2=y2-21;

maxima = ones(length(pts),1);


%test within radius of pixels (done after first test for slight speed increase)
if size(pts,1)>0
    for i = 1:length(x)
        pts2 = pts + y(i) + x(i)*h;
        maxima = maxima & img(pts)>img(pts2);       %test points   
    end
    xp = xp(find(maxima));                          %save maxima from immediate neighborhood
    yp = yp(find(maxima));
    pts = yp+(xp-1)*h;                              %create new index list

    mx = [yp xp];
    
else
    mx = [];
end
   


