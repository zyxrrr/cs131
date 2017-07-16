temp = imread('coke_both.jpg');
temp = rgb2gray(temp);
temp = double(temp);

figure
imshow(temp,[]);

figure
kernel = fspecial('sobel');
gradx = conv2(kernel,temp);
grady = conv2(kernel',temp);
imshow(gradx+grady)

figure
temp_noisy = temp + 10*randn(size(temp));
imshow(temp_noisy,[])

figure
gradx_noisy = conv2(kernel,temp_noisy);
grady_noisy = conv2(kernel',temp_noisy);
imshow(gradx_noisy+grady_noisy)