function restored = custom_lucy(blurred, PSF, iterations)
    % Lucy-Richardson iterative deconvolution
    PSF = PSF / sum(PSF(:));  % Normalize PSF
    PSF_flipped = rot90(PSF, 2);
    
    estimated = blurred;
    
    for i = 1:iterations
        conv_est = imfilter(estimated, PSF, 'conv', 'circular');
        ratio = blurred ./ (conv_est + eps);
        correction = imfilter(ratio, PSF_flipped, 'conv', 'circular');
        estimated = estimated .* correction;
    end
    
    restored = estimated;
end