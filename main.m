clc; clear; close all;

addpath('custom');
addpath('utils');
addpath('experiments');
addpath('ai');

if ~exist('results/figures', 'dir'); mkdir('results/figures'); end
if ~exist('results/metrics', 'dir'); mkdir('results/metrics'); end

fig_manager('plots_fig');
fig_manager('grids_fig');

fprintf('\n=== MOTION DEBLURRING COMPARATIVE STUDY ===\n');

exp1_method_comparison();  drawnow;
exp2_noise_robustness();   drawnow;
exp3_blur_length();        drawnow;
exp4_wrong_psf();          drawnow;
exp5_convergence();        drawnow;
exp6_custom_vs_builtin();  drawnow;

fprintf('\nAll done. Figures saved in results/figures/\n');