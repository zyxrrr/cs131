function SaveAnimatedGif(video, filename, frame_delay, loop_delay)
% Saves a 4D array of frame data to an animated GIF that will loop
% infinitely.
%
% INPUTS
% video - An array of size h x w x 3 x f where video(:, :, c, f) is the
%         pixel data for color channel c in frame f of the video.
% filename - The filename to which the GIF will be saved.
% frame_delay - The time (in seconds) between subsequent frames of the
%               video.
% loop_delay - After the video ends, it will restart after loop_delay
%              seconds.

    if nargin < 3
        frame_delay = 0.25;
    end
    
    if nargin < 4
        loop_delay = 1;
    end
    num_frames = size(video, 4);

    for f = 1:num_frames
        [frame, map] = rgb2ind(video(:, :, :, f), 256, 'nodither');
        if f == 1
            imwrite(frame, map, filename, 'GIF', ...
                    'LoopCount', Inf, ...
                    'DelayTime', 0.25);
        else
            if f == num_frames
                delay = loop_delay;
            else
                delay = frame_delay;
            end
            imwrite(frame, map, filename, 'GIF', ...
                    'WriteMode', 'append', ...
                    'DelayTime', delay);            
        end
    end
end