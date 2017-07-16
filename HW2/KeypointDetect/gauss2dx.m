%Author : Scott Ettinger
%Details:
%
%gauss2d(order, sig)  
%
%Generates a normalized 2d matrix to use as a gaussian convolution filter
%  order - size of filter matrix.  Returns an order X order matrix
%  sig - sigma value in gaussian equation

function f = gauss2dx(order,sig)

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