function [yctr,xctr] = fit_paraboloid(data)

%Create Solution Matrix
[yp,xp] = meshgrid(-1:1,-1:1);
yp=yp(:); xp=xp(:);

M=zeros(9,6);
for i=1:length(yp)
    x=xp(i); y=yp(i);
    M(i,:) = [x^2 y^2 x*y x y 1];
end

g = data';
g = g(:);

cf = inv(M'*M)*M'*g;
a=cf(1); b=cf(2); c=cf(3); d=cf(4); e=cf(5);
xctr = (-2*b*d+e*c)/(4*a*b-c*c);
yctr = (-2*a*e-d*c)/(4*a*b-c*c);

%A = [a c/2; c/2 b];
%[u,s,v] = svd(A);
