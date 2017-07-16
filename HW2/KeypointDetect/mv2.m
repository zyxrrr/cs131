j=1;
for i=4000:10:4100

sprintf('Movie Frame : %d',[i])
img=imread(sprintf('M:\\corridor_part3\\corridor%.4d.bmp',i));
test;
M(j) = getframe(gcf);
j=j+1;
end