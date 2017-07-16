function D = ChiSquareDist( I1, I2, nbins )
%HistIntersectDist
%   Compute the chi square measure for the two given image
%   patches.
%
%Input:
%   I1: image patch 1
%   I2: image patch 2
%   nbins: number of bins for histograms
%
%Output:
%   D: Chi square measure (a real number)
%
    if nargin == 2,
        nbins = 20;
    end
    
	
	D = 0;
    % YOUR CODE STARTS HERE
    H1=Histogram(I1,nbins);
    H2=Histogram(I2,nbins);
    H=[H1 ;H2];
    sumH=sum(H,1);
    subH=(H1-H2).^2;
    ind=sumH==0;
    ind=~ind;
    D=sum(subH(ind)./sumH(ind));
    % YOUR CODE ENDS HERE
end

