function exp4_wrong_psf()

    original = load_image(getappdata(0, 'DIP_image_path'));
    if min(size(original)) < 128
        fprintf('  [warning] Image is smaller than 128x128; some blurs may exceed image bounds.\n');
    end
    
    true_len = 30; true_theta = 45;
    [blurred, ~] = generate_blur(original, true_len, true_theta);
    len_values = [25, 30, 35];
    theta_values = [40, 45, 50];
    psnr_matrix = zeros(3, 3);
    ssim_matrix = zeros(3, 3);
    
    tab = uitab(fig_manager('tabs'), 'Title', 'Exp4: Wrong PSF');
    tl = tiledlayout(tab, 3, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl, sprintf('Wrong PSF (True: L=%d, \\theta=%d)', true_len, true_theta), ...
        'FontSize', 12, 'FontWeight', 'bold');
    
    for i = 1:3
        for j = 1:3
            wrong_PSF = fspecial('motion', len_values(i), theta_values(j));
            wrong_PSF = wrong_PSF / sum(wrong_PSF(:));
            restored = custom_wiener(blurred, wrong_PSF, 0.001);
            psnr_matrix(i,j) = psnr(restored, original);
            ssim_matrix(i,j) = ssim(restored, original);
            
            nexttile(tl, (i-1)*3 + j);
            imshow(restored);
            title(sprintf('L=%d \\theta=%d\n%.1f dB', ...
                len_values(i), theta_values(j), psnr_matrix(i,j)), 'FontSize', 9);
        end
    end
    
    % Heatmap in tile #3
    ax = nexttile(fig_manager('plots_tl'), 3);
    imagesc(theta_values, len_values, psnr_matrix);
    colorbar; xlabel('Assumed \theta'); ylabel('Assumed Length');
    title('Exp4: Wrong PSF Sensitivity'); axis square;
    for i = 1:3
        for j = 1:3
            text(theta_values(j), len_values(i), ...
                sprintf('%.1f', psnr_matrix(i,j)), ...
                'HorizontalAlignment', 'center', 'Color', 'w', 'FontWeight', 'bold', 'BackgroundColor', 'black');
        end
    end
    
    fprintf('\n=== Experiment 4: Wrong PSF ===\n');
    fprintf('%-10s', 'len\\theta');
    for t = theta_values; fprintf('%-10d', t); end
    fprintf('\n%s\n', repmat('-', 1, 50));
    for i = 1:3
        fprintf('%-10d', len_values(i));
        for j = 1:3; fprintf('%-10.2f', psnr_matrix(i,j)); end
        fprintf('\n');
    end
    
    T = array2table(psnr_matrix, ...
        'VariableNames', {'theta_40','theta_45','theta_50'}, ...
        'RowNames', {'len_25','len_30','len_35'});
    writetable(T, 'results/metrics/exp4_wrong_psf.csv', 'WriteRowNames', true);
    save('results/metrics/exp4_wrong_psf.mat', ...
        'psnr_matrix', 'ssim_matrix', 'len_values', 'theta_values');
    fprintf('  [saved] exp4\n');

    drawnow;
    save_tab(tl, 'results/figures/exp4_wrong_psf_images.png');
    clone_axes(ax, 'results/figures/exp4_wrong_psf.png', [100 100 700 600]);
    
end