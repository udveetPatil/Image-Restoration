function exp2_noise_robustness()
    original = im2double(imread('cameraman.tif'));
    len = 30; theta = 45;
    noise_levels = [0, 0.001, 0.01, 0.05];
    method_labels = {'Blurred', 'Inverse', 'Wiener', 'Lucy', 'Regularized'};
    methods = {'Inverse', 'Wiener', 'Lucy', 'Regularized'};
    psnr_results = zeros(4, length(noise_levels));
    
    % --- Image grid in a new tab ---
    tab = uitab(fig_manager('tabs'), 'Title', 'Exp2: Noise');
    tl = tiledlayout(tab, 4, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl, 'Noise Robustness', 'FontSize', 12, 'FontWeight', 'bold');
    
    for n = 1:length(noise_levels)
        [blurred, PSF] = generate_blur(original, len, theta, noise_levels(n));
        r_inv  = custom_inverse(blurred, PSF);
        r_wie  = custom_wiener(blurred, PSF, 0.001);
        r_lucy = custom_lucy(blurred, PSF, 20);
        r_reg  = custom_regularized(blurred, PSF, 0.01);
        imgs = {blurred, r_inv, r_wie, r_lucy, r_reg};
        
        psnr_results(1,n) = psnr(r_inv, original);
        psnr_results(2,n) = psnr(r_wie, original);
        psnr_results(3,n) = psnr(r_lucy, original);
        psnr_results(4,n) = psnr(r_reg, original);
        
        for m = 1:5
            nexttile(tl, (n-1)*5 + m);
            imshow(imgs{m});
            if n == 1; title(method_labels{m}, 'FontSize', 9); end
            if m == 1
                text(5, 25, sprintf('\\sigma=%.3f', noise_levels(n)), ...
                    'Color', 'yellow', 'FontWeight', 'bold');
            end
        end
    end
    
    % --- Plot in tile #1 of plots figure ---
    ax = nexttile(fig_manager('plots_tl'), 1);
    plot(noise_levels, psnr_results', 'o-', 'LineWidth', 2);
    xlabel('Noise (\sigma)'); ylabel('PSNR (dB)');
    title('Exp2: Noise Robustness');
    legend(methods, 'Location', 'best'); grid on;
    
    % --- Console + metrics ---
    fprintf('\n=== Experiment 2: Noise Robustness ===\n');
    fprintf('%-15s', 'Method');
    for n = 1:length(noise_levels); fprintf('σ=%-8.3f', noise_levels(n)); end
    fprintf('\n%s\n', repmat('-', 1, 70));
    for m = 1:4
        fprintf('%-15s', methods{m});
        for n = 1:length(noise_levels); fprintf('%-10.2f', psnr_results(m,n)); end
        fprintf('\n');
    end
    
    T = array2table(psnr_results, ...
        'VariableNames', {'sigma_0','sigma_0_001','sigma_0_01','sigma_0_05'});
    T.Method = methods'; T = movevars(T, 'Method', 'Before', 1);
    writetable(T, 'results/metrics/exp2_noise_robustness.csv', 'WriteRowNames', false);
    save('results/metrics/exp2_noise_robustness.mat', ...
        'psnr_results', 'methods', 'noise_levels');
    fprintf('  [saved] exp2\n');

    drawnow;
    save_tab(tl, 'results/figures/exp2_noise_robustness_images.png');
    clone_axes(ax, 'results/figures/exp2_noise_robustness.png');
    
end