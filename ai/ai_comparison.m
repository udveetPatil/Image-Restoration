function ai_comparison()
    % Compare classical methods with a pre-trained denoising network
    % Note: Requires Deep Learning Toolbox
    
    original = im2double(imread('cameraman.tif'));
    len = 30; theta = 45;
    noise_sigma = 0.01;
    [blurred, PSF] = generate_blur(original, len, theta, noise_sigma);
    
    % Classical restoration
    restored_wiener = custom_wiener(blurred, PSF, 0.001);
    restored_lucy = custom_lucy(blurred, PSF, 20);
    
    % AI-based denoising (using pre-trained DnCNN if available)
    try
        net = denoisingNetwork('DnCNN');
        restored_ai = denoiseImage(blurred, net);
        ai_available = true;
    catch
        fprintf('DnCNN not available. Using bilateral filter as placeholder.\n');
        restored_ai = imbilatfilt(blurred);
        ai_available = false;
    end
    
    % Compare
    fprintf('\n=== AI Comparison ===\n');
    fprintf('%-20s %-10s %-10s\n', 'Method', 'PSNR', 'SSIM');
    fprintf('%s\n', repmat('-', 1, 45));
    
    methods = {'Blurred', 'Wiener (Custom)', 'Lucy (Custom)', 'AI/Bilateral'};
    images = {blurred, restored_wiener, restored_lucy, restored_ai};
    
    for i = 1:length(methods)
        fprintf('%-20s %-10.2f %-10.4f\n', methods{i}, ...
            psnr(images{i}, original), ssim(images{i}, original));
    end
end