function [cl, or]=f_class(r)

a = [r(length(r)) r r(1) r(2)];
b = (a(1:length(r)+1)-a(2:length(r)+2));
b = b./abs(b);
d = ones(1,length(r)).*(b(1:length(r))>b(2:length(r)+1));
c = find(d);

m = [(r(c))' c'];
m = sortrows(m,1);

or(1) = (m(1,2)-1)*pi/length(r)*2;
cl = 2;

dst = m(:,1)-m(1,1);
i=find(dst < .3*(max(r)-min(r)));

cl = length(i);
or = (m(i,2)-1)*pi/length(r)*2;

