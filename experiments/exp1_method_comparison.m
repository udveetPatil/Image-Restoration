function exp1_method_comparison()
    
    original = load_image(getappdata(0, 'DIP_image_path'));
    if min(size(original)) < 128
        fprintf('  [warning] Image is smaller than 128x128; some blurs may exceed image bounds.\n');
    end
    
    len = 30; theta = 45;
    [blurred, PSF] = generate_blur(original, len, theta);
    
    % Custom methods
    tic; restored_inv = custom_inverse(blurred, PSF); t_inv = toc;
    tic; restored_wie = custom_wiener(blurred, PSF, 0.001); t_wie = toc;
    tic; restored_lucy = custom_lucy(blurred, PSF, 20); t_lucy = toc;
    tic; restored_reg = custom_regularized(blurred, PSF, 0.01); t_reg = toc;
    
    % Built-in methods
    tic; restored_winr = deconvwnr(blurred, PSF, 0.001); t_winr = toc;
    tic; restored_lucyb = deconvlucy(blurred, PSF, 20); t_lucyb = toc;
    tic; restored_regb = deconvreg(blurred, PSF, 0.01); t_regb = toc;
    
    methods = {'Inverse (Custom)', 'Wiener (Custom)', 'Lucy (Custom)', ...
               'Regularized (Custom)', 'Wiener (Built-in)', ...
               'Lucy (Built-in)', 'Regularized (Built-in)'};
    
    restored_all = {restored_inv, restored_wie, restored_lucy, restored_reg, ...
                    restored_winr, restored_lucyb, restored_regb};
    
    runtimes = [t_inv, t_wie, t_lucy, t_reg, t_winr, t_lucyb, t_regb];
    
    % Pre-allocate metric arrays
    psnr_vals = zeros(1, length(methods));
    ssim_vals = zeros(1, length(methods));
    
    fprintf('\n=== Experiment 1: Method Comparison ===\n');
    fprintf('%-25s %-10s %-10s %-10s\n', 'Method', 'PSNR', 'SSIM', 'Time (s)');
    fprintf('%s\n', repmat('-', 1, 60));
    
    for i = 1:length(methods)
        psnr_vals(i) = psnr(restored_all{i}, original);
        ssim_vals(i) = ssim(restored_all{i}, original);
        fprintf('%-25s %-10.2f %-10.4f %-10.4f\n', ...
            methods{i}, psnr_vals(i), ssim_vals(i), runtimes(i));
    end
    
    % Save metrics
    save_metrics('exp1_method_comparison', methods, psnr_vals, ssim_vals, runtimes);
    
    % Plot
    % Add to image grid figure as tab
    tab = uitab(fig_manager('tabs'), 'Title', 'Exp1: Method Comparison');
    tl = tiledlayout(tab, 3, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl, 'Method Comparison', 'FontSize', 12, 'FontWeight', 'bold');
    
    nexttile(tl, 1); imshow(original); title('Original');
    nexttile(tl, 2); imshow(blurred);  title('Blurred');
    for i = 1:length(methods)
        nexttile(tl, i+2);
        imshow(restored_all{i});
        title(methods{i}, 'Interpreter', 'none', 'FontSize', 9);
    end

    drawnow;
    save_tab(tl, 'results/figures/exp1_method_comparison.png');
    
end