function SaveImageSequence(video, filename, grid_width)
% Expands a 4D array of frame data to a tiled grid of frames and saves the
% resulting image to a file.
%
% INPUTS
% video - An array of size h x w x 3 x f where video(:, :, c, f) is the
%         pixel data for color channel c in frame f of the video.
% filename - The filename to which the tiled image will be saved.
% grid_width - The maximum width of the tiled grid. Optional; default is 3.

    if nargin < 3
        grid_width = 3;
    end

    height = size(video, 1);
    width = size(video, 2);
    num_frames = size(video, 4);
    
    grid_height = ceil(num_frames / grid_width);
    
    frame_sequence = zeros(grid_height * height, grid_width * width, 3);
    f = 1;
    
    done = false;
    for y = 1:grid_height
        if done
            break;
        end
        for x = 1:grid_width
            if f > num_frames
                done = true;
                break;
            end
            x0 = 1 + (x - 1) * width;
            x1 = x * width;
            y0 = 1 + (y - 1) * height;
            y1 = y * height;
            frame_sequence(y0:y1, x0:x1, :) = video(:, :, :, f);
            f = f + 1;
        end
    end

    imwrite(uint8(frame_sequence), filename, 'PNG');
end