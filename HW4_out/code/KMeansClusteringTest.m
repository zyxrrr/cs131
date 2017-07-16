function KMeansClusteringTest(visualize)
% Tests your implementation of KMeansClustering.m by comparing its output
% on a testing dataset with the output of our reference implementation on
% the same dataset.
%
% INPUT
% visualize - Whether or not to visualize each step of the KMeans
%             algorithm. Optional; default is true.

    if nargin < 1
        visualize = true;
    end
	if visualize
		disp('Hit Enter to run the next iteration')
	end
    load('../test_data/KMeansClusteringTest.mat');
    my_idx = KMeansClustering(X, num_clusters, visualize, centers);
    
    if all(my_idx == idx)
        disp(['Congrats! Your KMeansClustering algorithm produces the same ' ...
             'output as ours.']);
    else
        disp(['Uh oh - Your KMeansClustring algorithm produces a different ' ...
              ' output from ours.']);
    end
end