function viewMultipleFaces( faceMatrix, stride )
%VIEWFACE Summary of this function goes here
%   Detailed explanation goes here
    stride = max(stride,1);
    disp('Displaying faces. Hit Ctrl-C to stop...');
    for i = 1:stride:size(faceMatrix,2)
        viewFace( faceMatrix(:,i) );
        pause(.5);
    end

end
