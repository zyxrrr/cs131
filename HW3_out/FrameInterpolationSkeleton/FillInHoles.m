function img = FillInHoles(img)
% Fill in any zero or NaN values in an array using linear interpolation.
%
% INPUTS
% img - A two-dimensional array of size h x w that may contain zeros or NaN
%       values.
%
% OUTPUTS
% img - A copy of the input img with all zero and NaN values filled in
%       using linear interpolation.

    if length(size(img)) ~= 2
        error('img must be 2-dimensional');
    end
    
    if ~any(img(:))
        error('At least one color channel of the image was empty')
    end
    
    filled = (img ~= 0 & ~isnan(img));
    while any(~filled(:))
        % I and J will be column vectors such that img(I(k), J(k)) is an
        % unfilled point for all k.
        [I, J] = find(~filled);
        
        % Construct the coordinates of all neighbors of unfilled points.
        % The neighbors of the point img(I(k), J(k)) will be
        % img(II(k, l), JJ(k, l)) for all l.
        II = [I + 1, I - 1, I, I];
        JJ = [J, J, J + 1, J - 1];
        
        % Check whether each neighbor is within the boundaries of img.
        in_bounds = InBounds(img, II, JJ);
        
        % To avoid out of bounds errors in sub2ind, we replace all the
        % indices of all out of bounds points with [1, 1]. These points
        % will be ignored going forward.
        II(~in_bounds) = 1;
        JJ(~in_bounds) = 1;
        
        % For convenient array operations we also need the linear indices
        % of all points that neighbor unfilled points.
        % ind(y, x) is the linear index of the point (II(y, x), JJ(y, x))
        ind = sub2ind(size(img), II, JJ);
        
        % A good neighbor is one that is in bounds and which has already
        % been filled.
        good_neighbor = in_bounds & filled(ind);
        
        % num_good_neighbors(k) is the number of good neighbors of the
        % point img(I(k), J(k))
        num_good_neighbors = sum(good_neighbor, 2);
        
        % pix(k) is the sum of the values of all good neighbors of
        % img(I(k), J(k)).
        pix = zeros(size(good_neighbor));
        pix(good_neighbor) = img(ind(good_neighbor));
        pix = sum(pix, 2);
        
        % has_good_neighbors(k) tells whether img(I(k), J(k)) has at least
        % one good neighbor.
        has_good_neighbors = (num_good_neighbors > 0);
        
        % ind2 gives linear indices into img of all points that have at
        % least one good neighbor.
        ind2 = sub2ind(size(img), I(has_good_neighbors), J(has_good_neighbors));
        
        % For all points with at least one good neighbor, mark them filled
        % and set their value to the average of all their good neighbors.
        filled(ind2) = true;
        img(ind2) = pix(has_good_neighbors) ./ num_good_neighbors(has_good_neighbors);                
    end
end