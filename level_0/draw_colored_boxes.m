function  figure_handle = draw_colored_boxes(rc, z, boxes, data, data_bounds, label_str, only_greater_than)
% generate figure with colored boxes for diagnostics
% used by gen_diagnostics.m
if nargin<6, label_str{1} = 'untitled figure'; end
if nargin < 7
    only_greater_than = false; % Used if only want outliers greater than mean, for eg. residuals where smaller than the mean is better
end
figure_handle = figure;
is_data_nan = isnan(data);
c = mat2gray(data, data_bounds);
c(is_data_nan) = NaN;

for tix = 1:numel(boxes)
    P = boxes{tix}{1}/10^4;   % patch for this tile
   % P(:,1) = 23-P(:,1);
   % P(:,2) = 14.5-P(:,2);
    if isnan(c(tix))
        p = patch( P(:,1), P(:,2), 'black', 'EdgeColor', 'none' , 'Facealpha', 0.6);
    elseif c(tix) ==1 % Too large
        p = patch( P(:,1), P(:,2), 'red', 'EdgeColor', 'none' , 'Facealpha', 0.6);
    elseif  c(tix)==0 && ~only_greater_than % Too small
        p = patch( P(:,1), P(:,2), 'black','EdgeColor', 'none' , 'Facealpha', 0.6);
    else
        p = patch( P(:,1), P(:,2), c(tix),'FaceColor', 'flat',   'EdgeColor', 'none' , 'Facealpha', 0.4);
    end
    P = boxes{tix}{1};
    mean_x = mean(P(:,1));
    mean_y = mean(P(:,2));
    url = sprintf('http://renderer-catmaid:8000/?pid=%s\\&zp=%d\\&yp=%d\\&xp=%d\\&tool=navigator\\&sid0=%s\\&s0=2',rc.project, 35*z,round(4*mean_y), round(4*mean_x), rc.stack);
    set(p,'ButtonDownFcn',{@open_tile_in_catmaid,url});
end
title(label_str{1});
daspect([1 1 1]);axis ij; h = colorbar; set(h, 'ylim', [0,1],'ytick',(0:.25:1),'yticklabel',round(100*(data_bounds(1):(data_bounds(2)-data_bounds(1))/4: data_bounds(2)))/100);
if numel(label_str)==2, ylabel(h,label_str{2}); end
xlabel('Pixels (x10^4)');
ylabel('Pixels (x10^4)');
box on;
drawnow;