function featuresNorm = NormalizeFeatures(features)
% Normalize image features to have zero mean and unit variance. This
% normalization can cause k-means clustering to perform better.
%
% INPUTS
% features - An array of features for an image. features(i, j, :) is the
%            feature vector for the pixel img(i, j, :) of the original
%            image.
%
% OUTPUTS
% featuresNorm - An array of the same shape as features where each feature
%                has been normalized to have zero mean and unit variance.

    features = double(features);
    featuresNorm = features;
num=size(features,1)*size(features,2);
dim3=size(features,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%                                YOUR CODE HERE:                               %
% temp=repmat(features,size(features,3),num);
temp=sum(features,1);
temp=sum(temp,2);
temp=temp(:);
uj=temp/num;
tempuj=zeros(size(features));
for ii=1:dim3
    tempuj(:,:,ii)=uj(ii);
end
% feasize=size(features);
% feasize(1)=feasize(1)/length(uj);
% 
% tempuj=repmat(uj,feasize);
temp1=(features-tempuj).^2;
temp1=sum(sum(temp1,1),2);
temp1=temp1(:);
gam=sqrt(temp1/(num-1));
tempgam=zeros(size(features));
for ii=1:dim3
    tempgam(:,:,ii)=gam(ii);
end
% gam=repmat(gam,size(features));
featuresNorm=(features-tempuj)./tempgam;
%                                                                              %
%                HINT: The functions mean and std may be useful                %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end