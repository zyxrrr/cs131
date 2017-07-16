
function od_out = match_dv_odometry(od_in,dv)

    c = 1;
    i = 1;
    while i<size(dv,1) & c<size(od_in,1)
        
        while od_in(c,1)<dv(i) & c<size(od_in,1) %find matching odometry measurement
            c = c+1;
        end
  
        od_out(i,:) = od_in(c,:);
        i=i+1;
    end
    
    for k=i:size(dv,1)
        od_out(k,:)=od_in(c,:);
    end
        