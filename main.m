% main.m -- Master script for Motion Deblurring Comparative Study
clc; clear; close all;

% ---- Paths ----
addpath('custom');
addpath('utils');
addpath('experiments');
addpath('ai');

% ---- Results folders ----
if ~exist('results/figures', 'dir'); mkdir('results/figures'); end
if ~exist('results/metrics', 'dir'); mkdir('results/metrics'); end


% ---- Ask user for image (or use default) ----
fprintf('\n========================================\n');
fprintf('MOTION DEBLURRING COMPARATIVE STUDY\n');
fprintf('========================================\n');
fprintf('\nChoose image source:\n');
fprintf('  1. Use default (cameraman.tif)\n');
fprintf('  2. Pick an image file\n');
choice = input('Enter 1 or 2 [default=1]: ');


if isempty(getenv('MATLAB_ONLINE'))  % if not in MATLAB Online
    if isempty(choice) || choice == 1
        img_path = 'cameraman.tif';
    else
        [f, p] = uigetfile({'*.png;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp', 'Image Files'}, ...
            'Select an image');
        if isequal(f, 0)
            fprintf('No file selected. Using cameraman.tif.\n');
            img_path = 'cameraman.tif';
        else
            img_path = fullfile(p, f);
        end
    end
else
    img_path = 'cameraman.tif';
end

% ---- Store the choice so experiments can find it ----
setappdata(0, 'DIP_image_path', img_path);

% ---- Shared figures ----
fig_manager('plots_fig');
fig_manager('grids_fig');


% ---- Run experiments ----
fprintf('\nUsing image: %s\n', img_path);
fprintf('\n=== Running experiments ===\n');

exp1_method_comparison();  drawnow;
exp2_noise_robustness();   drawnow;
exp3_blur_length();        drawnow;
exp4_wrong_psf();          drawnow;
exp5_convergence();        drawnow;
exp6_custom_vs_builtin();  drawnow;

fprintf('\nAll done. Figures saved in results/figures/\n');
