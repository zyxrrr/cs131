
for i=1:455
    
    
      fname = sprintf('f:\\robot\\loop3data\\f00%.3d.bmp',i-1)
    img = imread(fname);
    img1 = imresize(img,2,'bilinear');
    [features{i},pyr,imp,keys{i}] = detect_features(img1,1.5,0,3,4,4,4,.04,5);

end

save loop3_features features keys

