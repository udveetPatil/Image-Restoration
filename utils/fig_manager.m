function h = fig_manager(type)
% Manages two shared figures: "All Plots" and "All Image Grids"

hPlots  = getappdata(0, 'hPlots');
hGrids  = getappdata(0, 'hGrids');
tlPlots = getappdata(0, 'tlPlots');
tabGrp  = getappdata(0, 'tabGrp');

if isempty(hPlots) || ~isvalid(hPlots)
    hPlots = figure('Name', 'All Plots', 'NumberTitle', 'off', ...
        'Position', [50 50 1300 800]);
    tlPlots = tiledlayout(hPlots, 2, 2, ...
        'TileSpacing', 'compact', 'Padding', 'compact');
    title(tlPlots, 'Motion Deblurring — All Plots', ...
        'FontSize', 14, 'FontWeight', 'bold');
    setappdata(0, 'hPlots', hPlots);
    setappdata(0, 'tlPlots', tlPlots);
end

if isempty(hGrids) || ~isvalid(hGrids)
    hGrids = figure('Name', 'All Image Grids', 'NumberTitle', 'off', ...
        'Position', [50 50 1500 900]);
    tabGrp = uitabgroup(hGrids, 'Position', [0.01 0.01 0.98 0.98]);
    setappdata(0, 'hGrids', hGrids);
    setappdata(0, 'tabGrp', tabGrp);
end

switch type
    case 'plots_fig';  h = hPlots;
    case 'plots_tl';   h = tlPlots;
    case 'grids_fig';  h = hGrids;
    case 'tabs';       h = tabGrp;
end
end