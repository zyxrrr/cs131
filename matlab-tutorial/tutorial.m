%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Introduction to Matlab 
% (adapted from https://cs.brown.edu/courses/cs143/docs/matlab-tutorial/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Symbol "%"is used to comment a line
%% Helpful commands
clc;
clear all;
close all;
help imshow;
who;
whos;
%% Basics
% data type
5       % integer 32-bit
3.1415  % double 64-bit
isfloat(5.0) 

% Arithmetic 
1 + 2
1 / 2
2 ^ 5

% Logic 
1 == 0
1 ~= 0
1 && 0
1 || 0

% variable
a = 4                   % displays output
b = 0.5;                % ";" suppresses output
c = a ^ b

%% Vector and matrix, Basic
% vector
s = 5                   % A scalar
r = [1 2 3]             % A row vector
c = [4; 5; 6]           % A column vector

v = r'
v = 1:3                 % from 1 to 3, with a default size of 1
v = 1:.5:3              % from 1 to 3, with a step size of 0.5

% matrix
A = [1 2 3;4 5 6]   % 2x3 matrix, ";" separates row, "," separates column (optional)
B = zeros(2,4)      % 2x4 matrix filled with zero
B = ones(2,4)       % 2x4 matrix filled with one
C = eye(3)          % 3x3 identity matrix


% indexing
v= 1:.5:3
v(1)                % vector element
A = [1 2 3 4; 5 6 7 8; 9 10 11 12]
A(2,3)              % matrix element
A(2,:)              % 2nd row 
A(2:end,2)          % [6;10;14]

size(A)
size(A, 1)          % number of rows
size(A, 2)          % number of columns
numel(A)            % number of elements

%% Vector and matrix, operations
% vector
a = 1:3
b = 4:6
a + b

2 * a               % scalar multiplication
a .* b              % element-wise multiplication
a * b'              % vector multiplication

% built-in functions
sum(a)                       % Sum of vector elements
mean(a)                      % Mean of vector elements
var(a)                       % Variance of elements
std(a)                       % Standard deviation
max(a)                       % Maximum
min(a)                       % Minimum
log(a)                       % Element-wise logarithm

% matrix
A = [1 2; 3 4; 5 6];         % A 3x2 matrix
B = [5 6 7];                 % A 1x3 row vector
B * A                        % Vector-matrix product results in
                             %   a 1x2 row vector
                             
B = A(:)                     % 6x1 column vector 
max(B(:))                    % max of all elements

A = reshape(B, 2, 3)
C = repmat(B, 1, 2)

[U, S, V] = svd(A)
%% Control flow
% Copy positive elements from A to B
% Implementation using loops:
A = [1 -1 1; -1 1 -1; 1 -1 1]
[m,n] = size(A);
B = zeros(m,n);
for i=1:m
  for j=1:n
    if A(i,j)>0
      B(i,j) = A(i,j);
    end
  end
end
B
% All this can be computed w/o any loop!
B = zeros(m,n);
ind = find(A > 0);           % Find indices of positive elements of A 
                             %   (see "help find" for more info)
B(ind) = A(ind);             % Copies into B only the elements of A
                             %   that are > 0
B
%% Image Processing
img = imread('superman.png');
imshow(img);
MINGREEN = 100; MAXGREEN = 220; 
mask = ~(MINGREEN <= img(:,:,2) & img(:,:,2) <= MAXGREEN);
img_new = repmat(mask,[1 1 3]) .* double(img);
figure;
imshow(uint8(img_new));
%% Plot
figure;                      % Open new figure
x = pi*[-24:24]/24;          % 1x49 row vec
plot(x, sin(x));
xlabel('radians');           % Assign label for x-axis
ylabel('sin value');         % Assign label for y-axis
title('Sin wave');           % Assign plot title


