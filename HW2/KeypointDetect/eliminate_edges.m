function [f2,k2] = eliminate_edges( features,keys);

f2 = features(find(features(:,5)>0),:);
k2 = keys(find(features(:,5)>0),:);


