function VisualizeClusters2D(points, idx, centers, figHandle)
% Display a visualization of clusters of points in 2D.
%
% Each cluster is shown in a unique color.
%
% The points being clustered are shown as open circles, and cluster centers
% are shown as filled circles.
%
% For clusters of size 1, only the single point is displayed.
%
% For clusters of size 2, a line is drawn between the two points and the
% cluster center is shown.
%
% For clusters of size 3 or greater, the convex hull of the points in the
% cluster is shown and the cluster center is shown.
%
% INPUTS
% points - An array of size n x 2 giving the points being clustered.
%          Specifically, points(i, :) == [xi, yi] gives the coordinates of
%          the ith point.
% idx - A vector giving the assigments of points to clusters. idx(i) == c
%       means that points(i, :) is assigned to cluster c.
% centers - An array giving the centers of the clusters.
%           Specifically, centers(c, :) == [cx, cy] gives the coordinates
%           of the center of the cth cluster. To prevent cluster centers
%           from being drawn, set centers = [].
% figHandle - OPTIONAL: A handle to the figure where the visualization
%             should be drawn. If figHandle is not specified then the
%             visualization is drawn in a new figure.
    
    if nargin < 4
        figHandle = figure;
    end

    POINT_SIZE = 8;
    CENTER_SIZE = 30;
    CONVEX_HULL_ALPHA = 0.25;

    assert(size(points, 2) == 2, 'Must have size(points, 2) == 2');

    % First we need to reindex clusters; otherwise the colors of the
    % clusters will be too close to each other in color space.
    oldIdx = idx;
    idx = ReindexClusters(idx);
    
    numClusters = length(unique(idx));
    
    % Generate colors for all clusters.
    colors = hsv(numClusters);
    
    % Bring the figure to the front and clear it.
    figure(figHandle);
    clf(figHandle);
    
    for i = 1:numClusters
        hold on;
        
        % Extract the points for this cluster
        x = points(idx == i, 1);
        y = points(idx == i, 2);
        
        clusterSize = size(x, 1);
        
        % Plot the points for this cluster
        plot(x, y, 'o', 'Color', colors(i, :), ...
             'MarkerSize', POINT_SIZE);
         
        % For clusters of size 2 and greater we draw the cluster center
        if clusterSize > 1 && ~isempty(centers)
            % Find the index of the center of this cluster; centers(j, :) will
            % be the center of this cluster.
            j = find(idx == i, 1, 'first');
            j = oldIdx(j);
            
            plot(centers(j, 1), centers(j, 2), '.', 'Color', colors(i, :), ...
                 'MarkerSize', CENTER_SIZE);
        end
        
        % For clusters of size 2 we draw a line between the two points; for
        % clusters of size 3 and greater we draw the convex hull of the
        % points in the cluster.
        if clusterSize == 2
            plot(x, y, 'Color', colors(i, :));
        elseif clusterSize > 2
            hull = convhull(x, y);
            fill(x(hull), y(hull), colors(i, :), ...
                 'FaceAlpha', CONVEX_HULL_ALPHA, ...
                 'EdgeColor', colors(i, :));
        end  
        hold off;
    end
end