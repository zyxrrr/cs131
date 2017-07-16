function show_plist(list,color,mark)

if size(list,1)>0
    colormap gray
    y = list(:,1);
    x = list(:,2);
    hold on
    plot(x,y,mark,'MarkerEdgeColor',color,'MarkerSize',2);
end