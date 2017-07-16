function idx = HAClustering(X, k, visualize2D)
% Run the hierarchical agglomerative clustering algorithm.
% 
% The algorithm is conceptually simple:
%
% Assign each point to its own cluster
% While the number of clusters is greater than k:
%   Compute the distance between all pairs of clusters
%   Merge the pair of clusters that are closest to each other
%
% There are many valid ways of determining the distance between two
% clusters. For this assignment we will define the distance between two
% clusters to be the Euclidean distance between their centroids.
%
% Recomputing the centroids of all clusters and the distances between all
% pairs of centroids at each step of the loop would be very slow.
% Thankfully most of the distances and centroids remain the same in
% successive iterations of the outer loop; therefore we can speed up the
% computation by only recomputing the centroid and distances for the new
% merged cluster.
%
% Even with this trick, this algorithm will consume a lot of memory and run
% very slowly when clustering large sets of points. In practice, you
% probably do not want to use this algorithm to cluster more than 10,000
% points.
%
% NOTE: To get full credit for this part you should only update the cluster
% centroids and distances for the merged and deleted clusters at each
% iteration of the main loop.
%
% INPUTS
% X - An array of size m x n containing the points to cluster. Each row is
%     an n-dimensional point, so X(i, :) gives the coordinates of the ith
%     point.
% k - The number of clusters to compute.
% visualize2D - OPTIONAL parameter telling whether or not to visualize the
%               progress of the algorithm for 2D data. If not set then 2D
%               data will not be visualized.
%
% OUTPUTS
% idx     - The assignments of points to clusters. idx(i) = c means that the
%           point X(i, :) has been assigned to cluster c.

    if nargin < 3
        visualize2D = false;
    end

    if ~isa(X, 'double')
        X = double(X);
    end

    % The number of points to cluster.
    m = size(X, 1);
        
    % The dimension of each point.
    n = size(X, 2);
    
    % The number of clusters that we currently have.
    num_clusters = m;
    
    % The assignment of points to clusters. If idx(i) = c then X(i, :) is
    % assigned to cluster c. Since each point is initally assigned to its
    % own cluster, we initialize idx to the column vector [1; 2; ...; m].
    idx = (1:m)';

    % The centroids of all clusters. The row centroids(c, :) is the
    % centroid of the cth cluster. Since each point starts in its own
    % cluster, the centroids are initially the same as the data matrix.
    centroids = X;

    % The number of points in each cluster. If cluster_sizes(c) = n then
    % cluster c contains n points. Since each point is initially assigned
    % to its own cluster, each cluster size is initialized to 1.
    cluster_sizes = ones(m, 1);
    
    % The distances between the centroids of the clusters. For ci != cj,
    % dists(ci, cj) = d means that the Euclidean distance between
    % centroids(ci, :) and centroids(cj, :) is d. We will choose the pair
    % of clusters to merge at each step by finding the smallest element of
    % the dists matrix. We never want to merge a cluster with itself;
    % therefore we set the diagonal elements of dists to be +Inf.
    dists = squareform(pdist(centroids));
    dists = dists + diag(Inf(m, 1));
    
    % If we are going to display the clusters graphically then create a
    % figure in which to draw the visualization.
    figHandle = [];
    if n == 2 && visualize2D
        figHandle = figure;
    end
    
    
    % In the 2D case we can easily visualize the starting points.
    if n == 2 && visualize2D          
        VisualizeClusters2D(X, idx, centroids, figHandle);
%         pause;
    end
    
    while num_clusters > k
        
        
        % Find the pair of clusters that are closest together.
        % Set i and j to be the indices of the nearest pair of clusters.
        i = 0;
        j = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            YOUR CODE HERE                           %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [i j]=find(dists==min(dists(:)));
        i=i(1);
        j=j(1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Make sure that i < j
        if i > j        
            t = i;
            i = j;
            j = t;
        end
                
        % Next we need to merge cluster j into cluster i.
        %
        % We also need to 'delete' cluster j. We will do this by setting
        % its cluster size to 0 and moving its centroid to +Inf. This
        % ensures that the distance from cluster j to any other cluster is
        % +Inf.
        
        % Assign all points currently in cluster j to cluster i.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            YOUR CODE HERE                           %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        indj=find(j==idx);
        idx(indj)=i;        
% idx(j)=i;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Compute the new centroid for clusters i and set the centroid of
        % cluster j to +Inf.
        % HINT: You should be able to compute both updated cluster
        % centroids in O(1) time.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            YOUR CODE HERE                           %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%         indi=find(i==idx);
%         tempcentroid=mean(centroids(indi,:),1);
%         centroids(indi,:)=repmat(tempcentroid,length(indi),1);
%         centroids(indj,:)=Inf;
indmean=[find(i==idx) find(j==idx)];
tempcentroid=mean(X(indmean,:),1);
centroids(i,:)=tempcentroid;
centroids(j,:)=Inf;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Update the size of clusters i and j.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            YOUR CODE HERE                           %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        cluster_sizes(i)=cluster_sizes(i)+cluster_sizes(j);
        cluster_sizes(j)=0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     
        % Update the dists array. In particular, we need to update the
        % distances from clusters i and j to all other clusters.
        % Hint: You might find the pdist2 function useful.
        % Hint: Remember that the diagonal of dists must be +Inf.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            YOUR CODE HERE                           %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dists = squareform(pdist(centroids));
        dists = dists + diag(Inf(m, 1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % If everything worked correctly then we have one less cluster.
        num_clusters = num_clusters - 1;
        
        % In the 2D case we can easily visualize the clusters.
        if n == 2 && visualize2D          
            VisualizeClusters2D(X, idx, centroids, figHandle);
%             pause;
        end
        
    end
    
    % Now we need to reindex the clusters from 1 to k
    idx = ReindexClusters(idx);
end