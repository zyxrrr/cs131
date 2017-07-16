function FrameInterpolation(use_precomputed_optical_flow)
% Main entry point to the frame interpolation mini-project.
%
% INPUTS
% use_precomputed_optical_flow - Whether to use a precomputed optical flow
%                                or compute one on the spot. Optional;
%                                default is true.
    
    addpath('OpticalFlow');

    if nargin < 1
        use_precomputed_optical_flow = true;
    end

    % Load the frames that will be interpolated.
    frame1 = imread('data/table/images/frame01.jpg');
    frame2 = imread('data/table/images/frame05.jpg');
    
    % For computational efficiency, we may resize the frames before
    % computing optical flow and performing frame interpolation.
    resize = 0.25;    
    if resize ~= 1
        frame1 = imresize(frame1, resize);
        frame2 = imresize(frame2, resize);
    end
    
    % The total number of framed in the interpolated video sequence. Since
    % we start with 2 frames, this means that we will compute num_frames-2
    % interpolated frames.
    num_frames = 9;

    % Load or compute the optical flow between the images. We have provided
    % precomputed optical flow for the default frames. If you want to use
    % your own images then you will need to compute the optical flow
    % instead.
    if use_precomputed_optical_flow
        if resize == 0.25
            flow = load('data/table/flows/01-05-quarter.mat', 'u0', 'v0');
        elseif resize == 0.5
            flow = load('data/table/flows/01-05-half.mat', 'u0', 'v0');
        elseif resize == 1
            flow = load('data/table/flows/01-05-full.mat', 'u0', 'v0');
        else
            error(['No suitable precomputed optical flow could be found; try setting resize ' ...
                   'equal to 1, 0.5, or 0.25']);
        end
        u0 = flow.u0;
        v0 = flow.v0;
    else 
        optical_flow_method = 'Liu';
        [u0, v0] = OpticalFlow(frame1, frame2, optical_flow_method);
    end
    
    % Now the optical flow is stored in the variables u0 and v0; u0
    % contains the horizontal component of the flow and v0 contains the
    % vertical component of the flow.
    % 
    % Each of u0 and v0 is a 2D array of the same size as the input images. The
    % velocity of the pixel frame1(y, x) is given by (u0(y, x), v0(y, x)).

    % We can optionally visualize the computed optical flow.
    view_flow = true;
    if view_flow
        figure;
        subplot(2, 1, 1);
        imshow(frame1);
        title('First image');
        subplot(2, 1, 2);
        imshow(VisualizeFlow(u0, v0));
        title('Optical flow');
    end 
    
    % Now that we have a pair of frames and an optical flow between them,
    % we can use different frame interpolated functions to create an
    % interpolated video sequence. As you implement different frame
    % interpolation functions you can uncomment the following lines to
    % compute and view the interpolated video sequences. Each interpolated
    % video sequence will be displayed in MATLAB as a video sequence, saved
    % to an animated GIF, and saved as a tiled image of frames.
    
    % Uncomment these lines after completing Problem 2(a).
    crossfade_video = ComputeVideo(frame1, frame2, u0, v0, num_frames, @ComputeCrossFadeFrame);
    implay(crossfade_video, 5);
    SaveAnimatedGif(crossfade_video, 'crossfade.gif');
    SaveImageSequence(crossfade_video, 'crossfade.png');

    % Uncomment these lines after completing Problem 2(b).
    forwardwarped_video = ComputeVideo(frame1, frame2, u0, v0, num_frames, @ComputeForwardWarpingFrame);
    implay(forwardwarped_video);
    SaveAnimatedGif(forwardwarped_video, 'forwardwarped.gif');
    SaveImageSequence(forwardwarped_video, 'forwardwarped.png');

    % Uncomment these lines after completing Problem 2(e).
    flowwarp_video = ComputeVideo(frame1, frame2, u0, v0, num_frames, @ComputeFlowWarpFrame);
    implay(flowwarp_video, 5);
    SaveAnimatedGif(flowwarp_video, 'flowwarped.gif');
    SaveImageSequence(flowwarp_video, 'flowwarped.png');
end

function video = ComputeVideo(img0, img1, u0, v0, num_frames, frame_fn)
% Compute a video sequence of frames using specified start and end frames,
% optical flow, and frame interpolation function.
%
% INPUTS
% img0 - Array of size h x w x 3 containing pixel data for the starting
%        frame.
% img1 - Array of the same size as img0 containing pixel data for the
%        ending frame.
% u0 - Horizontal component of the optical flow from img0 to img1. In
%      particular, an array of size h x w where u0(y, x) is the horizontal
%      component of the optical flow at the pixel img0(y, x, :).
% v0 - Vertical component of the optical flow from img0 to img1. In
%      particular, an array of size h x w where v0(y, x) is the vertical
%      component of the optical flow at the pixel img0(y, x, :).
% num_frames - The total number of frames in the final video. Must have
%              num_frames >= 2. The total number of interpolated frames is
%              num_frames - 2.
% frame_fn - Handle to a function that will be used to compute interpolated
%            frames. The function must accept the following parameters:
%            
%            frame = frame_fn(img0, img1, u0, v0, t)
%            
%            INPUTS
%            img0, img1, u0, v0 - Same as above.
%            t - Parameter in the range [0, 1] giving the point in time at
%                which to compute the interpolated frame. For example, 
%                t = 0 corresponds to img0, t = 1 corresponds to img1, and
%                t = 0.5 is equally spaced in time between img0 and img1.
%            
%            OUTPUTS
%            frame - Array of the same size as img0 and img1 containing the
%            interpolated frame.
%
% OUTPUTS
% video - Array of size h x w x 3 x num_frames where video(:, :, :, i)
%         contains the pixel data for the ith frame of the video sequence.

    if num_frames < 2
        error('num_frames must be >= 2');
    end
    height = size(img0, 1);
    width = size(img0, 2);
    video = zeros(height, width, 3, num_frames);
    video(:, :, :, 1) = img0;
    video(:, :, :, num_frames) = img1;
    
    for i = 2:num_frames-1
        fprintf('Computing frame %d / %d\n', i - 1, num_frames - 2);
        t = (i - 1) / (num_frames - 1);
        img = frame_fn(img0, img1, u0, v0, t);
        video(:, :, :, i) = img;
    end
    
    video = uint8(video);   
end
