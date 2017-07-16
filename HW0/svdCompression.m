img=double(rgb2gray(imread('flower.bmp')));
figure;imshow(uint8(img))
[U,S,V]=svd(img);
for k=[10 50 100]
singular=diag(S);
singular(k+1:end)=0;
S1=diag(singular);
img1=U*S1*V';
figure;
imshow(uint8(img1));
end