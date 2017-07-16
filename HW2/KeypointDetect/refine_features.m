%/////////////////////////////////////////////////////////////////////////////////////////////
%
% refine_features - scale space feature detector based upon difference of gaussian filters.
%                 selects features based upon their maximum response in scale space
%
% Usage:  features = refine_features(img, pyr, scl, imp, pts, radius, min_separation, edgeratio)
%
% Parameters:  
%            
%            img :      original image
%            pyr :      cell array of filtered image pyramid
%            scl :      scaling factor between levels of the image pyramid
%            imp :      image pyramid cell array
%            pts :      cell array of selected points on each pyramid level
%            radius :   radius for edge rejection test
%            min_separation :  minimum separation distance for maxima rejection.
%            edgeratio: maximum ratio of eigenvalues of feature curvature for edge rejection.
%
% Returns:
%
%            features  - matrix with one row for each feature consisting of the following:
%              [x loc,  y loc, scale value, size, edge flag, edge orientation, scale space curvature]
%              
%               where:
%               x loc and y loc are the x and y positions on the original image
%               scale value is the sub level adjusted scale value 
%               size is the size of the feature in pixels on the original image
%               edge flag is zero if the feature is classified as an edge
%               edge orientation is the angle made by the edge through the feature point
%               scale space curvature is a rough confidence measure of feature prominence
%
% Author: 
% Scott Ettinger
% scott.m.ettinger@intel.com
%
% May 2002
%/////////////////////////////////////////////////////////////////////////////////////////////

function [features,keys] = refine_features(img, pyr, scl, imp,pts, radius, min_separation, edgeratio)
    
[ho,wo]=size(img);
[h2,w2]=size(imp{2});

%create offset list for ring of pixels
[ry2,rx2]=meshgrid(-20:20,-20:20);    
z = (rx2.^2+ry2.^2)<=(radius)^2 & (rx2.^2+ry2.^2)>(radius-1)^2;
[ry2,rx2]=find(z);
rx2=rx2-21; ry2=ry2-21;

ndx = 1;

%loop through each level of pyramid
for j=2:length(imp)-1                                               

    p=pts{j};                                                       %get current level filter response
    img=imp{j};                                                     %get current level image

    [dh,dw]=size(img);
    np = 1;
    min_sep = min_separation*max(max(pyr{j}));                      %calculate minimum separation for valid maximum
    for i=1:size(p,1)
    
        
        ptx = p(i,2);
        pty = p(i,1);
    
        if p(i,1) < radius+3                                       %ensure neighborhood is not outside of image
            p(i,1) = radius+3;
        end
        if p(i,1) > dh-radius-3
            p(i,1) = dh-radius-3;
        end
        if p(i,2) < radius+3
            p(i,2) = radius+3;
        end
        if p(i,2) > dw-radius-3
            p(i,2) = dw-radius-3;
        end
            
        %adjust to sub pixel maxima location
        
        r = pyr{j}(pty-1:pty+1,ptx-1:ptx+1);                        %get 3X3 neighborhood of pixels
        
        [pcy,pcx] = fit_paraboloid(r);                              %find center of paraboloid fit to points
        
        if abs(pcy)>1                                               %ignore extreme offsets due to singularities in parabola fitting
            pcy=0;
            pcx=0;
        end
        if abs(pcx)>1
            pcx=0;
            pcy=0;
        end
               
        p(i,1) = p(i,1) + pcy;                                      %adjust center
        p(i,2) = p(i,2) + pcx;
        ptx = p(i,2);
        pty = p(i,1);
        
        px=(pts{j}(i,2)+pcx - 1)*scl^(j-2) + 1;                     %calculate point locations at pyramid level 2
        py=(pts{j}(i,1)+pcy - 1)*scl^(j-2) + 1;
                 
        %calculate Sub-Scale level adjustment
        y1 = interp(pyr{j-1},(p(i,2)-1)*scl+1, (p(i,1)-1)*scl+1);   %get response on surrounding scale levels using interpolation
        y3 = interp(pyr{j+1},(p(i,2)-1)/scl+1, (p(i,1)-1)/scl+1);
        y2 = interp(pyr{j},p(i,2),p(i,1));
        
        coef = fit_parabola(0,1,2,y1,y2,y3);                        % fit neighborhood of 3 scale points to parabola 
        scale_ctr = -coef(2)/2/coef(1);                             %find max in scale space 
        
        if abs(scale_ctr-1)>1                                       %ignore extreme values due to singularities in parabola fitting
            scale_ctr=0;
        end

        %eliminate edge points and enforce minimum separation
        
        rad2 = radius * scl^(scale_ctr-1);                          %adust radius size to account for new scale value
        
        o=0:pi/8:2*pi-pi/8;                                         %create ring of points at radius around test point
        rx = (rad2)*cos(o);
        ry = (rad2)*sin(o);
        
        rmax = 1e-9;                                                %init max and min values
        rmin = 1e9;
        
        gp_flag = 1;
        pval = interp(pyr{j},ptx,pty);                              %get response at feature center
        rtst = [];
                
        %check points on ring around feature point
        for k=1:length(rx)                           
            rtst(k) = interp(pyr{j},ptx+rx(k),pty+ry(k));           %get ring point value with bilinear interpolation
            
            if pval> 0                                              %calculate distance from feature point for each point in ring
                rtst(k) = pval - rtst(k);
            else
                rtst(k) = rtst(k) - pval;
            end
            
            gp_flag = gp_flag * rtst(k)>min_sep;                    %test for valid maxima above noise floor
            
            if rtst(k)>rmax                                         %find min and max
                rmax = rtst(k);
            end
            if rtst(k)<rmin
                rmin = rtst(k);
            end
         end        
        
    
        fac = scl/(wo*2/size(pyr{2},2));                            %calculate size offset due to edge effects of downsampling

        [cl,or] = f_class(rtst);                                    %classify features and get orientations


            
        if rmax/rmin > edgeratio                                    %test for edge criterion
            gp_flag=0;
            
            if cl ~= 2                                              %keep all intersections (# ridges > 2)
                gp_flag = 1;
            else    
                ang = min(abs([(or(1)-or(2)) (or(1)-(or(2)-2*pi))]));
                if ang < 6.5*pi/8;                                  %keep edges with angles more acute than 145 deg.
                    gp_flag = 1;
                end
            end
            
     
        end
         
        %save info
       
        features(ndx,1) = (px-1)*wo/w2*fac +1;                      %save x and y position IN ORIGINAL IMAGE (sub pixel adjusted)
        features(ndx,2) = (py-1)*wo/w2*fac +1;
        features(ndx,3) = j+scale_ctr-1;                            %save scale value (sub scale adjusted in units of pyramid level)
        features(ndx,4) = ((7-4)*scl^(j-2+scale_ctr-1))*wo/w2*fac;  %save size of feature on original image        
        features(ndx,5) = gp_flag;                                  %save edge flag
        features(ndx,6) = or(1);                                    %save edge orientation angle
        features(ndx,7) = coef(1);                                  %save curvature of response through scale space
        features(ndx,8) = ptx;                                       %save x and y position in the current pyramid level
        features(ndx,9) = pty;           % i.e. the center pixel is imp{round(features(ndx,3))}(py,px)

        if features(ndx,1) > wo
            px
        end
 
        
        keys(ndx,:) = construct_key(ptx,pty,imp{j},3 * scl^(scale_ctr-1));
        ndx = ndx + 1;
    end
    
end


function v = interp(img,xc,yc)                                      %bilinear interpolation between points

    
       px = floor(xc);
       py = floor(yc);
       alpha = xc-px;
       beta = yc-py;

       nw = img(py,px);
       ne = img(py,px+1);
       sw = img(py+1,px);
       se = img(py+1,px+1);
       
       v = (1-alpha)*(1-beta)*nw + ...                              %interpolate
              (1-alpha)*beta*sw + ...
              alpha*(1-beta)*ne + ...
              alpha*beta*se;
          



    