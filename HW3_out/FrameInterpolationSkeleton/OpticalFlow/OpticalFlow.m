function [u, v] = OpticalFlow(img1, img2, method)
    allowed_methods = {'Lucas-Kanade', 'Horn-Schunck', 'Liu'};
    if ~ismember(method, allowed_methods)
        error_message = '''method'' must be one of:';
        for i = 1:length(allowed_methods)
            error_message = [error_message ' ''' allowed_methods{i} ''','];
        end
        error(error_message(1:end-1));
    end

    if strcmp(method, 'Liu')
        if ~exist('Coarse2FineTwoFrames', 'file')
            error('Cannot find Liu optical flow implementation');
        end
        alpha = 0.012;
        ratio = 0.75;
        minWidth = 20;
        nOuterFPIterations = 7;
        nInnerFPIterations = 1;
        nSORIterations = 30;

        para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
        [u, v] = Coarse2FineTwoFrames(img1, img2, para);
    else
        img1 = double(rgb2gray(img1));
        img2 = double(rgb2gray(img2));

        optical_flow = vision.OpticalFlow(...
            'Method', method, ...
            'OutputValue', 'Horizontal and vertical components in complex form', ...
            'ReferenceFrameSource', 'Input port', ...
            'Smoothness', 200);

        flow = step(optical_flow, img1, img2);
        flow = double(flow);
        u = real(flow);
        v = imag(flow);
    end
end