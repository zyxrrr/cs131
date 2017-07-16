function DrawCircle(x, y, R, color)
% DrawCircle Visualizes a circle
% Input:
%   x, y, R: (x, y) is the center of the fitted circle, R is the radius
%   color is a string: 'k'=black, 'r'=red, 'b'=blue
%
    theta = 0:0.1:2*pi;
    ptx = x + R * cos(theta);
    pty = y + R * sin(theta);
    plot(ptx, pty, ['--' color], 'linewidth', 2);
end