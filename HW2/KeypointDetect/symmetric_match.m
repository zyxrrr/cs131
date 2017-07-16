
close all
[p2a,p1a,a2,Fa] = motion_corr2(f2,k2,f1,k1,im2,im1, 'sdthresh', 1e-4);
'done with #1'
[p1b,p2b,a1,Fb] = motion_corr2(f1,k1,f2,k2,im1,im2,'sdthresh', 1e-4);

r=zeros(size(a1,1),1);
for i=1:size(a1,1)
    if a1(i)>0
        if a2(a1(i)) == i
            r(i)=1;
        end
    end
end

showfeatures(f2,im2);


showfeatures(f1,im1);
hold on
for i=1:size(p1b,1)
    x = p1b(i,1);
    y = p1b(i,2);
    if a1(i)~=0 & r(i)>0
        u = p2b(a1(i),1)-p1b(i,1);
        v = p2b(a1(i),2)-p1b(i,2);
        plot([x x+u],[y y+v],'y');
    end
end



pt1 = p1b(find(r),:);
pt2 = p2b(a1(find(r)),:);
w1 = f1(find(r),4);
w2 = f2(a1(find(r)),4);


g=sampson(pt1, pt2, Fb);
m = mean(g);

fk1 = k1(find(r),:);
fk2 = k2(a1(find(r)),:);

for i=1:size(fk1,1)
    c(i) = sum((fk1(i,:)-fk2(i,:)).^2);
end

cavg = mean(c);

pt1 = pt1(:,1:2)';
pt2 = pt2(:,1:2)';
pt1 = (pt1-1)/2;
pt2 = (pt2-1)/2;
w1 = (w1/2)';
w2 = (w2/2)';



