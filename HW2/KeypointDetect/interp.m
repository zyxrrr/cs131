function v = interp(img,xc,yc)


       px = floor(xc);
       py = floor(yc);
       alpha = xc-px;
       beta = yc-py;

       nw = img(py,px);
       ne = img(py,px+1);
       sw = img(py+1,px);
       se = img(py+1,px+1);
       
       v = (1-alpha)*(1-beta)*nw + ...  %interpolate
              (1-alpha)*beta*sw + ...
              alpha*(1-beta)*ne + ...
              alpha*beta*se;