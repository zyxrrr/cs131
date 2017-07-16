vectorize = false;

% Read in the images. They must be the same size.
superman = imread('superman.png');
space = imread('space.png');

characterImg = superman;
backgroundImg = space;

% Create a matrix matching the dimensions of characterImg.
outputImg = zeros(size(characterImg));
height = size(characterImg, 1);
width = size(characterImg, 2);

% By trial and error, I determined that the green screen pixels are within
% these color values.
MINRED = 10; MINGREEN = 100; MINBLUE = 10;
MAXRED = 160; MAXGREEN = 220; MAXBLUE = 110;

if ~vectorize
    % The straightforward implementation using nested for loops.
    for y = 1:height
        for x = 1:width
            redMatch = MINRED <= superman(y, x, 1) && superman(y, x, 1) <= MAXRED;
            greenMatch = MINGREEN <= superman(y, x, 2) && superman(y, x, 2) <= MAXGREEN;
            blueMatch = MINBLUE <= superman(y, x, 3) && superman(y, x, 3) <= MAXBLUE;
            match = redMatch && greenMatch && blueMatch;
            if match
                outputImg(y,x,:) = backgroundImg(y,x,:);
            else
                outputImg(y,x,:) = characterImg(y,x,:);
            end
        end
    end
else
    % The advanced, fast implementation using matrix math.

    % Make a 2D array that holds a '1' where red is within bounds.
    redMatchImg = (MINRED <= superman(:,:,1)) & (superman(:,:,1) <= MAXRED);
    greenMatchImg = MINGREEN <= superman(:,:,2) & superman(:,:,2) <= MAXGREEN;
    blueMatchImg = MINBLUE <= superman(:,:,3) & superman(:,:,3) <= MAXBLUE;

    % Holds a '1' where all colors matched the green screen.
    matchImg = redMatchImg & greenMatchImg & blueMatchImg;

    % Duplicate the matrix to convert it from 480x640 to 480x640x3.
    % This makes it easy to do an element-by-element multiplication with the images.
    matchImg = repmat(matchImg, [1 1 3]);

    % Make another matrix which is '1' everywhere the original was '0', and vice versa
    nonMatchImg = ~matchImg;

    % Now, multiply the character image by '1' where there's no green screen, and
    % multiply the background by '1' where there IS green screen. This
    % replaces the "if" statement above.
    outputImg = double(characterImg) .* nonMatchImg + double(backgroundImg) .* matchImg;

    % The cast to double is to deal with a MATLAB quirk: images are read in
    % as arrays of type "uint8" (a.k.a. byte). But MATLAB generally needs to work in
    % doubles. So we'll convert to double to do math, and then convert back
    % to uint8, below, to display.
end

% Note that, if the image color format is 0 to 255, we need to cast to uint8 for it to display.
imshow(uint8(outputImg), []);
