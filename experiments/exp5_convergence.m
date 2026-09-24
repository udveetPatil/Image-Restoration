function exp5_convergence()
    
    original = load_image(getappdata(0, 'DIP_image_path'));
    if min(size(original)) < 128
        fprintf('  [warning] Image is smaller than 128x128; some blurs may exceed image bounds.\n');
    end

    [blurred, PSF] = generate_blur(original, 30, 45);
    iterations = [1, 5, 10, 15, 20, 25, 30, 40, 50];
    psnr_custom  = zeros(1, 9); psnr_builtin = zeros(1, 9);
    ssim_custom  = zeros(1, 9); ssim_builtin = zeros(1, 9);
    
    % Custom Lucy tab
    tab1 = uitab(fig_manager('tabs'), 'Title', 'Exp5: Custom Lucy');
    tl1 = tiledlayout(tab1, 3, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl1, 'Custom Lucy-Richardson', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Built-in Lucy tab
    tab2 = uitab(fig_manager('tabs'), 'Title', 'Exp5: Built-in Lucy');
    tl2 = tiledlayout(tab2, 3, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl2, 'Built-in Lucy-Richardson', 'FontSize', 12, 'FontWeight', 'bold');
    
    for i = 1:9
        r_c = custom_lucy(blurred, PSF, iterations(i));
        r_b = deconvlucy(blurred, PSF, iterations(i));
        psnr_custom(i) = psnr(r_c, original);  psnr_builtin(i) = psnr(r_b, original);
        ssim_custom(i) = ssim(r_c, original);  ssim_builtin(i) = ssim(r_b, original);
        
        nexttile(tl1, i); imshow(r_c);
        title(sprintf('it=%d  %.1f dB', iterations(i), psnr_custom(i)), 'FontSize', 9);
        
        nexttile(tl2, i); imshow(r_b);
        title(sprintf('it=%d  %.1f dB', iterations(i), psnr_builtin(i)), 'FontSize', 9);
    end
    
    ax = nexttile(fig_manager('plots_tl'), 4);
    plot(iterations, psnr_custom, 'o-', 'LineWidth', 2, 'DisplayName', 'Custom');
    hold on;
    plot(iterations, psnr_builtin, 's-', 'LineWidth', 2, 'DisplayName', 'Built-in');
    xlabel('Iterations'); ylabel('PSNR (dB)');
    title('Exp5: Lucy-Richardson Convergence');
    legend('Location', 'best'); grid on;
    
    fprintf('\n=== Experiment 5: Convergence ===\n');
    fprintf('%-6s %-10s %-10s %-10s %-10s\n', ...
        'Iter', 'Cust PSNR', 'Bltn PSNR', 'Cust SSIM', 'Bltn SSIM');
    fprintf('%s\n', repmat('-', 1, 55));
    for i = 1:9
        fprintf('%-6d %-10.2f %-10.2f %-10.4f %-10.4f\n', ...
            iterations(i), psnr_custom(i), psnr_builtin(i), ...
            ssim_custom(i), ssim_builtin(i));
    end
    
    T = table(iterations(:), psnr_custom(:), psnr_builtin(:), ...
              ssim_custom(:), ssim_builtin(:), ...
        'VariableNames', {'Iterations','Custom_PSNR','BuiltIn_PSNR', ...
                          'Custom_SSIM','BuiltIn_SSIM'});
    writetable(T, 'results/metrics/exp5_convergence.csv');
    save('results/metrics/exp5_convergence.mat', ...
        'iterations', 'psnr_custom', 'psnr_builtin', ...
        'ssim_custom', 'ssim_builtin');
    fprintf('  [saved] exp5\n');

    drawnow;
    save_tab(tl1, 'results/figures/exp5_convergence_custom_images.png');
    save_tab(tl2, 'results/figures/exp5_convergence_builtin_images.png');
    clone_axes(ax, 'results/figures/exp5_convergence.png');

end