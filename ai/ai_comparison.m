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
    
    % Preallocate metrics
    PSNR_vals = zeros(length(methods), 1);
    SSIM_vals = zeros(length(methods), 1);
    
    for i = 1:length(methods)
        PSNR_vals(i) = psnr(images{i}, original);
        SSIM_vals(i) = ssim(images{i}, original);
        fprintf('%-20s %-10.2f %-10.4f\n', methods{i}, ...
            PSNR_vals(i), SSIM_vals(i));
    end
    
    % --- ADDED: Save result image to results/figures/ ---
    fig = figure('Visible', 'off');
    montage(images, 'Size', [1 4]);
    title('Blurred | Wiener (Custom) | Lucy (Custom) | AI/Bilateral');
    
    % Ensure folder exists
    if ~exist('results/figures', 'dir')
        mkdir('results/figures');
    end
    
    % Save as PNG
    exportgraphics(fig, 'results/figures/ai_comparison.png', 'Resolution', 300);
    close(fig);
    
    fprintf('\nResult image saved to results/figures/ai_comparison.png\n');
    
    % --- ADDED: Save metrics to results/metrics/ ---
    if ~exist('results/metrics', 'dir')
        mkdir('results/metrics');
    end
    
    ai_results = table( ...
        methods', ...
        PSNR_vals, ...
        SSIM_vals, ...
        'VariableNames', {'Method', 'PSNR_dB', 'SSIM'});
    
    % Save CSV
    writetable(ai_results, 'results/metrics/ai_comparison_results.csv');
    fprintf('Metrics CSV saved: results/metrics/ai_comparison_results.csv\n');
    
    % Save MAT
    save('results/metrics/ai_comparison_results.mat', ...
        'ai_results', 'methods', 'PSNR_vals', 'SSIM_vals', ...
        'len', 'theta', 'noise_sigma', 'ai_available');
    fprintf('Metrics MAT saved: results/metrics/ai_comparison_results.mat\n');
end
