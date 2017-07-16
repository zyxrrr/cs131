
%/////////////////////////////////////////////////////////////////////////////////////////////
%
% find_features - scale space feature detector based upon difference of gaussian filters.
%                 selects features based upon their maximum response in scale space
%
% Usage:  maxima = find_features(pyr, img, thresh, radius, radius2, min_sep, edgeratio, disp_flag, img_flag)
%
% Parameters:  
%            pyr :      cell array of filtered image pyramid (built with build_pyramid)
%            img :      original image (only used for visualization)
%            thresh :   threshold value for maxima search (minimum filter response considered)
%            radius :   radius for maxima comparison within current scale
%            radius2:   radius for maxima comparison between neighboring scales
%            disp_flag: 1- display each scale level on separate figure.  0 - display nothing
%            img_flag: 1 - display filter responses. 0 - display original images.
%
% Returns:
%
%            maxima  - cell array of nX2 matrices of row,column coordinates of selected points on each scale level
%
% Author: 
% Scott Ettinger
% scott.m.ettinger@intel.com
%
% May 2002
%/////////////////////////////////////////////////////////////////////////////////////////////

function maxima = find_features(pyr, img, scl, thresh, radius, radius2, disp_flag, img_flag)
  %                pts = find_features(pyr,img,scl,thresh,radius,radius2,disp_flag,1);


levels = size(pyr);
levels = levels(2);

mcolor = [ 0 1 0;   %color array for display of features at different scales
           0 1 0;
           1 0 0;
           .2 .5 0;
           0 0 1;
           1 0 1;
           0 1 1;
           1 .5 0
           .5 1 0
          0 1 .5
           .5 1 .5];


[himg,wimg] = size(img);                                            %get size of images
[h,w] = size(pyr{2});

    
for i=2:levels-1

    [h,w] = size(pyr{i});
    [h2,w2] = size(pyr{i+1});
    
    %find maxima
    mx = find_extrema(pyr{i},thresh,radius);                        %find maxima at current scale level
    mx2 = round((mx-1)/scl) + 1;                                    %find coords in level above        
    mx_above = neighbor_max(pyr{i},pyr{i+1},mx,mx2,radius2);        %do neighbor comparison in scale space above

    if i>1
        mx2 = round((mx-1)*scl) + 1;                                %find coords in level below     
        mx_below = neighbor_max(pyr{i},pyr{i-1},mx,mx2,radius2);    %do comparison in scale below
    
        maxima{i} = plist(mx, mx_below & mx_above);                 %get coord list for retained maxima and minima
    else
        maxima{i} = plist(mx, mx_above);
    end
       
    %find minima
    %if i==11,
    %    keyboard;
    %end;
    
    mx = find_extrema(-pyr{i},thresh,radius);                       %find minima at current scale level
    mx2 = round((mx-1)/scl) + 1;                                    %find coords in level above        
    mx_above = neighbor_max(-pyr{i},-pyr{i+1},mx,mx2,radius2);      %do neighbor comparison in scale space above
    if i>1
        mx2 = round((mx-1)*scl) + 1;                                %find coords in level below     
        mx_below = neighbor_max(-pyr{i},-pyr{i-1},mx,mx2,radius2);  %do comparison in scale below
    
        mxtemp = plist(mx, mx_below & mx_above);                    %get coord list for retained maxima and minima
    else
        mxtemp = plist(mx, mx_above);
    end
  

    maxima{i} = [maxima{i}; mxtemp];                                %combine maxima and minima into list for return
    
    
    %display results if desired
    if disp_flag > 0                                                
        figure
        if img_flag == 0
            tmp=resample_bilinear(img,himg/h);
            imagesc(tmp);
            colormap gray;
            show_plist(maxima{i},mcolor(mod(i-1,7)+1,:),'+');
        else
            imagesc(pyr{i});
            colormap gray;
            show_plist(maxima{i},mcolor(mod(i-1,7)+1,:),'+');
        end
    end    
end
    
%//////////////////////////////////////////////////////////////////////////////////////////////
%
%   Compare a vector of pixels with its neighbors in another scale 
%
%//////////////////////////////////////////////////////////////////////////////////////////////

function v = neighbor_max(img1,img2,i,i2,radius)                    % i and i2 are column vectors of r,c coords
    
    if (size(i2,1))==0 | size(img2,1)<11 | size(img2,2)<11
        v=zeros(length(i),1);
    else
        
        [h,w] = size(img1);
        [h2,w2] = size(img2);
    
        [y,x]=meshgrid(-20:20,-20:20);                              %create set of offsets within radius 
        z = (x.^2+y.^2)<=radius^2;
        [y,x]=find(z);
        x=x-21; y=y-21;
    
        radius=ceil(radius);
    
        bound = ones(size(i2,1),2)*[h2-radius 0;0 w2-radius];        %create boundary listing
        i2 = i2 - ((i2 > bound).*(i2-bound+1));                      %test bounds to make all points within image
        i2 = i2 + ((i2 < radius+1).*(radius-i2+1));
        
        
        i2 = vec(i2,h2);                                             %create indices from x,y coords
        i = vec(i,h);
    
        p = img1(i);
        res = ones(length(i),1);
    
        for j=1:length(x)                                            %check against all points within radius
            itest = i2 + x(j) + h2*y(j);
            p2 = img2(itest);
            res = res & (p>=p2);
        end

        
        v = res;                                                     %store results in binary vector
    end
    
%//////////////////////////////////////////////////////////////////////////////////////////////

function v = vec(points,h)

    y = points(:,1);
    x = points(:,2);
    
    v = y + (x-1)*h;  %create index vectors
    
%//////////////////////////////////////////////////////////////////////////////////////////////

function p = plist(points, flags)

    p = points(find(flags),:);
   
    