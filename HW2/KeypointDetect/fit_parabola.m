function [c]=fit_parabola(x1, x2, x3, y1, y2, y3)

z = [x1^2 x1 1; x2^2 x2 1; x3^2 x3 1];
c = inv(z)*[y1; y2; y3];
