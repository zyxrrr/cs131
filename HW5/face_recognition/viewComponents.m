function viewComponents( componentColumns, imageHeight)
%viewComponents Takes a matrix of principal components, and for each of the
% first 12 columns, re-rolls the column into an image and displays it with
% brightness scaled to the range min(image) to max(image)

%   INPUTS:
%       componentColumns: a matrix where each column is a principal
%       component
%       imageHeight: code assumes the columns are unrolled images of this
%       height

    figure
    hold on
    for columnIndex = 1:min(20,size(componentColumns,2))
        subplot(5,4,columnIndex)
        imshow(reshape(componentColumns(:,columnIndex),imageHeight,[]),[]);
    end
    hold off

end

