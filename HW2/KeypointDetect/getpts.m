
%display features with sub-pixel and sub-scale accuracy
%Scott Ettinger

function [features] = getpts(img, pyr, scl,imp,pts,hood_size,radius,min_separation,edgeratio)

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
       

    
[ho,wo]=size(img);
[h2,w2]=size(imp{2});

hood_size = hood_size + ~mod(hood_size, 2);  % ensure neighborhood size is odd
w = (hood_size+1)/2;


%create offset list for ring of pixels
[ry2,rx2]=meshgrid(-20:20,-20:20);    
z = (rx2.^2+ry2.^2)<=(radius)^2 & (rx2.^2+ry2.^2)>(radius-1)^2;
[ry2,rx2]=find(z);
rx2=rx2-21; ry2=ry2-21;

F = fspecial('gaussian', hood_size, 2);

ndx = 1;

for j=2:length(imp)-1

    p=pts{j};
    img=imp{j};

    [dh,dw]=size(img);
    np = 1;
    min_sep = min_separation*max(max(pyr{j}));
    for i=1:size(p,1)
    
        
        ptx = p(i,2);
        pty = p(i,1);
    
        if p(i,1) < radius+3       %ensure neighborhood is not outside of image
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
        
        r = [pyr{j}(pty-1,ptx-1:ptx+1) ;pyr{j}(pty,ptx-1:ptx+1) ;pyr{j}(pty+1,ptx-1:ptx+1)];
        
        [pcy,pcx] = fit_paraboloid(r); %find center of paraboloid
        
        if abs(pcy)>1   %ignore extreme offsets due to singularities in parabola fitting
            pcy=0;
            pcx=0;
        end
        if abs(pcx)>1
            pcx=0;
            pcy=0;
        end
               
        p(i,1) = p(i,1) + pcy;  %adjust center
        p(i,2) = p(i,2) + pcx;
        ptx = p(i,2);
        pty = p(i,1);
        
        px=(pts{j}(i,2)+pcx - 1)*scl^(j-2) + 1;  %calculate point locations at pyramid level 2
        py=(pts{j}(i,1)+pcy - 1)*scl^(j-2) + 1;
                 
        y1 = interp(pyr{j-1},(p(i,2)-1)*scl+1, (p(i,1)-1)*scl+1);   %get response on surrounding scale levels using interpolation
        y3 = interp(pyr{j+1},(p(i,2)-1)/scl+1, (p(i,1)-1)/scl+1);
        y2 = interp(pyr{j},p(i,2),p(i,1));
        
        coef = fit_parabola(0,1,2,y1,y2,y3);    % fit 3 scale points to parabola 
        scale_ctr = -coef(2)/2/coef(1);         %find max in scale space 
        
        if abs(scale_ctr-1)>1   %ignore extreme values due to singularities in parabola fitting
            scale_ctr=0;
        end

        %eliminate edge points and enforce minimum separation
        
        rad2 = radius * scl^(scale_ctr-1);  %adust radius size for scale space
        
        o=0:pi/8:2*pi-pi/8;         %create ring of points at radius around test point
        rx = (rad2)*cos(o);
        ry = (rad2)*sin(o);
        
        rmax = 1e-9;
        rmin = 1e9;
        
        gp_flag = 1;
        pval = interp(pyr{j},ptx,pty);
        rtst = [];
                
        %check points on ring around feature point
        for k=1:length(rx)                           
            rtst(k) = interp(pyr{j},ptx+rx(k),pty+ry(k));   %get value with bilinear interpolation
            
            if pval> 0                      %calculate distance from feature point response for each point
                rtst(k) = pval - rtst(k);
            else
                rtst(k) = rtst(k) - pval;
            end
            
            gp_flag = gp_flag * rtst(k)>min_sep;   %test for valid maxima above noise floor
            
            if rtst(k)>rmax         %find min and max
                rmax = rtst(k);
            end
            if rtst(k)<rmin
                rmin = rtst(k);
            end
         end        
        
    
        fac = scl/(wo*2/size(pyr{2},2));
        [cl,or] = f_class(rtst);


            
        if rmax/rmin > edgeratio  
            gp_flag=0;
            
            if cl ~= 2                      %keep all edge intersections
                gp_flag = 1;
            else    
                ang = min(abs([(or(1)-or(2)) (or(1)-(or(2)-2*pi))]));
                if ang < 6.5*pi/8;     %keep edges with angles more acute than 145 deg.
                    gp_flag = 1;
                end
            end
            
     
        end
         
        %save info
        features(ndx,1) = (px-1)*wo/w2*fac +1;      %save x and y position (sub pixel adjusted)
        features(ndx,2) = (py-1)*wo/w2*fac +1;
        features(ndx,3) = j+scale_ctr-1;            %save scale value (sub scale adjusted in units of pyramid level)
        features(ndx,4) = ((hood_size-4)*scl^(j-2+scale_ctr-1))*wo/w2*fac; %save size of feature on original image        
        features(ndx,5) = gp_flag;                  %save edge flag
        features(ndx,6) = or(1);                    %save edge orientation angle
        features(ndx,7) = coef(1);                  %save curvature of response through scale space
        ndx = ndx + 1;
        
    end
    
end


function v = interp(img,xc,yc)      %bilinear interpolation between points

    
       px = floor(xc);
       py = floor(yc);
       alpha = xc-px;
       beta = yc-py;

       nw = img(py,px);
       ne = img(py,px+1);
       sw = img(py+1,px);
       se = img(py+1,px+1);
       
       v = (1-alpha)*(1-beta)*nw + ...  %interpolate
              (1-alpha)*beta*sw + ...
              alpha*(1-beta)*ne + ...
              alpha*beta*se;
          

function f = gauss1d(order,sig)

f=0;
i=0;
j=0;

%generate gaussian coefficients 

for x = -fix(order/2):1:fix(order/2)
    i = i + 1;
    f(i) = 1/2/pi*exp(-((x^2)/(2*sig^2)));
end

f = f / sum(sum(f)); %normalize filter



    