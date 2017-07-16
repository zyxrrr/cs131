function accuracy = EvaluateSegmentation(maskGt, x)
% Compute the pixel-wise accuracy of a foreground-background segmentation
% given a ground truth segmentation. You can provide the
% foreground-background segmentation either as a mask (as output by
% ChooseSegments) or as a struct of segmentation data (as described in
% ComputeSegmentation). In the latter case, the best assignment of each
% segment to either foreground or background is chosen automatically.
%
% USAGE 1: Automatically assign segments to either foreground or background
% accuracy = EvaluateSegmentation(maskGt, segments)
%
%
% INPUTS
% maskGt - The ground truth foreground-background segmentation. A logical
%          array of size h x w where maskGt(y, x) is true if and only if
%          pixel (y, x) of the original image was part of the foreground.
% segments - A struct array of segments as described in
%            ComputeSegmentation.m.
%
% OUTPUT
% mask - A logical array of the same size as maskGt where mask(y, x) is
%        true if and only if the segment to which (y, x) was assigned was
%        assigned to the foreground.
%
%
%
% USAGE 2: Use your own assignments of segments to foreground or
%          background.
% accuracy = EvaluateSegmentation(maskGt, mask)
%
% INPUTS
% maskGt - The ground truth foreground-background segmentation. A logical
%          array of size h x w where maskGt(y, x) is true if and only if
%          pixel (y, x) of the original image was part of the foreground.
% mask   - The computed foreground-background segmentation. A logical array
%          of the same size and format as maskGt.
%
% OUTPUTS
% accuracy - The fraction of pixels where maskGt and mask agree. A bigger
%            number is better, where 1.0 indicates a perfect segmentation.

    if isstruct(x)
        mask = ChooseBestSegments(maskGt, x);
    elseif islogical(x)
        mask = x;
    else
        error(['Unrecognized input; x should either be a struct array or a' ...
               ' logical array.'])
    end
    accuracy = ComputeAccuracy(maskGt, mask);
end


function mask = ChooseBestSegments(maskGt, segments)
% Selects the subset of segments that give the highest accuracy on a given
% ground truth segmentation.
%
% INPUTS
% maskGt - The ground truth foreground-background segmentation. A logical
%          array of size h x w where maskGt(y, x) is true if and only if
%          pixel (y, x) of the original image was part of the foreground.
% segments - A struct array of segments as described in
%            ComputeSegmentation.m.
%
% OUTPUT
% mask - A logical array of the same size as maskGt where mask(y, x) is
%        true if and only if the segment to which (y, x) was assigned was
%        assigned to the foreground.

    mask = zeros(size(maskGt));
    
    for i = 1:length(segments)
        segment_labels = maskGt(segments(i).mask);
        good = sum(segment_labels(:));
        bad = numel(segment_labels) - good;
        if good >= bad
            mask(segments(i).mask) = 1;
        end
    end
end

function accuracy = ComputeAccuracy(maskGt, mask)
% Compute the pixel-wise accuracy of a foreground-background segmentation
% given a ground truth segmentation.
%
% INPUTS
% maskGt - The ground truth foreground-background segmentation. A logical
%          array of size h x w where maskGt(y, x) is true if and only if
%          pixel (y, x) of the original image was part of the foreground.
% mask   - The computed foreground-background segmentation. A logical array
%          of the same size and format as maskGt.
%
% OUTPUTS
% accuracy - The fraction of pixels where maskGt and mask agree. A bigger
%            number is better, where 1.0 indicates a perfect segmentation.

    same = (maskGt == mask);
    accuracy = sum(same(:)) / numel(mask);
end