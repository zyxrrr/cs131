%
% Author: 
% Scott Ettinger
% scott.m.ettinger@intel.com
%
% May 2002
%/////////////////////////////////////////////////////////////////////////////////////////////

function [] = plot_matched(p,w,img,num_flag)

if ~exist('num_flag')
    num_flag = 0;
end

figure(gcf);
imagesc(img)
hold on
colormap gray

for i=1:size(p,2)
    x = p(1,i)+1;
    y = p(2,i)+1;
    sz = w(i);
    
    if x>size(img,2)
        x
    end
          
    if num_flag ~= 1
        plot(x,y,'g+');         %draw box around real feature
    else
        plot(x,y,'g+');         %draw box around real feature
        text(x,y,sprintf('%d',i),'color','r');
    end
    
    drawbox(0,sz,x,y,[0 1 0]);
end
