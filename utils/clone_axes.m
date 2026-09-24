function clone_axes(srcAx, filepath, figSize)
% Copy an axes into a new figure, restoring labels + legend, then save.
if nargin < 3; figSize = [100 100 800 600]; end

tmp = figure('Visible', 'off', 'Position', figSize);
newAx = copyobj(srcAx, tmp);

if ~isempty(srcAx.XLabel.String); xlabel(newAx, srcAx.XLabel.String); end
if ~isempty(srcAx.YLabel.String); ylabel(newAx, srcAx.YLabel.String); end
if ~isempty(srcAx.Title.String);  title(newAx,  srcAx.Title.String);  end

if ~isempty(srcAx.Legend) && isvalid(srcAx.Legend)
    legend(newAx, srcAx.Legend.String, 'Location', srcAx.Legend.Location);
end

save_tab(tmp, filepath);
close(tmp);
end