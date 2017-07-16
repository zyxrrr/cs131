%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Run this script to test your FitCircle() code.
% It should work well on the data with no outliers (first plot),
% but you'll see that it's vulnerable to outliers (second plot).
% Run the script several times to see different data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=10;
sigma = .1; %additive noise on good points
outlier=0; %percent of totally random outliers to add
[Data, trueX, trueY, trueR] = GenData(N, sigma, outlier);
%Data is an Nx2 array. Each row is a point
[cx, cy, R] = FitCircle(Data);
figure('Name','No outliers')
hold on
DrawCircle(cx, cy, R, 'r')
DrawCircle(trueX, trueY, trueR, 'k')
plot(Data(:,1),Data(:,2),'k.')
axis equal
legend('Estimate','Truth')
hold off


outlier=0.1; %percent of totally random outliers to add
[Data, trueX, trueY, trueR] = GenData(N, sigma, outlier);
%Data is an Nx2 array. Each row is a point
[cx, cy, R] = FitCircle(Data);
figure('Name','With outliers')
hold on
DrawCircle(cx, cy, R,'r')
DrawCircle(trueX, trueY, trueR, 'k')
plot(Data(:,1),Data(:,2),'k.')
axis equal
legend('Estimate','Truth')
hold off