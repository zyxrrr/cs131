

xt= normalize(pt1(:,1:2)'-1,fc,cc,kc,alpha_c);
xtt= normalize(pt2(:,1:2)'-1,fc,cc,kc,alpha_c);

[T12,om12,X2,good_points,bad_points] = Motion_Structure_2views(xt,xtt,0);


figure(3);
plot3(X2(1,:),X2(3,:),-X2(2,:),'b+');
for i=1:size(X2,2)
    text(X2(1,i)+.2,X2(3,i),-X2(2,i),sprintf('%d',i),'color','m');
end
    
hold off;
%axis('equal');
xlabel('X');ylabel('Z');zlabel('-Y');
title('3D Structure from two views');
rotate3d on;
axis equal;


ptx1 = project_points2(X2,zeros(3,1),zeros(3,1),fc,cc,kc,alpha_c);
ptx2 = project_points2(X2,om12,T12,fc,cc,kc,alpha_c);

plotpoints(pt1(good_points,:),img1,1);

plotpoints(pt2(good_points,:),img2,1);

