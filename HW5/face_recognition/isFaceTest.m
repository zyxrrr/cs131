function isFaceTest()
% Loads test face data and asks isFace() to say whether it's human.

% Directory that holds face images, named like 1.png. All images must be
% the same size, and faces must be aligned.
trueExamples = './facetestset/true/'; 
% Directory that holds non-face images, named like 1.png. All images must
% be the same size, and faces must be aligned.
falseExamples = './facetestset/false/'; 

numCorrect = 0;
total = 0;

% check true examples
faceIndex = 1;
fileExists = true;
correctLabel=true;
while fileExists
    filename = [trueExamples num2str(faceIndex) '.png'];
    try
        img = double(rgb2gray(imread(filename)));
    catch err%we'll come here if file doesn't exist
        fileExists = false;
    end
    
    if fileExists
        if isFace(img(:)) == correctLabel
            numCorrect = numCorrect +1;
            disp([filename ' label was correct.'])
        else
            disp([filename ' label was incorrect.'])
        end
        total = total+1;
        faceIndex = faceIndex+1;
    end
end

% check false examples
faceIndex = 1;
fileExists = true;
correctLabel=false;
while fileExists
    filename = [falseExamples num2str(faceIndex) '.png'];
    try
        img = double(rgb2gray(imread(filename)));
    catch err%we'll come here if file doesn't exist
        fileExists = false;
    end
    
    if fileExists
        if isFace(img(:)) == correctLabel
            numCorrect = numCorrect +1;
            disp([filename ' label was correct.'])
        else
            disp([filename ' label was incorrect.'])
        end
        total = total+1;
        faceIndex = faceIndex+1;
    end
end

disp(['You got ' num2str(100.0*numCorrect/total) '% correct']);

end
