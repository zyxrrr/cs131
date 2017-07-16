function NormalizeFeaturesTest()
% Tests your implementation of NormalizeFeatures.m by comparing its output
% on a testing dataset with the output of our reference implementation on
% the same datasets.

    load('../test_data/NormalizeFeaturesTest.mat');
    featuresNormYours = NormalizeFeatures(features);
    same = sum(abs((featuresNorm(:) - featuresNormYours(:)))) < 1e-6;
    
    if all(same(:))
        disp(['Congrats! Your NormalizeFeatures algorithm produces the ' ...
              'same output as ours.']);
    else
        disp(['Uh oh - Your NormalizeFeatures algorithm produces a ' ...
              'different output from ours.']);
    end
end