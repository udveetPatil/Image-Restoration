function img = load_image(varargin)
% LOAD_IMAGE  Get a grayscale image for the deblurring experiments.
%
% Usage:
%   img = load_image()              % opens file dialog
%   img = load_image('path/to/img') % loads from path
%   img = load_image('skip')        % uses cameraman.tif silently (for CI/batch)
%
% Returns a double-precision grayscale image in [0, 1].

% ---- Decide source ----
if nargin == 0
    % Interactive: open file picker
    [f, p] = uigetfile( ...
        {'*.png;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp', ...
        'Image Files (*.png, *.jpg, *.tif, *.bmp)'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Select an image to deblur');
    if isequal(f, 0)
        fprintf('  [load_image] No file selected. Using cameraman.tif.\n');
        img = im2double(imread('cameraman.tif'));
        return;
    end
    path = fullfile(p, f);
elseif nargin == 1 && strcmpi(varargin{1}, 'skip')
    img = im2double(imread('cameraman.tif'));
    return;
else
    path = varargin{1};
end

% ---- Load ----
try
    img = imread(path);
catch e
    fprintf('  [load_image] Could not read %s: %s\n', path, e.message);
    fprintf('  [load_image] Falling back to cameraman.tif.\n');
    img = im2double(imread('cameraman.tif'));
    return;
end

% ---- Handle RGB or RGBA ----
if size(img, 3) == 3
    img = rgb2gray(img);
elseif size(img, 3) == 4
    img = rgb2gray(img(:, :, 1:3));
end

% ---- Convert to double in [0, 1] ----
img = im2double(img);

% ---- Resize if too large ----
MAX_DIM = 512;
[m, n] = size(img);
if max(m, n) > MAX_DIM
    scale = MAX_DIM / max(m, n);
    img = imresize(img, scale);
    fprintf('  [load_image] Resized from %dx%d to %dx%d.\n', ...
        m, n, size(img, 1), size(img, 2));
end
end
