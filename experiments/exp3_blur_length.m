function exp3_blur_length()
    
    original = load_image(getappdata(0, 'DIP_image_path'));
    if min(size(original)) < 128
        fprintf('  [warning] Image is smaller than 128x128; some blurs may exceed image bounds.\n');
    end
    
    blur_lengths = [10, 20, 30, 40, 50];
    theta = 45;
    method_labels = {'Blurred', 'Inverse', 'Wiener', 'Lucy', 'Regularized'};
    methods = {'Inverse', 'Wiener', 'Lucy', 'Regularized'};
    psnr_results = zeros(4, length(blur_lengths));
    ssim_results = zeros(4, length(blur_lengths));
    
    tab = uitab(fig_manager('tabs'), 'Title', 'Exp3: Blur Length');
    tl = tiledlayout(tab, 5, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl, 'Blur Length Variation', 'FontSize', 12, 'FontWeight', 'bold');
    
    for L = 1:length(blur_lengths)
        [blurred, PSF] = generate_blur(original, blur_lengths(L), theta);
        r_inv  = custom_inverse(blurred, PSF);
        r_wie  = custom_wiener(blurred, PSF, 0.001);
        r_lucy = custom_lucy(blurred, PSF, 20);
        r_reg  = custom_regularized(blurred, PSF, 0.01);
        imgs = {blurred, r_inv, r_wie, r_lucy, r_reg};
        
        psnr_results(1,L) = psnr(r_inv, original);
        psnr_results(2,L) = psnr(r_wie, original);
        psnr_results(3,L) = psnr(r_lucy, original);
        psnr_results(4,L) = psnr(r_reg, original);
        
        for m = 1:5
            nexttile(tl, (L-1)*5 + m);
            imshow(imgs{m});
            if L == 1; title(method_labels{m}, 'FontSize', 9); end
            if m == 1
                text(5, 25, sprintf('L=%d', blur_lengths(L)), ...
                    'Color', 'yellow', 'FontWeight', 'bold');
            end
        end
    end
    
    ax = nexttile(fig_manager('plots_tl'), 2);
    plot(blur_lengths, psnr_results', 'o-', 'LineWidth', 2);
    xlabel('Blur Length (px)'); ylabel('PSNR (dB)');
    title('Exp3: Blur Length');
    legend(methods, 'Location', 'best'); grid on;
    
    fprintf('\n=== Experiment 3: Blur Length ===\n');
    fprintf('%-15s', 'Method');
    for L = blur_lengths; fprintf('L=%-8d', L); end
    fprintf('\n%s\n', repmat('-', 1, 70));
    for m = 1:4
        fprintf('%-15s', methods{m});
        for L = 1:length(blur_lengths); fprintf('%-10.2f', psnr_results(m,L)); end
        fprintf('\n');
    end
    
    T = array2table(psnr_results, ...
        'VariableNames', {'L10','L20','L30','L40','L50'});
    T.Method = methods'; T = movevars(T, 'Method', 'Before', 1);
    writetable(T, 'results/metrics/exp3_blur_length.csv', 'WriteRowNames', false);
    save('results/metrics/exp3_blur_length.mat', ...
        'psnr_results', 'ssim_results', 'methods', 'blur_lengths');
    fprintf('  [saved] exp3\n');

    drawnow;
    save_tab(tl, 'results/figures/exp3_blur_length_images.png');
    clone_axes(ax, 'results/figures/exp3_blur_length.png');

end