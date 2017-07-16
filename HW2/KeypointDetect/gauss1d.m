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
