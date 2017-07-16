
function key = construct_key(px, py, img, sz)

    pct = .75;
    
    [h,w] = size(img);
    
    [yoff,xoff] = meshgrid(-1:1,-1:1);
    yoff = yoff(:)*pct;
    xoff = xoff(:)*pct;
    
    for i = 1:size(yoff,1)
        ctrx = px + xoff(i)*sz*2;  %method using interpolated values
        ctry = py + yoff(i)*sz*2;
        [y,x] = meshgrid(ctry-sz:sz/3:ctry+sz,ctrx-sz:sz/3:ctrx+sz);
        y=y(:);
        x=x(:);
        t = 0;
        c = 0;
        for k=1:size(y,1)
            if x(k)<w-1 & x(k)>1 & y(k)<h-1 & y(k)>1 
                t = t + interp(img,x(k),y(k));
                c=c+1;
            end
        end
        if c==0
            c
        end
        t = t/c;
        
        key(i) = t;
    end
   
    key = key/sum(key);
        
    
    

        