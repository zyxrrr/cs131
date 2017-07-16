% EvaluateAffineMatrix.m
% Run this script to test your ComputeAffineMatrix() function
% using sample data. You do not need to change anything in this script.

%% Test Data (You should not change the data here)
srcPt = [0.5, 0.1; 0.4, 0.2; 0.8, 0.2];
dstPt = [0.3, -0.2; -0.4, -0.9; 0.1, 0.1];

%% Calls your implementation of ComputeAffineMatrix.m
H = ComputeAffineMatrix(srcPt, dstPt);

%% Load data and check solution
load('./checkpoint/Affine_ref.mat');
error = sum(sum((H-solution).^2));
disp(['Difference from reference solution: ' num2str(error)]);

if error < 1e-20,
    fprintf('%s\n', 'Accepted!');
else
    fprintf('%s\n', 'There is something wrong.');
end