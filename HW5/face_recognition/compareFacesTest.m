function compareFacesTest()
    
    % uncomment the method you want to use
%     method = 'simple';
    method = 'eigenface';
    method = 'fisherface';
    
    % uncomment the face you want to test
    testImgName = 'f16_5.png';  % Sarah Connor.
    testImgName = 'f6_10.png'; % not Sarah Connor
%     testImgName = 'f5_5.png';  % not Sarah Connor
%     testImgName = 'f14_7.png'; % not Sarah Connor
    testImgName = 'f16_6.png';  % Sarah Connor, higher brightness.
    
    testImg = double(rgb2gray(imread(['./unknownfaces/' testImgName])));
    compareFaces(method, testImg);
end