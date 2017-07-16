function drawbox(ang,sz,xc,yc,clr)

    ang=-ang;
   b = [1 1; -1 1; -1 -1; 1 -1; 1 1] * sz;
   t = [ sin(ang) cos(ang);cos(ang) -sin(ang)];
   b = (t*b')';
   b(:,2)=b(:,2)+xc;
   b(:,1)=b(:,1)+yc;
   plot(b(:,2),b(:,1),'color',clr);
