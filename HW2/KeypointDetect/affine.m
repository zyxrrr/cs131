function img2 = affine(img, r, sx, sy, a, b, xo, yo)

R = [cos(r) -sin(r) 0; 
     sin(r) cos(r)  0; 
     0      0       1];
 
S = [sx  a   0;
     b  sy   0;
     0   0   1];
 
T2 = [1  0  -xo;
      0  1  -yo;
      0  0   1];
  
T1 = [1  0  xo;
      0  1  yo;
      0  0  1];

A = T1*R*S*T2;

[h,w]=size(img);

[x,y] = meshgrid(1:h,1:w);
x=x(:);
y=y(:);

XP = [x';y';ones(1,length(x))];

X = A*XP;

z = find(X(1,:)>w-1);
X(1,z) = w-1;

z = find(X(1,:)<=1);
X(1,z) = 1.5;

z= find(X(2,:)>h-1);
X(2,z) = h-1;

z= find(X(2,:)<1.5);
X(2,z) = 1.5;

x = X(1,:);
y = X(2,:);

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

img2 = reshape(img2,h,w);

imagesc(img2);

   