function exp6_custom_vs_builtin()
    % Experiment 6: Custom vs Built-in comparison
    
    original = im2double(imread('cameraman.tif'));
    len = 30; theta = 45;
    [blurred, PSF] = generate_blur(original, len, theta);
    
    % Custom
    restored_wie_custom = custom_wiener(blurred, PSF, 0.001);
    restored_lucy_custom = custom_lucy(blurred, PSF, 20);
    restored_reg_custom = custom_regularized(blurred, PSF, 0.01);
    
    % Built-in
    restored_wie_builtin = deconvwnr(blurred, PSF, 0.001);
    restored_lucy_builtin = deconvlucy(blurred, PSF, 20);
    restored_reg_builtin = deconvreg(blurred, PSF, 0.01);
    
    % Compare
    fprintf('\n=== Experiment 6: Custom vs Built-in ===\n');
    fprintf('%-20s %-10s %-10s %-10s\n', 'Method', 'Custom', 'Built-in', 'Diff');
    fprintf('%s\n', repmat('-', 1, 55));
    
    fprintf('%-20s %-10.2f %-10.2f %-10.2f\n', 'Wiener', ...
        psnr(restored_wie_custom, original), ...
        psnr(restored_wie_builtin, original), ...
        abs(psnr(restored_wie_custom, original) - psnr(restored_wie_builtin, original)));
    
    fprintf('%-20s %-10.2f %-10.2f %-10.2f\n', 'Lucy-Richardson', ...
        psnr(restored_lucy_custom, original), ...
        psnr(restored_lucy_builtin, original), ...
        abs(psnr(restored_lucy_custom, original) - psnr(restored_lucy_builtin, original)));
    
    fprintf('%-20s %-10.2f %-10.2f %-10.2f\n', 'Regularized', ...
        psnr(restored_reg_custom, original), ...
        psnr(restored_reg_builtin, original), ...
        abs(psnr(restored_reg_custom, original) - psnr(restored_reg_builtin, original)));

    % Save metrics
    methods6 = {'Wiener', 'Lucy-Richardson', 'Regularized'}';
    custom_psnr = [psnr(restored_wie_custom, original);
        psnr(restored_lucy_custom, original);
        psnr(restored_reg_custom, original)];
    builtin_psnr = [psnr(restored_wie_builtin, original);
        psnr(restored_lucy_builtin, original);
        psnr(restored_reg_builtin, original)];
    diff_psnr = abs(custom_psnr - builtin_psnr);

    T = table(methods6, custom_psnr, builtin_psnr, diff_psnr, ...
        'VariableNames', {'Method', 'Custom_PSNR', 'BuiltIn_PSNR', 'Abs_Diff_dB'});

    if ~exist('results/metrics', 'dir'); mkdir('results/metrics'); end
    writetable(T, 'results/metrics/exp6_custom_vs_builtin.csv');
    save('results/metrics/exp6_custom_vs_builtin.mat', 'T');
    fprintf('  [saved] results/metrics/exp6_custom_vs_builtin.csv\n');
end