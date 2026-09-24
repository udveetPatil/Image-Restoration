function save_metrics(exp_name, varargin)
% save_metrics(exp_name, T)          -> saves a table T
% save_metrics(exp_name, methods, psnr, ssim, runtime) -> builds table
%
% Saves as .csv and .mat in results/metrics/

if ~exist('results/metrics', 'dir'); mkdir('results/metrics'); end

if nargin == 2 && istable(varargin{1})
    T = varargin{1};
elseif nargin == 5
    methods  = varargin{1};
    psnr_vals = varargin{2};
    ssim_vals = varargin{3};
    runtimes  = varargin{4};
    T = table(methods(:), psnr_vals(:), ssim_vals(:), runtimes(:), ...
        'VariableNames', {'Method', 'PSNR_dB', 'SSIM', 'Runtime_s'});
else
    error('save_metrics: invalid arguments');
end

csv_path = fullfile('results', 'metrics', [exp_name '.csv']);
mat_path = fullfile('results', 'metrics', [exp_name '.mat']);

writetable(T, csv_path);
save(mat_path, 'T');

fprintf('  [saved] results/metrics/%s.csv\n', exp_name);
end