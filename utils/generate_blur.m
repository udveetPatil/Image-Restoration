function [blurred, PSF] = generate_blur(image, len, theta, noise_sigma)
    % Generate motion blur and optional noise
    PSF = fspecial('motion', len, theta);
    PSF = PSF / sum(PSF(:));  % Normalize!
    
    blurred = imfilter(image, PSF, 'conv', 'circular');
    
    if nargin > 3 && noise_sigma > 0
        blurred = imnoise(blurred, 'gaussian', 0, noise_sigma);
    end
end