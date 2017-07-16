%/////////////////////////////////////////////////////////////////////////////////////////////
% Author : Scott Ettinger
%
% filter_gaussian(img, order, sig)  
%
% The image is first padded with the outer image data enough times to allow for the size of the 
% filter used. 

function image_out = filter_gaussian(img,order,sig)

img2 = img;
for i=1:floor(order/2)  %pad image borders with enough for filter order
    
    [h,w] = size(img2);
   
    img2 = [img2(1,1)  img2(1,:)  img2(1,w);
            img2(:,1)  img2       img2(:,w);
            img2(h,1)  img2(h,:)  img2(h,w)];
end 
   
f = gauss1d(order,sig); %create filter coefficient matrix
    
image_out = conv2(img2,f,'valid'); % do the filtering
image_out = conv2(image_out,f','valid'); % do the filtering

%/////////////////////////////////////////////////////////////////////////////////////////

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


%/////////////////////////////////////////////////////////////////////////////////////////

function f = gauss2d(order,sig)

f=0;
i=0;
j=0;

%generate gaussian coefficients 

for x = -fix(order/2):1:fix(order/2)
    j=j+1;
    i=0;
    for y = -fix(order/2):1:fix(order/2)
        i=i+1;
        f(i,j) = 1/2/pi*exp(-((x^2+y^2)/(2*sig^2)));
    end
end

f = f / sum(sum(f)); %normalize filter