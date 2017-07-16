%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Run this script to test your RANSAC() code.
% It should work well on the data with no outliers (first plot),
% as well as the data with outliers (second plot).
% Run the script several times to see different data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=1000;
sigma = .1; %additive noise on good points
outlierFraction=0; %percent of totally random outliers to add

%Data is an Nx2 array. Each row is a point
[Data, trueX, trueY, trueR] = GenData(N, sigma, outlierFraction);

%Number of RANSAC iterations
maxIter = 100;

%With our error function, this is a bound on abs(distance^2 - R^2).
%Points with error < this are called inliers.
maxInlierError = 8.0;

%Number of inliers required to call a fit "good" (not counting the initial
%3 points that were used to fit the circle)
goodFitThresh = 500; 


[cx, cy, R] = RANSAC(Data, maxIter, maxInlierError, goodFitThresh);
figure('Name','No outliers')
hold on
DrawCircle(trueX, trueY, trueR, 'k')
DrawCircle(cx, cy, R, 'r')
plot(Data(:,1),Data(:,2),'k.')
DrawCircle(cx, cy, R,'r') %draw again to ensure it's not hidden by points
axis equal
legend('Truth','Estimate')
hold off


outlierFraction=0.1; %percent of totally random outliers to add
[Data, trueX, trueY, trueR] = GenData(N, sigma, outlierFraction);
%Data is an Nx2 array. Each row is a point
[cx, cy, R] = RANSAC(Data, maxIter, maxInlierError, goodFitThresh);
figure('Name','With outliers')

hold on

DrawCircle(trueX, trueY, trueR, 'k')
DrawCircle(cx, cy, R,'r')
plot(Data(:,1),Data(:,2),'k.');
DrawCircle(cx, cy, R,'r') %draw again to ensure it's not hidden by points

axis equal
legend('Truth','Estimate')
hold off

% Optional debugging data:
%disp(['truth: cx= ' num2str(trueX) ' cy= ' num2str(trueY) ' R= ' num2str(trueR)])
%disp(['estimate: cx= ' num2str(cx) ' cy= ' num2str(cy) ' R= ' num2str(R)])