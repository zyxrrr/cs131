function BoundingBox = SlideWindowDetector(Template, I, Dist, isMax)
%SlideWindowDetector 
%   Find the most similar regions to template images in I.
%
%Input:
%   Template: the template image
%   I: the image detector will run on
%   Dist: a function handler of distance measure function
%   isMax: a flag that represents if the highest score is preferred
%
%Output:
%   BoundingBox: the bounding box for visualisation, [left, right, upper, bottom]
%   left/right: the leftmost/rightmost index
%   upper/bottom: the upper/bottom index
%

Template = RGB2Lab(double(Template));
I = RGB2Lab(double(I));

ratio = size(Template, 1) / size(Template, 2);

[n, m, ~] = size(I);

if isMax,
    score = -Inf;
else
    score = Inf;
end

left = 0;
right = 0;
upper = 0;
bottom = 0;

wid_step = 15;
ht_step = 15;

for scale = .75 : .25 : 3,
    winWidth = round(size(Template, 1)*scale);
    winHeight = round(size(Template, 2)*scale);
    disp(['scanning windows of scale ' num2str(scale)])
    
    
    for i = 1 : ht_step : (n-winHeight),
%         if ( (i + winHeight - 1) > n ),
%             continue;
%         end
        
        for j = 1 : wid_step : (m-winWidth), 
%             if ( (j + winWidth - 1) > m ),
%                 continue;
%             end
            
            eval = Dist(Template, I(i:i+winHeight-1, j:j+winWidth-1, :));
            if ( (isMax &&  eval >= score) || (~isMax && eval <= score) ),
                score = eval;
                left = j;
                right = j+winWidth-1;
                upper = i;
                bottom = i+winHeight-1;
            end
        end
    end
end

BoundingBox = [left, right, upper, bottom];

end

