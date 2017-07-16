cd mex;
mex Coarse2FineTwoFrames.cpp GaussianPyramid.cpp OpticalFlow.cpp;
movefile Coarse2FineTwoFrames.mex* ../
cd ..