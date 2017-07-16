function [data] = get_dvtime(fname)

f=fopen(fname);

r=1; 
c=1;

while feof(f)~=1
             
             junk = fscanf(f,'%c',7);
             h = fscanf(f,'%d',1);
             junk = fscanf(f,'%c',1);
             m = fscanf(f,'%d',1);
             junk = fscanf(f,'%c',1);
             s = fscanf(f,'%d',1);
             junk = fscanf(f,'%c',1);
             ms = fscanf(f,'%d',1);
             
             if length(h)>0
                 data(r,1) = ms/1e6 + s + m*60 + h*3600;
             end
             r=r+1;

             junk = fgetl(f);
             
end
 
 fclose(f);