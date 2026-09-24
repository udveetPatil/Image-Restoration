function save_tab(tl, filepath)
    % Save a tiledlayout (or figure) as PNG. Auto-selects parent tab if any.
    % Usage: save_tab(tl, 'results/figures/whatever.png')
    
    if ~exist('results/figures', 'dir'); mkdir('results/figures'); end
    
    % If tl lives inside a tab, select it first
    try
        parentTab = ancestor(tl, 'matlab.ui.container.Tab');
        if ~isempty(parentTab)
            parentTab.Parent.SelectedTab = parentTab;
            drawnow;
        end
    catch
        % Not in a tab — proceed
    end
    
    try
        exportgraphics(tl, filepath, 'Resolution', 150);
        fprintf('  [saved] %s\n', filepath);
    catch e
        try
            f = getframe(tl.Parent);
            imwrite(f.cdata, filepath);
            fprintf('  [saved fallback] %s\n', filepath);
        catch e2
            fprintf('  [warn] could not save %s: %s\n', filepath, e2.message);
        end
    end
end